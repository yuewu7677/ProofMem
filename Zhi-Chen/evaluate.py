#!/usr/bin/env python3
"""
ProofMem evaluation pipeline.

Reads DATA_1.jsonl (header-only with `sorry`), calls a model to generate
proofs, verifies all proofs in a single `lean` invocation (batch compile),
and computes pass@1 / pass@k.

Supports:
  --gold          Use DATA_2.jsonl proofs instead of calling a model
  --pass-k N      Sample N times per problem
  --temperature   Sampling temperature (default 0.6)
  --limit N       Only evaluate first N problems
  --offset N      Skip first N problems
  --domain D      Filter by domain
  --level L       Filter by level (L1, L2, L3)
  --restricted    Use restricted imports in prompts + audit proofs after
  --restricted-cache PATH  Path to restricted_imports.json

Output:
  runs/<timestamp>/results.jsonl  — per-sample results
  runs/<timestamp>/summary.json   — aggregate metrics

Requirements:
  - Lake project must be built first (`lake build` from repo root)
  - For model mode: OPENAI_BASE_URL and optionally OPENAI_API_KEY env vars

Examples:
  python Zhi-Chen/evaluate.py --gold --limit 30
  OPENAI_BASE_URL=http://localhost:8000/v1 \\
    python Zhi-Chen/evaluate.py --limit 100 --pass-k 3
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------

ROOT = Path(__file__).resolve().parents[1]
DATA_1 = ROOT / "Zhi-Chen" / "DATA_1.jsonl"
DATA_2 = ROOT / "Zhi-Chen" / "DATA_2.jsonl"
DEFAULT_OUT = ROOT / "runs"


# ---------------------------------------------------------------------------
# Data loading
# ---------------------------------------------------------------------------

def load_jsonl(path: Path) -> list[dict[str, Any]]:
    records = []
    with path.open(encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                records.append(json.loads(line))
    return records


def load_gold_proofs(path: Path) -> dict[str, str]:
    """Build id -> full formal_statement map from DATA_2."""
    gold = {}
    for e in load_jsonl(path):
        gold[e["id"]] = e["formal_statement"]
    return gold


# ---------------------------------------------------------------------------
# Proof extraction from model output
# ---------------------------------------------------------------------------

def extract_code(text: str) -> str:
    blocks = re.findall(r"```(?:lean4?)?\s*\n(.*?)```", text, flags=re.DOTALL)
    if blocks:
        return blocks[-1].strip()
    return text.strip()


def extract_proof(text: str) -> tuple[str | None, str | None]:
    """Extract Lean proof from model output. Returns (proof, error)."""
    code = extract_code(text)
    match = re.search(r":=\s*by\b", code)
    if match:
        proof = "by" + code[match.end():]
    elif re.match(r"^\s*by\b", code):
        proof = code[code.find("by"):]
    else:
        return None, "could not find a Lean proof beginning with `by`"

    # Trim trailing declarations
    lines = proof.rstrip().splitlines()
    kept = []
    for idx, line in enumerate(lines):
        if idx > 0 and re.match(
            r"^\s*(?:import|namespace|end|theorem|lemma|def|instance|#check)\b", line
        ):
            break
        kept.append(line)
    proof = "\n".join(kept).rstrip()

    if re.search(r"\b(?:sorry|admit)\b", proof):
        return None, "proof contains sorry/admit"

    return proof, None


def extract_gold_proof(gold_fs: str) -> str | None:
    """Extract proof body from a gold formal_statement (DATA_2 entry)."""
    # Tactic proof: `:= by\n...`
    m = re.search(r":=\s*by\s*\n(.*)", gold_fs, re.DOTALL)
    if m:
        return "by\n" + m.group(1)
    # Term-style proof: `:= term`
    m = re.search(r":=\s*\n?\s*(.+?)$", gold_fs, re.DOTALL)
    if m and "sorry" not in m.group(1):
        return m.group(1).strip()
    return None


# ---------------------------------------------------------------------------
# Model interaction
# ---------------------------------------------------------------------------

def build_prompt(
    entry: dict[str, Any],
    restricted_imports: list[str] | None = None,
) -> str:
    """Build prompt for the model from a DATA_1 entry.

    If restricted_imports is provided, show only those imports.
    """
    header = entry["formal_statement"]
    header = re.sub(r":=\s*by\s*\n\s*sorry\s*$", "", header.strip()).rstrip()

    domain = entry.get("domain", "Unknown")
    informal = entry.get("informal_statement", "")

    if restricted_imports is not None:
        import_block = "\n".join(f"import {imp}" for imp in sorted(restricted_imports))
        prompt = (
            "You are an expert in Lean 4 and mathematics. "
            "Prove the following theorem using ONLY the lemmas and definitions "
            "available from the listed imports. Do not use any theorem or lemma "
            "outside these imports.\n\n"
            f"Domain: {domain}\n"
        )
        if informal:
            prompt += f"Informal description: {informal}\n"
        prompt += (
            f"\nAvailable imports:\n```lean4\n{import_block}\n```\n\n"
            "Return ONLY the Lean proof (starting with `by`), nothing else. "
            "Do not include the theorem statement, imports, or any explanation.\n\n"
            f"```lean4\n{header} := by\n```"
        )
    else:
        prompt = (
            "You are an expert in Lean 4 and mathematics. "
            "Prove the following theorem.\n\n"
            f"Domain: {domain}\n"
        )
        if informal:
            prompt += f"Informal description: {informal}\n"
        prompt += (
            "\n"
            "Return ONLY the Lean proof (starting with `by`), nothing else. "
            "Do not include the theorem statement, imports, or any explanation.\n\n"
            f"```lean4\n{header} := by\n```"
        )
    return prompt


def chat_completion(
    *,
    base_url: str,
    api_key: str | None,
    model: str,
    messages: list[dict[str, str]],
    temperature: float,
    top_p: float,
    max_tokens: int,
    timeout: float,
) -> str:
    url = base_url.rstrip("/") + "/chat/completions"
    payload = {
        "model": model,
        "messages": messages,
        "temperature": temperature,
        "top_p": top_p,
        "max_tokens": max_tokens,
    }
    headers = {"Content-Type": "application/json"}
    if api_key:
        headers["Authorization"] = f"Bearer {api_key}"
    data = json.dumps(payload).encode("utf-8")
    request = urllib.request.Request(url, data=data, headers=headers, method="POST")
    with urllib.request.urlopen(request, timeout=timeout) as response:
        body = json.loads(response.read().decode("utf-8"))
    return body["choices"][0]["message"]["content"]


# ---------------------------------------------------------------------------
# Batch verification
# ---------------------------------------------------------------------------

def _find_elan_bin() -> str:
    return os.path.expanduser("~/.elan/bin")


def _extract_header(fs: str) -> str:
    """Extract theorem/lemma statement from formal_statement (without proof)."""
    # Find `:= by\n  sorry` and strip it
    m = re.search(r"((?:theorem|lemma)\s+\S+.*?):=\s*by\s*\n\s*sorry", fs, re.DOTALL)
    if m:
        return m.group(1).strip()
    # Fallback
    header = re.sub(r":=\s*by\s*\n\s*sorry\s*$", "", fs.strip()).rstrip()
    lines = [l for l in header.split("\n")
             if not l.strip().startswith("import ")
             and not l.strip().startswith("open ")]
    return "\n".join(lines).strip()


def _collect_imports(entries: list[dict[str, Any]]) -> tuple[list[str], list[str]]:
    """Collect unique import and open lines across all entries.

    Checks both `formal_statement` (MA-ProofBench convention) and `imports`
    field (FormalMATH-L3 convention).
    """
    imports = []
    opens = []
    seen_imp = set()
    seen_open = set()

    def _add_lines(text: str) -> None:
        for line in text.split("\n"):
            s = line.strip()
            if s.startswith("import ") and s not in seen_imp:
                imports.append(s)
                seen_imp.add(s)
            elif s.startswith("open ") and s not in seen_open:
                opens.append(s)
                seen_open.add(s)

    for entry in entries:
        _add_lines(entry["formal_statement"])
        # Also check the imports field (FormalMATH-L3 convention)
        if entry.get("imports"):
            _add_lines(entry["imports"])

    return imports, opens


def _build_batch_file(
    eval_items: list[tuple[dict[str, Any], str, str]],
    all_entries: list[dict[str, Any]],
) -> str:
    """Build a single .lean file with all evaluation theorems.

    eval_items: list of (entry, proof, eval_name)
    Returns: complete .lean file content
    """
    imports, opens = _collect_imports(all_entries)

    parts = []
    if imports:
        parts.extend(imports)
        parts.append("")
    if opens:
        parts.extend(opens)
        parts.append("")

    for entry, proof, eval_name in eval_items:
        header = _extract_header(entry["formal_statement"])
        # Rename theorem to unique eval_name
        header = re.sub(
            r"^(\s*(?:theorem|lemma)\s+)(\S+)",
            rf"\1{eval_name}",
            header,
            count=1,
        )
        # Remove variable lines
        header_lines = [l for l in header.split("\n")
                        if not l.strip().startswith("variable ")]
        header = "\n".join(header_lines).strip()

        parts.append(f"{header} :=")
        parts.append(proof.strip())
        parts.append("")

    return "\n".join(parts) + "\n"


# Regex for Lean error: error: path.lean:line:col: message
_ERROR_RE = re.compile(
    r"error:\s*([^\s:]+\.lean):(\d+):(\d+):\s*(.+?)(?=\n\s*error:|\Z)",
    re.DOTALL,
)


def _parse_errors(output: str) -> dict[int, str]:
    """Parse Lean errors, return dict of line_number -> error_message."""
    errors = {}
    for m in _ERROR_RE.finditer(output):
        line = int(m.group(2))
        msg = " ".join(m.group(4).split())
        errors[line] = msg
    return errors


def _save_debug(content: str, output: str) -> None:
    """Save batch file and lean output for debugging."""
    import datetime
    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    debug_dir = ROOT / "runs" / "debug"
    debug_dir.mkdir(parents=True, exist_ok=True)
    (debug_dir / f"batch_{ts}.lean").write_text(content, encoding="utf-8")
    (debug_dir / f"output_{ts}.txt").write_text(output, encoding="utf-8")
    print(f"  [DEBUG] Saved batch file + output to {debug_dir}/batch_{ts}.lean", flush=True)


def verify_batch(
    eval_items: list[tuple[dict[str, Any], str, str]],
    all_entries: list[dict[str, Any]],
    timeout: float,
) -> list[dict[str, Any]]:
    """Verify all proofs in a single `lean` invocation.

    Args:
        eval_items: list of (entry, proof, eval_name)
        all_entries: all entries (for collecting imports)
        timeout: lean timeout in seconds

    Returns:
        list of {eval_name, verified, error} per eval_item
    """
    if not eval_items:
        return []

    lean_content = _build_batch_file(eval_items, all_entries)

    with tempfile.NamedTemporaryFile(
        "w", suffix=".lean", delete=False, encoding="utf-8"
    ) as tmp:
        tmp_path = Path(tmp.name)
        tmp.write(lean_content)
    try:
        elan_bin = _find_elan_bin()
        env = os.environ.copy()
        env["PATH"] = elan_bin + os.pathsep + env.get("PATH", "")

        result = subprocess.run(
            ["lake", "env", "lean", str(tmp_path)],
            cwd=str(ROOT),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=timeout,
            check=False,
        )
    except subprocess.TimeoutExpired as exc:
        # Save the file for debugging before deleting
        debug_path = tmp_path.with_suffix(".debug.lean")
        tmp_path.rename(debug_path)
        return [{"verified": False, "error": f"Lean timeout: {exc}"}
                for _ in eval_items]
    finally:
        if tmp_path.exists():
            tmp_path.unlink(missing_ok=True)

    stdout = result.stdout.decode("utf-8", errors="replace") if result.stdout else ""
    stderr = result.stderr.decode("utf-8", errors="replace") if result.stderr else ""
    output = stdout + "\n" + stderr

    if result.returncode == 0:
        return [{"verified": True, "error": ""} for _ in eval_items]

    # Parse errors and attribute to theorems by line number
    errors = _parse_errors(output)

    # Debug: save file + output when errors found
    if errors and result.returncode != 0:
        _save_debug(lean_content, output)

    # Find line numbers of each theorem in the generated file
    thm_lines = {}
    for i, line in enumerate(lean_content.split("\n"), 1):
        for _, _, eval_name in eval_items:
            if f"theorem {eval_name}" in line or f"lemma {eval_name}" in line:
                thm_lines[eval_name] = i
                break

    # Attribute errors: an error belongs to the theorem whose declaration
    # line is the nearest preceding one.
    sorted_thms = sorted(thm_lines.items(), key=lambda x: x[1])
    results = []
    for eval_name, line_num in sorted_thms:
        # Find next theorem's line for upper bound
        upper = float("inf")
        for name2, line2 in sorted_thms:
            if line2 > line_num:
                upper = line2
                break

        thm_errors = []
        for err_line, err_msg in errors.items():
            if line_num <= err_line < upper:
                thm_errors.append(err_msg)

        if thm_errors:
            results.append({
                "verified": False,
                "error": "; ".join(thm_errors[:3]),
            })
        else:
            results.append({"verified": True, "error": ""})

    # Pad if needed
    while len(results) < len(eval_items):
        results.append({"verified": False, "error": "error not attributed"})

    return results


# ---------------------------------------------------------------------------
# Main evaluation loop
# ---------------------------------------------------------------------------

def _sanitize_name(s: str) -> str:
    return re.sub(r"[^a-zA-Z0-9_]", "_", s)


def evaluate(
    entries: list[dict[str, Any]],
    *,
    gold_proofs: dict[str, str] | None = None,
    model: str = "",
    base_url: str = "",
    api_key: str | None = None,
    temperature: float = 0.6,
    top_p: float = 0.95,
    max_tokens: int = 4096,
    request_timeout: float = 600,
    lean_timeout: float = 600,
    pass_k: int = 1,
    restricted_imports: dict[str, list[str]] | None = None,
) -> list[dict[str, Any]]:
    """Evaluate entries and return results.

    If restricted_imports is provided, use restricted prompts and audit proofs.
    """
    all_results = []

    # Phase 1: Generate all proofs (model or gold)
    eval_items = []  # (entry, proof, eval_name)
    total = len(entries) * pass_k
    count = 0

    for entry in entries:
        eid = entry["id"]
        entry_imports = restricted_imports.get(eid) if restricted_imports else None

        for sample_idx in range(pass_k):
            count += 1
            eval_name = f"eval_{_sanitize_name(entry['id'])}_{sample_idx}"

            if gold_proofs is not None:
                gold_fs = gold_proofs.get(entry["id"], "")
                proof = extract_gold_proof(gold_fs)
                latency = 0
                if proof is None:
                    print(f"[{count}/{total}] {entry['id']}_s{sample_idx} NO GOLD PROOF",
                          flush=True)
                    all_results.append({
                        "id": entry["id"], "sample": sample_idx,
                        "verified": False,
                        "error": "Could not extract gold proof",
                        "latency_s": 0,
                    })
                    continue
            else:
                messages = [
                    {"role": "system",
                     "content": "You are an expert in mathematics and Lean 4 theorem proving."},
                    {"role": "user", "content": build_prompt(entry, entry_imports)},
                ]
                started = time.time()
                try:
                    raw_answer = chat_completion(
                        base_url=base_url, api_key=api_key, model=model,
                        messages=messages, temperature=temperature, top_p=top_p,
                        max_tokens=max_tokens, timeout=request_timeout,
                    )
                    proof, extraction_error = extract_proof(raw_answer)
                except Exception as exc:
                    proof = None
                    extraction_error = f"{type(exc).__name__}: {exc}"
                latency = time.time() - started

                if proof is None:
                    print(f"[{count}/{total}] {entry['id']}_s{sample_idx} FAIL "
                          f"({extraction_error})", flush=True)
                    all_results.append({
                        "id": entry["id"], "sample": sample_idx,
                        "verified": False,
                        "error": extraction_error or "No proof extracted",
                        "latency_s": latency,
                    })
                    continue

            eval_items.append((entry, proof, eval_name))
            # placeholder result (verified status filled in phase 2)
            all_results.append({
                "id": entry["id"], "sample": sample_idx,
                "verified": None,  # to be filled
                "error": "",
                "latency_s": latency,
                "proof_text": proof,  # stored for audit
            })

    if not eval_items:
        return all_results

    # Phase 2: Batch verify all proofs in one lean invocation
    print(f"\nVerifying {len(eval_items)} proofs in batch with `lean`...", flush=True)
    verify_started = time.time()
    verify_results = verify_batch(eval_items, entries, lean_timeout)
    verify_elapsed = time.time() - verify_started
    print(f"Verification complete in {verify_elapsed:.0f}s", flush=True)

    # Phase 3: Merge verification results back
    verify_idx = 0
    for i, r in enumerate(all_results):
        if r["verified"] is None:
            if verify_idx < len(verify_results):
                vr = verify_results[verify_idx]
                r["verified"] = vr["verified"]
                r["error"] = vr["error"]
                verify_idx += 1
            else:
                r["verified"] = False
                r["error"] = "verification result missing"

        status = "PASS" if r["verified"] else "FAIL"
        print(f"  {r['id']}_s{r['sample']} {status}", flush=True)

    # Phase 4: Audit restricted proofs (if restricted mode)
    if restricted_imports:
        print(f"\nAuditing proofs against restricted imports...", flush=True)
        try:
            from restricted_env import audit_proof, load_index

            idx = load_index()
            for r in all_results:
                eid = r["id"]
                allowed = restricted_imports.get(eid, [])
                proof = r.get("proof_text", "")
                if r["verified"] and proof and allowed:
                    clean, violations = audit_proof(proof, allowed, idx)
                    r["restricted_clean"] = clean
                    r["restricted_violations"] = violations[:10]  # cap at 10
                else:
                    r["restricted_clean"] = False
                    r["restricted_violations"] = []
        except ImportError:
            print("  WARNING: restricted_env module not found, skipping audit")
            for r in all_results:
                r["restricted_clean"] = None
                r["restricted_violations"] = []

    return all_results


# ---------------------------------------------------------------------------
# Metrics
# ---------------------------------------------------------------------------

def compute_metrics(results: list[dict[str, Any]], pass_k: int) -> dict[str, Any]:
    """Compute pass@1 and pass@k from results, plus restricted metrics if available."""
    by_id: dict[str, list[bool]] = {}
    by_id_restricted: dict[str, list[bool]] = {}
    has_restricted = any("restricted_clean" in r for r in results)

    for r in results:
        by_id.setdefault(r["id"], []).append(r["verified"])
        if has_restricted:
            rc = r.get("restricted_clean", False)
            by_id_restricted.setdefault(r["id"], []).append(rc is True)

    n = len(by_id)
    pass1 = sum(1 for v in by_id.values() if any(v[:1])) / n if n else 0
    passk = sum(1 for v in by_id.values() if any(v)) / n if n else 0

    metrics = {
        "total_problems": n,
        "total_samples": len(results),
        "pass@1": pass1,
        f"pass@{pass_k}": passk,
        "verified_count": sum(1 for r in results if r["verified"]),
    }

    if has_restricted:
        n_r = len(by_id_restricted)
        pass1_r = sum(1 for v in by_id_restricted.values() if any(v[:1])) / n_r if n_r else 0
        metrics["pass@1_restricted"] = pass1_r
        metrics["restricted_clean_count"] = sum(
            1 for r in results if r.get("restricted_clean") is True
        )
        # Violation stats
        total_viol = sum(len(r.get("restricted_violations", [])) for r in results)
        metrics["total_violations"] = total_viol

    return metrics


# ---------------------------------------------------------------------------
# Output
# ---------------------------------------------------------------------------

def save_results(out_dir: Path, results: list[dict[str, Any]],
                 summary: dict[str, Any]) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)

    results_path = out_dir / "results.jsonl"
    with results_path.open("w", encoding="utf-8") as f:
        for r in results:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")

    summary_path = out_dir / "summary.json"
    summary_path.write_text(
        json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8"
    )

    print(f"\nResults saved to {out_dir}")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main() -> int:
    parser = argparse.ArgumentParser(description="ProofMem evaluation pipeline")
    parser.add_argument("--data1", type=Path, default=DATA_1)
    parser.add_argument("--data2", type=Path, default=DATA_2)
    parser.add_argument("--output-dir", type=Path, default=None)
    parser.add_argument("--model", default="AI-MO/Kimina-Prover-72B")
    parser.add_argument("--base-url",
                        default=os.environ.get("OPENAI_BASE_URL",
                                               "http://localhost:8000/v1"))
    parser.add_argument("--api-key", default=os.environ.get("OPENAI_API_KEY"))
    parser.add_argument("--limit", type=int, default=0)
    parser.add_argument("--offset", type=int, default=0)
    parser.add_argument("--temperature", type=float, default=0.6)
    parser.add_argument("--top-p", type=float, default=0.95)
    parser.add_argument("--max-tokens", type=int, default=4096)
    parser.add_argument("--request-timeout", type=float, default=600)
    parser.add_argument("--lean-timeout", type=float, default=600)
    parser.add_argument("--pass-k", type=int, default=1)
    parser.add_argument("--gold", action="store_true")
    parser.add_argument("--restricted", action="store_true",
                        help="Use restricted imports in prompts + audit proofs")
    parser.add_argument("--restricted-cache", type=Path,
                        default=Path(__file__).resolve().parent / "restricted_imports.json",
                        help="Path to restricted_imports.json cache")
    parser.add_argument("--domain", type=str, default=None)
    parser.add_argument("--level", type=str, default=None)
    args = parser.parse_args()

    # Load
    entries = load_jsonl(args.data1)
    print(f"Loaded {len(entries)} entries from {args.data1}")

    if args.domain:
        entries = [e for e in entries if e.get("domain") == args.domain]
        print(f"  After domain filter '{args.domain}': {len(entries)}")
    if args.level:
        entries = [e for e in entries if e.get("level") == args.level]
        print(f"  After level filter '{args.level}': {len(entries)}")

    if args.offset:
        entries = entries[args.offset:]
    if args.limit:
        entries = entries[:args.limit]
    print(f"  Evaluating: {len(entries)} problems x {args.pass_k} samples = "
          f"{len(entries) * args.pass_k} total")

    if args.output_dir:
        out_dir = args.output_dir
    else:
        ts = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
        mode = "gold" if args.gold else "model"
        out_dir = DEFAULT_OUT / f"{mode}_{ts}"
    print(f"  Output: {out_dir}")

    gold_proofs = None
    if args.gold:
        gold_proofs = load_gold_proofs(args.data2)
        print(f"  Gold proofs loaded: {len(gold_proofs)} entries")

    # Load restricted imports if requested
    restricted_imports = None
    if args.restricted:
        cache_path = args.restricted_cache
        if cache_path.exists():
            restricted_imports = json.loads(cache_path.read_text(encoding="utf-8"))
            print(f"  Restricted imports loaded: {len(restricted_imports)} entries from {cache_path}")
        else:
            print(f"  WARNING: Restricted cache not found at {cache_path}")
            print(f"  Run: python Zhi-Chen/restricted_env.py --analyze")

    started = time.time()
    results = evaluate(
        entries,
        gold_proofs=gold_proofs,
        model=args.model,
        base_url=args.base_url,
        api_key=args.api_key,
        temperature=args.temperature,
        top_p=args.top_p,
        max_tokens=args.max_tokens,
        request_timeout=args.request_timeout,
        lean_timeout=args.lean_timeout,
        pass_k=args.pass_k,
        restricted_imports=restricted_imports,
    )
    elapsed = time.time() - started

    metrics = compute_metrics(results, args.pass_k)
    summary = {
        "mode": "gold" if args.gold else "model",
        "model": args.model if not args.gold else "gold_proofs",
        "dataset": str(args.data1),
        "pass_k": args.pass_k,
        "domain_filter": args.domain,
        "level_filter": args.level,
        "restricted": args.restricted,
        "elapsed_s": elapsed,
        **metrics,
    }

    save_results(out_dir, results, summary)

    print(f"\n{'='*50}")
    print(f"  Evaluation Complete")
    print(f"{'='*50}")
    print(f"  Problems:    {metrics['total_problems']}")
    print(f"  Samples:     {metrics['total_samples']}")
    print(f"  pass@1:      {metrics['pass@1']:.2%}")
    if args.pass_k > 1:
        print(f"  pass@{args.pass_k}:    {metrics[f'pass@{args.pass_k}']:.2%}")
    if args.restricted:
        print(f"  pass@1 (restricted): {metrics.get('pass@1_restricted', 0):.2%}")
        print(f"  Clean proofs:  {metrics.get('restricted_clean_count', 0)}")
        print(f"  Violations:    {metrics.get('total_violations', 0)}")
    print(f"  Time:        {elapsed:.0f}s")
    print(f"{'='*50}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

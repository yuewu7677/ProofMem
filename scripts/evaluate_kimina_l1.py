#!/usr/bin/env python3
"""Run a Kimina-Prover-72B baseline on the probability L1 split.

The script expects an OpenAI-compatible chat-completions endpoint serving
AI-MO/Kimina-Prover-72B, such as vLLM on port 8000 or SGLang on port 30000.

Examples:
  KIMINA_OPENAI_BASE_URL=http://localhost:8000/v1 \
    python3 scripts/evaluate_kimina_l1.py --limit 100

  python3 scripts/evaluate_kimina_l1.py --gold --limit 10
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import os
import re
import subprocess
import tempfile
import time
import urllib.error
import urllib.request
from collections import Counter
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DATASET = ROOT / "datasets/probability/theorem_proof_pairs.jsonl"
MATHLIB = ROOT / ".lake/packages/mathlib/Mathlib"
DEFAULT_OUT = ROOT / "runs/kimina_l1"
DEFAULT_MODEL = "AI-MO/Kimina-Prover-72B"


def load_l1_records(path: Path) -> list[dict[str, Any]]:
    records: list[dict[str, Any]] = []
    with path.open(encoding="utf-8") as f:
        for line in f:
            record = json.loads(line)
            if record["level"] == "L1":
                records.append(record)
    return records


def rename_decl(statement: str, new_name: str) -> str:
    renamed = re.sub(
        r"^(\s*(?:protected\s+)?(?:theorem|lemma)\s+)([^\s:{(]+)",
        rf"\1{new_name}",
        statement,
        count=1,
    )
    if renamed == statement:
        raise ValueError(f"could not rename declaration: {statement.splitlines()[0]}")
    return renamed


def source_prefix(record: dict[str, Any], context_lines: int) -> str:
    if context_lines <= 0:
        return ""
    path = MATHLIB / record["source_file"]
    lines = path.read_text(encoding="utf-8").splitlines()
    start_idx = max(0, int(record["source_line_start"]) - 1 - context_lines)
    end_idx = max(0, int(record["source_line_start"]) - 1)
    return "\n".join(lines[start_idx:end_idx]).strip()


def build_messages(record: dict[str, Any], eval_statement: str, context_lines: int) -> list[dict[str, str]]:
    context = source_prefix(record, context_lines)
    prompt = (
        "Think about and solve the following Lean 4 theorem step by step.\n"
        "Return a complete Lean 4 declaration, or just a Lean proof beginning with `by`.\n"
        "Do not use `sorry`, `admit`, or a direct citation of the source theorem.\n\n"
        f"# Source file\nMathlib/{record['source_file']}\n\n"
        "# Checking setup\n"
        "The generated proof will be inserted immediately before the original declaration "
        "inside a copy of that source file, so preceding imports, namespaces, variables, "
        "notation, and earlier lemmas from the file are available.\n\n"
    )
    if context:
        prompt += f"# Local source context excerpt\n```lean4\n{context}\n```\n\n"
    prompt += f"# Formal statement\n```lean4\n{eval_statement} := by\n```\n"
    return [
        {"role": "system", "content": "You are an expert in mathematics and proving theorems in Lean 4."},
        {"role": "user", "content": prompt},
    ]


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
    request = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers=headers,
        method="POST",
    )
    with urllib.request.urlopen(request, timeout=timeout) as response:
        data = json.loads(response.read().decode("utf-8"))
    return data["choices"][0]["message"]["content"]


def endpoint_available(base_url: str, api_key: str | None, timeout: float) -> tuple[bool, str]:
    url = base_url.rstrip("/") + "/models"
    headers: dict[str, str] = {}
    if api_key:
        headers["Authorization"] = f"Bearer {api_key}"
    request = urllib.request.Request(url, headers=headers, method="GET")
    try:
        with urllib.request.urlopen(request, timeout=timeout) as response:
            body = response.read(500).decode("utf-8", errors="replace")
        return True, f"HTTP {response.status}: {body[:200]}"
    except Exception as exc:  # noqa: BLE001 - this is a diagnostic preflight.
        return False, f"{type(exc).__name__}: {exc}"


def extract_code(text: str) -> str:
    blocks = re.findall(r"```(?:lean4?|Lean4?)?\s*\n(.*?)```", text, flags=re.DOTALL)
    if blocks:
        return blocks[-1].strip()
    return text.strip()


def trim_after_proof(proof: str) -> str:
    lines = proof.rstrip().splitlines()
    kept: list[str] = []
    for idx, line in enumerate(lines):
        if idx > 0 and re.match(r"^\s*(?:import|namespace|end|theorem|lemma|def|instance|#check)\b", line):
            break
        kept.append(line)
    return "\n".join(kept).rstrip()


def extract_proof(text: str) -> tuple[str | None, str | None]:
    code = extract_code(text)
    match = re.search(r":=\s*by\b", code)
    if match:
        proof = "by" + code[match.end() :]
    elif re.match(r"^\s*by\b", code):
        proof = code[code.find("by") :]
    else:
        return None, "could not find a Lean proof beginning with `by`"
    proof = trim_after_proof(proof)
    if re.search(r"\b(?:sorry|admit)\b", proof):
        return None, "proof contains sorry/admit"
    return proof, None


def find_safe_insert_index(lines: list[str], theorem_start_line: int) -> int:
    idx = theorem_start_line - 1
    while idx > 0:
        prev = lines[idx - 1].strip()
        if not prev:
            idx -= 1
            continue
        if prev.startswith("@["):
            idx -= 1
            continue
        if prev.endswith("-/"):
            j = idx - 1
            while j >= 0 and "/--" not in lines[j]:
                j -= 1
            if j >= 0:
                idx = j
                continue
        break
    return idx


def verify_candidate(
    record: dict[str, Any],
    candidate_decl: str,
    timeout: float,
) -> tuple[bool, str]:
    source_path = MATHLIB / record["source_file"]
    lines = source_path.read_text(encoding="utf-8").splitlines()
    insert_idx = find_safe_insert_index(lines, int(record["source_line_start"]))
    candidate_lines = ["", *candidate_decl.rstrip().splitlines(), ""]
    output_lines = [*lines[:insert_idx], *candidate_lines, *lines[insert_idx:]]

    with tempfile.NamedTemporaryFile("w", suffix=".lean", delete=False, encoding="utf-8") as tmp:
        tmp_path = Path(tmp.name)
        tmp.write("\n".join(output_lines) + "\n")
    try:
        result = subprocess.run(
            ["lake", "env", "lean", str(tmp_path)],
            cwd=ROOT,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=timeout,
            check=False,
        )
    except subprocess.TimeoutExpired as exc:
        tmp_path.unlink(missing_ok=True)
        return False, f"Lean timeout after {timeout}s: {exc}"
    finally:
        tmp_path.unlink(missing_ok=True)

    output = (result.stdout + "\n" + result.stderr).strip()
    if result.returncode == 0:
        return True, ""
    return False, output[-5000:]


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def append_jsonl(path: Path, data: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as f:
        f.write(json.dumps(data, ensure_ascii=False, sort_keys=True) + "\n")


def write_findings(out_dir: Path, summary: dict[str, Any], results: list[dict[str, Any]]) -> None:
    lines = [
        "# Kimina-Prover-72B L1 Probability Baseline",
        "",
        f"Run time: {summary['run_time']}",
        f"Dataset: `{summary['dataset']}`",
        f"Model: `{summary['model']}`",
        f"Status: `{summary['status']}`",
        "",
    ]
    if summary["status"] == "blocked":
        lines += [
            "## Finding",
            "",
            "No Kimina-Prover-72B accuracy number was produced in this run.",
            "",
            f"Blocker: {summary['blocker']}",
            "",
            "The local machine had no reachable OpenAI-compatible Kimina endpoint. "
            "The model card recommends serving `AI-MO/Kimina-Prover-72B` with vLLM "
            "or SGLang; this script is ready to call either endpoint once available.",
            "",
            "## Reproduction Command",
            "",
            "```bash",
            "KIMINA_OPENAI_BASE_URL=http://localhost:8000/v1 \\",
            "  python3 scripts/evaluate_kimina_l1.py --limit 100",
            "```",
            "",
        ]
    else:
        accuracy = summary["accuracy"]
        lines += [
            "## Accuracy",
            "",
            f"Verified: {summary['verified']} / {summary['attempted']}",
            f"Accuracy: {accuracy:.2%}",
            "Target band: 10%-40%",
            "",
        ]
        if accuracy < 0.10:
            verdict = "below target; this L1 slice is too hard for this inference setup."
        elif accuracy <= 0.40:
            verdict = "inside target; this is a useful unsaturated L1 slice."
        else:
            verdict = "above target; this L1 slice is likely too easy or the inference budget is too strong."
        lines += ["## Finding", "", verdict, ""]

        by_family = Counter()
        ok_family = Counter()
        for result in results:
            by_family[result["theorem_family"]] += 1
            if result["verified"]:
                ok_family[result["theorem_family"]] += 1
        lines += ["## Family Breakdown", "", "| Family | Verified | Total |", "|---|---:|---:|"]
        for family in sorted(by_family):
            lines.append(f"| {family} | {ok_family[family]} | {by_family[family]} |")
        lines.append("")

    (out_dir / "findings.md").write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dataset", type=Path, default=DATASET)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUT)
    parser.add_argument("--model", default=os.environ.get("KIMINA_MODEL", DEFAULT_MODEL))
    parser.add_argument("--base-url", default=os.environ.get("KIMINA_OPENAI_BASE_URL", "http://localhost:8000/v1"))
    parser.add_argument("--api-key", default=os.environ.get("KIMINA_API_KEY"))
    parser.add_argument("--limit", type=int, default=100)
    parser.add_argument("--offset", type=int, default=0)
    parser.add_argument("--temperature", type=float, default=0.6)
    parser.add_argument("--top-p", type=float, default=0.95)
    parser.add_argument("--max-tokens", type=int, default=8096)
    parser.add_argument("--request-timeout", type=float, default=600)
    parser.add_argument("--lean-timeout", type=float, default=180)
    parser.add_argument("--context-lines", type=int, default=160)
    parser.add_argument("--no-preflight", action="store_true")
    parser.add_argument("--gold", action="store_true", help="verify dataset gold proofs instead of calling Kimina")
    args = parser.parse_args()

    out_dir = args.output_dir
    answers_dir = out_dir / "answers"
    candidates_dir = out_dir / "candidates"
    results_path = out_dir / "results.jsonl"
    if results_path.exists():
        results_path.unlink()

    selected = load_l1_records(args.dataset)[args.offset : args.offset + args.limit]
    run_time = dt.datetime.now(dt.timezone.utc).isoformat()

    if not args.gold and not args.no_preflight:
        ok, diagnostic = endpoint_available(args.base_url, args.api_key, timeout=10)
        if not ok:
            summary = {
                "status": "blocked",
                "blocker": f"Kimina endpoint unavailable at {args.base_url}: {diagnostic}",
                "run_time": run_time,
                "dataset": str(args.dataset.relative_to(ROOT) if args.dataset.is_relative_to(ROOT) else args.dataset),
                "model": args.model,
                "attempted": 0,
                "verified": 0,
                "accuracy": None,
            }
            write_json(out_dir / "summary.json", summary)
            write_findings(out_dir, summary, [])
            print(json.dumps(summary, ensure_ascii=False, sort_keys=True))
            return 2

    results: list[dict[str, Any]] = []
    for idx, record in enumerate(selected, start=args.offset + 1):
        eval_name = f"proofmem_kimina_l1_{idx:03d}"
        eval_statement = rename_decl(record["lean_statement"], eval_name)

        if args.gold:
            raw_answer = record["lean_proof"]
            proof = record["lean_proof"]
            extraction_error = None
            latency = 0.0
        else:
            messages = build_messages(record, eval_statement, args.context_lines)
            started = time.time()
            try:
                raw_answer = chat_completion(
                    base_url=args.base_url,
                    api_key=args.api_key,
                    model=args.model,
                    messages=messages,
                    temperature=args.temperature,
                    top_p=args.top_p,
                    max_tokens=args.max_tokens,
                    timeout=args.request_timeout,
                )
                extraction_started = time.time()
                proof, extraction_error = extract_proof(raw_answer)
                latency = extraction_started - started
            except (urllib.error.URLError, TimeoutError, KeyError, json.JSONDecodeError) as exc:
                raw_answer = ""
                proof = None
                extraction_error = f"generation failed: {type(exc).__name__}: {exc}"
                latency = time.time() - started

        answer_record = {
            "id": record["id"],
            "source_mathlib_decl": record["source_mathlib_decl"],
            "theorem_family": record["theorem_family"],
            "eval_name": eval_name,
            "raw_answer": raw_answer,
            "extraction_error": extraction_error,
            "latency_seconds": latency,
        }
        write_json(answers_dir / f"{record['id']}.json", answer_record)

        if proof is None:
            result = {
                **{k: answer_record[k] for k in ("id", "source_mathlib_decl", "theorem_family", "eval_name")},
                "verified": False,
                "error": extraction_error,
                "latency_seconds": latency,
            }
            append_jsonl(results_path, result)
            results.append(result)
            continue

        candidate_decl = eval_statement.rstrip() + " := " + proof.rstrip() + "\n"
        (candidates_dir / f"{record['id']}.lean").parent.mkdir(parents=True, exist_ok=True)
        (candidates_dir / f"{record['id']}.lean").write_text(candidate_decl, encoding="utf-8")
        verified, lean_output = verify_candidate(record, candidate_decl, timeout=args.lean_timeout)
        result = {
            **{k: answer_record[k] for k in ("id", "source_mathlib_decl", "theorem_family", "eval_name")},
            "verified": verified,
            "error": "" if verified else lean_output,
            "latency_seconds": latency,
        }
        append_jsonl(results_path, result)
        results.append(result)
        print(json.dumps({"id": record["id"], "verified": verified}, ensure_ascii=False, sort_keys=True), flush=True)

    verified_count = sum(1 for result in results if result["verified"])
    attempted = len(results)
    summary = {
        "status": "complete",
        "run_time": run_time,
        "dataset": str(args.dataset.relative_to(ROOT) if args.dataset.is_relative_to(ROOT) else args.dataset),
        "model": args.model if not args.gold else "gold_proofs",
        "base_url": args.base_url if not args.gold else None,
        "attempted": attempted,
        "verified": verified_count,
        "accuracy": verified_count / attempted if attempted else None,
        "target_accuracy_band": "10%-40%",
        "gold_mode": args.gold,
    }
    write_json(out_dir / "summary.json", summary)
    write_findings(out_dir, summary, results)
    print(json.dumps(summary, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

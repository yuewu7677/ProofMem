#!/usr/bin/env python3
"""Generate a source-style probability dataset for ProofMem.

This generator uses actual theorem-proof declarations from the pinned mathlib
probability files.  L1 and L3 records are source declarations with their
original proof bodies.  L2 records are alpha-renamed variants of L1
declarations whose renamed proof bodies are checked by Lean in the original
source-file context.
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import tempfile
from collections import defaultdict, deque
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MATHLIB = ROOT / ".lake/packages/mathlib/Mathlib"
OUT_DIR = ROOT / "datasets/probability"

TARGET_PER_LEVEL = 100

SOURCE_FILES = [
    ("Probability/ConditionalProbability.lean", "conditional_probability"),
    ("Probability/Independence/Basic.lean", "independence"),
    ("Probability/Independence/Conditional.lean", "conditional_independence"),
    ("Probability/Independence/Integration.lean", "independence_integration"),
    ("Probability/HasLaw.lean", "laws_of_random_variables"),
    ("Probability/IdentDistrib.lean", "identical_distribution"),
    ("Probability/Moments/Basic.lean", "moments"),
    ("Probability/Moments/Covariance.lean", "covariance"),
    ("Probability/Moments/Variance.lean", "variance"),
    ("Probability/Moments/SubGaussian.lean", "subgaussian"),
    ("Probability/Kernel/Basic.lean", "markov_kernels"),
    ("Probability/Kernel/Composition/Comp.lean", "kernel_composition"),
    ("Probability/Kernel/Composition/CompProd.lean", "kernel_comp_prod"),
    ("Probability/Kernel/WithDensity.lean", "kernel_density"),
    ("Probability/Martingale/Basic.lean", "martingales"),
    ("Probability/Martingale/OptionalStopping.lean", "optional_stopping"),
    ("Probability/Distributions/Bernoulli.lean", "bernoulli_distribution"),
    ("Probability/Distributions/Binomial.lean", "binomial_distribution"),
    ("Probability/Distributions/Poisson/Basic.lean", "poisson_distribution"),
    ("Probability/Distributions/Exponential.lean", "exponential_distribution"),
    ("Probability/Distributions/Gaussian/Basic.lean", "gaussian_distribution"),
]

DECL_RE = re.compile(r"^\s*(?:protected\s+)?(?:theorem|lemma)\s+([^\s:{(]+)")
STOP_RE = re.compile(
    r"^(?:@\[|theorem\s|lemma\s|protected\s+(?:theorem|lemma)\s|"
    r"nonrec\s+(?:theorem|lemma)\s|def\s|instance\s|alias\b|/--|"
    r"section\b|end\b|namespace\b|variable\b|open\b|"
    r"attribute\b|noncomputable\b|scoped\b|example\b)"
)

GREEK_NAMES = {
    "Ω": "Omega",
    "Ω'": "OmegaPrime",
    "Ω''": "OmegaDoublePrime",
    "μ": "mu",
    "ν": "nu",
    "κ": "kappa",
    "η": "eta",
    "π": "pi",
    "α": "alpha",
    "β": "beta",
    "γ": "gamma",
    "ι": "iota",
    "ω": "omega",
    "𝓧": "Xcal",
    "𝓨": "Ycal",
    "ℱ": "Fcal",
}


@dataclass(frozen=True)
class SourceDecl:
    kind: str
    name: str
    full_name: str
    source_file: str
    family: str
    start_line: int
    end_line: int
    text: str
    statement: str
    proof: str
    binder_names: tuple[str, ...]


@dataclass(frozen=True)
class L2Variant:
    parent: SourceDecl
    index: int
    text: str
    statement: str
    proof: str
    renamed_binders: dict[str, str]
    start_line: int | None = None
    end_line: int | None = None


def run(cmd: list[str], *, cwd: Path = ROOT) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        cmd,
        cwd=cwd,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )


def split_statement_proof(text: str) -> tuple[str, str] | None:
    marker = ":= by"
    if marker not in text:
        return None
    statement, rest = text.split(marker, 1)
    return statement.rstrip(), ("by" + rest).rstrip()


def matching_close(ch: str) -> str:
    return {"(": ")", "{": "}", "[": "]"}[ch]


def parse_group(text: str, start: int) -> tuple[str, int]:
    opener = text[start]
    stack = [matching_close(opener)]
    i = start + 1
    while i < len(text) and stack:
        ch = text[i]
        if ch in "({[":
            stack.append(matching_close(ch))
        elif ch == stack[-1]:
            stack.pop()
        i += 1
    if stack:
        raise ValueError("unbalanced binder group")
    return text[start + 1 : i - 1], i


def split_top_level_colon(text: str) -> tuple[str, str] | None:
    stack: list[str] = []
    for i, ch in enumerate(text):
        if ch in "({[":
            stack.append(matching_close(ch))
        elif stack and ch == stack[-1]:
            stack.pop()
        elif ch == ":" and not stack:
            return text[:i], text[i + 1 :]
    return None


def binder_names_from_group(group: str) -> list[str]:
    split = split_top_level_colon(group)
    if split is None:
        return []
    lhs = split[0].strip()
    if not lhs or lhs.startswith("_"):
        return []
    names = lhs.split()
    return [name for name in names if name != "_" and re.match(r"^[^\d\s:][^\s:]*$", name)]


def binder_names_from_statement(statement: str) -> tuple[str, ...]:
    first_line = statement.splitlines()[0]
    match = re.match(r"\s*(?:protected\s+)?(?:theorem|lemma)\s+[^\s:{(]+\s*", first_line)
    if not match:
        return ()

    header_rest = first_line[match.end() :] + "\n" + "\n".join(statement.splitlines()[1:])
    names: list[str] = []
    seen: set[str] = set()
    i = 0
    while i < len(header_rest):
        while i < len(header_rest) and header_rest[i].isspace():
            i += 1
        if i >= len(header_rest) or header_rest[i] == ":":
            break
        if header_rest[i] not in "({[":
            break
        opener = header_rest[i]
        try:
            group, i = parse_group(header_rest, i)
        except ValueError:
            return ()
        if opener in "({":
            for name in binder_names_from_group(group):
                if name not in seen:
                    seen.add(name)
                    names.append(name)
    return tuple(names)


def identifier_char(ch: str) -> bool:
    return ch.isalnum() or ch in "_'₀₁₂₃₄₅₆₇₈₉"


def replace_identifier(text: str, old: str, new: str) -> str:
    pieces: list[str] = []
    i = 0
    n = len(old)
    while i < len(text):
        if text.startswith(old, i):
            before = text[i - 1] if i > 0 else ""
            after = text[i + n] if i + n < len(text) else ""
            if (not before or not identifier_char(before)) and (
                not after or not identifier_char(after)
            ):
                pieces.append(new)
                i += n
                continue
        pieces.append(text[i])
        i += 1
    return "".join(pieces)


def sanitize_identifier(name: str) -> str:
    if name in GREEK_NAMES:
        return GREEK_NAMES[name]
    result: list[str] = []
    for ch in name:
        if ch.isascii() and (ch.isalnum() or ch == "_"):
            result.append(ch)
        elif ch == "'":
            result.append("Prime")
        elif ch in "₀₁₂₃₄₅₆₇₈₉":
            result.append(str("₀₁₂₃₄₅₆₇₈₉".index(ch)))
        elif ch in GREEK_NAMES:
            result.append(GREEK_NAMES[ch])
        else:
            result.append("x")
    sanitized = "".join(result).strip("_") or "arg"
    if sanitized[0].isdigit():
        sanitized = f"arg_{sanitized}"
    return sanitized


def make_l2_variant(decl: SourceDecl, index: int) -> L2Variant:
    new_name = f"proofmem_l2_{index:03d}"
    text = re.sub(
        r"^(\s*(?:protected\s+)?(?:theorem|lemma)\s+)([^\s:{(]+)",
        rf"\1{new_name}",
        decl.text,
        count=1,
    )
    renamed: dict[str, str] = {}
    for idx, name in enumerate(decl.binder_names, start=1):
        renamed[name] = f"pm{idx}_{sanitize_identifier(name)}"
    for old in sorted(renamed, key=len, reverse=True):
        text = replace_identifier(text, old, renamed[old])
    split = split_statement_proof(text)
    if split is None:
        raise ValueError(f"L2 variant lost proof marker for {decl.full_name}")
    statement, proof = split
    return L2Variant(
        parent=decl,
        index=index,
        text=text,
        statement=statement,
        proof=proof,
        renamed_binders=renamed,
    )


def collect_source_decls() -> list[SourceDecl]:
    decls: list[SourceDecl] = []
    seen: set[str] = set()

    for rel_path, family in SOURCE_FILES:
        path = MATHLIB / rel_path
        if not path.exists():
            continue
        lines = path.read_text(encoding="utf-8").splitlines()
        namespace_stack: list[str] = []
        i = 0
        while i < len(lines):
            namespace_match = re.match(r"^\s*namespace\s+(.+?)\s*$", lines[i])
            if namespace_match:
                namespace_stack.extend(namespace_match.group(1).split("."))
                i += 1
                continue

            end_match = re.match(r"^\s*end(?:\s+([A-Za-z0-9_'.]+))?\s*$", lines[i])
            if end_match and end_match.group(1):
                end_name = end_match.group(1).split(".")[-1]
                if namespace_stack and namespace_stack[-1] == end_name:
                    namespace_stack.pop()
                i += 1
                continue

            decl_match = DECL_RE.match(lines[i])
            if not decl_match:
                i += 1
                continue

            start = i
            j = i + 1
            while j < len(lines):
                if j > start and STOP_RE.match(lines[j]):
                    break
                j += 1

            raw_text = "\n".join(lines[start:j]).rstrip()
            split = split_statement_proof(raw_text)
            if split is None:
                i = j
                continue
            statement, proof = split
            if len(raw_text.splitlines()) > 80:
                i = j
                continue
            if re.match(r"^by\s+exact\s+[^\n]+\s*$", proof):
                i = j
                continue
            if len(proof.split()) < 8:
                i = j
                continue

            name = decl_match.group(1)
            if name.startswith("_root_."):
                full_name = name.removeprefix("_root_.")
            else:
                full_name = ".".join([*namespace_stack, name]) if namespace_stack else name
            if full_name in seen or "«" in full_name or "»" in full_name:
                i = j
                continue

            binder_names = binder_names_from_statement(statement)
            if not binder_names:
                i = j
                continue

            seen.add(full_name)
            kind_match = re.match(r"\s*(?:protected\s+)?(theorem|lemma)\s+", lines[start])
            kind = kind_match.group(1) if kind_match else "theorem"
            decls.append(
                SourceDecl(
                    kind=kind,
                    name=name,
                    full_name=full_name,
                    source_file=rel_path,
                    family=family,
                    start_line=start + 1,
                    end_line=j,
                    text=raw_text,
                    statement=statement,
                    proof=proof,
                    binder_names=binder_names,
                )
            )
            i = j
    return decls


def round_robin_select(candidates: list[SourceDecl], count: int, excluded: set[str] | None = None) -> list[SourceDecl]:
    excluded = excluded or set()
    by_family: dict[str, deque[SourceDecl]] = defaultdict(deque)
    for decl in candidates:
        if decl.full_name not in excluded:
            by_family[decl.family].append(decl)

    selected: list[SourceDecl] = []
    families = sorted(by_family)
    while len(selected) < count:
        progressed = False
        for family in families:
            queue = by_family[family]
            if queue:
                selected.append(queue.popleft())
                progressed = True
                if len(selected) == count:
                    break
        if not progressed:
            break
    if len(selected) < count:
        raise RuntimeError(f"Only selected {len(selected)} declarations; need {count}")
    return selected


def verify_source_names(decls: list[SourceDecl]) -> None:
    with tempfile.NamedTemporaryFile("w", suffix=".lean", delete=False, encoding="utf-8") as tmp:
        tmp_path = Path(tmp.name)
        tmp.write("import Mathlib\n")
        for decl in decls:
            tmp.write(f"#check {decl.full_name}\n")
    try:
        result = run(["lake", "env", "lean", str(tmp_path)])
    finally:
        tmp_path.unlink(missing_ok=True)
    if result.returncode != 0:
        raise RuntimeError(result.stdout + "\n" + result.stderr)


def verify_l2_variants(variants: list[L2Variant]) -> set[int]:
    active = {variant.index: variant for variant in variants}

    for _round in range(6):
        bad: set[int] = set()
        for rel_path in sorted({variant.parent.source_file for variant in active.values()}):
            source_lines = (MATHLIB / rel_path).read_text(encoding="utf-8").splitlines()
            inserts_by_line: dict[int, list[L2Variant]] = defaultdict(list)
            for variant in active.values():
                if variant.parent.source_file == rel_path:
                    inserts_by_line[variant.parent.end_line].append(variant)

            output_lines: list[str] = []
            ranges: list[tuple[range, int]] = []
            for line_no, line in enumerate(source_lines, start=1):
                output_lines.append(line)
                for variant in inserts_by_line.get(line_no, []):
                    output_lines.append("")
                    start = len(output_lines) + 1
                    variant_lines = variant.text.splitlines()
                    output_lines.extend(variant_lines)
                    end = len(output_lines)
                    ranges.append((range(start, end + 1), variant.index))

            with tempfile.NamedTemporaryFile("w", suffix=".lean", delete=False, encoding="utf-8") as tmp:
                tmp_path = Path(tmp.name)
                tmp.write("\n".join(output_lines) + "\n")
            try:
                result = run(["lake", "env", "lean", str(tmp_path)])
            finally:
                tmp_path.unlink(missing_ok=True)

            if result.returncode == 0:
                continue

            output = result.stdout + "\n" + result.stderr
            for match in re.finditer(r":(\d+):\d+: error", output):
                line = int(match.group(1))
                mapped = False
                for line_range, index in ranges:
                    if line in line_range:
                        bad.add(index)
                        mapped = True
                        break
                if not mapped:
                    raise RuntimeError(
                        f"L2 verification failed outside generated variants in {rel_path}.\n"
                        f"{output[-4000:]}"
                    )

        if not bad:
            return set(active)
        for index in bad:
            active.pop(index, None)

    raise RuntimeError("L2 verification did not converge after repeated filtering")


def record_for_source(level: str, idx: int, decl: SourceDecl, parent: str | None) -> dict[str, object]:
    return {
        "id": f"prob_{level}_{idx:03d}",
        "level": level,
        "source_dataset": "mathlib4_probability_source_pinned_by_lean_v4.32.0-rc1",
        "source_mathlib_decl": decl.full_name,
        "source_file": decl.source_file,
        "source_line_start": decl.start_line,
        "source_line_end": decl.end_line,
        "domain": "probability",
        "theorem_family": decl.family,
        "training_split": "train_replay_source" if level == "L1" else "test_sibling_transfer",
        "parent_theorem": parent,
        "transformation": "direct_source_extraction" if level == "L1" else "sibling_source_extraction",
        "proof_strategy": "original mathlib proof body",
        "lean_version": "leanprover/lean4:v4.32.0-rc1",
        "mathlib_version": "v4.32.0-rc1",
        "verified": True,
        "verification_method": "#check source declaration after importing Mathlib; proof body is from pinned mathlib source",
        "lean_statement": decl.statement,
        "lean_proof": decl.proof,
        "lean_declaration": decl.text,
        "binder_names": list(decl.binder_names),
    }


def record_for_l2(idx: int, variant: L2Variant, parent_id: str) -> dict[str, object]:
    return {
        "id": f"prob_L2_{idx:03d}",
        "level": "L2",
        "source_dataset": "mathlib4_probability_source_pinned_by_lean_v4.32.0-rc1",
        "source_mathlib_decl": variant.parent.full_name,
        "source_file": variant.parent.source_file,
        "source_line_start": variant.parent.start_line,
        "source_line_end": variant.parent.end_line,
        "domain": "probability",
        "theorem_family": variant.parent.family,
        "training_split": "test_perturbation",
        "parent_theorem": parent_id,
        "transformation": "alpha_rename_source_binders_and_proof_body",
        "proof_strategy": "alpha-renamed original mathlib proof body",
        "lean_version": "leanprover/lean4:v4.32.0-rc1",
        "mathlib_version": "v4.32.0-rc1",
        "verified": True,
        "verification_method": "inserted alpha-renamed declaration into a copy of the original mathlib source file and compiled with Lean",
        "lean_statement": variant.statement,
        "lean_proof": variant.proof,
        "lean_declaration": variant.text,
        "renamed_binders": variant.renamed_binders,
    }


def write_outputs(records: list[dict[str, object]], report: dict[str, object]) -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    with (OUT_DIR / "theorem_proof_pairs.jsonl").open("w", encoding="utf-8") as f:
        for record in records:
            f.write(json.dumps(record, ensure_ascii=False, sort_keys=True) + "\n")
    (OUT_DIR / "verification_report.json").write_text(
        json.dumps(report, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    (OUT_DIR / "README.md").write_text(
        "# Source-Style Probability Theorem-Proof Pairs\n\n"
        "This dataset contains 300 probability theorem-proof pairs generated from the pinned mathlib source.\n\n"
        "- `L1`: 100 original mathlib theorem/lemma declarations with original proof bodies.\n"
        "- `L2`: 100 alpha-renamed variants of the L1 declarations, with proof bodies renamed the same way and Lean-checked in the original source context.\n"
        "- `L3`: 100 disjoint sibling source declarations selected from the same probability families.\n\n"
        "Unlike the earlier wrapper dataset, these records use readable source-style Lean and do not cite the parent theorem as the proof.\n"
        "See `verification_report.json` for counts and verification methods.\n",
        encoding="utf-8",
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--target-per-level", type=int, default=TARGET_PER_LEVEL)
    args = parser.parse_args()

    candidates = collect_source_decls()
    l1_pool = round_robin_select(candidates, args.target_per_level + 60)
    l2_pool = [make_l2_variant(decl, idx + 1) for idx, decl in enumerate(l1_pool)]
    verified_l2_indices = verify_l2_variants(l2_pool)
    l1 = [decl for idx, decl in enumerate(l1_pool, start=1) if idx in verified_l2_indices][
        : args.target_per_level
    ]
    if len(l1) < args.target_per_level:
        raise RuntimeError(f"Only {len(l1)} L1 declarations had verified L2 variants")

    l1_names = {decl.full_name for decl in l1}
    l3 = round_robin_select(candidates, args.target_per_level, excluded=l1_names)

    verify_source_names([*l1, *l3])

    records: list[dict[str, object]] = []
    parent_ids: list[str] = []
    for idx, decl in enumerate(l1, start=1):
        parent_id = f"prob_L1_{idx:03d}"
        parent_ids.append(parent_id)
        records.append(record_for_source("L1", idx, decl, None))

    for idx, decl in enumerate(l1, start=1):
        variant = make_l2_variant(decl, idx)
        records.append(record_for_l2(idx, variant, parent_ids[idx - 1]))

    for idx, decl in enumerate(l3, start=1):
        records.append(record_for_source("L3", idx, decl, parent_ids[(idx - 1) % len(parent_ids)]))

    report = {
        "total_records": len(records),
        "levels": {level: sum(r["level"] == level for r in records) for level in ("L1", "L2", "L3")},
        "families": sorted({str(r["theorem_family"]) for r in records}),
        "lean_version": "leanprover/lean4:v4.32.0-rc1",
        "mathlib_version": "v4.32.0-rc1",
        "l1_l3_verification": "#check selected source declarations after importing Mathlib",
        "l2_verification": "compile alpha-renamed declarations inserted into copies of their original mathlib source files",
        "note": "L3 source declarations are disjoint from L1 and selected from the same probability families; logical inequivalence still needs semantic audit for publication-grade labels.",
    }
    write_outputs(records, report)
    print(json.dumps(report, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

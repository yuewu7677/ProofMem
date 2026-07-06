#!/usr/bin/env python3
"""Fetch L3 Analysis problems from FormalMATH (SphereLab/FormalMATH-All).

MA-ProofBench only has L1 (100) + L2 (100).  This script pulls 100 L3 sibling
theorems from FormalMATH's Analysis/Calculus subset and converts to the project
JSON schema (meeting notes 6.30).

Outputs:
  - raw/         — original records extracted to JSON
  - processed/   — project JSON schema
"""

import json
import os
import re
import sys
from pathlib import Path

OUT_DIR = Path(__file__).resolve().parent / "FormalMATH-L3"
RAW_DIR = OUT_DIR / "raw"
PROCESSED_DIR = OUT_DIR / "processed"

# ── Analysis/Calculus domain filter ──────────────────────────────────────
# FormalMATH domains are hierarchical strings like
#   "Mathematics -> Calculus -> Integral Calculus -> Techniques of Integration;"
# We match against these keywords (case-insensitive).
ANALYSIS_KEYWORDS = [
    "Calculus",
    "Analysis",
    "integral_calc",
    "differential_calc",
    "multivariable_calculus",
    "sequences_series",
    "Infinite Series",
    "Series of Functions",
    "Differentiation",
    "Convex Functions",
    "Continuous Functions",
    "Sequences and Limits",
    "Integration",
    "Approximation by Polynomials",
    "Improper Integrals",
    "ODE",
    "nondimensionalization",
    "polynomial_roots",
]

# Domains that are too elementary for L3 (high-school / pre-university level)
EXCLUDE_KEYWORDS = [
    "precalculus",
    "Prealgebra",
    "Simple Equations",
]


def is_analysis(domain: str) -> bool:
    """Return True if `domain` belongs to Analysis/Calculus."""
    dlower = domain.lower()
    # Exclude elementary topics
    if any(kw.lower() in dlower for kw in EXCLUDE_KEYWORDS):
        return False
    return any(kw.lower() in dlower for kw in ANALYSIS_KEYWORDS)


def extract_lean_statement(autoformalization: str) -> str:
    """Strip 'import Mathlib' / 'open ...' header, return bare theorem statement.

    If the statement ends with ':= by' (empty proof body), append 'sorry' so it's
    explicit that no target proof exists — consistent with MA-ProofBench format.
    """
    lines = autoformalization.strip().split("\n")
    # Find first line that starts with 'theorem' (or 'example')
    start_idx = 0
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("theorem ") or stripped.startswith("example "):
            start_idx = i
            break
    stmt = "\n".join(lines[start_idx:]).strip()
    # Add explicit sorry if proof body is empty
    if stmt.rstrip().endswith(":= by"):
        stmt = stmt + "\n  sorry"
    return stmt


def extract_imports(autoformalization: str) -> str:
    """Extract the import/Open header from the autoformalization."""
    lines = autoformalization.strip().split("\n")
    header_lines = []
    for line in lines:
        stripped = line.strip()
        if stripped.startswith("theorem ") or stripped.startswith("example "):
            break
        if stripped:
            header_lines.append(stripped)
    return "\n".join(header_lines)


def fetch_raw():
    """Download FormalMATH and save Analysis subset as raw JSON."""
    from datasets import load_dataset

    print("Fetching SphereLab/FormalMATH-All ...")
    ds = load_dataset("SphereLab/FormalMATH-All")

    RAW_DIR.mkdir(parents=True, exist_ok=True)

    # Filter Analysis records
    analysis_records = []
    for rec in ds["train"]:
        if is_analysis(rec["domain"]):
            analysis_records.append(dict(rec))

    print(f"  Analysis/Calculus subset: {len(analysis_records)} / {len(ds['train'])}")

    out_path = RAW_DIR / "analysis_subset.json"
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(analysis_records, f, indent=2, ensure_ascii=False)
    print(f"  Saved → {out_path}")

    # Print domain summary
    domains = {}
    for r in analysis_records:
        d = r["domain"]
        domains[d] = domains.get(d, 0) + 1
    print(f"\n  Top Analysis domains:")
    for d, c in sorted(domains.items(), key=lambda x: -x[1])[:15]:
        print(f"    [{c:4d}] {d}")


def convert_to_project_schema(target_count: int = 100):
    """Convert raw JSON to project schema.

    We select `target_count` L3 problems, attempting to cover diverse
    sub-domains within Analysis.
    """
    json_files = sorted(RAW_DIR.glob("*.json"))
    if not json_files:
        print("No raw JSON files. Run fetch_raw() first.")
        return

    PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

    with open(json_files[0], "r", encoding="utf-8") as f:
        records = json.load(f)

    # Simple deterministic selection: spread across the full list
    # (avoids clustering in one sub-domain)
    if len(records) <= target_count:
        selected = records
    else:
        step = len(records) / target_count
        indices = [int(i * step) for i in range(target_count)]
        selected = [records[idx] for idx in indices]

    all_items = []
    for i, rec in enumerate(selected):
        lean_stmt = extract_lean_statement(rec["autoformalization"])
        imports = extract_imports(rec["autoformalization"])

        # Parse compiler_feedback for Lean version / mathlib info if available
        compiler_feedback = rec.get("compiler_feedback", "")
        mathlib_version = ""
        if isinstance(compiler_feedback, str) and compiler_feedback:
            try:
                cf = json.loads(compiler_feedback)
            except json.JSONDecodeError:
                cf = {}
        else:
            cf = {}

        item = {
            "id": f"formalmath-l3-{i+1:04d}",
            "level": "L3",
            "domain": "Analysis",
            "sub_domain": rec.get("domain", ""),
            "source_dataset": "FormalMATH",
            "formal_statement": lean_stmt,
            "target_proof": None,          # FormalMATH is benchmark-only (sorry placeholder)
            "informal_statement": rec.get("refined_statement", ""),
            "imports": imports,
            "parent_id": None,
            "transformation_type": "sibling-theorem",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": mathlib_version,
            "verified": False,
            "split": "test",
        }
        all_items.append(item)

    # Shuffle deterministic — not needed since we sample across the list

    out_path = PROCESSED_DIR / "dataset.json"
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(all_items, f, indent=2, ensure_ascii=False)
    print(f"\nConverted {len(all_items)} L3 records → {out_path}")

    # Stats
    levels = {}
    domains = {}
    sub_domains = {}
    for r in all_items:
        levels[r["level"]] = levels.get(r["level"], 0) + 1
        domains[r["domain"]] = domains.get(r["domain"], 0) + 1
        sd = r["sub_domain"]
        sub_domains[sd] = sub_domains.get(sd, 0) + 1
    print(f"  Levels: {levels}")
    print(f"  Domains: {domains}")
    print(f"  Sub-domains ({len(sub_domains)} unique):")
    for sd, c in sorted(sub_domains.items(), key=lambda x: -x[1])[:10]:
        print(f"    [{c:3d}] {sd}")


def main():
    import argparse
    parser = argparse.ArgumentParser(
        description="Fetch FormalMATH L3 Analysis problems"
    )
    parser.add_argument("--raw-only", action="store_true", help="Only download raw")
    parser.add_argument("--convert-only", action="store_true", help="Only convert raw→schema")
    parser.add_argument("--count", type=int, default=100, help="Number of L3 problems (default 100)")
    args = parser.parse_args()

    if args.convert_only:
        convert_to_project_schema(target_count=args.count)
    elif args.raw_only:
        fetch_raw()
    else:
        fetch_raw()
        convert_to_project_schema(target_count=args.count)


if __name__ == "__main__":
    main()

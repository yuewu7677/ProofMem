#!/usr/bin/env python3
"""Fetch MA-ProofBench from Hugging Face and save to Zhi-Chen/MA-ProofBench/.

Outputs two formats:
  - raw/         — original Parquet data extracted to JSON
  - processed/   — project JSON schema (meeting notes 6.30 format)
"""

import json
import os
import sys
from pathlib import Path

OUT_DIR = Path(__file__).resolve().parent / "MA-ProofBench"
RAW_DIR = OUT_DIR / "raw"
PROCESSED_DIR = OUT_DIR / "processed"


def fetch_raw():
    """Download and save raw dataset as JSON."""
    from datasets import load_dataset

    print("Fetching openbmb/MA-ProofBench ...")
    ds = load_dataset("openbmb/MA-ProofBench")

    RAW_DIR.mkdir(parents=True, exist_ok=True)

    for split_name, split_ds in ds.items():
        records = [dict(row) for row in split_ds]
        out_path = RAW_DIR / f"{split_name}.json"
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(records, f, indent=2, ensure_ascii=False)
        print(f"  {split_name}: {len(records)} records → {out_path}")

    # Print schema info
    if list(ds.values()):
        first = list(ds.values())[0]
        print(f"\nColumns: {first.column_names}")
        print(f"Features:\n{first.features}\n")
        if len(first) > 0:
            print(f"First record keys: {list(dict(first[0]).keys())}")


def convert_to_project_schema():
    """Convert raw JSON to project schema (meeting notes 6.30)."""
    RAW_DIR.mkdir(parents=True, exist_ok=True)

    json_files = sorted(RAW_DIR.glob("*.json"))
    if not json_files:
        print("No raw JSON files. Run fetch_raw() first.")
        return

    PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

    all_records = []
    id_counter = 0

    for jf in json_files:
        with open(jf, "r", encoding="utf-8") as f:
            records = json.load(f)

        for rec in records:
            id_counter += 1

            # --- Field mapping (verified against actual dataset) ---
            # split  → level:  "level1"→L1, "level2"→L2
            raw_split = rec.get("split", "")
            if raw_split.startswith("level"):
                level = f"L{raw_split[len('level'):]}"
            else:
                level = raw_split or "L?"

            domain = rec.get("topic", "Analysis")
            tag = rec.get("tag", "")           # sub-domain, e.g. "Functions of one variable"
            header = rec.get("header", "")      # imports header
            formal_stmt = rec.get("formal_statement", "")
            nl_stmt = rec.get("informal_statement", "")
            version = rec.get("version", "")

            # No target proofs — all formal_statements end with `:= by\n  sorry`
            # This is a benchmark dataset: model must fill in the proof.

            item = {
                "id": f"ma-proofbench-{id_counter:04d}",
                "level": level,
                "domain": domain,
                "sub_domain": tag,
                "source_dataset": "MA-ProofBench",
                "formal_statement": formal_stmt,
                "target_proof": None,
                "informal_statement": nl_stmt,
                "imports": header,
                "parent_id": None,
                "transformation_type": None,
                "proof_strategy": [],
                "lean_version": "Lean4",
                "mathlib_version": version,
                "verified": False,
                "split": "test",               # all records are eval — no reference proofs
            }
            all_records.append(item)

    out_path = PROCESSED_DIR / "dataset.json"
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(all_records, f, indent=2, ensure_ascii=False)
    print(f"\nConverted {len(all_records)} records → {out_path}")

    # Stats
    levels = {}
    domains = {}
    for r in all_records:
        levels[r["level"]] = levels.get(r["level"], 0) + 1
        domains[r["domain"]] = domains.get(r["domain"], 0) + 1
    print(f"  Levels: {levels}")
    print(f"  Domains: {domains}")


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Fetch MA-ProofBench")
    parser.add_argument("--raw-only", action="store_true", help="Only download raw")
    parser.add_argument("--convert-only", action="store_true", help="Only convert raw→schema")
    args = parser.parse_args()

    if args.convert_only:
        convert_to_project_schema()
    elif args.raw_only:
        fetch_raw()
    else:
        fetch_raw()
        convert_to_project_schema()


if __name__ == "__main__":
    main()

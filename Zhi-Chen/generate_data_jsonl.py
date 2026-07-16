#!/usr/bin/env python3
"""
Generate DATA 1 (header-only) and DATA 2 (header+proof) JSONL files
from MA-ProofBench and FormalMATH-L3 dataset JSONs.

DATA 1: theorem signature with `:= by\n  sorry` — for Kimina baseline evaluation
DATA 2: full formal_statement with proof — for fine-tuning reference

Output:
  Zhi-Chen/DATA_1.jsonl  — 300 lines (200 MA + 100 FormalMATH)
  Zhi-Chen/DATA_2.jsonl  — 300 lines (200 MA + 100 FormalMATH)
"""

import json
import copy


def extract_header(formal_statement: str) -> str:
    """
    Extract theorem signature from formal_statement.
    Splits at the first `:=` (proof assignment) and returns everything before it.
    """
    idx = formal_statement.find(":=")
    if idx == -1:
        return formal_statement.strip()
    return formal_statement[:idx].rstrip()


def make_data1_entry(entry: dict) -> dict:
    """Create DATA 1 entry: header-only with `:= by\n  sorry`."""
    header = extract_header(entry["formal_statement"])
    data1 = copy.deepcopy(entry)
    data1["formal_statement"] = header + " := by\n  sorry"
    return data1


def make_data2_entry(entry: dict) -> dict:
    """Create DATA 2 entry: full formal_statement (header+proof), unchanged."""
    return copy.deepcopy(entry)


def load_json(path: str) -> list:
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def save_jsonl(path: str, data: list):
    with open(path, "w", encoding="utf-8") as f:
        for entry in data:
            f.write(json.dumps(entry, ensure_ascii=False) + "\n")
    print(f"  Saved: {path} ({len(data)} lines)")


def main():
    base = "."

    ma_path = f"{base}/MA-ProofBench/processed/dataset.json"
    formal_path = f"{base}/FormalMATH-L3/processed/dataset.json"

    ma_data = load_json(ma_path)
    formal_data = load_json(formal_path)

    print(f"Loaded MA-ProofBench: {len(ma_data)} entries")
    print(f"Loaded FormalMATH-L3: {len(formal_data)} entries")

    all_entries = ma_data + formal_data
    print(f"Total: {len(all_entries)} entries")

    # ── Generate DATA 1 (header-only) ──
    data1 = [make_data1_entry(e) for e in all_entries]
    # Validate: every DATA 1 entry ends with "sorry"
    for i, e in enumerate(data1):
        if not e["formal_statement"].strip().endswith("sorry"):
            print(f"  WARNING: DATA 1 entry {i} ({e['id']}) does not end with 'sorry'")
    save_jsonl(f"{base}/DATA_1.jsonl", data1)

    # ── Generate DATA 2 (header+proof) ──
    data2 = [make_data2_entry(e) for e in all_entries]
    save_jsonl(f"{base}/DATA_2.jsonl", data2)

    # ── Summary ──
    manual_count = sum(1 for e in all_entries if e.get("source_dataset") == "Manual")
    print(f"\nManual entries: {manual_count}")
    print(f"DATA 1: {len(data1)} lines (300 expected)")
    print(f"DATA 2: {len(data2)} lines (300 expected)")
    assert len(data1) == 300, f"DATA 1: expected 300, got {len(data1)}"
    assert len(data2) == 300, f"DATA 2: expected 300, got {len(data2)}"
    print("\nDone.")


if __name__ == "__main__":
    main()

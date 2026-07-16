#!/usr/bin/env python3
"""Add manually authored problems to the processed datasets.

Usage:
  python add_manual.py L1 01   # add L1 problem #01
  python add_manual.py --list   # list all manual problems
"""

import json
import os
import sys
from pathlib import Path

MANUAL_DIR = Path(__file__).resolve().parent
PROJECT_DIR = MANUAL_DIR.parent  # Zhi-Chen/

# ── Problem registry ─────────────────────────────────────────────────────
# Each entry: (id_suffix, lean_file, metadata)
MANUAL_PROBLEMS = {
    "L1": [
        # ── Analysis ──────────────────────────────────────────────────
        {
            "id_suffix": "manual-01",
            "lean_file": "L1_01_squeeze_theorem.lean",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Limits and convergence of real sequences",
            "transformation_type": "manual-authored",
            "proof_strategy": ["squeeze", "epsilon-N"],
        },
        {
            "id_suffix": "manual-02",
            "lean_file": "L1_02_limit_of_const.lean",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Limits of real sequences",
            "transformation_type": "manual-authored",
            "proof_strategy": ["tendsto_const"],
        },
        {
            "id_suffix": "manual-03",
            "lean_file": "L1_03_limit_add.lean",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Algebraic properties of limits",
            "transformation_type": "manual-authored",
            "proof_strategy": ["tendsto_add"],
        },
        {
            "id_suffix": "manual-04",
            "lean_file": "L1_04_limit_unique.lean",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Uniqueness of limits",
            "transformation_type": "manual-authored",
            "proof_strategy": ["hausdorff", "tendsto_nhds_unique"],
        },
        {
            "id_suffix": "manual-05",
            "lean_file": "L1_05_convergent_bounded.lean",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Boundedness of convergent sequences",
            "transformation_type": "manual-authored",
            "proof_strategy": ["tendsto", "bounded_iff"],
        },
        {
            "id_suffix": "manual-06",
            "lean_file": "L1_06_continuous_at_id.lean",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Continuity of identity function",
            "transformation_type": "manual-authored",
            "proof_strategy": ["continuous_at_id"],
        },
        # ── Linear Algebra ────────────────────────────────────────────
        {
            "id_suffix": "manual-07",
            "lean_file": "L1_07_smul_zero.lean",
            "level": "L1",
            "domain": "Linear Algebra",
            "sub_domain": "Vector space axioms",
            "transformation_type": "manual-authored",
            "proof_strategy": ["smul_zero"],
        },
        {
            "id_suffix": "manual-08",
            "lean_file": "L1_08_zero_smul.lean",
            "level": "L1",
            "domain": "Linear Algebra",
            "sub_domain": "Vector space axioms",
            "transformation_type": "manual-authored",
            "proof_strategy": ["zero_smul"],
        },
        {
            "id_suffix": "manual-09",
            "lean_file": "L1_09_add_comm_vec.lean",
            "level": "L1",
            "domain": "Linear Algebra",
            "sub_domain": "Vector space axioms",
            "transformation_type": "manual-authored",
            "proof_strategy": ["add_comm"],
        },
        {
            "id_suffix": "manual-10",
            "lean_file": "L1_10_neg_smul.lean",
            "level": "L1",
            "domain": "Linear Algebra",
            "sub_domain": "Vector space operations",
            "transformation_type": "manual-authored",
            "proof_strategy": ["neg_smul"],
        },
        {
            "id_suffix": "manual-11",
            "lean_file": "L1_11_linear_map_id.lean",
            "level": "L1",
            "domain": "Linear Algebra",
            "sub_domain": "Linear maps",
            "transformation_type": "manual-authored",
            "proof_strategy": ["linear_map_id"],
        },
        {
            "id_suffix": "manual-12",
            "lean_file": "L1_12_submodule_zero_mem.lean",
            "level": "L1",
            "domain": "Linear Algebra",
            "sub_domain": "Subspaces",
            "transformation_type": "manual-authored",
            "proof_strategy": ["submodule_zero_mem"],
        },
        # ── Group Theory ──────────────────────────────────────────────
        {
            "id_suffix": "manual-13",
            "lean_file": "L1_13_inv_mul_cancel.lean",
            "level": "L1",
            "domain": "Group Theory",
            "sub_domain": "Group axioms and identities",
            "transformation_type": "manual-authored",
            "proof_strategy": ["inv_mul_self"],
        },
        {
            "id_suffix": "manual-14",
            "lean_file": "L1_14_mul_inv_cancel.lean",
            "level": "L1",
            "domain": "Group Theory",
            "sub_domain": "Group axioms and identities",
            "transformation_type": "manual-authored",
            "proof_strategy": ["mul_inv_self"],
        },
        {
            "id_suffix": "manual-15",
            "lean_file": "L1_15_identity_unique.lean",
            "level": "L1",
            "domain": "Group Theory",
            "sub_domain": "Uniqueness of identity",
            "transformation_type": "manual-authored",
            "proof_strategy": ["one_unique", "mul_one"],
        },
        {
            "id_suffix": "manual-16",
            "lean_file": "L1_16_inv_unique.lean",
            "level": "L1",
            "domain": "Group Theory",
            "sub_domain": "Uniqueness of inverse",
            "transformation_type": "manual-authored",
            "proof_strategy": ["eq_inv_of_mul_eq_one"],
        },
        {
            "id_suffix": "manual-17",
            "lean_file": "L1_17_mul_left_inj.lean",
            "level": "L1",
            "domain": "Group Theory",
            "sub_domain": "Cancellation laws",
            "transformation_type": "manual-authored",
            "proof_strategy": ["mul_left_inj", "mul_left_cancel_iff"],
        },
        {
            "id_suffix": "manual-18",
            "lean_file": "L1_18_inv_inv.lean",
            "level": "L1",
            "domain": "Group Theory",
            "sub_domain": "Inverse properties",
            "transformation_type": "manual-authored",
            "proof_strategy": ["inv_inv"],
        },
        # ── Ring Theory ───────────────────────────────────────────────
        {
            "id_suffix": "manual-19",
            "lean_file": "L1_19_mul_zero.lean",
            "level": "L1",
            "domain": "Ring Theory",
            "sub_domain": "Ring arithmetic with zero",
            "transformation_type": "manual-authored",
            "proof_strategy": ["mul_zero"],
        },
        {
            "id_suffix": "manual-20",
            "lean_file": "L1_20_zero_mul.lean",
            "level": "L1",
            "domain": "Ring Theory",
            "sub_domain": "Ring arithmetic with zero",
            "transformation_type": "manual-authored",
            "proof_strategy": ["zero_mul"],
        },
        {
            "id_suffix": "manual-21",
            "lean_file": "L1_21_neg_mul_neg.lean",
            "level": "L1",
            "domain": "Ring Theory",
            "sub_domain": "Sign rules",
            "transformation_type": "manual-authored",
            "proof_strategy": ["neg_mul_neg", "ring"],
        },
        {
            "id_suffix": "manual-22",
            "lean_file": "L1_22_sub_eq_add_neg.lean",
            "level": "L1",
            "domain": "Ring Theory",
            "sub_domain": "Subtraction and additive inverse",
            "transformation_type": "manual-authored",
            "proof_strategy": ["sub_eq_add_neg"],
        },
        {
            "id_suffix": "manual-23",
            "lean_file": "L1_23_mul_one.lean",
            "level": "L1",
            "domain": "Ring Theory",
            "sub_domain": "Multiplicative identity",
            "transformation_type": "manual-authored",
            "proof_strategy": ["mul_one"],
        },
        {
            "id_suffix": "manual-24",
            "lean_file": "L1_24_one_mul.lean",
            "level": "L1",
            "domain": "Ring Theory",
            "sub_domain": "Multiplicative identity",
            "transformation_type": "manual-authored",
            "proof_strategy": ["one_mul"],
        },
        # ── Number Theory ─────────────────────────────────────────────
        {
            "id_suffix": "manual-25",
            "lean_file": "L1_25_dvd_refl.lean",
            "level": "L1",
            "domain": "Number Theory",
            "sub_domain": "Divisibility on ℕ",
            "transformation_type": "manual-authored",
            "proof_strategy": ["dvd_refl", "dvd_mul_right"],
        },
        {
            "id_suffix": "manual-26",
            "lean_file": "L1_26_dvd_trans.lean",
            "level": "L1",
            "domain": "Number Theory",
            "sub_domain": "Divisibility on ℕ",
            "transformation_type": "manual-authored",
            "proof_strategy": ["dvd_trans"],
        },
        {
            "id_suffix": "manual-27",
            "lean_file": "L1_27_gcd_comm.lean",
            "level": "L1",
            "domain": "Number Theory",
            "sub_domain": "GCD properties",
            "transformation_type": "manual-authored",
            "proof_strategy": ["Nat.gcd_comm"],
        },
        {
            "id_suffix": "manual-28",
            "lean_file": "L1_28_gcd_zero_right.lean",
            "level": "L1",
            "domain": "Number Theory",
            "sub_domain": "GCD properties",
            "transformation_type": "manual-authored",
            "proof_strategy": ["Nat.gcd_zero_right"],
        },
        {
            "id_suffix": "manual-29",
            "lean_file": "L1_29_dvd_add.lean",
            "level": "L1",
            "domain": "Number Theory",
            "sub_domain": "Divisibility on ℕ",
            "transformation_type": "manual-authored",
            "proof_strategy": ["dvd_add"],
        },
        {
            "id_suffix": "manual-30",
            "lean_file": "L1_30_prime_not_one.lean",
            "level": "L1",
            "domain": "Number Theory",
            "sub_domain": "Prime numbers",
            "transformation_type": "manual-authored",
            "proof_strategy": ["Nat.not_prime_one"],
        },
    ],
    "L2": [],
    "L3": [],
}


def extract_statement_and_imports(lean_path: Path) -> tuple[str, str]:
    """Extract formal_statement and imports from a .lean file."""
    content = lean_path.read_text(encoding="utf-8")

    # Split into imports section and theorem section
    lines = content.split("\n")
    imports = []
    stmt_start = 0
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("import ") or stripped.startswith("open "):
            imports.append(stripped)
        elif stripped.startswith("theorem ") or stripped.startswith("lemma "):
            stmt_start = i
            break

    # Extract the theorem (from stmt_start to end, including sorry)
    stmt_lines = []
    for line in lines[stmt_start:]:
        stmt_lines.append(line)

    stmt = "\n".join(stmt_lines).strip()

    # Remove comments (lines starting with /-- or --)
    clean_lines = []
    for line in stmt.split("\n"):
        stripped = line.strip()
        if stripped.startswith("/--") or stripped == "--" or stripped.startswith("set_option"):
            continue
        clean_lines.append(line)
    stmt = "\n".join(clean_lines).strip()

    imports_str = "\n".join(imports)
    return stmt, imports_str


def add_problem(problem: dict, target_dataset: str) -> None:
    """Add a single manual problem to the target dataset."""
    lean_file = MANUAL_DIR / problem["lean_file"]
    if not lean_file.exists():
        print(f"ERROR: {lean_file} not found")
        return

    stmt, imports = extract_statement_and_imports(lean_file)

    dataset_path = PROJECT_DIR / target_dataset
    if not dataset_path.exists():
        print(f"ERROR: {dataset_path} not found")
        return

    with open(dataset_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Generate a unique ID
    existing_ids = {r["id"] for r in data}
    base_id = f"proofmem-{problem['id_suffix']}"
    new_id = base_id
    counter = 1
    while new_id in existing_ids:
        new_id = f"{base_id}-{counter}"
        counter += 1

    entry = {
        "id": new_id,
        "level": problem["level"],
        "domain": problem["domain"],
        "sub_domain": problem["sub_domain"],
        "source_dataset": "ProofMem-Manual",
        "formal_statement": stmt,
        "target_proof": None,
        "informal_statement": f"Manual-authored {problem['level']} problem: {problem.get('description', '')}",
        "imports": imports,
        "parent_id": None,
        "transformation_type": problem["transformation_type"],
        "proof_strategy": problem.get("proof_strategy", []),
        "lean_version": "Lean4",
        "mathlib_version": "",
        "verified": False,  # Set to True after lake build succeeds
        "split": "test",
    }

    data.append(entry)
    data.sort(key=lambda r: r["level"] + r["id"])

    with open(dataset_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    level_count = sum(1 for r in data if r["level"] == problem["level"])
    print(f"Added {new_id} ({problem['level']}) → {target_dataset}")
    print(f"  {problem['level']} count: {level_count}")


def list_problems() -> None:
    """List all registered manual problems."""
    for level, problems in MANUAL_PROBLEMS.items():
        if problems:
            print(f"\n{level}:")
            for p in problems:
                lean_file = MANUAL_DIR / p["lean_file"]
                status = "OK" if lean_file.exists() else "MISSING"
                print(f"  {p['id_suffix']} -- {p['lean_file']} [{status}]")
    print()


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Manage manually authored problems")
    parser.add_argument("level", nargs="?", choices=["L1", "L2", "L3"],
                        help="Problem level")
    parser.add_argument("index", nargs="?", type=int, default=1,
                        help="Problem index (1-based)")
    parser.add_argument("--list", action="store_true", help="List all manual problems")
    parser.add_argument("--all", action="store_true", help="Add all unadded problems")
    args = parser.parse_args()

    if args.list:
        list_problems()
        return

    if args.level is None:
        parser.print_help()
        return

    # Map level to target dataset
    if args.level == "L1" or args.level == "L2":
        target = "MA-ProofBench/processed/dataset.json"
    else:
        target = "FormalMATH-L3/processed/dataset.json"

    problems = MANUAL_PROBLEMS.get(args.level, [])
    idx = args.index - 1  # 1-based → 0-based

    if idx < 0 or idx >= len(problems):
        print(f"No problem #{args.index} registered for {args.level}.")
        print(f"Available: {len(problems)} problem(s)")
        list_problems()
        sys.exit(1)

    add_problem(problems[idx], target)


if __name__ == "__main__":
    main()

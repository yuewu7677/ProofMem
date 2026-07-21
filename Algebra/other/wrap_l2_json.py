#!/usr/bin/env python3
"""Wrap the L2 theorems from AlgebraQuals_L2.lean into a JSON file that matches
the L1 verified schema (algebra_qual_theorems_verified.json):

    id, field, latex_theorem, latex_proof, lean_theorem, lean_proof, source

Plus two provenance keys a derived set should not lose:

    parent_id, transformation_type

`lean_theorem` is the bare statement; `lean_proof` is a standalone compilable
unit (`import Mathlib`, any section-local `open`s, then the full declaration),
exactly like the L1 file.

For genuine (meaning-preserving) perturbations the parent's LaTeX still
describes the child, so it is carried through. For the `constant_substitution`
record (003) the LaTeX no longer applies; latex fields are null and a
`semantic_note` is attached instead.

Run AFTER perturb_l2.py has (re)generated the L2 artifacts.
"""

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
L2_LEAN = ROOT / "AlgebraQuals_L2.lean"
L1_JSON = ROOT / "algebra_qual_theorems_verified.json"
REPORT = ROOT / "L2" / "perturbation_report.json"
OUT = ROOT / "L2" / "algebra_qual_theorems_l2_verified.json"

SECTION_RE = re.compile(
    r"^section\s+(L2Thm\d+)\s*$(.*?)^end\s+\1\s*$", re.MULTILINE | re.DOTALL
)
DECL_RE = re.compile(r"^(theorem|lemma)\s+(\w+)", re.MULTILINE)
OPEN = {"(": ")", "{": "}", "[": "]", "⦃": "⦄"}
CLOSE = {v: k for k, v in OPEN.items()}


def top_level_assign(decl: str):
    """Index of the `:=` that starts the proof, ignoring bracket nesting."""
    depth = 0
    for i in range(len(decl) - 1):
        c = decl[i]
        if c in OPEN:
            depth += 1
        elif c in CLOSE:
            depth -= 1
        elif c == ":" and decl[i + 1] == "=" and depth == 0:
            return i
    return None


def main() -> int:
    for p in (L2_LEAN, L1_JSON, REPORT):
        if not p.exists():
            print(f"error: {p} not found; run perturb_l2.py first", file=sys.stderr)
            return 1

    lean = L2_LEAN.read_text(encoding="utf-8").replace("\r\n", "\n")
    l1 = json.loads(L1_JSON.read_text(encoding="utf-8"))
    report = json.loads(REPORT.read_text(encoding="utf-8"))

    # parent theorem name -> L1 record (keyed via the name inside lean_theorem)
    l1_by_name = {}
    for r in l1:
        m = re.search(r"theorem\s+(\w+)", r.get("lean_theorem") or "")
        if m:
            l1_by_name[m.group(1)] = r

    # child theorem name -> perturbation record
    pert = {r["child"]: r for r in report.get("perturbed", [])}

    records, problems = [], []
    for m in SECTION_RE.finditer(lean):
        sec_id, body = m.group(1), m.group(2)
        num = sec_id.replace("L2Thm", "")  # "001".."030", aligns with L1 ids

        dm = DECL_RE.search(body)
        if not dm:
            problems.append(f"{sec_id}: no declaration found")
            continue
        name = dm.group(2)
        decl = body[dm.start():].strip()

        idx = top_level_assign(decl)
        if idx is None:
            problems.append(f"{name}: no top-level ':=' found")
            lean_theorem = decl
        else:
            lean_theorem = decl[:idx].rstrip()

        opens = [ln.strip() for ln in body.split("\n") if ln.strip().startswith("open ")]
        header = ["import Mathlib"]
        if opens:
            header += [""] + opens
        lean_proof = "\n".join(header) + "\n\n" + decl + "\n"

        pr = pert.get(name, {})
        parent_name = pr.get("parent")
        ttype = pr.get("transformation_type")
        parent = l1_by_name.get(parent_name, {})

        rec = {
            "id": num,
            "field": parent.get("field"),
            "latex_theorem": parent.get("latex_theorem"),
            "latex_proof": parent.get("latex_proof"),
            "lean_theorem": lean_theorem,
            "lean_proof": lean_proof,
            "source": parent.get("source"),
            "parent_id": parent_name,
            "transformation_type": ttype,
        }
        # A constant_substitution is a different theorem; the parent LaTeX no
        # longer describes it, so drop it and flag the caveat instead.
        if ttype == "constant_substitution":
            note = next((n[len("semantic: "):] for n in pr.get("notes", [])
                         if n.startswith("semantic: ")), None)
            rec["latex_theorem"] = None
            rec["latex_proof"] = None
            rec["semantic_note"] = note
            rec["rubric_level_actual"] = "L3-sibling"

        records.append(rec)

    records.sort(key=lambda r: r["id"])
    OUT.write_text(json.dumps(records, indent=2, ensure_ascii=False) + "\n",
                   encoding="utf-8")

    # --- checks ---
    if len(records) != len(l1):
        problems.append(f"record count {len(records)} != L1 count {len(l1)}")
    for r in records:
        if not r["lean_theorem"].startswith(("theorem", "lemma")):
            problems.append(f"{r['id']}: lean_theorem does not start with theorem/lemma")
        if not r["lean_proof"].startswith("import Mathlib"):
            problems.append(f"{r['id']}: lean_proof missing import header")
        if "push_neg" in r["lean_proof"]:
            problems.append(f"{r['id']}: lean_proof still contains deprecated push_neg")
        if r["transformation_type"] != "constant_substitution" and not r["latex_theorem"]:
            problems.append(f"{r['id']}: missing latex_theorem (expected for a perturbation)")

    print(f"wrote {OUT.relative_to(ROOT)}  ({len(records)} records)")
    if problems:
        print("PROBLEMS:")
        for p in problems:
            print("  -", p)
        return 1
    print("all checks passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())

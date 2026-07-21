#!/usr/bin/env python3
"""
ProofMem restricted Lean environment.

Windows: set PYTHONIOENCODING=utf-8 before running.

Two-phase approach:
  1. Analysis: extract all identifiers from gold proofs, map to mathlib modules.
  2. Evaluation: model sees only allowed imports in prompt; verification uses
     `import Mathlib` but POST-CHECKS that no unauthorized identifiers appear.

Usage:
  # Build identifier → module index (once, ~60s):
  python Zhi-Chen/restricted_env.py --build-index

  # Analyze all gold proofs, save per-theorem import sets:
  python Zhi-Chen/restricted_env.py --analyze --limit 30

  # Audit a proof against its allowed import set:
  python Zhi-Chen/restricted_env.py --audit --id ma-proofbench-0001

Output:
  Zhi-Chen/restricted_index.json       — identifier → [module, ...]
  Zhi-Chen/restricted_imports.json     — theorem_id → [import, ...]
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Any

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------

ROOT = Path(__file__).resolve().parents[1]
ZHI_CHEN = ROOT / "Zhi-Chen"
MATHLIB_SRC = ROOT / ".lake" / "packages" / "mathlib" / "Mathlib"
MATHLIB_BUILD = ROOT / ".lake" / "packages" / "mathlib" / ".lake" / "build" / "lib" / "lean"
DATA_GOLD = ZHI_CHEN / "DATA_gold.jsonl"
INDEX_FILE = ZHI_CHEN / "restricted_index.json"
IMPORTS_CACHE = ZHI_CHEN / "restricted_imports.json"

# ---------------------------------------------------------------------------
# Lean builtins / keywords — never need import
# ---------------------------------------------------------------------------

LEAN_KEYWORDS: set[str] = {
    "by", "have", "show", "from", "let", "in", "if", "then", "else",
    "fun", "forall", "exists", "match", "with", "set", "calc",
    "refine", "apply", "exact", "intro", "intros", "assumption",
    "rw", "rwa", "rw_mod_orphans", "simp", "simpa", "dsimp",
    "rcases", "obtain", "cases", "case", "induction",
    "left", "right", "constructor", "split", "trivial",
    "exfalso", "contradiction", "push_neg",
    "ring", "linarith", "nlinarith", "positivity", "norm_num",
    "field_simp", "gcongr", "abel", "omega",
    "decide", "native_decide",
    "first", "try", "repeat", "skip",
    "done", "admit", "sorry",
    "infer_instance", "inferInstance",
    "by_cases", "by_contra", "filter_upwards",
    "all_goals", "any_goals", "focus",
    "on_goal", "swap", "rotate",
    "apply_assumption", "tauto", "itauto",
    "specialize", "generalize", "subst", "injection",
    "convert", "ac_rfl", "rfl", "trans",
    "congr", "ext", "funext",
    "h", "h1", "h2", "h0", "ha", "hb", "hc", "hd",
    "hx", "hy", "hz", "hpos", "hneg", "hzero",
    "hp", "hq", "hr", "hs", "ht",
    "h_", "h0_", "h1_",
    "ih", "ih1", "ih2",
    "hn", "hm", "hx0", "hx1",
}

# Common mathlib tactic namespaces
TACTIC_NAMESPACES: set[str] = {
    "norm_num", "positivity", "linarith", "nlinarith", "ring", "field_simp",
    "gcongr", "abel", "omega", "dec_trivial",
}

# Builtin types/constants that don't need mathlib imports
BUILTIN_TYPES: set[str] = {
    "Nat", "Int", "Fin", "String", "Char", "List", "Option",
    "Prod", "Sum", "Unit", "Empty", "Sigma", "Subtype",
    "Eq", "HEq", "True", "False", "And", "Or", "Not", "Iff",
    "Exists", "Forall", "Decidable",
    "And.intro", "And.left", "And.right", "And.casesOn",
    "Or.inl", "Or.inr", "Or.casesOn",
    "Type", "Prop", "Sort",
    "OfNat", "HAdd", "HMul", "HPow", "HDiv", "HSub", "HMod",
    "Add", "Mul", "Pow", "Div", "Sub", "Mod",
    "BEq", "DecidableEq", "Repr", "ToString", "Inhabited",
    "FunLike", "Coe", "CoeTC", "CoeSort",
}

# Overrides: exact import path for known identifiers
# (derived from grep of mathlib source)
_KNOWN_OVERRIDES: dict[str, str] = {
    "Real.sin": "Mathlib.Data.Real.Basic",
    "Real.cos": "Mathlib.Data.Real.Basic",
    "Real.sqrt": "Mathlib.Data.Real.Basic",
    "Real.pi": "Mathlib.Data.Real.Basic",
    "Real.exp": "Mathlib.Data.Real.Basic",
    "Real.log": "Mathlib.Data.Real.Basic",
    "Real.sin_lt_x": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds",
    "abs_sin_le_one": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds",
    "abs_cos_le_one": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds",
    "Real.sin_sq": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic",
    "Real.cos_sq": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic",
    "Real.sin_add": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic",
    "Real.cos_add": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic",
    "Real.sin_two_mul": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic",
    "Real.cos_two_mul": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic",
    "Real.deriv_sin": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv",
    "Real.deriv_cos": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv",
    "Real.differentiableAt_sin": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv",
    "Real.differentiableAt_cos": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv",
    "deriv_sin": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv",
    "deriv_cos": "Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv",
    "exists_deriv_eq_slope": "Mathlib.Analysis.Calculus.Deriv.MeanValue",
    "HasDerivAt": "Mathlib.Analysis.Calculus.Deriv.Basic",
    "deriv": "Mathlib.Analysis.Calculus.Deriv.Basic",
    "DifferentiableAt": "Mathlib.Analysis.Calculus.Deriv.Basic",
    "DifferentiableOn": "Mathlib.Analysis.Calculus.Deriv.Basic",
    "ContDiff": "Mathlib.Analysis.Calculus.ContDiff.Basic",
    "ContDiffOn": "Mathlib.Analysis.Calculus.ContDiff.Basic",
    "fderiv": "Mathlib.Analysis.Calculus.FDeriv.Basic",
    "HasFDerivAt": "Mathlib.Analysis.Calculus.FDeriv.Basic",
    "LipschitzWith": "Mathlib.Topology.MetricSpace.Lipschitz",
    "LipschitzWith.of_dist_le_mul": "Mathlib.Topology.MetricSpace.Lipschitz",
    "Set.Icc": "Mathlib.Data.Set.Intervals.Basic",
    "Set.Ioc": "Mathlib.Data.Set.Intervals.Basic",
    "Set.Ioo": "Mathlib.Data.Set.Intervals.Basic",
    "Set.Ioi": "Mathlib.Data.Set.Intervals.Basic",
    "Set.Iic": "Mathlib.Data.Set.Intervals.Basic",
    "Set.range": "Mathlib.Data.Set.Basic",
    "Set.mem": "Mathlib.Data.Set.Basic",
    "Set.EqOn": "Mathlib.Data.Set.Basic",
    "Set.Finite": "Mathlib.Data.Set.Finite",
    "Set.Infinite": "Mathlib.Data.Set.Infinite",
    "IsOpen": "Mathlib.Topology.Basic",
    "IsClosed": "Mathlib.Topology.Basic",
    "IsCompact": "Mathlib.Topology.Basic",
    "IsConnected": "Mathlib.Topology.Connected",
    "Continuous": "Mathlib.Topology.Basic",
    "ContinuousOn": "Mathlib.Topology.Basic",
    "UniformContinuous": "Mathlib.Topology.Basic",
    "Tendsto": "Mathlib.Topology.Basic",
    "TendstoUniformly": "Mathlib.Topology.UniformConvergence",
    "TendstoUniformlyOn": "Mathlib.Topology.UniformConvergence",
    "Monotone": "Mathlib.Order.Basic",
    "StrictMono": "Mathlib.Order.Basic",
    "Antitone": "Mathlib.Order.Basic",
    "StrictAnti": "Mathlib.Order.Basic",
    "Function.Injective": "Mathlib.Logic.Function.Basic",
    "Function.Surjective": "Mathlib.Logic.Function.Basic",
    "Function.Periodic": "Mathlib.Logic.Function.Basic",
    "Summable": "Mathlib.Analysis.InfiniteSum.Basic",
    "MeasureTheory.IntegrableOn": "Mathlib.MeasureTheory.Integral.Basic",
    "MeasureTheory.Integrable": "Mathlib.MeasureTheory.Integral.Basic",
    "MeasureTheory.volume": "Mathlib.MeasureTheory.Measure.Basic",
    "HasFiniteIntegral": "Mathlib.MeasureTheory.Integral.Basic",
    "Measurable": "Mathlib.MeasureTheory.MeasurableSpace.Basic",
    "MeasurableSet": "Mathlib.MeasureTheory.MeasurableSpace.Basic",
    "SigmaFinite": "Mathlib.MeasureTheory.Measure.SigmaFinite",
    "Finset.range": "Mathlib.Data.Finset.Basic",
    "Finset.sum": "Mathlib.Data.Finset.Basic",
    "Finset.sum_range_succ": "Mathlib.Data.Finset.Basic",
    "Nat.factorial": "Mathlib.Data.Nat.Factorial.Basic",
    "Nat.succ_add": "Mathlib.Data.Nat.Basic",
    "Nat.add_succ": "Mathlib.Data.Nat.Basic",
    "Metric.ball": "Mathlib.Topology.MetricSpace.Basic",
    "Metric.closedBall": "Mathlib.Topology.MetricSpace.Basic",
    "Metric.sphere": "Mathlib.Topology.MetricSpace.Basic",
    "NormedAddCommGroup": "Mathlib.Analysis.NormedSpace.Basic",
    "NormedSpace": "Mathlib.Analysis.NormedSpace.Basic",
    "CompleteSpace": "Mathlib.Topology.MetricSpace.Complete",
    "Bornology.IsBounded": "Mathlib.Topology.Bornology.Basic",
    "Complex.I": "Mathlib.Data.Complex.Basic",
    "Complex.conj": "Mathlib.Data.Complex.Basic",
    "Complex.re": "Mathlib.Data.Complex.Basic",
    "Complex.im": "Mathlib.Data.Complex.Basic",
    "Odd": "Mathlib.Data.Nat.Parity",
    "Even": "Mathlib.Data.Nat.Parity",
    "StrongDual": "Mathlib.Analysis.NormedSpace.Dual",
    "Filter.atTop": "Mathlib.Order.Filter.Basic",
    "ENNReal": "Mathlib.Data.ENNReal.Basic",
    "intervalIntegral": "Mathlib.MeasureTheory.Integral.IntervalIntegral",
    "Set.indicator": "Mathlib.Data.Set.Indicator",
    "Function.Odd": "Mathlib.Logic.Function.Basic",
    # Common basic lemmas (may be re-exported transitively)
    "abs_neg": "Mathlib.Algebra.Order.Group.Abs",
    "abs_mul": "Mathlib.Algebra.Order.Ring.Abs",
    "abs_mul_le_abs_mul_abs": "Mathlib.Algebra.Order.Ring.Abs",
    "abs_sub": "Mathlib.Algebra.Order.Group.Abs",
    "abs_sub_abs_le_abs_sub": "Mathlib.Algebra.Order.Group.Abs",
    "add_comm": "Mathlib.Algebra.Group.Basic",
    "add_assoc": "Mathlib.Algebra.Group.Basic",
    "mul_comm": "Mathlib.Algebra.Group.Basic",
    "mul_assoc": "Mathlib.Algebra.Group.Basic",
    "sub_add_cancel": "Mathlib.Algebra.Group.Basic",
    "add_sub_cancel": "Mathlib.Algebra.Group.Basic",
    "sq_nonneg": "Mathlib.Algebra.Order.Ring.Basic",
    "pow_two": "Mathlib.Algebra.Power.Basic",
    "mul_nonneg": "Mathlib.Algebra.Order.Ring.Basic",
    "div_nonneg": "Mathlib.Algebra.Order.Field.Basic",
    "inv_nonneg": "Mathlib.Algebra.Order.Field.Basic",
    "lt_of_lt_of_le": "Mathlib.Order.Basic",
    "le_of_le_of_eq": "Mathlib.Order.Basic",
    "not_le": "Mathlib.Order.Basic",
    "le_refl": "Mathlib.Order.Basic",
    "le_trans": "Mathlib.Order.Basic",
    "lt_of_lt_of_eq": "Mathlib.Order.Basic",
    "max_eq_left": "Mathlib.Order.Basic",
    "max_eq_right": "Mathlib.Order.Basic",
    "min_eq_left": "Mathlib.Order.Basic",
    "min_eq_right": "Mathlib.Order.Basic",
    "mem_Icc": "Mathlib.Data.Set.Intervals.Basic",
    "mem_Ioo": "Mathlib.Data.Set.Intervals.Basic",
    "mem_Ioc": "Mathlib.Data.Set.Intervals.Basic",
    "div_pos": "Mathlib.Algebra.Order.Field.Basic",
    "one_div": "Mathlib.Algebra.Field.Basic",
    "zero_le_one": "Mathlib.Algebra.Order.Field.Basic",
    "zero_lt_one": "Mathlib.Algebra.Order.Field.Basic",
    "zero_lt_two": "Mathlib.Algebra.Order.Field.Basic",
    "zero_le_two": "Mathlib.Algebra.Order.Field.Basic",
    "sq_sqrt": "Mathlib.Data.Real.Basic",
    "sqrt_pos": "Mathlib.Data.Real.Basic",
    "sqrt_mul_self": "Mathlib.Data.Real.Basic",
    "mul_self_sqrt": "Mathlib.Data.Real.Basic",
    # More common lemmas
    "Real.sqrt_pos": "Mathlib.Analysis.Real.Sqrt",
    "Real.sqrt_pos.mpr": "Mathlib.Analysis.Real.Sqrt",
    "div_le_div_iff": "Mathlib.Algebra.Order.Field.Basic",
    "one_div_le_one_div": "Mathlib.Algebra.Order.Field.Basic",
    "Finset.sum_nonneg": "Mathlib.Algebra.Order.BigOperators.Group.Finset",
    "sum_nonneg": "Mathlib.Algebra.Order.BigOperators.Group.Finset",
    "positivity": "Mathlib.Tactic.Positivity",
    "field_simp": "Mathlib.Tactic.FieldSimp",
    "ring": "Mathlib.Tactic.Ring",
    "nlinarith": "Mathlib.Tactic.Nlinarith",
    "norm_num": "Mathlib.Tactic.NormNum",
    # More common lemmas
    "Finset.sum_le_sum": "Mathlib.Algebra.Order.BigOperators.Group.Finset",
    "eventually_of_forall": "Mathlib.Order.Filter.Basic",
    "tendsto_of_tendsto_of_tendsto_of_le_of_le": "Mathlib.Topology.Order.Basic",
    "tendsto_of_tendsto_of_tendsto_of_le_of_le'": "Mathlib.Topology.Order.Basic",
    # Measure theory
    "MeasureTheory.volume": "Mathlib.MeasureTheory.Measure.Basic",
    "Measure": "Mathlib.MeasureTheory.Measure.Basic",
    "MeasurableSpace": "Mathlib.MeasureTheory.MeasurableSpace.Basic",
    "MeasureTheory.IntegrableOn": "Mathlib.MeasureTheory.Integral.Basic",
    "MeasureTheory.Integrable": "Mathlib.MeasureTheory.Integral.Basic",
    "SigmaFinite": "Mathlib.MeasureTheory.Measure.SigmaFinite",
    # Basic algebra/order lemmas
    "add_le_add": "Mathlib.Algebra.Order.Group.Basic",
    "mul_le_mul": "Mathlib.Algebra.Order.Ring.Basic",
    "sub_le_sub": "Mathlib.Algebra.Order.Group.Basic",
    "le_add_of_nonneg_right": "Mathlib.Algebra.Order.Group.Basic",
    "Measure.prod_apply": "Mathlib.MeasureTheory.Constructions.Prod",
    "Measure.prod": "Mathlib.MeasureTheory.Constructions.Prod",
}

# Domain heuristic imports (fallback when exact identifier mapping fails)
_DOMAIN_IMPORTS: dict[str, list[str]] = {
    "Real functions": [
        "Mathlib.Data.Real.Basic",
        "Mathlib.Analysis.Calculus.Deriv.Basic",
        "Mathlib.Analysis.Calculus.ContDiff.Basic",
        "Mathlib.Analysis.Calculus.FDeriv.Basic",
        "Mathlib.Topology.Basic",
        "Mathlib.Topology.MetricSpace.Basic",
    ],
    "Sequences, series, summability": [
        "Mathlib.Data.Real.Basic",
        "Mathlib.Analysis.InfiniteSum.Basic",
        "Mathlib.Topology.Basic",
        "Mathlib.Order.Filter.Basic",
    ],
    "Functions of a complex variable": [
        "Mathlib.Data.Complex.Basic",
        "Mathlib.Analysis.Calculus.Deriv.Basic",
        "Mathlib.Analysis.Calculus.FDeriv.Basic",
        "Mathlib.Topology.Basic",
        "Mathlib.Topology.MetricSpace.Basic",
    ],
    "Measure and integration": [
        "Mathlib.MeasureTheory.Measure.Basic",
        "Mathlib.MeasureTheory.Integral.Basic",
        "Mathlib.MeasureTheory.MeasurableSpace.Basic",
        "Mathlib.Topology.Basic",
    ],
    "Functional analysis": [
        "Mathlib.Analysis.NormedSpace.Basic",
        "Mathlib.Topology.Basic",
        "Mathlib.Topology.MetricSpace.Basic",
    ],
    "Operator theory": [
        "Mathlib.Analysis.NormedSpace.Basic",
        "Mathlib.LinearAlgebra.Basic",
    ],
    "Analysis": [
        "Mathlib.Data.Real.Basic",
        "Mathlib.Analysis.Calculus.Deriv.Basic",
        "Mathlib.Analysis.Calculus.FDeriv.Basic",
        "Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic",
        "Mathlib.MeasureTheory.Integral.Basic",
        "Mathlib.Topology.Basic",
    ],
}

# Fallback imports when nothing else found — basic ℝ + calculus
_MINIMAL_IMPORTS = [
    "Mathlib.Data.Real.Basic",
]


# ---------------------------------------------------------------------------
# Index building
# ---------------------------------------------------------------------------

_DECL_RE = re.compile(
    r"^\s*(?:(?:noncomputable|protected|private|unsafe|partial|scoped)\s+)*"
    r"(?:def|theorem|lemma|structure|inductive|class|instance|abbrev|alias)\s+"
    r"([\w.]+)"
)


def build_index() -> dict[str, list[str]]:
    """Walk mathlib source, build identifier → [module, ...] mapping."""
    print(f"Building index from {MATHLIB_SRC}...")
    index: dict[str, list[str]] = {}

    for lean_file in MATHLIB_SRC.rglob("*.lean"):
        rel = lean_file.relative_to(MATHLIB_SRC.parent)
        module = str(rel.with_suffix("")).replace(os.sep, ".")

        try:
            for line in lean_file.read_text(encoding="utf-8", errors="replace").split("\n"):
                m = _DECL_RE.match(line)
                if not m:
                    continue
                full_name = m.group(1)
                short_name = full_name.split(".")[-1]

                for name in {full_name, short_name}:
                    index.setdefault(name, [])
                    if module not in index[name]:
                        index[name].append(module)
        except Exception:
            continue

    # Merge known overrides
    for ident, mod in _KNOWN_OVERRIDES.items():
        if ident not in index:
            index[ident] = [mod]
        elif mod not in index[ident]:
            index[ident].insert(0, mod)

    print(f"  {len(index):,} identifiers indexed")
    INDEX_FILE.write_text(json.dumps(index, ensure_ascii=False), encoding="utf-8")
    print(f"  Saved to {INDEX_FILE}")
    return index


def load_index() -> dict[str, list[str]]:
    if INDEX_FILE.exists():
        return json.loads(INDEX_FILE.read_text(encoding="utf-8"))
    return build_index()


# ---------------------------------------------------------------------------
# Identifier extraction from proof text
# ---------------------------------------------------------------------------

# Match dot-qualified identifiers: A.B.c.d
_QUALIFIED_RE = re.compile(r"\b([A-Z][\w]*(?:\.[\w]+)+)\b")
# Match single capitalized identifiers (potential lemma/theorem names)
_SINGLE_CAP_RE = re.compile(r"\b([A-Z][a-z]\w{2,})\b")
# Match lowercase identifiers with underscores (lemma/theorem names like exists_deriv_eq_slope)
_LOWERCASE_LEMMA_RE = re.compile(r"\b([a-z]\w*_[a-z]\w*(?:_\w+)*)\b")
# Match `variable` lines that shouldn't be counted as used identifiers
_VARIABLE_RE = re.compile(r"^\s*variable\s")

# Extended keywords — lowercase identifiers that should NOT be counted as lemmas
_LOWERCASE_KEYWORDS: set[str] = {
    "a_gt", "b_gt",  # common pattern variables
}


def _clean_proof(proof: str) -> str:
    """Remove comments and import lines from a Lean proof."""
    # Remove block comments
    proof = re.sub(r"/-.*?-/", "", proof, flags=re.DOTALL)
    # Remove line comments
    proof = re.sub(r"--[^\n]*", "", proof)
    # Remove import lines
    proof = re.sub(r"^\s*import\s+[^\n]*\n?", "", proof, flags=re.MULTILINE)
    # Remove open lines (these are part of the environment, not used identifiers)
    proof = re.sub(r"^\s*open\s+[^\n]*\n?", "", proof, flags=re.MULTILINE)
    return proof


# Only used for single-cap identifiers (module/namespace names)
_IGNORED_TOP_IDS: set[str] = {
    "Mathlib", "Init", "Prelude", "Lean",
    "Real", "Complex", "Nat", "Int", "Fin",
    "CategoryTheory", "Algebra", "Analysis", "Topology",
    "MeasureTheory", "Data", "Order", "Set", "Finset",
    "Batteries",
}


def extract_identifiers(proof: str, theorem_name: str = "") -> set[str]:
    """Extract all mathlib identifiers referenced in a proof."""
    cleaned = _clean_proof(proof)
    ids: set[str] = set()

    # Remove the theorem's own name from consideration
    if theorem_name:
        cleaned = cleaned.replace(theorem_name, " ")

    # Qualified identifiers: A.B.c
    for m in _QUALIFIED_RE.finditer(cleaned):
        ident = m.group(1)
        # Filter out things that look like file paths or Lean internals
        if ident.startswith("_") or ".." in ident:
            continue
        # Only filter qualified builtin.constructor patterns (And.intro, Or.inl, etc.)
        top = ident.split(".")[0]
        if top in BUILTIN_TYPES:
            continue
        ids.add(ident)

    # Single capitalized identifiers
    for m in _SINGLE_CAP_RE.finditer(cleaned):
        name = m.group(1)
        if (name not in LEAN_KEYWORDS
            and name not in BUILTIN_TYPES
            and name not in TACTIC_NAMESPACES
            and name not in _IGNORED_TOP_IDS
            and not name.startswith("_")
            and len(name) >= 3):
            ids.add(name)

    # Lowercase lemma names with underscores: abs_sin_le_one, exists_deriv_eq_slope
    # But NOT local variable names (h_foo, h0_foo, etc.)
    for m in _LOWERCASE_LEMMA_RE.finditer(cleaned):
        name = m.group(1)
        if (name not in LEAN_KEYWORDS
            and name not in _LOWERCASE_KEYWORDS
            and len(name) >= 5):
            # Skip local hypothesis patterns:
            #   h_foo, h0_foo, h1_foo, ih_foo, hn_foo, hx_foo, etc.
            #   hfoo_bar (hsq_eq, hden_pos, hnum_nonneg, etc.)
            if (name.startswith("h_") or name.startswith("h0_") or name.startswith("h1_")
                or name.startswith("ih_") or name.startswith("hn_") or name.startswith("hm_")
                or name.startswith("hx_") or name.startswith("hy_") or name.startswith("hz_")
                or name.startswith("hf_") or name.startswith("hg_") or name.startswith("hd_")
                or re.match(r"^h[a-z]{1,4}_", name)  # hsq_, hden_, hnum_, hpos_, hneg_, etc.
                or re.match(r"^h[A-Z]", name)):       # hPos, hNeg, etc.
                continue
            # Skip if this is a sub-component of an already-captured qualified identifier
            if any(qid.endswith("." + name) or ("." + name + ".") in qid
                   for qid in ids):
                continue
            ids.add(name)

    return ids


# ---------------------------------------------------------------------------
# Import resolution
# ---------------------------------------------------------------------------

def _module_exists(module: str) -> bool:
    """Check if a mathlib source module exists (has a .lean file)."""
    # Strip leading Mathlib. prefix since MATHLIB_SRC already points to Mathlib/
    if module.startswith("Mathlib."):
        module = module[len("Mathlib."):]
    rel_path = module.replace(".", os.sep) + ".lean"
    return (MATHLIB_SRC / rel_path).exists()


def resolve_imports(
    proof: str,
    index: dict[str, list[str]],
    domain: str = "",
    theorem_name: str = "",
    header: str = "",
) -> list[str]:
    """
    Map identifiers in a proof AND its header to specific mathlib import modules.

    Returns a sorted list of import module paths.
    """
    identifiers = extract_identifiers(proof, theorem_name)
    # Also extract identifiers from the theorem statement (types, constants)
    if header:
        header_clean = "\n".join(
            l for l in header.split("\n")
            if not l.strip().startswith("import ")
        )
        identifiers |= extract_identifiers(header_clean, theorem_name)
    imports: list[str] = []

    for ident in identifiers:
        # 1. Check known overrides first
        if ident in _KNOWN_OVERRIDES:
            mod = _KNOWN_OVERRIDES[ident]
            if mod not in imports:
                imports.append(mod)
            continue

        # 2. Check index
        if ident in index:
            modules = index[ident]
            # Prefer .Basic modules, then shortest path
            basic = [m for m in modules if m.endswith((".Basic", ".Defs"))]
            pick = basic[0] if basic else sorted(modules, key=len)[0]
            if pick not in imports and _module_exists(pick):
                imports.append(pick)
            continue

        # 3. Try short name (last component)
        short = ident.split(".")[-1]
        if short != ident and short in index:
            modules = index[short]
            # Prefer modules whose path contains the identifier's namespace
            top = ident.split(".")[0]
            matching = [m for m in modules if top in m]
            pick = matching[0] if matching else sorted(modules, key=len)[0]
            if pick not in imports and _module_exists(pick):
                imports.append(pick)
            continue

    # 4. Add domain-heuristic imports as fallback
    if domain and domain in _DOMAIN_IMPORTS:
        for imp in _DOMAIN_IMPORTS[domain]:
            if imp not in imports and _module_exists(imp):
                imports.append(imp)

    # 5. If still nothing found, add minimal imports (at least ℝ)
    if not imports:
        for imp in _MINIMAL_IMPORTS:
            if _module_exists(imp):
                imports.append(imp)

    return sorted(imports)


# ---------------------------------------------------------------------------
# Audit: check proof against allowed imports
# ---------------------------------------------------------------------------

def audit_proof(
    proof: str,
    allowed_imports: list[str],
    index: dict[str, list[str]],
    theorem_name: str = "",
) -> tuple[bool, list[str]]:
    """
    Check whether all identifiers in a proof are covered by allowed imports.

    Returns (clean, violations):
      - clean: True if no unauthorized identifiers found
      - violations: list of identifiers not in allowed import set
    """
    identifiers = extract_identifiers(proof, theorem_name)
    violations: list[str] = []

    for ident in identifiers:
        # Find which module provides this identifier
        module = None
        if ident in _KNOWN_OVERRIDES:
            module = _KNOWN_OVERRIDES[ident]
        elif ident in index:
            modules = index[ident]
            basic = [m for m in modules if m.endswith(".Basic")]
            module = basic[0] if basic else sorted(modules, key=len)[0]
        else:
            short = ident.split(".")[-1]
            if short != ident and short in index:
                modules = index[short]
                module = sorted(modules, key=len)[0]

        if module and module not in allowed_imports:
            violations.append(f"{ident} (from {module})")
        elif not module:
            violations.append(f"{ident} (unknown origin)")

    return len(violations) == 0, violations


# ---------------------------------------------------------------------------
# Prompt generation with restricted imports
# ---------------------------------------------------------------------------

def build_restricted_prompt(
    entry: dict[str, Any],
    allowed_imports: list[str],
) -> str:
    """
    Build a model prompt that only shows the allowed imports.

    This restricts what the model "knows about" — it should only use
    theorems/lemmas from the listed imports.
    """
    header = entry.get("S_Lean", entry.get("formal_statement", ""))

    # Strip existing imports from header
    header_clean = "\n".join(
        l for l in header.split("\n")
        if not l.strip().startswith("import ")
        and not l.strip().startswith("open ")
    ).strip()

    domain = entry.get("domain", "Unknown")
    informal = entry.get("S_NL", entry.get("informal_statement", ""))

    # Format imports block
    import_block = "\n".join(f"import {imp}" for imp in sorted(allowed_imports))

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
        f"```lean4\n{header_clean} := by\n```"
    )
    return prompt


# ---------------------------------------------------------------------------
# Batch analysis
# ---------------------------------------------------------------------------

def load_gold_data(path: Path | None = None) -> list[dict[str, Any]]:
    p = path or DATA_GOLD
    records = []
    with p.open(encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                records.append(json.loads(line))
    return records


def load_import_cache() -> dict[str, list[str]]:
    if IMPORTS_CACHE.exists():
        return json.loads(IMPORTS_CACHE.read_text(encoding="utf-8"))
    return {}


def save_import_cache(cache: dict[str, list[str]]) -> None:
    IMPORTS_CACHE.write_text(
        json.dumps(cache, ensure_ascii=False, indent=2), encoding="utf-8"
    )


def analyze_entries(
    entries: list[dict[str, Any]],
    index: dict[str, list[str]],
    limit: int = 0,
) -> dict[str, list[str]]:
    """Analyze all gold proofs, compute restricted import sets."""
    cache = load_import_cache()
    total = min(len(entries), limit) if limit else len(entries)

    for i, entry in enumerate(entries):
        if limit and i >= limit:
            break

        eid = entry["id"]
        if eid in cache:
            print(f"[{i+1}/{total}] {eid} (cached: {len(cache[eid])} imports)")
            continue

        proof = entry.get("P_Lean_gold", "")
        domain = entry.get("domain", "")
        incomplete = not proof or "sorry" in proof

        # Extract theorem name: prefer theorem/lemma over def.
        # Only break on theorem/lemma; keep scanning for def as fallback.
        thm_name = ""
        def_name = ""
        for src in [entry.get("S_Lean", ""), entry.get("P_Lean_gold", "")]:
            if not src:
                continue
            tm = re.search(r"(?:theorem|lemma)\s+(\S+)", src)
            if tm:
                thm_name = tm.group(1)
                break  # theorem/lemma found, stop
            if not def_name:
                dm = re.search(r"def\s+(\S+)", src)
                if dm:
                    def_name = dm.group(1)
        if not thm_name:
            thm_name = def_name

        header_src = entry.get("S_Lean", "")
        imports = resolve_imports(proof, index, domain, thm_name, header_src)
        identifiers = extract_identifiers(proof, thm_name)
        # Also count header identifiers for display
        header_ids = extract_identifiers(header_src, thm_name) if header_src else set()
        all_ids_count = len(identifiers | header_ids)

        # Audit: check this import set covers the proof
        clean, violations = audit_proof(proof, imports, index, thm_name)

        if incomplete:
            status = "INCOMPLETE"
        elif clean:
            status = "CLEAN"
        else:
            status = f"{len(violations)} viol"
        print(f"[{i+1}/{total}] {eid}: {all_ids_count} ids -> "
              f"{len(imports)} imports [{status}]")

        if violations:
            for v in violations[:3]:
                print(f"    [!] {v}")

        cache[eid] = imports

        if (i + 1) % 10 == 0:
            save_import_cache(cache)

    save_import_cache(cache)
    return cache


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main() -> int:
    parser = argparse.ArgumentParser(
        description="ProofMem restricted Lean environment"
    )
    parser.add_argument("--build-index", action="store_true",
                        help="Build identifier→module index from mathlib source")
    parser.add_argument("--analyze", action="store_true",
                        help="Analyze all gold proofs, compute import sets")
    parser.add_argument("--audit", action="store_true",
                        help="Audit a proof against its allowed imports")
    parser.add_argument("--id", type=str, default=None,
                        help="Operate on a single entry by id")
    parser.add_argument("--limit", type=int, default=0,
                        help="Limit number of entries")
    parser.add_argument("--print-imports", action="store_true",
                        help="Print the allowed imports for --id entry")
    parser.add_argument("--print-prompt", action="store_true",
                        help="Print the restricted prompt for --id entry")
    args = parser.parse_args()

    if args.build_index:
        build_index()
        return 0

    index = load_index()

    if args.analyze:
        entries = load_gold_data()
        if args.id:
            entries = [e for e in entries if e["id"] == args.id]
        analyze_entries(entries, index, limit=args.limit)
        return 0

    if args.audit and args.id:
        cache = load_import_cache()
        entries = load_gold_data()
        entry = next((e for e in entries if e["id"] == args.id), None)
        if not entry:
            print(f"Entry '{args.id}' not found")
            return 1

        imports = cache.get(args.id, [])
        if not imports:
            print(f"No cached imports for {args.id}. Run --analyze first.")
            return 1

        proof = entry.get("P_Lean_gold", "")
        thm_name = ""
        def_name = ""
        for src in [entry.get("S_Lean", ""), entry.get("P_Lean_gold", "")]:
            if not src:
                continue
            tm = re.search(r"(?:theorem|lemma)\s+(\S+)", src)
            if tm:
                thm_name = tm.group(1)
                break
            if not def_name:
                dm = re.search(r"def\s+(\S+)", src)
                if dm:
                    def_name = dm.group(1)
        if not thm_name:
            thm_name = def_name
        clean, violations = audit_proof(proof, imports, index, thm_name)
        identifiers = extract_identifiers(proof, thm_name)

        print(f"Entry: {args.id}")
        print(f"Domain: {entry.get('domain', '?')}")
        print(f"Identifiers found: {len(identifiers)}")
        print(f"Allowed imports: {len(imports)}")
        for imp in imports:
            print(f"  import {imp}")
        print(f"\nAudit: {'CLEAN' if clean else f'{len(violations)} VIOLATIONS'}")
        if violations:
            for v in violations:
                print(f"  [!] {v}")
        return 0

    if args.print_imports and args.id:
        cache = load_import_cache()
        imports = cache.get(args.id, [])
        if not imports:
            print(f"No cached imports for {args.id}")
            return 1
        for imp in sorted(imports):
            print(imp)
        return 0

    if args.print_prompt and args.id:
        cache = load_import_cache()
        entries = load_gold_data()
        entry = next((e for e in entries if e["id"] == args.id), None)
        if not entry or args.id not in cache:
            print(f"No data for {args.id}")
            return 1
        print(build_restricted_prompt(entry, cache[args.id]))
        return 0

    parser.print_help()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

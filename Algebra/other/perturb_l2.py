#!/usr/bin/env python3
"""Generate L2 (Theorem Perturbation) data from the L1 Mathlib90 corpus.

Implements the two perturbations named in `data_classification.md` L2:

  * alpha-renaming of variables and binders
  * reordering of binders / hypotheses

Policy (one L2 record per L1 theorem, "best available"):
  - alpha-rename is always attempted;
  - hypothesis reordering is applied additionally whenever the binder
    dependency graph admits a non-identity topological order;
  - if reordering is not safe, the record is emitted alpha-only and tagged
    accordingly, rather than skipped or emitted as a no-op.

Scope: each L1 theorem lives in its own `section SNNN` carrying its own
`variable` lines. Renaming rewrites the section's `variable` block as well as
the theorem's own binders, so theorems whose parameters come entirely from
`variable` (37 of 93) still receive a genuine perturbation.

IMPORTANT: this script performs a token-aware *textual* transformation. It does
not parse Lean. Every output must be checked with the verifier before use:

    py Zhi-Chen/verify/verify.py Mathlib90_algebra/L2/Mathlib90_L2.lean

Usage:
    python scripts/perturb_l2.py [--seed N] [--dry-run]
"""

from __future__ import annotations

import argparse
import json
import random
import re
import sys
from itertools import permutations
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# Two corpora share this machinery, and they are shaped differently:
#
#   Mathlib90.lean   `section SNNN`,   parameters mostly in `variable` blocks,
#                    a few sections carrying two declarations.
#   AlgebraQuals.lean `section ThmNNN`, exactly one theorem per section, no
#                    `variable` blocks at all -- every binder, including the
#                    type variables, is written on the theorem itself.
PRESETS = {
    "mathlib90": {
        "lean": "Mathlib90_algebra/L1/Mathlib90.lean",
        "json": "Mathlib90_algebra/L1/Mathlib90.json",
        "out_dir": "Mathlib90_algebra/L2",
        "out_lean": "Mathlib90_L2.lean",
        "out_json": "Mathlib90_L2.json",
        "section_pat": r"S\d+",
        "section_prefix": "L2S",
    },
    "algebraquals": {
        "lean": "AlgebraQuals_L1.lean",
        "json": "algebra_qual_theorems_verified.json",
        "out_dir": "L2",
        # The .lean lands at the repo root, not in out_dir. A lean_lib resolves
        # its root module relative to srcDir (default "."), and AlgebraQuals.lean
        # is already known to build from there. Burying the file in L2/ without a
        # matching srcDir would leave it outside every lake target -- in which
        # case `lake build` succeeds without touching it and verify.py reports a
        # perfect score having elaborated nothing.
        "out_lean_dir": ".",
        "out_lean": "AlgebraQuals_L2.lean",
        "out_json": "algebra_quals_l2.json",
        "section_pat": r"Thm\d+",
    },
}

# Manual perturbations for theorems the automatic binder machinery cannot touch.
#
# `ker_aeval_t2_t3_t4_isPrime` is a fully concrete statement over ℂ with no
# binders, so alpha-renaming and reordering have nothing to act on. Substituting
# the monomial exponents gives a non-verbatim variant whose proof
# (`RingHom.ker_isPrime _`) is unchanged, because it only needs the codomain
# ℂ[X] to be an integral domain -- the specific exponents are irrelevant.
#
# NOTE ON CLASSIFICATION: this is NOT a meaning-preserving L2 perturbation. The
# resulting theorem is about a *different* ideal, so per data_classification.md
# it is really an L3-style sibling (shared proof ingredient, not logical
# equivalence). It is tagged `constant_substitution` so it can be filtered or
# relabelled rather than silently counted as robustness-to-surface-change.
MANUAL_SUBS = {
    "algebraquals": {
        "ker_aeval_t2_t3_t4_isPrime": {
            "new_name": "ker_aeval_t3_t5_t7_isPrime_l2",
            # Applied as a single atomic pass (see apply_exponent_map): a naive
            # sequential 2->3 then 3->5 would rewrite the freshly-created 3s.
            "exponent_map": {2: 3, 3: 5, 4: 7},
            "transformation_type": "constant_substitution",
            "semantic_note": (
                "Different ideal from the L1 parent; proof unchanged because "
                "ker of any algebra map into the domain ℂ[X] is prime. "
                "Sibling (L3-style), not a meaning-preserving L2 perturbation."
            ),
        }
    }
}

# Matches the exponent in `(Polynomial.X : Polynomial ℂ) ^ N`.
_POW_RE = re.compile(r"(Polynomial ℂ\) \^ )(\d+)")


def apply_exponent_map(text: str, expmap: dict[int, int]) -> tuple[str, int]:
    """Rewrite `X ^ N` exponents via expmap in one atomic pass.

    Single-pass `re.sub` guarantees each occurrence is considered exactly once,
    so an entry like {2:3, 3:5} never lets the 3 produced from a 2 get caught by
    the 3->5 rule. Returns (new_text, count_changed).
    """
    n = 0

    def repl(m: re.Match) -> str:
        nonlocal n
        old = int(m.group(2))
        if old in expmap:
            n += 1
            return f"{m.group(1)}{expmap[old]}"
        return m.group(0)

    return _POW_RE.sub(repl, text), n

# ---------------------------------------------------------------------------
# Identifier handling
# ---------------------------------------------------------------------------

# Characters that may appear *inside* a Lean identifier. Used to build
# boundary assertions, so we never rename a substring of a longer name
# (e.g. renaming `a` must not touch `mul_assoc` or `add_comm`).
IDC = (
    "A-Za-z0-9_'!?"
    "À-ɏ"      # Latin-1 supplement / extended
    "Ͱ-Ͽ"      # Greek (α β γ σ ...)
    "ᴀ-ᵿ"      # phonetic extensions
    "₀-₟"      # SUBscripts only (h₁, u₂ ...)
    "℀-⅏"      # letterlike (ℝ ℕ ...)
)
# Superscripts (U+2070-U+207F) are deliberately NOT identifier characters.
# In Lean `⁻¹` is postfix notation, so `a⁻¹` is the identifier `a` followed by
# notation. Including U+207B here would make the boundary check read `a⁻` as a
# single token and silently skip renaming `a` -- producing Lean that does not
# compile. Same reasoning for `¹` (U+00B9), which sits below the À-ɏ range.

# A rename must not fire when preceded by `.` either, so that `h.symm` renames
# `h` but never the projection `symm`, and `Nat.foo` is left alone.
def rename_token(text: str, old: str, new: str) -> str:
    pat = rf"(?<![{IDC}.]){re.escape(old)}(?![{IDC}])"
    return re.sub(pat, new, text)


def token_present(text: str, name: str) -> bool:
    return re.search(rf"(?<![{IDC}.]){re.escape(name)}(?![{IDC}])", text) is not None


# ---------------------------------------------------------------------------
# Comment / string masking
# ---------------------------------------------------------------------------

def mask_noncode(text: str):
    """Replace comments and string literals with placeholders.

    Renaming must never reach inside a comment or a string. Returns the masked
    text plus a restore function.
    """
    store: list[str] = []

    def stash(m: re.Match) -> str:
        store.append(m.group(0))
        return f"\x00{len(store) - 1}\x00"

    # Block comments first (they may contain `--`), then line comments, then strings.
    masked = re.sub(r"/-.*?-/", stash, text, flags=re.DOTALL)
    masked = re.sub(r"--[^\n]*", stash, masked)
    masked = re.sub(r'"(?:[^"\\]|\\.)*"', stash, masked)

    def restore(s: str) -> str:
        return re.sub(r"\x00(\d+)\x00", lambda m: store[int(m.group(1))], s)

    return masked, restore


# ---------------------------------------------------------------------------
# Binder parsing
# ---------------------------------------------------------------------------

OPEN = {"(": ")", "{": "}", "[": "]", "⦃": "⦄"}  # ( { [ ⦃
CLOSE = {v: k for k, v in OPEN.items()}


def split_binder_region(decl: str):
    """Split `theorem NAME <binders> : <goal>` at the first depth-0 colon.

    Returns (head, binder_text, rest) where head is `theorem NAME`.
    Colons inside binder groups are at depth > 0 and are skipped.
    """
    m = re.match(r"\s*(theorem|lemma)\s+(\S+)", decl)
    if not m:
        return None
    start = m.end()
    depth = 0
    for i in range(start, len(decl)):
        c = decl[i]
        if c in OPEN:
            depth += 1
        elif c in CLOSE:
            depth -= 1
        elif c == ":" and depth == 0:
            # `:=` at depth 0 with no goal would mean no explicit goal; still fine.
            return decl[:start], decl[start:i], decl[i:]
    return None


def parse_binder_groups(binder_text: str):
    """Split a binder region into bracketed groups, preserving order.

    Returns list of dicts: {raw, kind, names, type}.
    Anonymous instance binders like `[Group G]` get names == [].
    """
    groups = []
    i = 0
    n = len(binder_text)
    while i < n:
        c = binder_text[i]
        if c in OPEN:
            close = OPEN[c]
            depth = 0
            j = i
            while j < n:
                if binder_text[j] in OPEN:
                    depth += 1
                elif binder_text[j] in CLOSE:
                    depth -= 1
                    if depth == 0:
                        break
                j += 1
            raw = binder_text[i : j + 1]
            inner = raw[1:-1]
            if ":" in inner:
                lhs, rhs = inner.split(":", 1)
                names = lhs.split()
                # `[Decidable p]` has no `:`; `[inst : Decidable p]` does.
                if c == "[" and not re.fullmatch(r"[\w'₀-₉]+", lhs.strip()):
                    names, rhs = [], inner
            else:
                names, rhs = [], inner
            groups.append(
                {"raw": raw, "kind": c, "names": names, "type": rhs.strip()}
            )
            i = j + 1
        else:
            i += 1
    return groups


def dependency_edges(groups):
    """edges[i] = set of earlier group indices that group i depends on."""
    edges = {i: set() for i in range(len(groups))}
    for i, g in enumerate(groups):
        for j, prior in enumerate(groups):
            if j >= i:
                continue
            for nm in prior["names"]:
                if token_present(g["type"], nm):
                    edges[i].add(j)
                    break
    return edges


def find_reordering(groups, rng, max_groups=7):
    """Return a non-identity permutation respecting dependencies, or None.

    Instance binders `[...]` are PINNED and nothing is moved across them.

    A name-based dependency scan cannot see typeclass requirements. Given

        {R : Type*} [CommRing R] [IsLocalRing R] {x : R}
        (hx : x ∈ IsLocalRing.maximalIdeal R)

    nothing in `hx`'s text names the instance binders, yet elaborating
    `IsLocalRing.maximalIdeal R` requires `[IsLocalRing R]` to already be in
    scope; likewise `[Module R M]` needs the semiring structure from `[Ring R]`.
    Permuting freely therefore produces statements that do not elaborate.
    Restricting permutation to contiguous runs of non-instance binders keeps
    every instance in place and every binder on the same side of it.
    """
    n = len(groups)
    if n < 2:
        return None
    edges = dependency_edges(groups)

    perm = list(range(n))
    changed = False
    i = 0
    while i < n:
        if groups[i]["kind"] == "[":
            i += 1
            continue
        j = i
        while j < n and groups[j]["kind"] != "[":
            j += 1
        run = list(range(i, j))
        if len(run) >= 2:
            new_run = _permute_run(run, edges, rng, max_groups)
            if new_run:
                perm[i:j] = new_run
                changed = True
        i = j
    return perm if changed else None


def _permute_run(run, edges, rng, max_groups):
    """Permute one contiguous run of non-instance binders, or return None.

    Dependencies on binders outside the run are automatically preserved: those
    binders do not move, and run members stay inside the run's own span.
    """
    def ok(cand) -> bool:
        pos = {orig: p for p, orig in enumerate(cand)}
        for orig in cand:
            for d in edges[orig]:
                if d in pos and pos[d] >= pos[orig]:
                    return False
        return True

    if len(run) > max_groups:
        for _ in range(200):
            cand = run[:]
            rng.shuffle(cand)
            if cand != run and ok(cand):
                return cand
        return None

    cands = [list(p) for p in permutations(run) if list(p) != run and ok(list(p))]
    return rng.choice(cands) if cands else None


def _valid(perm, edges) -> bool:
    """perm[k] = original index placed at position k. Deps must come earlier."""
    pos = {orig: k for k, orig in enumerate(perm)}
    for i, deps in edges.items():
        for d in deps:
            if pos[d] >= pos[i]:
                return False
    return True


# ---------------------------------------------------------------------------
# Section parsing
# ---------------------------------------------------------------------------

DECL_RE = re.compile(r"^(theorem|lemma)\s+(\S+)", re.MULTILINE)

# Set by main() from the chosen preset. Anchoring on the specific section-name
# shape (S\d+ or Thm\d+) matters: it keeps nested `section Monoid'` blocks in
# the Mathlib90 corpus from being mistaken for top-level sections.
SECTION_RE = re.compile(
    r"^section\s+(S\d+)\s*$(.*?)^end\s+\1\s*$", re.MULTILINE | re.DOTALL
)


def set_section_pattern(pat: str) -> None:
    global SECTION_RE
    SECTION_RE = re.compile(
        rf"^section\s+({pat})\s*$(.*?)^end\s+\1\s*$", re.MULTILINE | re.DOTALL
    )


def parse_sections(lean_text: str):
    """One entry per `section SNNN`.

    A section may contain more than one declaration (S021, S023 and S052 each
    hold two, inside nested `section Monoid'` blocks). All of them are recorded,
    because they share the section's `variable` context and must be renamed
    together to stay consistent.
    """
    out = []
    for m in SECTION_RE.finditer(lean_text):
        sec, body = m.group(1), m.group(2)
        decls = [(dm.group(2), dm.start()) for dm in DECL_RE.finditer(body)]
        if not decls:
            continue
        var_lines = [
            ln for ln in body.split("\n") if ln.strip().startswith("variable")
        ]
        out.append(
            {"section": sec, "body": body, "var_lines": var_lines,
             "names": [n for n, _ in decls],
             "decl": body[decls[0][1]:].strip()}
        )
    return out


def collect_type_vars(sec) -> list[str]:
    """Type variables declared by `variable {... : Type*}` lines.

    Used only as a fallback: four theorems (m006, m007, m013, m079) bind no
    term-level variable at all, so renaming a type variable is the only
    alpha-rename available to them.
    """
    out = []
    for ln in sec["var_lines"]:
        if "Type" not in ln:
            continue
        for g in parse_binder_groups(ln):
            if "Type" in g["type"]:
                out += g["names"]
    return out


def collect_renamable(sec) -> list[str]:
    """Names bound by this section's `variable` lines or the theorem's binders.

    Type variables (α β G M …) declared in the shared `variable {α β G M : Type*}`
    line are deliberately excluded: they recur across every section and renaming
    them buys little while risking collisions with Mathlib notation.
    """
    names: list[tuple[str, str]] = []

    def harvest(groups):
        for g in groups:
            is_type = re.search(r"\bType\b|\bSort\b", g["type"]) is not None
            for nm in g["names"]:
                names.append(
                    (nm, "type" if is_type
                     else ("hyp" if nm.startswith("h") else "value"))
                )

    for ln in sec["var_lines"]:
        harvest(parse_binder_groups(ln))

    # Binders of every declaration in the section, not just the first.
    body = sec["body"]
    starts = [m.start() for m in DECL_RE.finditer(body)]
    for k, s in enumerate(starts):
        e = starts[k + 1] if k + 1 < len(starts) else len(body)
        split = split_binder_region(body[s:e])
        if split:
            harvest(parse_binder_groups(split[1]))

    skip = {"Type", "Sort", "Prop"}
    out: dict[str, str] = {}
    for nm, role in names:
        if nm in skip or nm in out:
            continue
        # In Mathlib90 the type variables come from a boilerplate
        # `variable {α β G M : Type*}` line repeated in every section; renaming
        # those buys little and risks collisions, so they are left alone.
        # AlgebraQuals has no variable lines at all, so its type variables are
        # genuine theorem binders and do get renamed.
        if role == "type" and any(
            "Type" in ln and nm in ln for ln in sec["var_lines"]
        ):
            continue
        out[nm] = role
    return out


VALUE_POOL = ["u", "v", "w", "x", "y", "z", "s", "t", "p", "q", "r", "k", "m", "n"]
HYP_POOL = ["hu", "hv", "hw", "hx", "hy", "hz", "hp", "hq"]
TYPE_POOL = ["A", "B", "C", "D", "E", "T", "U", "V", "W"]
POOLS = {"type": TYPE_POOL, "hyp": HYP_POOL, "value": VALUE_POOL}


def fresh_names(roles, used, rng):
    """Map each old binder name to an unused fresh name of the same flavour.

    `roles` maps name -> 'type' | 'hyp' | 'value'. Keeping the flavour matters
    for readability: a ring should not be renamed to `u`, and a proof term
    reading `foo hy hz` should not become `foo u' v₃`.
    """
    mapping, taken = {}, set(used)
    for old, role in roles.items():
        pool = POOLS.get(role, VALUE_POOL)
        cand = None
        for base in pool:
            for suffix in ["", "₁", "₂", "₃", "'"]:
                trial = base + suffix
                if trial not in taken and trial != old:
                    cand = trial
                    break
            if cand:
                break
        if cand is None:
            cand = old + "'"
        taken.add(cand)
        mapping[old] = cand
    return mapping


def check_no_survivors(new_body: str, applied: dict) -> list[str]:
    """Every renamed name must be gone from the output as a bare token.

    This is the guard against boundary bugs: if the identifier-character class
    is wrong (as it was for the superscript in `a⁻¹`), a name gets renamed in
    most places but survives in one, producing Lean that will not compile.
    Catching it here is far cheaper than catching it in `lake build`.
    """
    masked, _ = mask_noncode(new_body)
    return [old for old in applied if token_present(masked, old)]


# ---------------------------------------------------------------------------
# Perturbation
# ---------------------------------------------------------------------------

def perturb_section(sec, rng, subs=None):
    """Return (new_body, name_map, transformation_type, notes, survivors).

    name_map maps each original declaration name in this section to its L2 name.
    `subs` maps a theorem name to a manual-substitution spec (see MANUAL_SUBS).
    """
    subs = subs or {}
    notes = []
    body = sec["body"]
    masked, restore = mask_noncode(body)
    substituted = False

    # --- 1. alpha-rename -----------------------------------------------------
    old_names = collect_renamable(sec)
    used = set(re.findall(rf"[{IDC}]+", masked))
    mapping = fresh_names(old_names, used, rng) if old_names else {}

    renamed = masked
    applied = {}
    for old, new in mapping.items():
        if token_present(renamed, old):
            renamed = rename_token(renamed, old, new)
            applied[old] = new

    # Fallback: a handful of theorems bind no term-level variable whatsoever
    # (e.g. `(1 : G) / 1 = 1`). For those the only alpha-rename available is on
    # the type variable, so rename one that actually occurs in the declaration.
    if not applied:
        decl_start = DECL_RE.search(renamed)
        decl_txt = renamed[decl_start.start():] if decl_start else renamed
        cands = [t for t in collect_type_vars(sec) if token_present(decl_txt, t)]
        if cands:
            tmap = fresh_names({cands[0]: "type"}, used, rng)
            for old, new in tmap.items():
                renamed = rename_token(renamed, old, new)
                applied[old] = new
            notes.append("alpha: type-variable fallback")

    if applied:
        notes.append(f"alpha: {', '.join(f'{k}->{v}' for k, v in applied.items())}")

    # --- 2. hypothesis reordering -------------------------------------------
    # Handle every declaration in the section, walking last-to-first so that
    # earlier offsets stay valid as the text is rewritten.
    reordered = False
    starts = [m.start() for m in DECL_RE.finditer(renamed)]
    for k in range(len(starts) - 1, -1, -1):
        s = starts[k]
        e = starts[k + 1] if k + 1 < len(starts) else len(renamed)
        split = split_binder_region(renamed[s:e])
        if not split:
            continue
        head, binder_text, rest = split
        groups = parse_binder_groups(binder_text)
        perm = find_reordering(groups, rng)
        if perm:
            new_binders = " " + " ".join(groups[i]["raw"] for i in perm)
            renamed = (renamed[:s] + head + new_binders + " "
                       + rest.lstrip() + renamed[e:])
            reordered = True
            notes.append(f"reorder[{k}]: {list(range(len(groups)))} -> {perm}")
        elif len(groups) >= 2:
            notes.append(f"reorder[{k}]: skipped (dependency-locked)")
        else:
            notes.append(f"reorder[{k}]: skipped (<2 binder groups)")

    # --- 3. manual substitution (theorems the machinery can't perturb) -------
    for old in sec["names"]:
        spec = subs.get(old)
        if not spec:
            continue
        if "exponent_map" in spec:
            renamed, n = apply_exponent_map(renamed, spec["exponent_map"])
            if n:
                substituted = True
                notes.append(
                    f"constant: {n} exponent(s) via {spec['exponent_map']}")
        if spec.get("semantic_note"):
            notes.append("semantic: " + spec["semantic_note"])

    # --- 4. rename the declarations themselves ------------------------------
    name_map = {}
    for old in sec["names"]:
        spec = subs.get(old)
        if spec and spec.get("new_name"):
            new = spec["new_name"]
        else:
            new = old.replace("_t_", "_l2_", 1)
            if new == old:
                new = old + "_l2"
        name_map[old] = new
        renamed = rename_token(renamed, old, new)

    if substituted:
        parts = []
        if applied:
            parts.append("alpha_rename")
        if reordered:
            parts.append("hypothesis_reorder")
        parts.append("constant_substitution")
        ttype = "+".join(parts)
    else:
        ttype = "alpha_rename+hypothesis_reorder" if reordered else "alpha_rename"
        if not applied and not reordered:
            ttype = "none"

    new_body = restore(renamed)
    survivors = check_no_survivors(new_body, applied)
    return new_body, name_map, ttype, notes, survivors


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("corpus", nargs="?", default="algebraquals",
                    choices=sorted(PRESETS), help="which corpus to perturb")
    ap.add_argument("--seed", type=int, default=20260720)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()
    rng = random.Random(args.seed)

    cfg = PRESETS[args.corpus]
    set_section_pattern(cfg["section_pat"])
    L1_LEAN = ROOT / cfg["lean"]
    L1_JSON = ROOT / cfg["json"]
    L2_DIR = ROOT / cfg["out_dir"]
    L2_LEAN = ROOT / cfg.get("out_lean_dir", cfg["out_dir"]) / cfg["out_lean"]
    L2_JSON = L2_DIR / cfg["out_json"]
    L2_REPORT = L2_DIR / "perturbation_report.json"

    if not L1_LEAN.exists():
        print(f"error: {L1_LEAN} not found", file=sys.stderr)
        return 1

    lean_text = L1_LEAN.read_text(encoding="utf-8").replace("\r\n", "\n")

    # Parent metadata is keyed by theorem name. Mathlib90 keys records by `id`;
    # the AlgebraQuals JSON keys by numeric id and carries the Lean name inside
    # `lean_theorem`, so key off that instead.
    l1_records = {}
    if L1_JSON.exists():
        for r in json.loads(L1_JSON.read_text(encoding="utf-8")):
            key = r.get("id")
            m = re.search(r"theorem\s+(\w+)", r.get("lean_theorem") or "")
            if m:
                key = m.group(1)
            l1_records[key] = r

    sections = parse_sections(lean_text)

    # Rebuild the file header rather than copying it: AlgebraQuals.lean opens
    # with a doc comment asserting "this file has NOT been compiled", which is
    # both stale and misleading once carried into a derived file.
    raw_header = lean_text[: lean_text.find("section ")]
    header_lines = raw_header.split("\n")
    imports_opens = [
        ln for ln in header_lines
        if ln.strip().startswith(("import ", "open "))
    ]
    # Carry non-linter set_options (e.g. maxHeartbeats); re-emit linter disables
    # ourselves so the header is deterministic regardless of the source's state.
    other_setopts = [
        ln for ln in header_lines
        if ln.strip().startswith("set_option ") and "linter" not in ln
    ]
    # Reordering collapses a theorem's binders onto one line and the file carries
    # an unscoped maxHeartbeats -- both trip Mathlib PR *style* linters that do
    # not apply to a machine-generated dataset. Disable exactly those, in an
    # order that silences the maxHeartbeats set_option that follows.
    suppress = [
        "set_option linter.style.setOption false     -- unscoped maxHeartbeats",
        "set_option linter.style.longLine false       -- reordered binder lines",
        "set_option linter.unnecessarySimpa false     -- carried simpa phrasing",
    ]
    directives = imports_opens + [""] + suppress + [""] + other_setopts
    header = (
        "/-\n"
        f"  L2 (Theorem Perturbation) set, generated from {cfg['lean']}\n"
        f"  by scripts/perturb_l2.py --seed {args.seed}.\n\n"
        "  Each theorem is alpha-renamed, and its binders are reordered where\n"
        "  the dependency graph permits. Statements are mathematically\n"
        "  equivalent to their L1 parents; see perturbation_report.json for the\n"
        "  per-theorem record of what changed. Any record tagged\n"
        "  `constant_substitution` is a manual sibling variant, NOT a\n"
        "  meaning-preserving perturbation -- see its semantic note.\n\n"
        "  Generated mechanically by a textual transform. Verify before use.\n"
        "-/\n\n" + "\n".join(directives)
    )
    subs = MANUAL_SUBS.get(args.corpus, {})
    out_sections, out_records, report, skipped = [], [], [], []
    stats = {}
    problems = []

    for sec in sections:
        new_body, name_map, ttype, notes, survivors = perturb_section(sec, rng, subs)
        stats[ttype] = stats.get(ttype, 0) + 1
        if survivors:
            problems.append(
                f"{sec['section']}: renamed name(s) survived in output: "
                f"{survivors} -- output will not compile")

        # A theorem with no binders at all (e.g. a fully concrete statement over
        # ℂ) admits neither alpha-renaming nor reordering. Emitting it would
        # reproduce the L1 statement verbatim, which the L2 rubric excludes
        # ("Any theorem statement identical to an L1 statement"). Drop it and
        # say so, rather than pad the set with a duplicate.
        if ttype == "none":
            skipped.append({"section": sec["section"], "names": sec["names"],
                            "reason": "no binders to rename or reorder"})
            continue

        new_sec_id = "L2" + sec["section"]
        out_sections.append(f"section {new_sec_id}{new_body}end {new_sec_id}")

        # One record per declaration; a section may carry more than one.
        starts = [m.start() for m in DECL_RE.finditer(new_body)]
        for k, old_name in enumerate(sec["names"]):
            if k >= len(starts):
                problems.append(f"{old_name}: declaration vanished during rewrite")
                continue
            s = starts[k]
            e = starts[k + 1] if k + 1 < len(starts) else len(new_body)
            decl = new_body[s:e].strip()

            stmt, proof = decl, ""
            idx = _top_level_assign(decl)
            if idx is not None:
                stmt, proof = decl[:idx].rstrip(), decl[idx + 2:].strip()

            parent = l1_records.get(old_name, {})
            new_name = name_map[old_name]
            if stmt.strip() == (parent.get("formal_statement") or "").strip():
                problems.append(
                    f"{old_name}: L2 statement identical to L1 (rubric violation)")

            rec = {
                "id": new_name,
                "level": "L2",
                "domain": parent.get("domain") or parent.get("field"),
                "source_dataset": parent.get("source_dataset"),
                "formal_statement": stmt,
                "target_proof": proof,
                "parent_id": old_name,
                "transformation_type": ttype,
                "proof_strategy": parent.get("proof_strategy", []),
                "lean_version": parent.get("lean_version", "Lean4"),
                "mathlib_version": parent.get("mathlib_version"),
                "verified": False,   # set true only after verify.py passes
                "split": parent.get("split"),
            }
            # Carry the informal statement through unchanged for genuine L2
            # perturbations (meaning-preserving). For a constant_substitution the
            # parent LaTeX no longer describes the child, so drop it and record
            # the caveat instead of shipping a mismatched informal/formal pair.
            spec = subs.get(old_name)
            if spec and spec.get("transformation_type") == "constant_substitution":
                rec["semantic_note"] = spec.get("semantic_note")
                rec["rubric_level_actual"] = "L3-sibling"
                if parent.get("source") is not None:
                    rec["source"] = parent["source"]
            else:
                for k_ in ("latex_theorem", "latex_proof", "source"):
                    if parent.get(k_) is not None:
                        rec[k_] = parent[k_]
            out_records.append(rec)
            report.append({"parent": old_name, "child": new_name,
                           "transformation_type": ttype, "notes": notes})

    expected = len(l1_records) - sum(len(s["names"]) for s in skipped)
    if l1_records and len(out_records) != expected:
        problems.append(
            f"record count {len(out_records)} != expected {expected} "
            f"(L1 {len(l1_records)} minus {len(l1_records) - expected} unperturbable)")

    lean_out = header + "\n\n" + "\n\n".join(out_sections) + "\n"

    print(f"sections processed : {len(sections)}")
    for k, v in stats.items():
        print(f"  {k:34s} {v}")
    print(f"L2 records emitted : {len(out_records)}")
    if skipped:
        print("\nEXCLUDED (unperturbable, would duplicate L1 verbatim):")
        for s in skipped:
            print(f"  - {', '.join(s['names'])}  [{s['reason']}]")
    if problems:
        print("\nPROBLEMS:")
        for p in problems:
            print("  -", p)

    if args.dry_run:
        print("\n[dry-run] nothing written")
        return 1 if problems else 0

    L2_DIR.mkdir(parents=True, exist_ok=True)
    L2_LEAN.parent.mkdir(parents=True, exist_ok=True)
    L2_LEAN.write_text(lean_out, encoding="utf-8")
    L2_JSON.write_text(json.dumps(out_records, indent=2, ensure_ascii=False) + "\n",
                       encoding="utf-8")
    L2_REPORT.write_text(
        json.dumps({"perturbed": report, "excluded": skipped},
                   indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"\nwrote {L2_LEAN.relative_to(ROOT)}")
    print(f"wrote {L2_JSON.relative_to(ROOT)}")
    print(f"wrote {L2_REPORT.relative_to(ROOT)}")
    print("\nNEXT: verify before using this data --")
    print(f"  py Zhi-Chen/verify/verify.py {L2_LEAN.relative_to(ROOT)}")
    return 1 if problems else 0


def _top_level_assign(decl: str):
    """Index of the `:=` that starts the proof, ignoring nested brackets."""
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


if __name__ == "__main__":
    sys.exit(main())

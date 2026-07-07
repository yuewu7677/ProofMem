# Source-Style Probability Theorem-Proof Pairs

This dataset contains 300 probability theorem-proof pairs generated from the pinned mathlib source.

- `L1`: 100 original mathlib theorem/lemma declarations with original proof bodies.
- `L2`: 100 alpha-renamed variants of the L1 declarations, with proof bodies renamed the same way and Lean-checked in the original source context.
- `L3`: 100 disjoint sibling source declarations selected from the same probability families.

Unlike the earlier wrapper dataset, these records use readable source-style Lean and do not cite the parent theorem as the proof.
See `verification_report.json` for counts and verification methods.

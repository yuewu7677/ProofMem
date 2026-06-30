# Data Classification Rubric

This document defines the current Lean proof-data categories and gives compact examples for each. A proof is valid only if Lean accepts it.

## Replay

- **Question:** Can the model prove an original theorem from the training set?
- **Label:** `replay`
- **Definition:** The theorem statement is unchanged from the original dataset.
- **Example:** `theorem pow_orderOf' (a : G) : a ^ orderOf a = 1 := by ...`
- **Success criterion:** Lean accepts the proof.

## Theorem Perturbation

- **Question:** Does the proof survive variable renaming or reordering?
- **Label:** `theorem_perturbation`
- **Definition:** The theorem keeps the same mathematical meaning, but its surface form changes.
- **Example:**
  - Base theorem: `theorem pow_orderOf' (a : G) : a ^ orderOf a = 1 := by ...`
  - Perturbed theorem: `theorem pow_orderOf_renamed' (x : G) : 1 = x ^ orderOf x := by ...`
- **Common perturbations:** rename variables, reorder assumptions, reverse equalities, or rewrite goals into equivalent forms.

## Sibling-Theorem Transfer

- **Question:** Can the same proof idea solve a different theorem statement?
- **Label:** `sibling_theorem_transfer`
- **Definition:** The theorem is new but closely related to a known theorem, usually within the same family.
- **Example:**
  - Known theorem: `gcd_comm' (m n : ℕ) : Nat.gcd m n = Nat.gcd n m`
  - Sibling theorem: `gcd_assoc' (m n k : ℕ) : Nat.gcd (Nat.gcd m n) k = Nat.gcd m (Nat.gcd n k)`
- **What qualifies:** a new statement with a related proof strategy in the same domain.

## Cross-Domain Retention

- **Question:** Does proof knowledge decay across domains?
- **Label:** `cross_domain_retention`
- **Definition:** Earlier proof knowledge is evaluated after later training on a different mathematical domain.
- **Example:**
  - Initial domain: group theory lemmas such as `mul_inv_rev'` and `inv_one'`
  - Later domain: number theory lemmas such as `dvd_add'` and `gcd_dvd_left'`
  - Evaluation: re-run the original-domain proofs after later-domain training and measure whether they still compile.
- **Typical setup:** train on domain A, fine-tune on domain B, then evaluate again on domain A.

## Summary

| Category | Label | Input type | Success criterion |
|---|---|---|---|
| Replay | `replay` | original theorem | Lean accepts the proof |
| Theorem Perturbation | `theorem_perturbation` | equivalent theorem with changed syntax | Lean accepts the proof |
| Sibling-Theorem Transfer | `sibling_theorem_transfer` | new related theorem | Lean accepts the proof |
| Cross-Domain Retention | `cross_domain_retention` | original-domain theorem after different-domain training | Lean accepts the proof |

## Data Generation

- Generate perturbations with parser-aware variable renaming, assumption reordering, and equivalent goal rewrites.
- Build sibling theorems from small theorem families such as group identities, cyclic-group powers, gcd, and divisibility.
- Use mathlib lemmas as scaffolds, then verify generated examples with `lake build`.
- For retention, define a sequence of training domains and evaluate earlier-domain proofs after each later-domain stage.

## Workflow

1. Select a small base set of theorems from each target family.
2. Keep the original statements as `replay` examples.
3. Create `theorem_perturbation` variants from those theorems.
4. Build `sibling_theorem_transfer` examples using theorem templates and domain knowledge.
5. Schedule `cross_domain_retention` evaluations across training stages.
6. Verify all generated `.lean` files with Lean.

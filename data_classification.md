# Data Classification Rubric for Proof Behavior

This document defines four evaluation categories for Lean proof data and gives concrete examples for each. It also describes feasible approaches to scale data generation.

## 1. Replay

- **Definition:** The model reproduces the original proof script or proof trace for an exact theorem statement.
- **Example:**
  - Input theorem: `theorem pow_orderOf' (a : G) : a ^ orderOf a = 1 := by exact pow_orderOf_eq_one a`
  - Expected model output: the same Lean proof `by exact pow_orderOf_eq_one a`.
- **Label:** `replay`
- **Purpose:** measure whether the model can memorize and recall specific proof text.
- **When to use:** as a baseline to establish that the model can at least reproduce training examples.

## 2. Perturbation robustness

- **Definition:** The model proves the same mathematical statement after superficial changes to syntax, naming, or presentation.
- **Example:**
  - Base theorem: `theorem pow_orderOf' (a : G) : a ^ orderOf a = 1 := by exact pow_orderOf_eq_one a`
  - Perturbed theorem: `theorem pow_orderOf_renamed' (x : G) : 1 = x ^ orderOf x := by ...`
  - Valid proof may be different, as long as it proves the equivalent statement.
- **Label:** `perturbation`
- **Purpose:** measure robustness to surface variation, not exact memorization.
- **Common perturbations:**
  - rename variables and hypotheses
  - change the order of assumptions
  - rewrite a goal in an equivalent form
  - change connective order or use symmetric equality

## 3. Sibling transfer

- **Definition:** The model proves a new but closely related theorem using the same underlying reasoning pattern.
- **Example:**
  - Known theorem: `gcd_comm' (m n : ℕ) : Nat.gcd m n = Nat.gcd n m`
  - Sibling theorem: `gcd_assoc' (m n k : ℕ) : Nat.gcd (Nat.gcd m n) k = Nat.gcd m (Nat.gcd n k)`
  - The proof should reuse the same style of reasoning about gcd properties, even if the statement is different.
- **Label:** `sibling_transfer`
- **Purpose:** measure generalization of proof ideas across related statements.
- **What qualifies:**
  - a different theorem, not a restatement
  - same theorem family or proof strategy
  - same domain, but new specific formula

## 4. Retention

- **Definition:** The model retains earlier proof knowledge after further training or domain transfer.
- **Example:**
  - Pretraining set: group theory lemmas such as `mul_inv_rev'` and `inv_one'`
  - Fine-tuning set: number theory lemmas such as `dvd_add'` and `gcd_dvd_left'`
  - Retention evaluation: re-run the original group theory proofs and measure whether they still succeed.
- **Label:** `retention`
- **Purpose:** measure stability of proof knowledge after continued training.
- **Typical setup:**
  - train on initial family A
  - fine-tune on family B
  - evaluate again on family A

## Why replay is limited

- **Replay is not the main scientific target.** It measures exact recollection, not mathematical understanding.
- **Most mathematicians do not value verbatim proofs.** They value proof ideas, structural reasoning, and the ability to adapt proofs to new statements.
- **Usefulness of replay:** only as a baseline and as a check that the model has seen the training data.
- **Not enough for evaluation:** if a model only wins on replay, it may simply memorize proof text rather than generalize.

## Practical data-generation rubric

| Category | Input type | Output expectation | Use case |
|---|---|---|---|
| `replay` | original theorem | exact original proof | memorize baseline |
| `perturbation` | equivalent theorem with changed syntax | any valid proof | robustness to surface variation |
| `sibling_transfer` | new, related theorem | valid proof using same idea | transfer/generalization |
| `retention` | original theorem after later training | valid proof still succeeds | long-term stability |

## Feasible approaches to scale

### A. Automated perturbations
- generate variable renamings automatically
- swap assumption order where semantics permit
- rewrite goals using simple equivalences (e.g. `a = b` ⇔ `b = a`)
- use parser-based transformations to avoid invalid Lean syntax

### B. Template-based sibling generation
- define theorem templates for family structure
- instantiate templates with new names or new numeric constants
- derive sibling statements from the same algebraic pattern
- example families: group identities, cyclic group power facts, gcd/divisibility

### C. Use existing mathlib lemmas as scaffolds
- extract small theorem families from mathlib or Smoke test files
- create sibling variants by replacing one lemma call with a closely related lemma
- generate proofs that rely on the same high-level strategy

### D. Evaluate retention with training schedules
- define a sequence of training domains
- use original proofs as held-out retention evaluation examples
- measure how many original proofs still compile after each training stage

### E. Human-in-the-loop sanity checks
- sample generated perturbations and sibling variants for correctness
- ensure transformations preserve semantics
- use Lean compilation as the final filter

## Recommended workflow for the team

1. select a small base set of theorems from each target family
2. generate `replay` examples from the original proofs
3. create `perturbation` variants automatically from those theorems
4. build `sibling_transfer` examples using theorem templates and domain knowledge
5. schedule retention evaluations after each additional fine-tuning stage
6. verify all generated examples by running Lean on the resulting `.lean` files

## Notes for implementation

- Use Lean itself as the truth oracle: a proof is valid only if `lake build` succeeds.
- Do not use exact script match as the main success criterion except for the `replay` baseline.
- For `perturbation` and `sibling_transfer`, accept any proof that compiles and matches the intended theorem meaning.
- For `retention`, measure degradation or stability over training stages rather than raw accuracy on new statements.

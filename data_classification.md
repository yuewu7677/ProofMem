# Data Classification Rubric for Proof Knowledge Levels

This document follows the four proof-knowledge levels in `README.md` and gives concrete examples for each. It also describes feasible approaches to scale data generation.

## L1. Replay

- **Question:** Can the model prove original theorem statements?
- **Definition:** The model is evaluated on original theorem statements from the training set.
- **Example:**
  - Input theorem: `theorem pow_orderOf' (a : G) : a ^ orderOf a = 1 := by ...`
  - Evaluation: feed the original theorem statement to the model and verify that Lean accepts the generated proof.
- **Label:** `replay`
- **Purpose:** establish a baseline for solving original theorem statements.
- **Important note:** This category is about input type, not verbatim proof output. The success criterion is Lean verification.

## L2. Theorem Perturbation

- **Question:** Does it survive variable renaming / reordering?
- **Definition:** The model proves the same mathematical statement after superficial changes to syntax, naming, or presentation.
- **Example:**
  - Base theorem: `theorem pow_orderOf' (a : G) : a ^ orderOf a = 1 := by exact pow_orderOf_eq_one a`
  - Perturbed theorem: `theorem pow_orderOf_renamed' (x : G) : 1 = x ^ orderOf x := by ...`
  - Valid proof may be different, as long as it proves the equivalent statement.
- **Label:** `theorem_perturbation`
- **Purpose:** measure robustness to surface variation.
- **Common perturbations:**
  - rename variables and hypotheses
  - change the order of assumptions
  - rewrite a goal in an equivalent form
  - change connective order or use symmetric equality

## L3. Sibling-Theorem Transfer

- **Question:** Can the same proof idea solve a different theorem statement?
- **Definition:** The model proves a new but closely related theorem using the same underlying reasoning pattern.
- **Example:**
  - Known theorem: `gcd_comm' (m n : ℕ) : Nat.gcd m n = Nat.gcd n m`
  - Sibling theorem: `gcd_assoc' (m n k : ℕ) : Nat.gcd (Nat.gcd m n) k = Nat.gcd m (Nat.gcd n k)`
  - The proof should reuse the same style of reasoning about gcd properties, even if the statement is different.
- **Label:** `sibling_theorem_transfer`
- **Purpose:** measure generalization of proof ideas across related statements.
- **What qualifies:**
  - a different theorem, not a restatement
  - same theorem family or proof strategy
  - same domain, but new specific formula

## L4. Cross-Domain Retention

- **Question:** Does proof knowledge decay across domains?
- **Definition:** The model retains earlier proof knowledge after further training on a different mathematical domain.
- **Example:**
  - Initial domain: group theory lemmas such as `mul_inv_rev'` and `inv_one'`
  - Later domain: number theory lemmas such as `dvd_add'` and `gcd_dvd_left'`
  - Cross-domain retention evaluation: re-run the original group theory proofs after number-theory fine-tuning and measure whether they still succeed.
- **Label:** `cross_domain_retention`
- **Purpose:** measure whether proof knowledge from one domain decays after adaptation to another domain.
- **Typical setup:**
  - train on initial domain A
  - fine-tune on different domain B
  - evaluate again on domain A
  - plot retention curves across the training sequence

## Why replay is limited

- **Replay is not the main scientific target.** It measures performance on original theorem statements, not proof-pattern generalization.
- **Most mathematicians do not value verbatim proofs.** They value proof ideas, structural reasoning, and the ability to adapt proofs to new statements.
- **Usefulness of replay:** it is a baseline and a check that the model can solve the original examples.
- **Not enough for evaluation:** if a model only wins on replay, it may not generalize to changed or related theorem statements.

## Practical data-generation rubric

| Level | Name | Label | Input type | Output expectation | Use case |
|---|---|---|---|---|---|
| L1 | Replay | `replay` | original theorem | valid proof accepted by Lean | original-statement baseline |
| L2 | Theorem Perturbation | `theorem_perturbation` | equivalent theorem with changed syntax | valid proof accepted by Lean | robustness to surface variation |
| L3 | Sibling-Theorem Transfer | `sibling_theorem_transfer` | new, related theorem | valid proof accepted by Lean | proof-pattern transfer/generalization |
| L4 | Cross-Domain Retention | `cross_domain_retention` | original-domain theorem after different-domain training | valid proof still accepted by Lean | cross-domain knowledge decay |

## Saturation / initial-correctness control

In ProofMem, "unsaturated" means that the base model should not already solve most examples before ProofMem training or adaptation. It does **not** only mean private, unseen, or newly authored.

The target band for the main experiments should be:

- `too_easy`: baseline Lean-verified correctness is high; useful only for smoke tests
- `target_unsaturated`: baseline correctness is low-to-moderate; primary ProofMem data
- `too_hard`: baseline correctness is near zero; useful only for stress tests or later stages

A practical first target is:

- pass@1 approximately 10--30%, or
- pass@k approximately 20--50% under the intended inference/search budget

Examples around 0--5% are usually too hard for the first ProofMem experiment, because they give too few successful proofs for replay and make it difficult to distinguish training effects from new learning. Examples above 60% are too saturated, because they leave little headroom.

Therefore, dataset selection should be empirical. For each candidate dataset, run the intended base model under the intended inference budget and record:

- baseline pass@1
- baseline pass@k
- Lean version and Mathlib version
- generation budget and search/correction budget
- number of verified successful proofs
- average successful proof length
- whether proofs depend on retrieval, premise selection, external search, or self-correction

## Candidate dataset and model screening table

The table below is a planning table. Published numbers should be treated as external reference points only, because reported accuracy depends heavily on Lean version, Mathlib version, prompt format, sample budget, self-correction, search, and whether the benchmark uses public or private splits. ProofMem should still run its own baseline screen.

| Candidate | Release / paper date | Domains and level | Size | Published public signal | ProofMem role |
|---|---:|---|---:|---|---|
| FormalProofBench / ProofBench | 2026-03 paper; benchmark page updated later | graduate-level analysis, algebra, probability, logic, algebraic geometry, topology-style formal proof tasks | 200 | Paper reports Claude Opus 4.5 Thinking at 33.5%; later benchmark page reports stronger proprietary systems much higher | Best conceptual match if access is available; use as reference even if not the main dataset |
| FormalMATH | 2025-05 | broad Lean 4 benchmark: algebra, geometry, calculus, number theory, discrete math, applied math; high-school to undergraduate | 5,560 | paper reports strongest evaluated provers at 16.46% under practical sampling budgets | Best broad public candidate pool for initial low-correctness filtering, though not mostly graduate-level |
| Lean Workbook | 2024-06 | broad Lean 4 natural-language-to-formalized math problems; many contest/undergraduate-style tasks | about 57,000 statements; about 5,000 with formal solutions | useful scale; not ideal as a clean graduate benchmark | Candidate pool for theorem-proof pairs and perturbation generation, not the core final benchmark |
| FATE-H | 2025-11 | honors-undergraduate / graduate abstract and commutative algebra | 100 | Seed-Prover 1.5 reports 80%; earlier/open models may be much lower | Algebra slice only; too narrow to be the whole project |
| FATE-X | 2025-11 | advanced PhD-level algebra, including problems beyond current library coverage | 100 | Seed-Prover 1.5 reports 33%; earlier/open models may be near zero | Stretch algebra set; probably too hard as the first main slice |
| LeanCat | 2025-12 / 2026-02 version | category theory; graduate-level abstraction | 100 | public reports for frontier/API models are low-to-moderate depending on budget | Good second-domain retention slice if public files and harness fit our Lean setup |
| ArXivLean | 2026-04 for the 03/2026 set | research-level statements from recent arXiv papers | 41 in the March 2026 set | MathArena lists top public leaderboard around the 30% range for AlephProver | Excellent external research-level evaluation; too small for main training |
| PutnamBench | 2024, updated | hard undergraduate competition mathematics | 672 Lean 4 problems on the benchmark site | DeepSeek-Prover-V2 reports 49 solved on a Lean 4 subset; later systems report much higher | Calibration/stress test, not graduate/research-level enough by itself |
| CombiBench | 2025-05 | combinatorics; mixed difficulty from school to university/olympiad | 100 | Kimina-Prover reports 7/100 in both with-solution and without-solution settings | Optional combinatorics OOD slice |

## Recommended ProofMem dataset plan

Do not use one dataset as the whole project. Use a multi-domain benchmark suite with empirical filtering:

1. **Primary public candidate pool:** FormalMATH, because it is broad, Lean 4, public, and has low published baseline correctness.
2. **Graduate/research slices:** FormalProofBench if access is available; otherwise LeanCat, FATE-H/FATE-X, and ArXivLean as smaller high-level slices.
3. **Training/replay source:** Lean Workbook and LEAN-GitHub-style corpora for theorem-proof pairs, because ProofMem needs verified proof scripts for L1 replay.
4. **Calibration/stress tests:** PutnamBench and CombiBench.

The first concrete experiment should be:

- choose a strong open Lean prover as the base model;
- run it on the candidate pool;
- keep examples whose initial correctness falls in the target band;
- use the verified successful proofs as L1 replay examples;
- generate L2 perturbations and L3 siblings only for examples that pass the Lean checker;
- evaluate L4 retention by training or adapting across domains.

## Candidate base models

| Model | Release date | Size / base | Published signal | Practical role |
|---|---:|---|---|---|
| Kimina-Prover-72B | 2025-07 | 72B, Qwen2.5-72B based | very strong public Lean 4 prover; high miniF2F performance | Preferred main open model if H200 GPU memory is available; likely more meaningful than weaker 7B/8B baselines |
| Goedel-Prover-V2-32B | 2025-08 | 33B, Qwen3-32B based | strong open Lean 4 prover; easier than 72B to run | Practical main/secondary baseline; useful if 72B iteration is too slow |
| Goedel-Prover-V2-8B | 2025-08 | 8B | strong for size | Fast ablation and pipeline debugging model |
| DeepSeek-Prover-V2-7B | 2025-04 | 7B | strong small Lean 4 prover | Cheap baseline; probably too weak for final ProofMem claims |
| DeepSeek-Prover-V2-671B | 2025-04 | 671B | strong published results, including PutnamBench | Reference only; not feasible as the main local training model |
| Seed-Prover 1.5 | 2025-12 | system/model details not as locally controllable | reports 80% on FATE-H, 33% on FATE-X, 88% on PutnamBench | SOTA reference, not a controllable starting model |
| AlephProver | 2025--2026 public results | proprietary / unavailable | high public leaderboard results on PutnamBench and ArXivLean | SOTA reference only |

Recommended starting model:

- **Main:** Kimina-Prover-72B, if LoRA/inference on the available H200 setup is stable.
- **Fallback:** Goedel-Prover-V2-32B, if 72B iteration is too slow.
- **Debug:** Goedel-Prover-V2-8B or DeepSeek-Prover-V2-7B.

This model choice should be validated by the same initial-correctness screen. If Kimina-Prover-72B is already too strong on a slice, move that slice to smoke-test status or reduce the inference budget. If it is too weak, use a stronger search/correction budget or move the slice to stress-test status.

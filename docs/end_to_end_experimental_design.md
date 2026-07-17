# ProofMem End-to-End Experimental Design

## 1. Scope and central question

ProofMem measures whether one supervised fine-tuning intervention changes the mathematical proof
behavior of a foundation language model. The model is evaluated as a language model, not as a
retrieval-and-search theorem-proving system.

The central question is:

> After fine-tuning on a set of natural-language theorem--proof pairs, does a model merely replay
> those proofs, or does it acquire proof knowledge that transfers to equivalent statements,
> related theorems, and structurally analogous theorems in other domains?

The project contains two experiments over the same theorem families:

1. **Experiment 1: natural-language evaluation.** The model receives a natural-language theorem
   statement and produces one natural-language proof. A calibrated proof judge and expert review
   evaluate that proof.
2. **Experiment 2: Lean-backed evaluation.** The exact natural-language proof produced in
   Experiment 1 is translated into a Lean proof body by a frozen translator. The proof body is
   attached to an immutable, pre-audited Lean statement and checked by Lean.

There is one target fine-tuning intervention. There is no later fine-tuning after the target model
has been produced.

## 2. End-to-end overview

```text
Candidate theorem/proof sources
        |
        v
Construct and manually audit
(S_NL, P_NL_gold, S_Lean, P_Lean_gold)
        |
        v
Build L1--L4 theorem families
        |
        v
Qualify each item with the frozen NL-to-Lean proof translator
        |
        v
Freeze the translator-qualified benchmark D_T
        |
        +-------------------------------+
        |                               |
        v                               v
Experiment 1                       Experiment 2
S_NL -> model -> P_NL             reuse the same P_NL
        |                               |
        v                               v
NL judge + expert review           frozen translator + bounded repair
                                        |
                                        v
                              immutable S_Lean := P_Lean
                                        |
                                        v
                                    Lean kernel
        |                               |
        +---------------+---------------+
                        v
              joint attribution analysis
```

## Part I. Data generation

## 3. Data sources and sampling

Candidate examples may be sampled from:

- textbook-derived datasets such as ProofNet;
- competition datasets such as miniF2F;
- natural-language proof collections such as NaturalProofs;
- manually selected open textbook exercises; and
- a separately reported Mathlib-derived control corpus.

For ProofNet, use the original dataset for the natural-language statement and proof, and a Lean 4
port as a candidate source for the formal statement. A Lean 4 port is not automatically a semantic
correction: every retained natural/formal statement pair must still be reviewed.

Sampling a fraction of a source dataset is acceptable. However, **every item retained in the core
benchmark must be manually audited** on the critical fields below. A random audit of only a small
percentage of the final benchmark is not sufficient for statement alignment.

Sampling should be stratified by:

- mathematical domain;
- proof method;
- source and textbook;
- estimated proof length;
- base-model difficulty; and
- expected formalization difficulty.

The sampling procedure, all exclusions, and the number of retained items per stratum must be
recorded.

## 4. Canonical record

Every retained theorem has the following four core artifacts:

```text
S_NL          natural-language theorem statement
P_NL_gold     complete human-audited natural-language reference proof
S_Lean        semantically equivalent Lean theorem statement
P_Lean_gold   compiling Lean proof faithful to P_NL_gold
```

Recommended metadata:

```text
id
source_dataset
source_identifier
source_and_license
level                         # L1, L2, L3, or L4
parent_l1_id                  # null for L1
theorem_family
mathematical_domain
proof_schema
required_proof_ingredients
forbidden_shortcuts

S_NL
P_NL_gold
S_Lean
P_Lean_gold
lean_header
alignment_contract

statement_auditor_ids
statement_audit_status
proof_auditor_ids
proof_audit_status
translator_qualification_status
translator_attempt_log

lean_version
mathlib_revision
provenance
contamination_risk
difficulty_metadata
```

The Lean toolchain, Mathlib revision, imports, namespace openings, and relevant local definitions
are part of the benchmark and must be immutable after the main experiment begins.

## 5. Statement-alignment audit

The statement audit establishes:

```text
S_NL expresses the same mathematical theorem as S_Lean.
```

For every item, construct an explicit alignment contract mapping the natural-language objects to
the formal context. For example:

```text
"G is a group"                 <-> (G : Type*) [Group G]
"a and b are elements of G"    <-> (a b : G)
"assume a = b"                 <-> (h : a = b)
"prove a * c = b * c"          <-> a * c = b * c
```

The audit checks:

1. Every quantified natural-language object has the correct Lean binder and type.
2. Every natural-language assumption has a corresponding Lean hypothesis.
3. Lean has no extra assumption that materially strengthens the theorem unless it is explicitly
   represented in `S_NL`.
4. The natural-language and Lean conclusions are equivalent.
5. Number systems, domains, nonzero conditions, positivity conditions, finiteness conditions, and
   typeclass assumptions agree.
6. Definitions used in the two representations have the same intended meaning.

At least one mathematical reviewer and one Lean-capable reviewer should approve each core item.
Disagreements are adjudicated before the item can enter the benchmark.

## 6. Gold-proof construction and audit

`P_NL_gold` must be a complete proof rather than a final answer or a loose sketch. It must identify
all substantive proof ideas required by the item-level rubric.

`P_Lean_gold` must:

- compile against the frozen `S_Lean` and environment;
- contain no `sorry`, `admit`, new axiom, unsafe declaration, or replacement theorem statement;
- avoid citing the target theorem itself or a direct alias of it; and
- be judged faithful to the mathematical argument in `P_NL_gold`.

A formal proof may contain Lean-specific bookkeeping not stated in the natural-language proof,
such as coercion management or elaboration hints. It may not replace the reference argument with a
substantively different proof while still being labeled a translation of that argument.

## 7. Constructing L1--L4 theorem families

The unit of construction and statistical analysis is a theorem family.

| Level | Relation to L1 | What it measures |
|---|---|---|
| L1 | Exact training statement | Exact proof replay |
| L2 | Same theorem under an audited meaning-preserving restatement | Semantic invariance |
| L3 | Different theorem in the same family sharing a substantive proof ingredient | Near transfer |
| L4 | Different domain, but an audited shared abstract proof schema | Far transfer |

### 7.1 L1: exact replay

The pair `(S_NL, P_NL_gold)` is included in target fine-tuning. At evaluation, the exact `S_NL` is
shown and the proof is hidden. L1 is training-set replay, not held-out generalization.

### 7.2 L2: semantic invariance

L2 is mathematically equivalent to its L1 parent but differs in wording, notation, variable names,
or arrangement of assumptions. Every change must be audited against both the natural-language and
Lean statements.

### 7.3 L3: near transfer

L3 is not equivalent to L1. It is a new theorem in the same family and requires at least one
substantive proof ingredient used in the L1 proof. Topic or namespace similarity alone does not
establish L3 membership.

### 7.4 L4: far transfer

L4 belongs to a different mathematical domain but requires the same documented abstract proof
schema as its L1 parent. An arbitrary out-of-domain problem is not a valid L4 item.

Each L2--L4 record has one explicit `parent_l1_id`, a relation description, and independent audit
of the claimed relationship.

## 8. Translator qualification during data generation

### 8.1 Purpose

The cross-experiment benchmark should contain only problems for which the selected translator has
demonstrated that it can formalize at least one known-correct natural-language proof. Otherwise, a
Lean failure could be caused by an item that is intrinsically outside the translator's operating
range.

Define:

- `D_A`: all statement-aligned, proof-audited candidate items;
- `D_T`: the translator-qualified subset of `D_A`.

`D_T` is the primary dataset shared by Experiments 1 and 2. Keep `D_A` and report the transition
from `D_A` to `D_T`, so translator filtering and domain-selection effects remain observable.

### 8.2 Frozen translator

Before qualification, choose and version the translator `T`:

```text
T(S_Lean, S_NL, alignment_contract, P_NL) -> Lean proof body beginning with "by"
```

Freeze:

- translator model and checkpoint;
- system and user prompts;
- decoding settings;
- context supplied to the translator;
- number of compiler-feedback repair attempts;
- timeout and token budget; and
- allowed imports, tactics, and external resources.

The primary translator condition receives no web access, source-code search, theorem retrieval,
reference Lean proof, or target theorem solution. It may use the fixed Mathlib environment and Lean
compiler feedback under the repair policy below.

All translator calls are stateless and isolated by item and attempt chain. Qualification transcripts
and gold proofs are not available to the translator during Experiment 2, and the translator receives
no fine-tuning or parameter update after qualification.

Translator training and translator development data must be disjoint from the final ProofMem
theorem families.

### 8.3 Qualification test

For each item in `D_A`:

1. Give `T` the immutable `S_Lean`, audited `S_NL`, alignment contract, and `P_NL_gold`.
2. Require `T` to return only a proof body beginning with `by`.
3. Attach that body mechanically to the exact `S_Lean`.
4. Compile the result in the frozen Lean environment.
5. If compilation fails, allow the fixed repair budget described below.
6. Audit the final compiling proof for faithfulness to `P_NL_gold`.

An item enters `D_T` only if the final proof compiles and passes the faithfulness audit. A stronger
robustness subset may additionally require successful translation of a second, independently
written or paraphrased correct natural-language proof.

Qualification is performed on gold proofs before the experimental checkpoints are evaluated. **Do
not include or exclude an item based on whether the translator succeeds on an `M0`, `MA`, or `MC`
generated proof.** Doing that would make the benchmark checkpoint-dependent and bias the treatment
comparison.

### 8.4 Translator repair policy

Let `K` be a preregistered maximum number of repair attempts; a reasonable pilot value is `K = 3`.

```text
attempt 0: translator sees the original translation input
attempt j: translator additionally sees its previous Lean proof and Lean's error messages
stop:      first accepted proof or K failed repairs
```

Allowed repair operations include:

- correcting Lean syntax;
- resolving binder names, namespaces, coercions, and types;
- choosing the correct formal name for a fact explicitly invoked in `P_NL`;
- adding Lean-specific intermediate claims needed to express an existing natural-language step;
- rearranging the formal proof while preserving the natural-language argument; and
- repairing elaboration and tactic-state errors using compiler feedback.

Disallowed operations include:

- modifying `S_Lean`, its binders, assumptions, or conclusion;
- adding imports, axioms, declarations, assumptions, `sorry`, or `admit`;
- consulting `P_Lean_gold` or another solution to the target theorem;
- retrieving or searching for a ready-made target theorem;
- silently replacing an incorrect `P_NL` with an independently invented correct proof; and
- bypassing the key argument with automation that proves the theorem without implementing the
  required proof ingredients.

Automation used for local algebra, normalization, or routine goal closure is allowed when it
faithfully implements a stated step. Record all substantial automation and audit whether it
bypasses the proof being translated.

### 8.5 Translator faithfulness controls

Before the main experiment, evaluate `T` on:

- multiple correct proofs of the same theorem;
- paraphrased correct proofs;
- a proof with one deleted key step;
- a proof with a changed number or symbol;
- a shuffled proof;
- an irrelevant proof; and
- an empty proof.

The translator should preserve meaning across harmless paraphrases but should not convert corrupted,
irrelevant, or empty proofs into correct proofs. Report:

```text
gold_translation_recall
paraphrase_stability
corruption_sensitivity
independent_solve_or_repair_rate
```

These controls measure whether the translator is functioning as a translator rather than as an
unacknowledged theorem prover.

## 9. Difficulty, contamination, and selection checks

Before fine-tuning, estimate base-model difficulty under the fixed single-shot natural-language
protocol. Preserve enough headroom to observe both improvement and failure. Mark nearly always
solved items as calibration examples and nearly impossible items as stress tests rather than
silently mixing them into the primary set.

Public theorems and proofs may occur in foundation-model pretraining. Record provenance, public
availability date, exact and near-duplicate searches, theorem-name exposure, and contamination
risk. Prefer newly authored or initially private L2--L4 items where feasible.

Compare `D_A` and `D_T` by domain, proof length, proof method, and difficulty. Conclusions from the
cross-experiment analysis apply directly to the translator-qualified population. If translator
qualification removes disproportionately hard items or an entire domain, report that limitation
and provide Experiment 1 results on `D_A` as a secondary analysis.

## 10. Dataset freeze

Before the main run, freeze:

- all L1--L4 records and parent relationships;
- `D_A` and `D_T` membership;
- target and control fine-tuning data;
- hidden reference proofs and rubrics;
- translator and repair configuration;
- natural-language judge and acceptance threshold;
- Lean and Mathlib versions; and
- exclusion and adjudication rules.

Do not change benchmark membership after inspecting the comparative `M0`, `MA`, and `MC` results.

## Part II. Experiment 1: natural-language proof generation

## 11. Model conditions

Let `M0` be a fixed general-purpose model checkpoint.

- `M0`: original model before target fine-tuning.
- `MA`: a branch of `M0` fine-tuned once on the L1 `(S_NL, P_NL_gold)` pairs.
- `MC`: a parallel branch of `M0` fine-tuned once on unrelated mathematical proof pairs, matched
  to `MA` on token budget, output format, optimizer settings, and number of updates.

`MC` separates target-specific proof learning from generic adaptation to mathematical proof style.
There is no subsequent fine-tuning of `MA` or `MC`.

## 12. Fine-tuning protocol

Only L1 pairs from the target families enter `MA` fine-tuning. L2--L4 statements and all hidden
proofs remain unavailable to training.

Record:

- checkpoint and tokenizer;
- fine-tuning method and trainable parameters;
- optimizer, schedule, batch construction, and epochs;
- exact training-token count;
- random seed; and
- every training example in its presented order.

Use multiple fine-tuning seeds where feasible.

## 13. Natural-language generation

Evaluate `M0`, `MA`, and `MC` on all levels of `D_T` under identical conditions. Experiment 1 may
also evaluate the larger `D_A` as a secondary natural-language-only analysis.

The model receives only:

```text
S_NL
an instruction to provide one complete rigorous proof
```

The primary condition uses:

- one stateless call per theorem;
- one proof output per call;
- no retrieval, web access, tools, theorem search, or source access;
- no judge or compiler feedback;
- no revision loop;
- a fixed prompt and decoding configuration; and
- a fixed output-token budget.

Store the exact generated proof as `P_NL_hat`. Experiment 2 must reuse this artifact rather than
asking the model to generate a new proof.

## 14. Natural-language proof evaluation

A versioned proof judge receives:

```text
S_NL
P_NL_hat
P_NL_gold
item rubric and required proof ingredients
```

The judge is blind to checkpoint, level, source, and fine-tuning condition. It returns:

```text
correctness_score
binary_accept
first_invalid_or_missing_step
justification
confidence
```

Calibrate the judge against expert labels on correct proofs, ordinary failures, and plausible
proofs with subtle errors. Report precision, recall, confusion matrix, and expert agreement. Send
all important judge/expert disagreements and a preregistered sample of agreements to expert
adjudication.

Until the judge is adequately calibrated, call its output `verifier-accepted rate`, not unqualified
mathematical accuracy.

## 15. Experiment 1 metrics

Let `A_NL(M, Lk)` be the calibrated accepted-at-one rate for checkpoint `M` at level `Lk`.

```text
raw_gain_NL_k = A_NL(MA, Lk) - A_NL(M0, Lk)

treatment_effect_NL_k =
    [A_NL(MA, Lk) - A_NL(M0, Lk)]
  - [A_NL(MC, Lk) - A_NL(M0, Lk)]
```

Also report ordinal correctness, proof length, first-error category, refusal rate, and the fraction
of outputs that are sketches rather than complete proofs. Resample theorem families, not related
variants as if they were independent.

## Part III. Experiment 2: Lean-backed evaluation of the same proofs

## 16. Fixed evaluation pipeline

For every stored `P_NL_hat` from Experiment 1:

```text
P_Lean_hat = T(
    immutable S_Lean,
    audited S_NL,
    alignment_contract,
    P_NL_hat
)

candidate_file = lean_header + immutable S_Lean + P_Lean_hat

Lean(candidate_file) -> pass or fail
```

The translator returns only the proof body beginning with `by`. The harness, not the translator,
attaches that body to `S_Lean`. Any statement text emitted by the translator is discarded or causes
automatic rejection.

The same translator, prompt, repair budget, tool restrictions, and Lean environment are used for
`M0`, `MA`, and `MC` outputs.

## 17. Repair loop during Experiment 2

The translator receives at most the same preregistered `K` repair attempts used during
qualification. Lean error messages may be returned to the translator after a failed compilation.
The natural-language generator receives no such feedback.

Every attempt log must retain:

```text
input P_NL_hat
attempt number
generated P_Lean_hat
Lean errors and warnings
changes made on repair
final pass/fail
```

A successful repair counts as an end-to-end pipeline success, but initial-translation success and
repair-assisted success are also reported separately.

## 18. Strict Lean acceptance criteria

A candidate passes the mechanical check only when:

1. It is attached to the exact frozen `S_Lean`.
2. It compiles in the frozen environment.
3. Lean reports no unsolved goals.
4. It contains no `sorry`, `admit`, new axiom, unsafe escape, or additional theorem declaration.
5. It does not cite the target theorem or a forbidden direct alias.
6. It stays within the declared imports and resource limits.

Lean pass establishes:

> `P_Lean_hat` proves the fixed formal statement `S_Lean`.

Lean alone does not establish that `P_Lean_hat` faithfully translates `P_NL_hat`.

## 19. Faithfulness and attribution audit

For each candidate, classify natural-language correctness, Lean outcome, and translator
faithfulness separately.

| Natural-language proof | Lean result | Interpretation |
|---|---|---|
| Correct | Pass, faithful | Lean-confirmed correct proof |
| Correct | Fail | Translator/formalization failure; not evidence that the generator reasoned incorrectly |
| Incorrect | Pass, unfaithful | Translator repaired or ignored the proof; not generator success |
| Incorrect | Fail | Consistent evidence of an incorrect generated proof |
| Uncertain | Either | Requires adjudication |

Faithfulness review should use the item rubric and, where possible, a numbered correspondence:

```text
NL step 1 -> Lean lines or intermediate claim implementing step 1
NL step 2 -> Lean lines or intermediate claim implementing step 2
...
```

All cases judged `NL correct + Lean fail` should receive translator-failure adjudication. All cases
judged `NL incorrect + Lean pass` should receive repair-leakage adjudication. Audit a preregistered
random sample of the two agreement cells as well.

## 20. Experiment 2 metrics

Report at least:

```text
lean_pipeline_rate
    fraction of all P_NL_hat outputs whose translated proof passes Lean

faithful_lean_confirmed_rate
    fraction that pass Lean and are judged faithful to P_NL_hat

translation_success_given_NL_correct
    Lean translation success among independently accepted natural-language proofs

translator_failure_rate
    accepted natural-language proofs that fail formalization after K repairs

initial_translation_success_rate
repair_assisted_success_rate
translator_repair_leakage_rate
    incorrect natural-language proofs turned into correct but unfaithful Lean proofs
```

Let `A_Lean(M, Lk)` be the faithful Lean-confirmed rate. The primary formal treatment effect is:

```text
treatment_effect_Lean_k =
    [A_Lean(MA, Lk) - A_Lean(M0, Lk)]
  - [A_Lean(MC, Lk) - A_Lean(M0, Lk)]
```

Report raw Lean-pass results as pipeline performance and faithful Lean-confirmed results as the
main evidence about the generated reasoning.

## 21. Joint interpretation of Experiments 1 and 2

| Result pattern | Supported interpretation |
|---|---|
| L1 improvement only | Primarily exact proof replay or training-format imitation |
| L1 and L2 improvement | Learned behavior survives meaning-preserving restatement |
| Positive control-adjusted L3 effect | Evidence of reusable within-family proof knowledge |
| Positive control-adjusted L4 effect | Evidence of cross-domain proof-schema transfer, conditional on the family audit |
| NL improvement and faithful Lean improvement agree | Stronger evidence that the intervention improved mathematical correctness |
| NL improvement without Lean improvement | Possible judge bias, proof gaps, or translator ceiling |
| Lean passes produced from NL failures | Translator repair leakage or independent theorem solving |
| `MA` and `MC` improve equally | Likely generic proof-format or mathematical-task adaptation |

Neither experiment alone proves that the model reasons like a human or identifies where knowledge
is stored inside the network. Together they separate three objects that must not be conflated:

```text
quality of the generated natural-language proof
faithfulness and competence of the translator
formal validity of the resulting Lean proof
```

## 22. Required ablations and robustness checks

- Target L1 fine-tuning versus matched-control fine-tuning.
- Translator with zero repairs versus the fixed `K`-repair condition.
- A second frozen translator or human formalizer on a stratified subset.
- Translator faithfulness controls using deleted, corrupted, irrelevant, and empty proofs.
- Natural-language judge with and without the reference proof and rubric.
- Human evaluation stratified by checkpoint and level.
- Main cross-experiment results on `D_T` and secondary Experiment 1 results on `D_A`.
- Results with powerful automation included versus key-step-bypassing cases removed.

## 23. Preregistration and release artifacts

Preregister:

- sample sizes and family construction rules;
- all inclusion and exclusion criteria;
- translator qualification and repair budgets;
- model prompts and inference budgets;
- judge threshold and human adjudication plan;
- primary metrics and statistical tests; and
- treatment-effect hypotheses for L1--L4.

Release, subject to licensing and hidden-test constraints:

1. versioned `D_A` and `D_T` manifests;
2. statement alignment contracts and audit outcomes;
3. theorem-family and proof-schema annotations;
4. frozen model, translator, judge, Lean, and Mathlib configurations;
5. anonymized natural-language generations;
6. all translator attempts and Lean logs;
7. automated and human evaluation labels;
8. selection, exclusion, and contamination reports; and
9. per-level pre/post and control-adjusted results with family-clustered uncertainty.

## 24. Final validity rule

The project must use the following conservative interpretation:

> A Lean pass proves that the translated Lean proof establishes the fixed Lean theorem. A Lean
> failure does not by itself prove that the generated natural-language proof is wrong. A generated
> proof receives Lean-confirmed reasoning credit only when the Lean proof passes and the
> translation is judged faithful to the generated natural-language argument.

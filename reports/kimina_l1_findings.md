# Kimina-Prover-72B L1 Probability Baseline Findings

Date: 2026-07-07

## What `binder_names` Means

`binder_names` is dataset metadata listing the explicit binders parsed from a Lean theorem statement. These are names for variables and hypotheses introduced in the theorem header.

Example:

```lean
lemma bernoulliMeasure_real_apply (p : I) {s : Set X}
    (hs : MeasurableSet s) ...
```

has:

```json
["p", "s", "hs"]
```

This field is used by the dataset generator to create L2 alpha-renamed variants. It is not an extra Lean assumption and does not change theorem meaning.

## Dataset

- File: `datasets/probability/theorem_proof_pairs.jsonl`
- Split requested: `L1`
- L1 size: 100 theorem-proof pairs
- Regenerated before evaluation after fixing parser leakage from trailing doc comments/aliases.
- Post-cleaning check: 0 L1/L2/L3 records contain accidental extra theorem, alias, instance, def, or doc-comment boundaries.

## Evaluation Harness

Added:

```bash
scripts/evaluate_kimina_l1.py
```

The harness expects an OpenAI-compatible endpoint serving:

```text
AI-MO/Kimina-Prover-72B
```

For each L1 theorem it:

1. Renames only the theorem name to `proofmem_kimina_l1_NNN`.
2. Prompts Kimina for a Lean 4 proof/declaration.
3. Extracts a proof beginning with `by`.
4. Inserts the candidate theorem immediately before the original declaration inside a temporary copy of the original mathlib source file.
5. Runs:

```bash
lake env lean <temporary_source_copy>.lean
```

This avoids a false pass from `exact OriginalTheoremName`, because the original declaration has not appeared yet in that copied source file.

Verifier smoke test:

```bash
python3 scripts/evaluate_kimina_l1.py --gold --limit 3 --output-dir runs/kimina_l1_gold_smoke
```

Result:

```text
3 / 3 verified
```

So the Lake verification path works for known-good proofs.

## Kimina Run Status

Attempted command:

```bash
python3 scripts/evaluate_kimina_l1.py --limit 100 --output-dir runs/kimina_l1
```

Result:

```json
{
  "status": "blocked",
  "attempted": 0,
  "verified": 0,
  "accuracy": null,
  "blocker": "Kimina endpoint unavailable at http://localhost:8000/v1: URLError: <urlopen error [Errno 61] Connection refused>"
}
```

Environment checks:

- No local `nvidia-smi` GPU detected.
- `torch`, `transformers`, `vllm`, `sglang`, and `openai` Python packages are not installed.
- No cached Kimina weights were found under Hugging Face cache.
- `HF_TOKEN` / `HUGGING_FACE_HUB_TOKEN` are unset.
- No local OpenAI-compatible server was listening on `localhost:8000` or `localhost:30000`.
- Hugging Face metadata confirmed `AI-MO/Kimina-Prover-72B` exists and is public, but unauthenticated inference was not available from this machine.

## Accuracy Finding

No Kimina-Prover-72B accuracy number was produced in this environment.

The requested target band is:

```text
10%-40% Lean-verified accuracy
```

Current status:

```text
Not measured
```

Therefore we cannot yet say whether this L1 probability slice is too easy, too hard, or in the desired unsaturated range.

## How To Run Once Kimina Is Available

For vLLM:

```bash
vllm serve "AI-MO/Kimina-Prover-72B"
KIMINA_OPENAI_BASE_URL=http://localhost:8000/v1 \
  python3 scripts/evaluate_kimina_l1.py --limit 100 --output-dir runs/kimina_l1
```

For SGLang:

```bash
python3 -m sglang.launch_server \
  --model-path "AI-MO/Kimina-Prover-72B" \
  --host 0.0.0.0 \
  --port 30000

KIMINA_OPENAI_BASE_URL=http://localhost:30000/v1 \
  python3 scripts/evaluate_kimina_l1.py --limit 100 --output-dir runs/kimina_l1
```

After the run, inspect:

```bash
runs/kimina_l1/summary.json
runs/kimina_l1/results.jsonl
runs/kimina_l1/findings.md
```

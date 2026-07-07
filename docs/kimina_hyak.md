# Running Kimina-Prover-72B L1 Evaluation On Hyak

This is the recommended path for measuring the L1 probability baseline because
`AI-MO/Kimina-Prover-72B` needs GPU resources that are not available on the
local laptop.

## Why Hyak Is Needed

The local run was blocked because there was no reachable Kimina endpoint, no
local GPU, no cached Kimina weights, and no vLLM/SGLang runtime installed.

Hyak uses Slurm for jobs. UW Hyak docs describe batch jobs with `sbatch`, GPU
requests with `--gres=gpu`, and Tillicum jobs requiring at least one GPU. The
Tillicum docs also show example single-node GPU requests such as:

```bash
salloc --qos=normal --gres=gpu:2 --cpus-per-task=16 --mem=400G --time=04:00:00
```

For Kimina-Prover-72B, prefer an 8-GPU node if you can get one.

## Files Added

```text
scripts/evaluate_kimina_l1.py   # prompts model, extracts Lean proof, verifies with lake
scripts/hyak_kimina_l1.slurm    # starts vLLM on a Hyak GPU node and runs L1 eval
reports/kimina_l1_findings.md   # current local finding: blocked without endpoint
```

## Copy Repo To Hyak

From your laptop:

```bash
rsync -av --exclude .lake --exclude .git \
  /Users/yuewu767/ProofMem/ \
  HYAK_USER@klone.hyak.uw.edu:/gscratch/YOUR_GROUP/YOUR_USER/ProofMem/
```

Adjust the hostname and `/gscratch/...` path for your Hyak environment.

On Hyak:

```bash
cd /gscratch/YOUR_GROUP/YOUR_USER/ProofMem
```

## Prepare Lean Dependencies

If `.lake` was not copied, fetch/build the Lean dependencies on Hyak:

```bash
lake update
lake exe cache get
```

Quick verifier smoke test:

```bash
python3 scripts/evaluate_kimina_l1.py \
  --gold \
  --limit 3 \
  --output-dir runs/kimina_l1_gold_smoke_hyak
```

Expected: `3 / 3` verified.

## Submit Kimina Job

First inspect your available GPU resources:

```bash
hyakalloc
```

For Tillicum, edit `scripts/hyak_kimina_l1.slurm` and add the QoS you want,
for example:

```bash
#SBATCH --qos=normal
```

For Klone checkpoint, replace the GPU request with a model-specific request
that matches idle GPUs, for example:

```bash
#SBATCH --partition=ckpt-all
#SBATCH --gpus-per-node=a40:8
```

Submit:

```bash
sbatch scripts/hyak_kimina_l1.slurm
```

The script will:

1. Create `.venv-kimina`.
2. Install vLLM, Transformers, and Hugging Face Hub.
3. Start an OpenAI-compatible vLLM server for `AI-MO/Kimina-Prover-72B`.
4. Run `scripts/evaluate_kimina_l1.py --limit 100`.
5. Write results under `runs/kimina_l1/`.

## Outputs

After the job finishes:

```bash
cat runs/kimina_l1/summary.json
sed -n '1,200p' runs/kimina_l1/findings.md
```

Main files:

```text
runs/kimina_l1/summary.json
runs/kimina_l1/results.jsonl
runs/kimina_l1/findings.md
runs/kimina_l1/answers/*.json
runs/kimina_l1/candidates/*.lean
```

Copy results back:

```bash
rsync -av \
  HYAK_USER@klone.hyak.uw.edu:/gscratch/YOUR_GROUP/YOUR_USER/ProofMem/runs/kimina_l1/ \
  /Users/yuewu767/ProofMem/runs/kimina_l1/
```

## Interpreting Accuracy

The target band is:

```text
10%-40% Lean-verified accuracy
```

Interpretation:

- `<10%`: this L1 probability slice is too hard for this inference setup.
- `10%-40%`: useful unsaturated slice.
- `>40%`: likely too easy for this model/budget; reduce prompting/search budget or move to harder L2/L3.

This harness measures pass@1 with one sampled proof per theorem. Do not compare
directly to reported pass@32 numbers.

#!/bin/bash
#SBATCH --job-name=kimina-l1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:8
#SBATCH --cpus-per-task=32
#SBATCH --mem=800G
#SBATCH --time=08:00:00
#SBATCH --output=runs/kimina_l1/hyak-%j.out

set -euo pipefail

# Usage:
#   sbatch scripts/hyak_kimina_l1.slurm
#
# Optional overrides:
#   KIMINA_MODEL=AI-MO/Kimina-Prover-72B
#   KIMINA_PORT=8000
#   KIMINA_TP=8
#   KIMINA_MAX_MODEL_LEN=16384
#   KIMINA_LIMIT=100
#   KIMINA_CONTEXT_LINES=80
#   KIMINA_MAX_TOKENS=4096
#
# On Tillicum, change/add the SBATCH QoS line as needed, e.g.
#   #SBATCH --qos=normal
# On Klone/checkpoint, replace the GPU request with the GPU type available
# to your account, e.g.
#   #SBATCH --partition=ckpt-all
#   #SBATCH --gpus-per-node=a40:8

MODEL="${KIMINA_MODEL:-AI-MO/Kimina-Prover-72B}"
PORT="${KIMINA_PORT:-8000}"
TP="${KIMINA_TP:-${SLURM_GPUS_ON_NODE:-8}}"
MAX_MODEL_LEN="${KIMINA_MAX_MODEL_LEN:-16384}"
LIMIT="${KIMINA_LIMIT:-100}"
CONTEXT_LINES="${KIMINA_CONTEXT_LINES:-80}"
MAX_TOKENS="${KIMINA_MAX_TOKENS:-4096}"
OUT_DIR="${KIMINA_OUT_DIR:-runs/kimina_l1}"

mkdir -p "${OUT_DIR}"

export HF_HOME="${HF_HOME:-${PWD}/.hf-cache}"
export HUGGINGFACE_HUB_CACHE="${HUGGINGFACE_HUB_CACHE:-${HF_HOME}/hub}"
mkdir -p "${HF_HOME}" "${HUGGINGFACE_HUB_CACHE}"

echo "job_id=${SLURM_JOB_ID:-manual}"
echo "host=$(hostname)"
echo "model=${MODEL}"
echo "tensor_parallel_size=${TP}"
echo "max_model_len=${MAX_MODEL_LEN}"
echo "limit=${LIMIT}"

if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi
fi

if command -v module >/dev/null 2>&1; then
  module load cuda || true
fi

if [ ! -d .venv-kimina ]; then
  python3 -m venv .venv-kimina
fi

source .venv-kimina/bin/activate
python -m pip install --upgrade pip
python -m pip install "vllm>=0.6.0" "transformers>=4.43.0" "huggingface_hub>=0.23.0"

python - <<'PY'
import importlib.util
missing = [m for m in ("vllm", "transformers") if importlib.util.find_spec(m) is None]
if missing:
    raise SystemExit(f"missing packages: {missing}")
PY

SERVER_LOG="${OUT_DIR}/vllm-server-${SLURM_JOB_ID:-manual}.log"

vllm serve "${MODEL}" \
  --host 127.0.0.1 \
  --port "${PORT}" \
  --tensor-parallel-size "${TP}" \
  --max-model-len "${MAX_MODEL_LEN}" \
  --gpu-memory-utilization 0.90 \
  >"${SERVER_LOG}" 2>&1 &

SERVER_PID=$!
trap 'kill "${SERVER_PID}" 2>/dev/null || true' EXIT

echo "waiting for vLLM server on port ${PORT}"
for _ in $(seq 1 180); do
  if curl -fsS "http://127.0.0.1:${PORT}/v1/models" >/dev/null; then
    break
  fi
  sleep 10
done

curl -fsS "http://127.0.0.1:${PORT}/v1/models" >/dev/null

python3 scripts/evaluate_kimina_l1.py \
  --base-url "http://127.0.0.1:${PORT}/v1" \
  --model "${MODEL}" \
  --limit "${LIMIT}" \
  --context-lines "${CONTEXT_LINES}" \
  --max-tokens "${MAX_TOKENS}" \
  --output-dir "${OUT_DIR}"

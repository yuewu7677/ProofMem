# ProofMem

**Separating Proof Replay from Proof-Pattern Generalization in Mathematical Language Models**

[![Lean Action CI](https://github.com/yuewu7677/ProofMem/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/yuewu7677/ProofMem/actions/workflows/lean_action_ci.yml)

## Team

| Name | GitHub | Email |
|---|---|---|
| Yue Wu | [yuewu7677](https://github.com/yuewu7677) | yuew29@uw.edu |
| Zhi Chen | [Chiyoru7D7](https://github.com/Chiyoru7D7) | jichan7a@gmail.com |
| Jayme Kim | [hyungoo-1](https://github.com/hyungoo-1) | hyungoo@uw.edu |

## Motivation

Large language models are increasingly evaluated on mathematical reasoning, but it is still unclear whether they learn **reusable proof ideas** or mainly succeed on theorem statements seen during training. This project studies whether models trained on theorem-proof pairs acquire:

- Replay performance on original theorem statements
- Reusable proof patterns (generalization)
- Theorem-level reasoning that survives increasing transfer distance

This connects to current concerns about benchmark contamination and reliable evaluation of mathematical reasoning.

## Approach

A controlled two-experiment study compares natural-language proof behavior with Lean-verified proof behavior. Both experiments use one target fine-tuning intervention and distinguish **four levels** of proof knowledge:

| Level | Name | Description |
|---|---|---|
| L1 | Replay | Can the model prove original theorem statements? |
| L2 | Semantic Invariance | Does proof knowledge survive a meaning-preserving restatement? |
| L3 | Near Transfer | Does the same proof idea transfer to a new theorem in the same family? |
| L4 | Far Transfer | Does a shared proof schema transfer across mathematical domains? |

The complete pipeline is specified in [ProofMem End-to-End Experimental Design](docs/end_to_end_experimental_design.md), covering data generation, Experiment 1, and Lean-backed Experiment 2. The natural-language portion is also documented in greater detail in [Experiment 1: Natural-Language Proof Replay and Transfer](docs/experiment1_natural_language.md).

### Metrics

- Human-calibrated natural-language proof correctness
- Verifier-accepted natural-language proof rate
- Lean verification success rate (`lake build`)
- Control-adjusted pre/post fine-tuning effects by transfer level

### Deliverables

1. Audited natural-language and Lean theorem-family datasets with replay and transfer splits
2. Baseline results comparing exact replay, semantic invariance, near transfer, and far transfer
3. A controlled one-intervention fine-tuning study with matched training controls
4. Draft paper targeting **ICLR 2027** (backup: NeurIPS 2027)

## Timeline

| Phase | When | What |
|---|---|---|
| Setup | June 2026 | Learn Lean, set up mathlib4 + LeanDojo, proof-checking pipeline |
| Dataset | July 2026 | First theorem family dataset, perturbation splits, pilot experiments |
| Transfer | Aug 2026 | Sibling and cross-domain transfer, matched-control training |
| Writing | Early Sept 2026 | Full paper draft, clean experiments, figures |
| Submit | Mid-Late Sept 2026 | Target ICLR 2027 |

## Repository Structure

```
├── Smoketest/                  # Theorem family smoke tests
│   ├── GroupTheory.lean        # Group identities (inv, mul, cancellation)
│   ├── CyclicGroups.lean       # Cyclic group / power / orderOf theorems
│   └── NumberTheory.lean       # Divisibility, gcd, primes, modular arithmetic
├── Smoketest.lean              # Library root (imports the three files above)
├── Zhi-Chen/                   # Verification framework & experiments
│   ├── test-lean/ProofMem/     # Lean project with test theorems
│   │   └── ProofMem/
│   │       ├── Basic.lean      # Verified theorems (correct)
│   │       ├── Broken.lean     # Deliberately broken theorems
│   │       └── playground.lean # Tactics tutorial / scratch pad
│   └── verify/
│       └── verify.py           # Automated proof checker
├── docs/
│   ├── end_to_end_experimental_design.md # Full data and experiment pipeline
│   └── experiment1_natural_language.md   # Natural-language experiment protocol
├── lakefile.toml               # Lake build configuration (library: Smoketest)
├── lake-manifest.json          # Dependency versions (pins Mathlib)
├── lean-toolchain              # Lean version: v4.32.0-rc1
├── README.md                   # This file
└── .github/workflows/          # CI (lean-action + release + docgen)
```

## Setup

### Prerequisites

Install [elan](https://github.com/leanprover/elan) (Lean version manager):

```bash
# macOS / Linux
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh

# Windows (PowerShell)
$ProgressPreference = 'SilentlyContinue'
$installScript = "$env:TEMP\elan-init.ps1"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/leanprover/elan/master/elan-init.ps1" -OutFile $installScript
& $installScript -y
```

### Build

```bash
# Clone and enter repo
git clone https://github.com/yuewu7677/ProofMem.git
cd ProofMem

# Fetch dependencies (mathlib4 + batteries + ...)
lake update

# Build all targets
lake build
```

### Verify Proofs

```bash
# Optional first run: fetch cached mathlib artifacts and build with visible progress.
lake exe cache get
lake build Smoketest

# Entire Smoketest directory
python3 Zhi-Chen/verify/verify.py Smoketest/

# Single Smoketest file
python3 Zhi-Chen/verify/verify.py Smoketest/GroupTheory.lean

# Batch mode (one lake build for N files)
python3 Zhi-Chen/verify/verify.py Smoketest/GroupTheory.lean Smoketest/CyclicGroups.lean Smoketest/NumberTheory.lean

# JSON output
python3 Zhi-Chen/verify/verify.py Smoketest/ --json
```

The verifier runs `lake build` internally and captures its output, so it may
look idle until Lean finishes building.

## Related Work

- [LeanDojo](https://leandojo.org/) — Lean proof environment for ML
- [mathlib4](https://github.com/leanprover-community/mathlib4) — Lean 4 mathematical library
- [Lean Action](https://github.com/leanprover/lean-action) — GitHub Actions for Lean CI

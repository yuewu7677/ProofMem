# ProofMem

**Separating Proof Replay from Proof-Pattern Generalization in Lean Theorem Proving**

[![Lean Action CI](https://github.com/yuewu7677/ProofMem/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/yuewu7677/ProofMem/actions/workflows/lean_action_ci.yml)

## Team

| Name | GitHub | Email |
|---|---|---|
| Yue Wu | [yuewu7677](https://github.com/yuewu7677) | yuew29@uw.edu |
| Zhi Chen | [Chiyoru7D7](https://github.com/Chiyoru7D7) | jichan7a@gmail.com |
| Jayme Kim | [hyungoo-1](https://github.com/hyungoo-1) | hyungoo@uw.edu |

## Motivation

Large language models are increasingly evaluated on mathematical reasoning, but it is still unclear whether they learn **reusable proof ideas** or mainly succeed on theorem statements seen during training. This project studies whether models trained on formal theorem-proof pairs retain:

- Replay performance on original theorem statements
- Reusable proof patterns (generalization)
- Theorem-level reasoning under perturbation and later fine-tuning

This connects to current concerns about benchmark contamination and reliable evaluation of mathematical reasoning.

## Approach

A controlled **Lean 4** evaluation framework built on [mathlib4](https://github.com/leanprover-community/mathlib4) that distinguishes **four levels** of proof knowledge:

| Level | Name | Description |
|---|---|---|
| L1 | Replay | Can the model prove original theorem statements? |
| L2 | Theorem Perturbation | Does it survive variable renaming / reordering? |
| L3 | Sibling-Theorem Transfer | Same proof idea, different theorem statement |
| L4 | Cross-Domain Generalization | Does proof knowledge generalize across domains? |

### Metrics

- Lean verification success rate (`lake build`)
- Proof-token log loss
- Tactic edit distance
- Retention curves after fine-tuning

### Deliverables

1. Clean Lean theorem-proof dataset with original, perturbed, and sibling-theorem splits
2. Baseline results comparing replay, perturbation, transfer, and retention
3. Sequential fine-tuning experiments measuring cross-domain knowledge decay
4. Draft paper targeting **ICLR 2027** (backup: NeurIPS 2027)

## Timeline

| Phase | When | What |
|---|---|---|
| Setup | June 2026 | Learn Lean, set up mathlib4 + LeanDojo, proof-checking pipeline |
| Dataset | July 2026 | First theorem family dataset, perturbation splits, pilot experiments |
| Transfer | Aug 2026 | Sibling-theorem transfer, sequential fine-tuning, anchored training |
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

import Mathlib

open MeasureTheory ProbabilityTheory
open scoped ENNReal

set_option linter.unusedVariables false

namespace ProofMem.Manual

variable {Ω : Type*} {m0 : MeasurableSpace Ω} {μ : Measure Ω}

/-! # Group 9: Martingale Basics -/

section Martingale

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
  {f : ℕ → Ω → E} {ℱ : Filtration ℕ m0}

-- L1: Expectation of a martingale is constant
theorem martingale_expectation_const [IsProbabilityMeasure μ]
    (hf : Martingale f ℱ μ) (i j : ℕ) (hij : i ≤ j) [SigmaFinite (μ.trim (ℱ.le i))] :
    μ[f j] = μ[f i] := by
  have h_cond := hf.2 i j hij
  calc
    μ[f j] = μ[μ[f j | ℱ i]] := by rw [integral_condExp (ℱ.le i)]
    _ = μ[f i] := integral_congr_ae (f := μ[f j | ℱ i]) (g := f i) h_cond

-- L2: Perturbation (alpha-rename, equality flip)
theorem mg_expectation_invariant [IsProbabilityMeasure μ]
    (h_mg : Martingale f ℱ μ) (n m : ℕ) (hnm : n ≤ m) [SigmaFinite (μ.trim (ℱ.le n))] :
    μ[f n] = μ[f m] := by
  rw [eq_comm]
  exact martingale_expectation_const h_mg n m hnm

-- L3: Doob decomposition
theorem doob_decomposition [IsProbabilityMeasure μ] [SigmaFiniteFiltration μ ℱ]
    (hf : StronglyAdapted ℱ f) (hf_int : ∀ n, Integrable (f n) μ) :
    Martingale (martingalePart f ℱ μ) ℱ μ :=
  martingale_martingalePart hf hf_int

end Martingale

end ProofMem.Manual

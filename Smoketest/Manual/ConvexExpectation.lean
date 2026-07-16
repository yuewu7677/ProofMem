import Mathlib

open MeasureTheory ProbabilityTheory
open scoped ENNReal

set_option linter.unusedVariables false

namespace ProofMem.Manual

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-! # Group 6: Expectation Properties -/

section Expectation

variable [IsProbabilityMeasure μ]

-- L1: Linearity of expectation
theorem expectation_linear {X Y : Ω → ℝ} (hX : Integrable X μ) (hY : Integrable Y μ)
    (a b : ℝ) : μ[a • X + b • Y] = a * μ[X] + b * μ[Y] := by
  calc
    μ[a • X + b • Y] = μ[a • X] + μ[b • Y] := integral_add (hX.smul a) (hY.smul b)
    _ = (∫ ω, a • X ω ∂μ) + (∫ ω, b • Y ω ∂μ) := rfl
    _ = (a • ∫ ω, X ω ∂μ) + (b • ∫ ω, Y ω ∂μ) := by
      rw [integral_smul a X, integral_smul b Y]
    _ = a * μ[X] + b * μ[Y] := by simp

-- L2: Perturbation (alpha-rename, binder reorder, equality flip)
theorem linear_expectation_expanded {U V : Ω → ℝ} (hU : Integrable U μ) (hV : Integrable V μ)
    (α β : ℝ) : α * μ[U] + β * μ[V] = μ[α • U + β • V] := by
  rw [eq_comm]
  exact expectation_linear hU hV α β

-- L3: Sibling — monotonicity of expectation
theorem expectation_monotone {X Y : Ω → ℝ} (hX : Integrable X μ) (hY : Integrable Y μ)
    (h_le : X ≤ᵐ[μ] Y) : μ[X] ≤ μ[Y] :=
  integral_mono_ae hX hY h_le

end Expectation

end ProofMem.Manual

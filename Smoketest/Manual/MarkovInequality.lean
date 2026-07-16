import Mathlib

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace ProofMem.Manual

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

set_option linter.unusedVariables false

/-! # Group 2: Markov Inequality -/

-- L1: Markov's inequality (standard form)
theorem markov_inequality {X : Ω → ℝ≥0∞} (hX : AEMeasurable X μ) {ε : ℝ≥0∞}
    (hε : ε ≠ 0) (hε' : ε ≠ ∞) : μ {ω | ε ≤ X ω} ≤ (∫⁻ ω, X ω ∂μ) / ε :=
  meas_ge_le_lintegral_div hX hε hε'

-- L2: Perturbation (multiplied form)
theorem markov_multiplied {Y : Ω → ℝ≥0∞} (hY : AEMeasurable Y μ) {c : ℝ≥0∞}
    (hc : c ≠ 0) (hc' : c ≠ ∞) : c * μ {ω | c ≤ Y ω} ≤ (∫⁻ ω, Y ω ∂μ) :=
  mul_meas_ge_le_lintegral₀ hY c

-- L3: Variant — integral form
theorem markov_integral_form {X : Ω → ℝ≥0∞} (hX : AEMeasurable X μ) :
    μ {ω | 1 ≤ X ω} ≤ (∫⁻ ω, X ω ∂μ) := by
  have h := mul_meas_ge_le_lintegral₀ hX 1
  simpa [one_mul] using h

end ProofMem.Manual

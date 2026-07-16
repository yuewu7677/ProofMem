import Mathlib

open MeasureTheory ProbabilityTheory
open scoped ENNReal

set_option linter.unusedVariables false

namespace ProofMem.Manual

variable {Ω : Type*} [m0 : MeasurableSpace Ω] {μ : Measure Ω}

/-! # Group 8: Conditional Expectation -/

section CondExp

variable [IsFiniteMeasure μ] {X Y : Ω → ℝ}

theorem law_of_total_expectation {m : MeasurableSpace Ω} (hm : m ≤ m0)
    [SigmaFinite (μ.trim hm)] : μ[μ[X|m]] = μ[X] :=
  integral_condExp hm

theorem total_expectation_eq_iterated {𝒢 : MeasurableSpace Ω} (h𝒢 : 𝒢 ≤ m0)
    [SigmaFinite (μ.trim h𝒢)] : μ[Y] = μ[μ[Y|𝒢]] := by
  rw [eq_comm, integral_condExp h𝒢]

theorem cond_exp_constant {m : MeasurableSpace Ω} (hm : m ≤ m0) (c : ℝ) :
    μ[fun _ => c | m] =ᵐ[μ] fun _ => c := by
  rw [condExp_const hm c]

end CondExp

end ProofMem.Manual

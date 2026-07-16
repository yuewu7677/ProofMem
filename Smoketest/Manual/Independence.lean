import Mathlib

open MeasureTheory ProbabilityTheory
open scoped ENNReal

set_option linter.unusedVariables false

namespace ProofMem.Manual

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-! # Group 7: Independence -/

section Independence

variable [IsProbabilityMeasure μ]
variable {α β : Type*} [MeasurableSpace α] [MeasurableSpace β]

-- L1: IndepFun iff product rule
theorem indepFun_product_rule {X : Ω → α} {Y : Ω → β} :
    IndepFun X Y μ ↔ ∀ (s : Set α) (t : Set β),
      MeasurableSet s → MeasurableSet t →
      μ (X ⁻¹' s ∩ Y ⁻¹' t) = μ (X ⁻¹' s) * μ (Y ⁻¹' t) :=
  indepFun_iff_measure_inter_preimage_eq_mul

-- L2: Perturbation (forward direction extraction)
lemma independence_product_apply {U : Ω → α} {V : Ω → β} {s : Set α} {t : Set β}
    (hs : MeasurableSet s) (ht : MeasurableSet t) (h_indep : IndepFun U V μ) :
    μ (U ⁻¹' s ∩ V ⁻¹' t) = μ (U ⁻¹' s) * μ (V ⁻¹' t) :=
  h_indep.measure_inter_preimage_eq_mul s t hs ht

-- L3: Sibling — independence implies expectation of product
lemma indepFun_expectation_mul {X : Ω → ℝ} {Y : Ω → ℝ}
    (hX : AEStronglyMeasurable X μ) (hY : AEStronglyMeasurable Y μ)
    (h_indep : IndepFun X Y μ)
    (hX_int : Integrable X μ) (hY_int : Integrable Y μ) :
    μ[X * Y] = μ[X] * μ[Y] :=
  h_indep.integral_mul_eq_mul_integral hX hY

end Independence

end ProofMem.Manual

import Mathlib

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace ProofMem.Manual

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-! # Group 5: Borel-Cantelli Lemma -/

open Filter

theorem borel_cantelli_first {s : ℕ → Set Ω} (h_sum : ∑' i, μ (s i) ≠ ∞) :
    μ (limsup s atTop) = 0 :=
  measure_limsup_atTop_eq_zero h_sum

theorem first_BC_variant {E : ℕ → Set Ω} (h_summable : ∑' k, μ (E k) < ∞) :
    0 = μ (limsup E atTop) := by
  rw [eq_comm]
  apply borel_cantelli_first
  exact ne_of_lt h_summable

theorem borel_cantelli_ae_finite {s : ℕ → Set Ω} (h_sum : ∑' i, μ (s i) ≠ ∞) :
    ∀ᵐ ω ∂μ, ∀ᶠ n in atTop, ω ∉ s n := by
  have h_finite := ae_finite_setOf_mem h_sum
  filter_upwards [h_finite] with ω hω
  have h_fin : {i | ω ∈ s i}.Finite := hω
  have h_bdd : BddAbove {i | ω ∈ s i} := h_fin.bddAbove
  rcases h_bdd with ⟨N, hN⟩
  rw [Filter.eventually_atTop]
  refine ⟨N + 1, fun n hn => ?_⟩
  by_contra h_mem
  have h_bound : n ≤ N := hN (Set.mem_setOf.mpr h_mem)
  omega

end ProofMem.Manual

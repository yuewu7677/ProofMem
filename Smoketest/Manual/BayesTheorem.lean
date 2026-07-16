import Mathlib

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace ProofMem.Manual

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-! # Group 4: Bayes Theorem -/

section Bayes

variable [IsProbabilityMeasure μ]

lemma cond_mul_eq_inter {A B : Set Ω} (hB : MeasurableSet B) :
    μ[A|B] * μ B = μ (A ∩ B) := by
  rw [cond_apply hB, Set.inter_comm B A]
  by_cases h : μ B = 0
  · rw [h, mul_zero]
    have h_empty : μ (A ∩ B) = 0 := by
      apply le_antisymm
      · calc
          μ (A ∩ B) ≤ μ B := measure_mono (Set.inter_subset_right (s := A) (t := B))
          _ = 0 := h
      · simp
    exact h_empty.symm
  · calc
      (μ B)⁻¹ * μ (A ∩ B) * μ B = μ (A ∩ B) * ((μ B)⁻¹ * μ B) := by ring
      _ = μ (A ∩ B) * 1 := by
        rw [ENNReal.inv_mul_cancel h (measure_ne_top _ _)]
      _ = μ (A ∩ B) := by simp

theorem bayes_theorem {A B : Set Ω} (hA : MeasurableSet A) (hB : MeasurableSet B) :
    μ[A|B] * μ B = μ[B|A] * μ A := by
  rw [cond_mul_eq_inter hB, cond_mul_eq_inter hA, Set.inter_comm]

theorem bayes_renamed {S T : Set Ω} (hS : MeasurableSet S) (hT : MeasurableSet T) :
    μ[S|T] * μ T = μ[T|S] * μ S :=
  bayes_theorem hS hT

theorem law_of_total_probability {A B : Set Ω} (hA : MeasurableSet A) (hB : MeasurableSet B) :
    μ B = μ[B|A] * μ A + μ[B|Aᶜ] * μ (Aᶜ) := by
  have hA_compl : MeasurableSet (Aᶜ) := hA.compl
  have h_disjoint : Disjoint (B ∩ A) (B ∩ Aᶜ) := by
    rw [Set.disjoint_iff_inter_eq_empty]
    calc
      (B ∩ A) ∩ (B ∩ Aᶜ) = B ∩ (A ∩ Aᶜ) := by aesop
      _ = B ∩ ∅ := by simp
      _ = ∅ := by simp
  calc
    μ B = μ (B ∩ Set.univ) := by simp
    _ = μ (B ∩ (A ∪ Aᶜ)) := by rw [Set.union_compl_self A]
    _ = μ ((B ∩ A) ∪ (B ∩ Aᶜ)) := by rw [Set.inter_union_distrib_left]
    _ = μ (B ∩ A) + μ (B ∩ Aᶜ) := by
      rw [measure_union h_disjoint (hB.inter hA_compl)]
    _ = μ[B|A] * μ A + μ[B|Aᶜ] * μ (Aᶜ) := by
      simp_rw [cond_mul_eq_inter hA, cond_mul_eq_inter hA_compl]

end Bayes

end ProofMem.Manual

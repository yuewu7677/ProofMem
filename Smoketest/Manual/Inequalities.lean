import Mathlib

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

set_option linter.unusedVariables false

namespace ProofMem.Manual

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-! # Group 2: Markov and Chebyshev Inequalities

Difficulty: advanced undergraduate
Family: inequalities
-/

-- L1: Markov's inequality
theorem markov_inequality {X : Ω → ℝ} (hX : AEMeasurable X μ)
    (h_nonneg : 0 ≤ᵐ[μ] X) {a : ℝ} (ha : 0 < a) :
    μ {ω | a ≤ X ω} ≤ (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) / ENNReal.ofReal a := by
  have ha0 : ENNReal.ofReal a ≠ 0 := by
    simpa using (ENNReal.ofReal_pos.mpr ha).ne.symm
  have ha_top : ENNReal.ofReal a ≠ ∞ := by simp
  have h_enn_meas : AEMeasurable (fun ω => ENNReal.ofReal (X ω)) μ :=
    hX.ennreal_ofReal
  have h_subset : {ω | a ≤ X ω} ⊆ {ω | ENNReal.ofReal a ≤ ENNReal.ofReal (X ω)} := by
    intro ω hω
    exact ENNReal.ofReal_le_ofReal hω
  calc
    μ {ω | a ≤ X ω} ≤ μ {ω | ENNReal.ofReal a ≤ ENNReal.ofReal (X ω)} :=
      measure_mono h_subset
    _ ≤ (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) / ENNReal.ofReal a :=
      meas_ge_le_lintegral_div h_enn_meas ha0 ha_top

-- L2: Perturbation (alpha-rename X↦Y, a↦c, algebraic rearrangement)
theorem prob_ge_threshold_bound {Y : Ω → ℝ} (h_meas_Y : AEMeasurable Y μ)
    (h_nonneg_Y : 0 ≤ᵐ[μ] Y) {c : ℝ} (hc_pos : 0 < c) :
    (ENNReal.ofReal c) * μ {ω | c ≤ Y ω} ≤ (∫⁻ ω, ENNReal.ofReal (Y ω) ∂μ) := by
  have h_enn_meas : AEMeasurable (fun ω => ENNReal.ofReal (Y ω)) μ :=
    h_meas_Y.ennreal_ofReal
  have h_subset : {ω | c ≤ Y ω} ⊆ {ω | ENNReal.ofReal c ≤ ENNReal.ofReal (Y ω)} := by
    intro ω hω
    exact ENNReal.ofReal_le_ofReal hω
  have h_mul := mul_meas_ge_le_lintegral₀ h_enn_meas (ENNReal.ofReal c)
  calc
    (ENNReal.ofReal c) * μ {ω | c ≤ Y ω} ≤
        (ENNReal.ofReal c) * μ {ω | ENNReal.ofReal c ≤ ENNReal.ofReal (Y ω)} := by
      gcongr
    _ ≤ (∫⁻ ω, ENNReal.ofReal (Y ω) ∂μ) := h_mul

-- L3: Chebyshev's inequality (measure-theoretic form via lintegral)
theorem chebyshev_inequality {X : Ω → ℝ} (hX : AEMeasurable X μ)
    (h_int : Integrable X μ) {ε : ℝ} (hε : 0 < ε) :
    μ {ω | ε ≤ |X ω - μ[X]|} ≤
    (∫⁻ ω, ENNReal.ofReal ((fun ω => (X ω - μ[X]) ^ 2) ω) ∂μ) / ENNReal.ofReal (ε ^ 2) := by
  let g : Ω → ℝ := fun ω => (X ω - μ[X]) ^ 2
  have hg_nonneg : 0 ≤ g := by
    intro ω; apply pow_two_nonneg
  have hg_meas : AEMeasurable g μ := by
    have h_sub : AEMeasurable (fun ω => X ω - μ[X]) μ :=
      hX.sub (measurable_const.aemeasurable (μ := μ))
    exact h_sub.pow_const (2 : ℕ)
  have h_markov : μ {ω | ε ^ 2 ≤ g ω} ≤
      (∫⁻ ω, ENNReal.ofReal (g ω) ∂μ) / ENNReal.ofReal (ε ^ 2) :=
    markov_inequality hg_meas (ae_of_all _ hg_nonneg) (pow_pos hε 2)
  have h_subset : {ω | ε ≤ |X ω - μ[X]|} ⊆ {ω | ε ^ 2 ≤ g ω} := by
    intro ω hω
    have h_abs : ε ≤ |X ω - μ[X]| := hω
    have hε_nonneg : 0 ≤ ε := hε.le
    have h_sq : ε ^ 2 ≤ |X ω - μ[X]| ^ 2 := by
      have := mul_self_le_mul_self hε_nonneg h_abs
      simpa [sq] using this
    calc
      ε ^ 2 ≤ |X ω - μ[X]| ^ 2 := h_sq
      _ = (X ω - μ[X]) ^ 2 := by rw [sq_abs]
      _ = g ω := rfl
  have h_measure_le : μ {ω | ε ≤ |X ω - μ[X]|} ≤ μ {ω | ε ^ 2 ≤ g ω} :=
    measure_mono h_subset
  exact h_measure_le.trans h_markov

end ProofMem.Manual

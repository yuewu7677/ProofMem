import Mathlib

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

set_option linter.unusedVariables false

namespace ProofMem.Manual

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-! # Group 1: Monotone Convergence Theorem

Difficulty: advanced undergraduate / graduate (measure-theoretic probability)
Family: monotone_convergence
-/

-- L1: Monotone Convergence Theorem (Beppo Levi)
theorem monotoneConvergence_integral {f : ℕ → Ω → ℝ≥0∞}
    (hf : ∀ n, AEMeasurable (f n) μ)
    (h_mono : ∀ n, f n ≤ᵐ[μ] f (n + 1)) :
    (∫⁻ ω, ⨆ n, f n ω ∂μ) = ⨆ n, (∫⁻ ω, f n ω ∂μ) := by
  have h_mono_ae : ∀ᵐ ω ∂μ, Monotone fun n => f n ω := by
    have : ∀ᵐ ω ∂μ, ∀ n, f n ω ≤ f (n + 1) ω := ae_all_iff.mpr h_mono
    filter_upwards [this] with ω hω
    exact monotone_nat_of_le_succ hω
  exact lintegral_iSup' hf h_mono_ae

-- L2: Perturbation of L1 (alpha-rename f↦g, equality flip, binder reorder)
theorem integral_iSup_monotone {g : ℕ → Ω → ℝ≥0∞}
    (h_meas : ∀ n, AEMeasurable (g n) μ)
    (h_nondec : ∀ n, g n ≤ᵐ[μ] g (n + 1)) :
    (⨆ n, (∫⁻ ω, g n ω ∂μ)) = (∫⁻ ω, ⨆ n, g n ω ∂μ) := by
  rw [eq_comm]
  exact monotoneConvergence_integral h_meas h_nondec

-- L3: Sibling — one-sided inequality from MCT (Fatou-like)
lemma lintegral_iSup_le_of_ae_monotone {f : ℕ → Ω → ℝ≥0∞}
    (hf : ∀ n, AEMeasurable (f n) μ)
    (h_mono : ∀ n, f n ≤ᵐ[μ] f (n + 1)) :
    (⨆ n, (∫⁻ ω, f n ω ∂μ)) ≤ (∫⁻ ω, ⨆ n, f n ω ∂μ) := by
  rw [← monotoneConvergence_integral hf h_mono]

end ProofMem.Manual

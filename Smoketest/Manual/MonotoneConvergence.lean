import Mathlib

open MeasureTheory
open scoped ENNReal

namespace Smoke.Manual.MonotoneConvergence

set_option linter.unusedVariables false

/-! # Group 6: Monotone Convergence Theorem (ENNReal) -/

variable {α : Type*} [MeasurableSpace α] {μ : Measure α}

-- L1: Monotone Convergence Theorem
theorem monotone_convergence_theorem {f : ℕ → α → ℝ≥0∞}
    (hf : ∀ n, AEMeasurable (f n) μ)
    (h_mono : ∀ᵐ ω ∂μ, Monotone fun n => f n ω) :
    (∫⁻ ω, ⨆ n, f n ω ∂μ) = ⨆ n, (∫⁻ ω, f n ω ∂μ) :=
  lintegral_iSup' hf h_mono

-- L2: Perturbation (alpha-rename, equality flip)
theorem mct_perturbed {g : ℕ → α → ℝ≥0∞}
    (hg : ∀ n, AEMeasurable (g n) μ)
    (h_nondecr : ∀ᵐ ω ∂μ, Monotone fun n => g n ω) :
    (⨆ n, (∫⁻ ω, g n ω ∂μ)) = (∫⁻ ω, ⨆ n, g n ω ∂μ) := by
  rw [eq_comm, monotone_convergence_theorem hg h_nondecr]

-- L3: Fatou's Lemma
theorem Fatou_lemma {f : ℕ → α → ℝ≥0∞}
    (hf : ∀ n, AEMeasurable (f n) μ) :
    (∫⁻ ω, liminf (fun n => f n ω) atTop ∂μ) ≤ liminf (fun n => ∫⁻ ω, f n ω ∂μ) atTop :=
  lintegral_liminf_le' hf

end Smoke.Manual.MonotoneConvergence

import Mathlib

open MeasureTheory
open scoped ENNReal

namespace Smoke.Manual.DominatedConvergence

set_option linter.unusedVariables false

/-! # Group 5: Dominated Convergence Theorem -/

variable {α : Type*} [MeasurableSpace α] {μ : Measure α}

-- L1: Dominated Convergence Theorem (special case: limit zero)
theorem dominated_convergence_theorem {F : ℕ → α → ℝ} {bound : α → ℝ}
    (F_meas : ∀ n, AEStronglyMeasurable (F n) μ)
    (bound_int : Integrable bound μ)
    (h_bound : ∀ n, ∀ᵐ ω ∂μ, ‖F n ω‖ ≤ bound ω)
    (h_lim : ∀ᵐ ω ∂μ, Tendsto (fun n => F n ω) atTop (𝓝 (0 : ℝ))) :
    Tendsto (fun n => ∫ ω, F n ω ∂μ) atTop (𝓝 (∫ ω, (0 : ℝ) ∂μ)) := by
  have h := tendsto_integral_of_dominated_convergence bound F_meas bound_int h_bound h_lim
  simpa using h

-- L2: Perturbation (alpha-rename F→G, bound→B)
theorem dct_renamed {G : ℕ → α → ℝ} {B : α → ℝ}
    (G_meas : ∀ n, AEStronglyMeasurable (G n) μ)
    (B_int : Integrable B μ)
    (h_bound : ∀ n, ∀ᵐ ω ∂μ, ‖G n ω‖ ≤ B ω)
    (h_lim : ∀ᵐ ω ∂μ, Tendsto (fun n => G n ω) atTop (𝓝 (0 : ℝ))) :
    Tendsto (fun n => ∫ ω, G n ω ∂μ) atTop (𝓝 (∫ ω, (0 : ℝ) ∂μ)) :=
  dominated_convergence_theorem G_meas B_int h_bound h_lim

-- L3: Bounded Convergence Theorem (finite measure + uniform bound)
theorem bounded_convergence_theorem [IsFiniteMeasure μ]
    {F : ℕ → α → ℝ} (M : ℝ)
    (F_meas : ∀ n, AEStronglyMeasurable (F n) μ)
    (h_bound : ∀ n, ∀ᵐ ω ∂μ, ‖F n ω‖ ≤ M)
    (h_lim : ∀ᵐ ω ∂μ, Tendsto (fun n => F n ω) atTop (𝓝 (0 : ℝ))) :
    Tendsto (fun n => ∫ ω, F n ω ∂μ) atTop (𝓝 (0 : ℝ)) := by
  have hM_int : Integrable (fun _ : α => M) μ := by
    simp
  have h := tendsto_integral_of_dominated_convergence (fun _ => M) F_meas hM_int h_bound h_lim
  simpa using h

end Smoke.Manual.DominatedConvergence

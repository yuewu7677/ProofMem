import Mathlib

open Set Filter

namespace Smoke.Manual.UniformLimit

set_option linter.unusedVariables false

/-! # Group 3: Uniform Convergence and Continuity -/

-- L1: Uniform limit of continuous functions is continuous
theorem uniform_limit_continuous {α : Type*} [TopologicalSpace α]
    {f : ℕ → α → ℝ} {f_lim : α → ℝ}
    (hf_cont : ∀ n, Continuous (f n))
    (h_unif : TendstoUniformly f f_lim atTop) : Continuous f_lim :=
  h_unif.continuous (eventually_of_forall hf_cont)

-- L2: Perturbation (alpha-rename)
theorem unif_limit_cont_perturbed {β : Type*} [TopologicalSpace β]
    {g : ℕ → β → ℝ} {g_lim : β → ℝ}
    (hg_cont : ∀ n, Continuous (g n))
    (h_unif_g : TendstoUniformly g g_lim atTop) : Continuous g_lim :=
  uniform_limit_continuous hg_cont h_unif_g

-- L3: Sibling — uniform limit of functions bounded by M is bounded by M
theorem uniform_limit_bounded {α : Type*} [TopologicalSpace α]
    {f : ℕ → α → ℝ} {f_lim : α → ℝ} (M : ℝ)
    (h_bound : ∀ n x, |f n x| ≤ M)
    (h_unif : TendstoUniformly f f_lim atTop) : ∀ x, |f_lim x| ≤ M := by
  intro x
  have h_tendsto : Tendsto (fun n : ℕ => f n x) atTop (𝓝 (f_lim x)) := h_unif.tendsto_at x
  have h_abs : Tendsto (fun n : ℕ => |f n x|) atTop (𝓝 (|f_lim x|)) :=
    h_tendsto.abs
  refine le_of_tendsto h_abs (eventually_of_forall (fun n => h_bound n x))

end Smoke.Manual.UniformLimit

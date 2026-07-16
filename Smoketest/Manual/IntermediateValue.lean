import Mathlib

open Set

namespace Smoke.Manual.IntermediateValue

set_option linter.unusedVariables false

/-! # Group 1: Intermediate Value Theorem -/

-- L1: Intermediate Value Theorem
theorem intermediate_value_theorem {a b : ℝ} {f : ℝ → ℝ}
    (hab : a ≤ b) (hf : ContinuousOn f (Icc a b))
    {y : ℝ} (hy : y ∈ Ioo (f a) (f b)) : ∃ x ∈ Ioo a b, f x = y := by
  have h := intermediate_value_Ioo hab hf
  rcases h hy with ⟨x, hx, rfl⟩
  exact ⟨x, hx, rfl⟩

-- L2: Perturbation (alpha-rename)
theorem ivt_renamed {c d : ℝ} {g : ℝ → ℝ}
    (hcd : c ≤ d) (hg : ContinuousOn g (Icc c d))
    {z : ℝ} (hz : z ∈ Ioo (g c) (g d)) : ∃ x ∈ Ioo c d, g x = z :=
  intermediate_value_theorem hcd hg hz

-- L3: Extreme Value Theorem on [0,1]
theorem extreme_value_theorem {f : ℝ → ℝ}
    (hf : ContinuousOn f (Icc (0:ℝ) 1)) : ∃ x ∈ Icc (0:ℝ) 1, ∀ y ∈ Icc (0:ℝ) 1, f y ≤ f x := by
  have h_compact : IsCompact (Icc (0:ℝ) (1:ℝ)) := isCompact_Icc
  have h_nonempty : (Icc (0:ℝ) (1:ℝ)).Nonempty := by
    refine ⟨0, ?_⟩; simp
  rcases h_compact.exists_isMaxOn h_nonempty hf with ⟨x, hx, hmax⟩
  exact ⟨x, hx, fun y hy => hmax hy⟩

end Smoke.Manual.IntermediateValue

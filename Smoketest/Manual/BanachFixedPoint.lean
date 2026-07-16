import Mathlib

open scoped NNReal

namespace Smoke.Manual.BanachFixedPoint

set_option linter.unusedVariables false

/-! # Group 9: Banach Fixed Point Theorem -/

-- L1: Every contraction on a complete nonempty metric space has a unique fixed point
theorem Banach_fixed_point {α : Type*} [MetricSpace α] [CompleteSpace α] [Nonempty α]
    {f : α → α} (hf : ContractingWith ℝ f) : ∃! x : α, f x = x := by
  have h_nonempty : Nonempty α := inferInstance
  obtain ⟨x₀⟩ := h_nonempty
  have hx : edist x₀ (f x₀) ≠ ∞ := by simp
  rcases hf.exists_fixedPoint x₀ hx with ⟨y, hy, _, _⟩
  refine ⟨y, hy, ?_⟩
  intro z hz
  apply hf.2
  · exact hy
  · exact hz

-- L2: Perturbation (alpha-rename α→β, f→g)
theorem contraction_mapping_perturbed {β : Type*} [MetricSpace β] [CompleteSpace β] [Nonempty β]
    {g : β → β} (hg : ContractingWith ℝ g) : ∃! y : β, g y = y :=
  Banach_fixed_point hg

-- L3: Sibling — iterates converge to fixed point
theorem fixed_point_iterates_converge {α : Type*} [MetricSpace α] [CompleteSpace α]
    {f : α → α} (hf : ContractingWith ℝ f) (x₀ : α) :
    ∃ x : α, f x = x ∧ Tendsto (fun n : ℕ => f^[n] x₀) atTop (𝓝 x) := by
  have hx : edist x₀ (f x₀) ≠ ∞ := by simp
  rcases hf.exists_fixedPoint x₀ hx with ⟨x, hx_fix, hx_tendsto, _⟩
  exact ⟨x, hx_fix, hx_tendsto⟩

end Smoke.Manual.BanachFixedPoint

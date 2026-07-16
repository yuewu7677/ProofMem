import Mathlib

open Set

namespace Smoke.Manual.MeanValue

set_option linter.unusedVariables false

/-! # Group 2: Mean Value Theorem -/

variable {a b : ℝ} {f : ℝ → ℝ}

-- L1: Lagrange Mean Value Theorem
theorem mean_value_theorem (hab : a < b) (hf : ContinuousOn f (Icc a b))
    (hf' : DifferentiableOn ℝ f (Ioo a b)) :
    ∃ c ∈ Ioo a b, deriv f c = (f b - f a) / (b - a) :=
  exists_deriv_eq_slope f hab hf hf'

-- L2: Perturbation (alpha-rename f→g, a→p, b→q)
theorem mvt_renamed {p q : ℝ} {g : ℝ → ℝ}
    (hpq : p < q) (hg_cont : ContinuousOn g (Icc p q))
    (hg_diff : DifferentiableOn ℝ g (Ioo p q)) :
    ∃ c ∈ Ioo p q, deriv g c = (g q - g p) / (q - p) :=
  exists_deriv_eq_slope g hpq hg_cont hg_diff

-- L3: Rolle's Theorem
theorem rolle_theorem (hab : a < b) (hf : ContinuousOn f (Icc a b))
    (hf' : DifferentiableOn ℝ f (Ioo a b)) (hfa : f a = f b) :
    ∃ c ∈ Ioo a b, deriv f c = 0 := by
  rcases mean_value_theorem hab hf hf' with ⟨c, hc, h_eq⟩
  refine ⟨c, hc, ?_⟩
  rw [hfa, sub_self, zero_div] at h_eq
  exact h_eq

end Smoke.Manual.MeanValue

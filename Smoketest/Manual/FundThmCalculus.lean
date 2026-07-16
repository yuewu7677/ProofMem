import Mathlib

namespace Smoke.Manual.FundThmCalculus

set_option linter.unusedVariables false

/-! # Group 8: Fundamental Theorem of Calculus -/

-- L1: Fundamental Theorem of Calculus
theorem fundamental_theorem_calculus {f : ℝ → ℝ} {a b : ℝ}
    (hderiv : ∀ x ∈ Set.uIcc a b, DifferentiableAt ℝ f x)
    (hint : IntervalIntegrable (deriv f) volume a b) :
    (∫ x in (a..b), deriv f x) = f b - f a :=
  integral_deriv_eq_sub hderiv hint

-- L2: Perturbation (alpha-rename a→c, b→d, f→g, equality flip)
theorem ftc_renamed {g : ℝ → ℝ} {c d : ℝ}
    (hderiv_g : ∀ x ∈ Set.uIcc c d, DifferentiableAt ℝ g x)
    (hint_g : IntervalIntegrable (deriv g) volume c d) :
    g d - g c = (∫ x in (c..d), deriv g x) := by
  rw [eq_comm, fundamental_theorem_calculus hderiv_g hint_g]

-- L3: Sibling — integral of zero is zero
theorem integral_zero_eq_zero {a b : ℝ} : (∫ x in (a..b), (0 : ℝ)) = (0 : ℝ) := by
  simp

end Smoke.Manual.FundThmCalculus

import Mathlib

variable {G : Type _} [Group G]

/--
Left multiplication by inverse cancels.

a⁻¹ * a = 1 for any group element a.

This is one of the defining group axioms.
-/
theorem inv_mul_cancel_g (a : G) : a⁻¹ * a = 1 := by
  sorry

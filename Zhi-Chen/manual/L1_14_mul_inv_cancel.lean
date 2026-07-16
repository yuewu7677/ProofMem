import Mathlib

variable {G : Type _} [Group G]

/--
Right multiplication by inverse cancels.

a * a⁻¹ = 1 for any group element a.

This is one of the defining group axioms.
-/
theorem mul_inv_cancel_g (a : G) : a * a⁻¹ = 1 := by
  sorry

import Mathlib

variable {G : Type _} [Group G]

/--
Inverses in a group are unique.

If a * b = 1, then b = a⁻¹.

Every element has exactly one inverse.
-/
theorem inv_unique_g (a b : G) (h : a * b = 1) : b = a⁻¹ := by
  sorry

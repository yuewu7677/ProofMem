import Mathlib

variable {G : Type _} [Group G]

/--
Left multiplication in a group is injective.

a * b = a * c if and only if b = c.

Follows from left cancellation via multiplying by a⁻¹.
-/
theorem mul_left_inj_g (a b c : G) : a * b = a * c ↔ b = c := by
  sorry

import Mathlib

variable {G : Type _} [Group G]

/--
The identity element of a group is unique.

If e satisfies e * a = a for all a, then e = 1.

Foundational uniqueness property of groups.
-/
theorem one_unique_g (e : G) (h : ∀ a : G, e * a = a) : e = 1 := by
  sorry

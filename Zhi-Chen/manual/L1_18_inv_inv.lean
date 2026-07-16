import Mathlib

variable {G : Type _} [Group G]

/--
Double inverse returns the original element.

(a⁻¹)⁻¹ = a for any group element a.

Inversion is an involution.
-/
theorem inv_inv_g (a : G) : a⁻¹⁻¹ = a := by
  sorry

import Mathlib

variable {R : Type _} [Ring R]

/--
Multiplying any element by zero yields zero.

a * 0 = 0 in any ring.

Follows from ring axioms: a*0 = a*(0+0) = a*0 + a*0, subtract a*0.
-/
theorem mul_zero_r (a : R) : a * 0 = 0 := by
  sorry

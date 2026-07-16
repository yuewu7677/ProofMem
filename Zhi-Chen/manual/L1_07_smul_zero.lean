import Mathlib

/--
Scalar multiplication by zero vector yields zero vector.

For any scalar c in a vector space V over ℝ, c • 0 = 0.

Axiom-derived property of vector spaces.
-/
theorem smul_zero_vec (V : Type _) [AddCommGroup V] [Module ℝ V] (c : ℝ) :
    c • (0 : V) = (0 : V) := by
  sorry

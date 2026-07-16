import Mathlib

/--
Zero scalar times any vector is the zero vector.

For any vector v in a vector space V over ℝ, 0 • v = 0.

Axiom-derived property of vector spaces.
-/
theorem zero_smul_vec (V : Type _) [AddCommGroup V] [Module ℝ V] (v : V) :
    (0 : ℝ) • v = (0 : V) := by
  sorry

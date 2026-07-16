import Mathlib

/--
Negation of scalar multiplication.

(-c) • v = -(c • v) in a vector space over ℝ.

Follows from the module axioms.
-/
theorem neg_smul_vec (V : Type _) [AddCommGroup V] [Module ℝ V] (c : ℝ) (v : V) :
    (-c) • v = -(c • v) := by
  sorry

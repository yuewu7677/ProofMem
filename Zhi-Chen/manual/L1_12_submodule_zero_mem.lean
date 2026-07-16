import Mathlib

/--
Zero vector belongs to every subspace.

For any subspace W of V, 0 ∈ W.

Fundamental property of subspaces — every subspace contains the zero vector.
-/
theorem submodule_zero_mem (V : Type _) [AddCommGroup V] [Module ℝ V]
    (W : Submodule ℝ V) : (0 : V) ∈ W := by
  sorry

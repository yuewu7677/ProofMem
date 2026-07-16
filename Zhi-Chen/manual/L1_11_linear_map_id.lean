import Mathlib

/--
The identity linear map id : V → V is linear.

∀ u v, id(u+v) = id(u) + id(v) and id(c•v) = c • id(v).

Foundation for the category of vector spaces.
-/
theorem linear_map_id (V : Type _) [AddCommGroup V] [Module ℝ V] :
    LinearMap.id ℝ V = { toFun := λ x => x, map_add' := by
      intro x y; rfl, map_smul' := by
      intro c x; rfl } := by
  sorry

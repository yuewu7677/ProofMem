import Mathlib

/--
Vector addition is commutative.

For any vectors u, v in an additive commutative group, u + v = v + u.

Axiom of additive commutative groups (and thus all vector spaces).
-/
theorem add_comm_vec (V : Type _) [AddCommGroup V] (u v : V) :
    u + v = v + u := by
  sorry

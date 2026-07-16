import Mathlib

open Filter
open Topology

/--
The identity function f(x) = x is continuous at every point.

∀ x₀, continuous_at id x₀. Foundation for building more complex continuous functions.
-/
theorem continuous_at_id_real (x₀ : ℝ) : ContinuousAt id x₀ := by
  sorry

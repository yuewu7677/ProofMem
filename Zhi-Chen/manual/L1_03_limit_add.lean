import Mathlib

open Filter
open Topology

/--
Limit of sum equals sum of limits.

If aₙ → L and bₙ → M, then aₙ + bₙ → L + M.

Fundamental algebraic property of sequential limits.
-/
theorem limit_add_seq (a b : ℕ → ℝ) (L M : ℝ)
    (ha : Tendsto a atTop (𝓝 L))
    (hb : Tendsto b atTop (𝓝 M)) :
    Tendsto (a + b) atTop (𝓝 (L + M)) := by
  sorry

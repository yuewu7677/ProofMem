import Mathlib

open Filter
open Topology

/--
Uniqueness of sequential limits in ℝ.

If aₙ → L and aₙ → M, then L = M.

Follows from Hausdorff property of ℝ.
-/
theorem limit_unique_seq (a : ℕ → ℝ) (L M : ℝ)
    (hL : Tendsto a atTop (𝓝 L))
    (hM : Tendsto a atTop (𝓝 M)) :
    L = M := by
  sorry

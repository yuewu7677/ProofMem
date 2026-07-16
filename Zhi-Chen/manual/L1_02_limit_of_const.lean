import Mathlib

open Filter
open Topology

/--
Limit of a constant sequence equals the constant.

If aₙ = c for all n, then lim aₙ = c.

Fundamental property of sequential limits in real analysis.
-/
theorem limit_of_const_seq (c : ℝ) : Tendsto (λ _ : ℕ => c) atTop (𝓝 c) := by
  sorry

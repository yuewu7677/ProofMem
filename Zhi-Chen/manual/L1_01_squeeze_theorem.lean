import Mathlib

open Filter
open Topology

/--
Squeeze theorem (Sandwich theorem) for real sequences.

If a_n ≤ b_n ≤ c_n for all n, and both a_n → L and c_n → L, then b_n → L.

This is a foundational result in undergraduate real analysis.
-/
theorem squeeze_theorem_real_seq (a b c : ℕ → ℝ) (L : ℝ)
    (hle : ∀ n, a n ≤ b n ∧ b n ≤ c n)
    (ha : Tendsto a atTop (𝓝 L))
    (hc : Tendsto c atTop (𝓝 L)) :
    Tendsto b atTop (𝓝 L) := by
  sorry

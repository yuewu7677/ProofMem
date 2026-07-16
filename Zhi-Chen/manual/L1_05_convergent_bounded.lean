import Mathlib

open Filter
open Topology

/--
Every convergent real sequence is bounded.

If aₙ → L, then there exists M > 0 such that |aₙ| ≤ M for all n.

Foundational result linking convergence and boundedness.
-/
theorem convergent_implies_bounded (a : ℕ → ℝ) (L : ℝ)
    (h : Tendsto a atTop (𝓝 L)) :
    ∃ (M : ℝ), ∀ n, |a n| ≤ M := by
  sorry

import Mathlib

open Set Filter

namespace Smoke.Manual.Weierstrass

set_option linter.unusedVariables false

/-! # Group 4: Weierstrass M-test -/

-- L1: Weierstrass M-test: uniform convergence of series on whole ℝ
theorem weierstrass_m_test {f : ℕ → ℝ → ℝ} {M : ℕ → ℝ}
    (hM_summable : Summable M) (h_bound : ∀ n x, ‖f n x‖ ≤ M n) :
    ∃ g : ℝ → ℝ, TendstoUniformly (fun N x => ∑ n in Finset.range N, f n x) g atTop := by
  refine ⟨fun x => ∑' n, f n x, ?_⟩
  have h := tendstoUniformlyOn_tsum_nat hM_summable (s := Set.univ) (fun n x hx => h_bound n x)
  simpa [tendstoUniformlyOn_univ] using h

-- L2: Perturbation (alpha-rename)
theorem m_test_perturbed {g : ℕ → ℝ → ℝ} {N : ℕ → ℝ}
    (hN_summable : Summable N) (h_bound : ∀ n x, ‖g n x‖ ≤ N n) :
    ∃ h : ℝ → ℝ, TendstoUniformly (fun K x => ∑ n in Finset.range K, g n x) h atTop :=
  weierstrass_m_test hN_summable h_bound

-- L3: Sibling — Absolute summability implies summability
theorem summable_of_norm_bound_series {f : ℕ → ℝ} {a : ℕ → ℝ}
    (ha_summable : Summable a) (h_bound : ∀ n, ‖f n‖ ≤ a n) : Summable f := by
  refine Summable.of_norm ?_
  apply ha_summable.of_nonneg_of_le (fun n => norm_nonneg _) (fun n => ?_)
  exact h_bound n

end Smoke.Manual.Weierstrass

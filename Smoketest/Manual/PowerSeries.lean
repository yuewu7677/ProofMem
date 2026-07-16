import Mathlib

open Filter

namespace Smoke.Manual.PowerSeries

set_option linter.unusedVariables false

/-! # Group 10: Series and Convergence -/

-- L1: Terms of a summable series tend to zero
theorem summable_imp_tendsto_zero {f : ℕ → ℝ} (hf : Summable f) : Tendsto f atTop (𝓝 0) :=
  hf.tendsto_atTop_zero

-- L2: Perturbation (alpha-rename)
theorem summable_imp_tendsto_zero_renamed {g : ℕ → ℝ} (hg : Summable g) : Tendsto g atTop (𝓝 0) :=
  summable_imp_tendsto_zero hg

-- L3: Sibling — geometric series converges for 0 ≤ r < 1
theorem summable_geometric_of_nn_lt_one {r : ℝ} (h0 : 0 ≤ r) (h1 : r < 1) :
    Summable fun n : ℕ => r ^ n :=
  summable_geometric_of_lt_one h0 h1

end Smoke.Manual.PowerSeries

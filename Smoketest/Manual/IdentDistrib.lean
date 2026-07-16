import Mathlib

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace ProofMem.Manual

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-! # Group 10: Identically Distributed Random Variables -/

section IdentDistrib

-- L1: Identical distribution implies same integral
theorem identDistrib_integral_eq {X Y : Ω → ℝ} (hXY : IdentDistrib X Y μ μ) :
    μ[X] = μ[Y] :=
  hXY.integral_eq

-- L2: Perturbation (alpha-rename, equality flip)
theorem same_distribution_same_mean {U V : Ω → ℝ} (hUV : IdentDistrib U V μ μ) :
    μ[V] = μ[U] := by
  rw [eq_comm]
  exact hUV.integral_eq

-- L3: Sibling — integrability is preserved under IdentDistrib
theorem identDistrib_integrable_iff {X Y : Ω → ℝ} (hXY : IdentDistrib X Y μ μ) :
    Integrable X μ ↔ Integrable Y μ :=
  hXY.integrable_iff

end IdentDistrib

end ProofMem.Manual

import Mathlib

open Set
open scoped NNReal

namespace Smoke.Manual.Lipschitz

set_option linter.unusedVariables false

/-! # Group 7: Lipschitz Continuity

Difficulty: advanced undergraduate
Family: lipschitz
-/

-- L1: Every Lipschitz function is uniformly continuous
theorem lipschitz_implies_uniformContinuous {K : ℝ≥0} {f : ℝ → ℝ}
    (hf : LipschitzWith K f) : UniformContinuous f :=
  hf.uniformContinuous

-- L2: Perturbation (alpha-rename f→g, K→L)
theorem lipschitz_implies_uc_renamed {L : ℝ≥0} {g : ℝ → ℝ}
    (hg : LipschitzWith L g) : UniformContinuous g :=
  hg.uniformContinuous

-- L3: Sibling — Heine-Cantor: continuous on compact [0,1] ⇒ uniformly continuous on [0,1]
theorem continuous_on_compact_uniformContinuousOn {f : ℝ → ℝ}
    (hf : ContinuousOn f (Icc (0:ℝ) 1)) : UniformContinuousOn f (Icc (0:ℝ) 1) := by
  have h_compact : IsCompact (Icc (0:ℝ) (1:ℝ)) := isCompact_Icc
  exact h_compact.uniformContinuousOn_of_continuous hf

end Smoke.Manual.Lipschitz

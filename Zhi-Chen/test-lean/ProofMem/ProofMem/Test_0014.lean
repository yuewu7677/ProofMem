import Mathlib

open Set

----------------------------------------------------------------------------
-- 0014: continuous injective on interval → strictly monotone
----------------------------------------------------------------------------

theorem ma_proofbench_l1_13_full {a b : ℝ} (hab : a < b) (f : Set.Icc a b → ℝ)
    (hf_cont : Continuous f) (hf_inj : Function.Injective f) :
    StrictMono f ∨ StrictAnti f := by
  haveI : Fact (a ≤ b) := ⟨hab.le⟩
  exact Continuous.strictMono_of_inj hf_cont hf_inj

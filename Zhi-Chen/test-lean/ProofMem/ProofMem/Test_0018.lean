import Mathlib

open MeasureTheory
open Filter

----------------------------------------------------------------------------
-- 0018: decreasing MCT for ENNReal (antitone version)
----------------------------------------------------------------------------

theorem ma_proofbench_l1_17_full {X : Type*} [MeasurableSpace X] (μ : Measure X)
    (fseq : ℕ → X → ENNReal) (f : X → ENNReal)
    (hmeas : ∀ n, Measurable (fseq n))
    (hmono : ∀ n x, fseq (n + 1) x ≤ fseq n x)
    (hlim : ∀ x, Tendsto (fun n => fseq n x) atTop (nhds (f x)))
    (hint : HasFiniteIntegral (fseq 0) μ) :
    Tendsto (fun n => ∫⁻ x, fseq n x ∂μ) atTop (nhds (∫⁻ x, f x ∂μ)) := by
  have h_ae_meas : ∀ n, AEMeasurable (fseq n) μ :=
    fun n => (hmeas n).aemeasurable
  have h_anti : ∀ᵐ x ∂μ, Antitone fun n => fseq n x := by
    filter_upwards with x
    exact antitone_nat_of_succ_le (fun n => hmono n x)
  have h0 : ∫⁻ x, fseq 0 x ∂μ ≠ ⊤ :=
    ne_of_lt hint
  have h_tendsto_ae : ∀ᵐ x ∂μ, Tendsto (fun n => fseq n x) atTop (nhds (f x)) := by
    filter_upwards with x using hlim x
  exact lintegral_tendsto_of_tendsto_of_antitone h_ae_meas h_anti h0 h_tendsto_ae

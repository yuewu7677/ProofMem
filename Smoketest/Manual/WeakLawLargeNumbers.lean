import Mathlib

open MeasureTheory ProbabilityTheory
open scoped ENNReal

set_option linter.unusedVariables false

namespace ProofMem.Manual

variable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}

/-! # Group 3: Sample Mean Expectation -/

section WLLN

variable [IsProbabilityMeasure μ]

-- L1: Expectation of sample mean equals population mean (iid case)
theorem expectation_sample_mean {X : ℕ → Ω → ℝ}
    (h_int : ∀ n, Integrable (X n) μ) (h_exp : ∀ n, μ[X n] = μ[X 0]) (n : ℕ) (hn : n ≠ 0) :
    μ[fun ω => (Finset.sum (Finset.range n) (fun i => X i) ω) / (n : ℝ)] = μ[X 0] := by
  have hn' : (n : ℝ) ≠ 0 := by exact_mod_cast hn
  calc
    μ[fun ω => (Finset.sum (Finset.range n) (fun i => X i) ω) / (n : ℝ)] =
        μ[Finset.sum (Finset.range n) (fun i => X i)] / (n : ℝ) :=
      integral_div (n : ℝ) (Finset.sum (Finset.range n) (fun i => X i))
    _ = (Finset.sum (Finset.range n) (fun i => μ[X i])) / (n : ℝ) := by
      have h := integral_finsetSum (Finset.range n) (fun i hi => h_int i)
      simpa [Finset.sum_apply] using congrArg (fun t : ℝ => t / (n : ℝ)) h
    _ = (Finset.sum (Finset.range n) (fun _ => μ[X 0])) / (n : ℝ) := by simp_rw [h_exp]
    _ = ((n : ℝ) * μ[X 0]) / (n : ℝ) := by simp
    _ = μ[X 0] := by field_simp [hn']

-- L2: Perturbation (alpha-rename, equality flip)
theorem sampleMean_expectation_eq {Y : ℕ → Ω → ℝ}
    (h_int_Y : ∀ m, Integrable (Y m) μ) (h_same_exp : ∀ m, μ[Y m] = μ[Y 0])
    (m : ℕ) (hm : m ≠ 0) :
    μ[Y 0] = μ[fun ω => (Finset.sum (Finset.range m) (fun i => Y i) ω) / (m : ℝ)] := by
  rw [eq_comm]
  exact expectation_sample_mean h_int_Y h_same_exp m hm

-- L3: Sibling — expectation of sum = sum of expectations
theorem expectation_sum {X : ℕ → Ω → ℝ}
    (h_int : ∀ n, Integrable (X n) μ) (n : ℕ) :
    μ[Finset.sum (Finset.range n) X] =
    Finset.sum (Finset.range n) (fun i => μ[X i]) := by
  simpa [Finset.sum_apply] using integral_finsetSum (Finset.range n) (fun i hi => h_int i)

end WLLN

end ProofMem.Manual

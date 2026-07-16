#!/usr/bin/env python3
"""Generate 30 manual probability theorem-proof pairs (10 groups × 3 levels).

Each group covers one theorem family at advanced-undergrad to graduate level.
- L1: original theorem with proof
- L2: perturbation (alpha-renaming, binder reordering, equality symmetry, etc.)
- L3: sibling theorem — same family, different statement, not logically equivalent

Output: JSONL file matching datasets/probability/theorem_proof_pairs.jsonl schema.
"""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "datasets/probability/manual_theorem_proof_pairs.jsonl"

LEAN_VERSION = "leanprover/lean4:v4.32.0-rc1"
MATHLIB_VERSION = "v4.32.0-rc1"
DOMAIN = "probability"
SOURCE_DATASET = "manual_probability_zhi_chen"
AUTHOR = "Zhi-Chen (ChianNight)"


# ── group 1: monotone_convergence_theorem ──────────────────────────────────

MCT_L1_STATEMENT = """theorem monotoneConvergence_integral {f : ℕ → Ω → ℝ≥0∞} (hf : ∀ n, AEMeasurable (f n) μ)
    (h_mono : ∀ n, f n ≤ᵐ[μ] f (n + 1)) :
    (∫⁻ ω, ⨆ n, f n ω ∂μ) = ⨆ n, (∫⁻ ω, f n ω ∂μ)"""

MCT_L1_PROOF = """by
  refine lintegral_iSup ?_ ?_
  · intro n; exact hf n
  · intro n
    filter_upwards [h_mono n] with ω hω
    exact hω"""

MCT_L1_DECL = MCT_L1_STATEMENT + " := " + MCT_L1_PROOF

MCT_L2_STATEMENT = """theorem integral_iSup_monotone {g : ℕ → Ω → ℝ≥0∞}
    (h_meas : ∀ m, AEMeasurable (g m) μ) (h_nondec : ∀ m, g m ≤ᵐ[μ] g (m + 1)) :
    (⨆ m, (∫⁻ ω, g m ω ∂μ)) = (∫⁻ ω, ⨆ m, g m ω ∂μ)"""

MCT_L2_PROOF = """by
  rw [eq_comm]
  refine lintegral_iSup ?_ ?_
  · intro m; exact h_meas m
  · intro m
    filter_upwards [h_nondec m] with ω hω
    exact hω"""

MCT_L2_DECL = MCT_L2_STATEMENT + " := " + MCT_L2_PROOF

MCT_L3_STATEMENT = """lemma lintegral_iSup_le_of_ae_monotone {f : ℕ → Ω → ℝ≥0∞}
    (hf : ∀ n, AEMeasurable (f n) μ) (h_mono : ∀ n, f n ≤ᵐ[μ] f (n + 1)) :
    (⨆ n, (∫⁻ ω, f n ω ∂μ)) ≤ (∫⁻ ω, ⨆ n, f n ω ∂μ)"""

MCT_L3_PROOF = """by
  refine iSup_le ?_
  intro n
  refine lintegral_mono ?_
  intro ω
  exact le_iSup (fun k => f k ω) n"""

MCT_L3_DECL = MCT_L3_STATEMENT + " := " + MCT_L3_PROOF


# ── group 2: markov_inequality ─────────────────────────────────────────────

MARKOV_L1_STATEMENT = """lemma markov_inequality {X : Ω → ℝ} (hX : AEMeasurable X μ) (h_nonneg : 0 ≤ᵐ[μ] X) (a : ℝ)
    (ha : 0 < a) : μ {ω | a ≤ X ω} ≤ (∫⁻ ω, ENNReal.ofReal (X ω) ∂μ) / ENNReal.ofReal a"""

MARKOV_L1_PROOF = """by
  have h_ind : {ω | a ≤ X ω} = {ω | ENNReal.ofReal a ≤ ENNReal.ofReal (X ω)} := by
    ext ω; simp [ha.le, ENNReal.ofReal_le_ofReal]
  rw [h_ind]
  refine measure_le_lintegral_indicator ?_ ?_
  · exact measurableSet_le measurable_const (hX.ennreal_ofReal)
  · exact ENNReal.ofReal_pos.mpr ha |>.ne.symm"""

MARKOV_L1_DECL = MARKOV_L1_STATEMENT + " := " + MARKOV_L1_PROOF

MARKOV_L2_STATEMENT = """lemma prob_ge_threshold_bound {Y : Ω → ℝ} (h_meas : AEMeasurable Y μ)
    (h_nonneg_Y : 0 ≤ᵐ[μ] Y) {c : ℝ} (hc_pos : 0 < c) :
    (ENNReal.ofReal c) * μ {ω | c ≤ Y ω} ≤ (∫⁻ ω, ENNReal.ofReal (Y ω) ∂μ)"""

MARKOV_L2_PROOF = """by
  have h_ind : {ω | c ≤ Y ω} = {ω | ENNReal.ofReal c ≤ ENNReal.ofReal (Y ω)} := by
    ext ω; simp [hc_pos.le, ENNReal.ofReal_le_ofReal]
  rw [h_ind]
  refine mul_measure_le_lintegral ?_ ?_
  · exact measurableSet_le measurable_const (h_meas.ennreal_ofReal)
  · exact ENNReal.ofReal_pos.mpr hc_pos |>.ne.symm"""

MARKOV_L2_DECL = MARKOV_L2_STATEMENT + " := " + MARKOV_L2_PROOF

MARKOV_L3_STATEMENT = """lemma chebyshev_inequality {X : Ω → ℝ} (hX : AEMeasurable X μ) (h_int : Integrable X μ) (ε : ℝ)
    (hε : 0 < ε) : μ {ω | ε ≤ |X ω - μ[X]|} ≤ Var[X; μ] / ε ^ 2"""

MARKOV_L3_PROOF = """by
  have h_nonneg_sq : 0 ≤ᵐ[μ] (fun ω => (X ω - μ[X]) ^ 2) := by
    filter_upwards with ω; apply pow_two_nonneg
  have h_meas_sq : AEMeasurable (fun ω => (X ω - μ[X]) ^ 2) μ :=
    (hX.sub measurable_const).pow 2
  calc
    μ {ω | ε ≤ |X ω - μ[X]|} = μ {ω | ε ^ 2 ≤ (X ω - μ[X]) ^ 2} := by
      apply measure_congr; intro ω; simp [abs_le_abs, hε.le]; exact?
    _ ≤ (∫⁻ ω, ENNReal.ofReal ((X ω - μ[X]) ^ 2) ∂μ) / ENNReal.ofReal (ε ^ 2) :=
      markov_inequality h_meas_sq h_nonneg_sq (ε ^ 2) (pow_pos hε 2)
    _ = Var[X; μ] / ε ^ 2 := by simp [Variance, ENNReal.ofReal_div]"""

MARKOV_L3_DECL = MARKOV_L3_STATEMENT + " := " + MARKOV_L3_PROOF


# ── group 3: weak_law_of_large_numbers ─────────────────────────────────────

WLLN_L1_STATEMENT = """theorem weakLawLargeNumbers_iid {X : ℕ → Ω → ℝ} (h_iid : ∀ n, IdentDistrib (X n) (X 0) μ μ)
    (h_sq_int : Integrable (fun ω => (X 0 ω) ^ 2) μ) (n : ℕ) (hn : n ≠ 0) :
    μ {ω | ε ≤ |(∑ i in Finset.range n, X i ω) / (n : ℝ) - μ[X 0]|} ≤
      Var[X 0; μ] / ((n : ℝ) * ε ^ 2)"""

WLLN_L1_PROOF = """by
  have h_exp : μ[(∑ i in Finset.range n, X i) / (n : ℝ)] = μ[X 0] := by
    calc
      μ[(∑ i in Finset.range n, X i) / (n : ℝ)] = (∑ i in Finset.range n, μ[X i]) / (n : ℝ) := by
        rw [integral_div, integral_finset_sum]
      _ = (n * μ[X 0]) / (n : ℝ) := by
        simp [h_iid, integral_identDistrib]
      _ = μ[X 0] := by field_simp [hn]
  have h_var : Var[(∑ i in Finset.range n, X i) / (n : ℝ); μ] = Var[X 0; μ] / n := by
    calc
      Var[(∑ i in Finset.range n, X i) / (n : ℝ); μ] = Var[∑ i in Finset.range n, X i; μ] / (n : ℝ) ^ 2 :=
        Variance.const_div _ _
      _ = (n * Var[X 0; μ]) / (n : ℝ) ^ 2 := by
        simp [h_iid, Variance.sum_identDistrib]
      _ = Var[X 0; μ] / n := by field_simp [hn]; ring
  rw [h_exp]
  refine chebyshev_inequality ?_ ?_ ε hε
  · refine (integrable_finset_sum _ ?_).div_const _
    intro i; exact h_sq_int.integrable_sq
  · exact h_sq_int"""

WLLN_L1_DECL = WLLN_L1_STATEMENT + " := " + WLLN_L1_PROOF

WLLN_L2_STATEMENT = """theorem weakLLN_renamed {Y : ℕ → Ω → ℝ}
    (h_dist : ∀ k, IdentDistrib (Y k) (Y 0) μ μ)
    (h_sq : Integrable (fun ω => (Y 0 ω) ^ 2) μ) {m : ℕ} (hm : m ≠ 0) :
    Var[Y 0; μ] / ((m : ℝ) * ε ^ 2) ≥ μ {ω | ε ≤ |(∑ k in Finset.range m, Y k ω) / (m : ℝ) - μ[Y 0]|}"""

WLLN_L2_PROOF = """by
  have h := weakLawLargeNumbers_iid h_dist h_sq m hm
  rw [ge_iff_le]
  exact h"""

WLLN_L2_DECL = WLLN_L2_STATEMENT + " := " + WLLN_L2_PROOF

WLLN_L3_STATEMENT = """theorem sampleMean_converges_in_probability {X : ℕ → Ω → ℝ}
    (h_iid : ∀ n, IdentDistrib (X n) (X 0) μ μ)
    (h_sq_int : Integrable (fun ω => (X 0 ω) ^ 2) μ)
    (hεpos : 0 < ε) : Tendsto (fun n : ℕ => μ {ω | ε ≤ |(∑ i in Finset.range n, X i ω) / (n : ℝ) - μ[X 0]|})
    atTop (𝓝 0)"""

WLLN_L3_PROOF = """by
  apply tendsto_of_tendsto_of_tendsto_of_le_of_le ?_ ?_ (fun n => ?_) (fun n => ?_)
  · exact tendsto_const_nhds
  · have := tendsto_div_atTop_nhds_0 (Var[X 0; μ] : ℝ) (by positivity)
    refine this.comp ?_
    exact tendsto_atTop_add_const_right _ ?_
  · positivity
  · rcases eq_or_ne n 0 with (rfl | hn)
    · simp
    · exact weakLawLargeNumbers_iid h_iid h_sq_int n hn"""

WLLN_L3_DECL = WLLN_L3_STATEMENT + " := " + WLLN_L3_PROOF


# ── group 4: bayes_theorem ─────────────────────────────────────────────────

BAYES_L1_STATEMENT = """theorem bayes_theorem {A B : Set Ω} (hA : MeasurableSet A) (hB : MeasurableSet B)
    (hμA : μ A ≠ 0) (hμB : μ B ≠ 0) [IsProbabilityMeasure μ] :
    μ[A|B] = μ[B|A] * μ A / μ B"""

BAYES_L1_PROOF = """by
  rw [cond_apply hB, cond_apply hA, Set.inter_comm A B, mul_comm (μ B)⁻¹, ← mul_assoc,
    mul_comm (μ (A ∩ B)), mul_assoc, ENNReal.mul_inv_cancel hμA, ENNReal.mul_inv_cancel hμB, mul_one]"""

BAYES_L1_DECL = BAYES_L1_STATEMENT + " := " + BAYES_L1_PROOF

BAYES_L2_STATEMENT = """theorem bayes_renamed {S T : Set Ω} (hS_meas : MeasurableSet S) (hT_meas : MeasurableSet T)
    (hμS_ne : μ S ≠ 0) (hμT_ne : μ T ≠ 0) [IsProbabilityMeasure μ] :
    (μ T)⁻¹ * μ[S|T] * μ S = μ[T|S]"""

BAYES_L2_PROOF = """by
  rw [bayes_theorem hS_meas hT_meas hμS_ne hμT_ne]
  ring"""

BAYES_L2_DECL = BAYES_L2_STATEMENT + " := " + BAYES_L2_PROOF

BAYES_L3_STATEMENT = """theorem law_of_total_probability {A : Set Ω} (hA : MeasurableSet A)
    (hAc : MeasurableSet (Aᶜ)) [IsProbabilityMeasure μ] {B : Set Ω} (hB : MeasurableSet B) :
    μ B = μ[B|A] * μ A + μ[B|Aᶜ] * μ (Aᶜ)"""

BAYES_L3_PROOF = """by
  have h_union : A ∪ Aᶜ = Set.univ := Set.union_compl_self A
  have h_disjoint : Disjoint A (Aᶜ) := Set.disjoint_compl_right A
  calc
    μ B = μ (B ∩ Set.univ) := by simp
    _ = μ (B ∩ (A ∪ Aᶜ)) := by rw [h_union]
    _ = μ ((B ∩ A) ∪ (B ∩ Aᶜ)) := by rw [Set.inter_union_distrib_left]
    _ = μ (B ∩ A) + μ (B ∩ Aᶜ) := by
      refine measure_union ?_ (hB.inter hAc)
      exact h_disjoint.inter_left B
    _ = μ[B|A] * μ A + μ[B|Aᶜ] * μ (Aᶜ) := by
      rw [cond_apply hA, cond_apply hAc, mul_comm, mul_comm _ (μ (Aᶜ))]"""

BAYES_L3_DECL = BAYES_L3_STATEMENT + " := " + BAYES_L3_PROOF


# ── group 5: borel_cantelli ─────────────────────────────────────────────────

BC_L1_STATEMENT = """theorem borel_cantelli {A : ℕ → Set Ω} (hA : ∀ n, MeasurableSet (A n))
    (h_sum : ∑' n, μ (A n) ≠ ∞) : μ (limsup A atTop) = 0"""

BC_L1_PROOF = """by
  have h_sum_lt : ∑' n, μ (A n) < ∞ := lt_of_le_of_ne ENNReal.le_top h_sum
  refine measure_limsup_eq_zero h_sum_lt ?_
  exact hA"""

BC_L1_DECL = BC_L1_STATEMENT + " := " + BC_L1_PROOF

BC_L2_STATEMENT = """theorem first_BC_renamed {E : ℕ → Set Ω} (h_meas : ∀ k, MeasurableSet (E k))
    (h_summable : ∑' k, μ (E k) < ∞) : 0 = μ (limsup E atTop)"""

BC_L2_PROOF = """by
  rw [eq_comm]
  apply borel_cantelli h_meas
  exact ne_of_lt h_summable"""

BC_L2_DECL = BC_L2_STATEMENT + " := " + BC_L2_PROOF

BC_L3_STATEMENT = """theorem borel_cantelli_ae_finite {A : ℕ → Set Ω} (hA : ∀ n, MeasurableSet (A n))
    (h_sum : ∑' n, μ (A n) ≠ ∞) : ∀ᵐ ω ∂μ, ∀ᶠ n in atTop, ω ∉ A n"""

BC_L3_PROOF = """by
  have h_zero := borel_cantelli hA h_sum
  have h_mem : {ω | ¬ ∀ᶠ n in atTop, ω ∉ A n} = limsup A atTop := by
    ext ω; simp [limsup_eq_infi_supr, Filter.eventually_atTop]
  rw [ae_iff]
  calc
    μ {ω | ¬ ∀ᶠ n in atTop, ω ∉ A n} = μ (limsup A atTop) := by rw [h_mem]
    _ = 0 := h_zero"""

BC_L3_DECL = BC_L3_STATEMENT + " := " + BC_L3_PROOF


# ── group 6: jensen_inequality ──────────────────────────────────────────────

JENSEN_L1_STATEMENT = """theorem jensen {X : Ω → ℝ} (hX : Integrable X μ) (hφ : ConvexOn ℝ Set.univ φ)
    (hφ_meas : Measurable φ) [IsProbabilityMeasure μ] :
    φ (μ[X]) ≤ μ[φ ∘ X]"""

JENSEN_L1_PROOF = """by
  have h_int_X : Integrable X μ := hX
  have h_int_φX : Integrable (φ ∘ X) μ := by
    refine hφ_meas.comp_aemeasurable hX.aemeasurable |>.integrable ?_
    exact hX
  refine convexOn_univ_integral_le ?_ hφ h_int_X h_int_φX
  · intro x; exact trivial"""

JENSEN_L1_DECL = JENSEN_L1_STATEMENT + " := " + JENSEN_L1_PROOF

JENSEN_L2_STATEMENT = """theorem expectation_convex_function {Y : Ω → ℝ}
    (h_int_Y : Integrable Y μ) (h_conv : ConvexOn ℝ Set.univ ψ) (h_meas_ψ : Measurable ψ)
    [IsProbabilityMeasure μ] : μ[ψ ∘ Y] ≥ ψ (μ[Y])"""

JENSEN_L2_PROOF = """by
  rw [ge_iff_le]
  apply jensen h_int_Y h_conv h_meas_ψ"""

JENSEN_L2_DECL = JENSEN_L2_STATEMENT + " := " + JENSEN_L2_PROOF

JENSEN_L3_STATEMENT = """theorem cond_jensen {X : Ω → ℝ} (hX : Integrable X μ) (hφ : ConvexOn ℝ Set.univ φ)
    (hφ_meas : Measurable φ) [IsProbabilityMeasure μ] {m : MeasurableSpace Ω} (hm : m ≤ m0) :
    φ (μ[X|m]) ≤ᵐ[μ] μ[φ ∘ X|m]"""

JENSEN_L3_PROOF = """by
  refine ae_of_ae_trim hm ?_
  refine cond_exp_convex_le hX hφ hφ_meas ?_
  exact hX.integrable_on"""

JENSEN_L3_DECL = JENSEN_L3_STATEMENT + " := " + JENSEN_L3_PROOF


# ── group 7: independence_product ───────────────────────────────────────────

INDEP_L1_STATEMENT = """lemma indepFun_iff_product {X : Ω → α} {Y : Ω → β}
    (hX : Measurable X) (hY : Measurable Y) [IsProbabilityMeasure μ] :
    IndepFun X Y μ ↔ ∀ (s : Set α) (t : Set β), MeasurableSet s → MeasurableSet t →
      μ (X ⁻¹' s ∩ Y ⁻¹' t) = μ (X ⁻¹' s) * μ (Y ⁻¹' t)"""

INDEP_L1_PROOF = """by
  rw [IndepFun_iff]
  refine ⟨fun h s t hs ht => ?_, fun h => ?_⟩
  · exact h (MeasurableSet.inter (hX hs) (hY ht))
  · intro u hu
    refine indepSets_iff.mp ?_ _ _ ?_ ?_ hu
    · exact hX; · exact hY
    · exact h"""

INDEP_L1_DECL = INDEP_L1_STATEMENT + " := " + INDEP_L1_PROOF

INDEP_L2_STATEMENT = """lemma independence_product_rule {U : Ω → α} {V : Ω → β}
    (hU_meas : Measurable U) (hV_meas : Measurable V) [IsProbabilityMeasure μ] :
    IndepFun U V μ ↔ μ (U ⁻¹' s ∩ V ⁻¹' t) = μ (U ⁻¹' s) * μ (V ⁻¹' t) := by
  refine indepFun_iff_product hU_meas hV_meas"""

INDEP_L2_PROOF = """by
  refine indepFun_iff_product hU_meas hV_meas"""

INDEP_L2_DECL = INDEP_L2_STATEMENT + " := " + INDEP_L2_PROOF

INDEP_L3_STATEMENT = """lemma indep_sigma_algebras_product {A B : Set (Set Ω)}
    (hA : MeasurableSpace Ω) (hB : MeasurableSpace Ω) [IsProbabilityMeasure μ] :
    Indep A B μ ↔ ∀ (a ∈ A) (b ∈ B), μ (a ∩ b) = μ a * μ b"""

INDEP_L3_PROOF = """by
  rw [Indep_iff]
  constructor
  · intro h a ha b hb
    exact h a b ha hb
  · intro h a b ha hb
    exact h a ha b hb"""

INDEP_L3_DECL = INDEP_L3_STATEMENT + " := " + INDEP_L3_PROOF


# ── group 8: conditional_expectation ────────────────────────────────────────

CONDEXP_L1_STATEMENT = """theorem law_of_total_expectation {X : Ω → ℝ} (hX : Integrable X μ) {m : MeasurableSpace Ω}
    (hm : m ≤ m0) [IsProbabilityMeasure μ] : μ[μ[X|m]] = μ[X]"""

CONDEXP_L1_PROOF = """by
  rw [integral_cond_exp hm]
  exact hX"""

CONDEXP_L1_DECL = CONDEXP_L1_STATEMENT + " := " + CONDEXP_L1_PROOF

CONDEXP_L2_STATEMENT = """theorem total_expectation_eq_iterated {Y : Ω → ℝ} (hY : Integrable Y μ)
    {𝒢 : MeasurableSpace Ω} (h𝒢 : 𝒢 ≤ m0) [IsProbabilityMeasure μ] : μ[Y] = μ[μ[Y|𝒢]]"""

CONDEXP_L2_PROOF = """by
  rw [eq_comm]
  apply law_of_total_expectation hY h𝒢"""

CONDEXP_L2_DECL = CONDEXP_L2_STATEMENT + " := " + CONDEXP_L2_PROOF

CONDEXP_L3_STATEMENT = """theorem tower_property {X : Ω → ℝ} (hX : Integrable X μ) {ℋ 𝒢 : MeasurableSpace Ω}
    (hℋ : ℋ ≤ m0) (h𝒢 : 𝒢 ≤ m0) (hℋ𝒢 : ℋ ≤ 𝒢) [IsProbabilityMeasure μ] :
    μ[μ[X|𝒢]|ℋ] =ᵐ[μ] μ[X|ℋ]"""

CONDEXP_L3_PROOF = """by
  refine ae_eq_of_subalgebra_of_subalgebra ?_ ?_ hℋ h𝒢 hℋ𝒢 hX
  exact hX.integrable_on"""

CONDEXP_L3_DECL = CONDEXP_L3_STATEMENT + " := " + CONDEXP_L3_PROOF


# ── group 9: martingale_basic ───────────────────────────────────────────────

MART_L1_STATEMENT = """lemma martingale_expectation_const {X : ℕ → Ω → ℝ} (h_mart : Martingale X ℱ μ)
    (n m : ℕ) (h_le : n ≤ m) [IsProbabilityMeasure μ] : μ[X n] = μ[X m]"""

MART_L1_PROOF = """by
  have h := martingale_expectation_eq h_mart n m h_le
  exact h"""

MART_L1_DECL = MART_L1_STATEMENT + " := " + MART_L1_PROOF

MART_L2_STATEMENT = """lemma mg_expectation_invariant {Y : ℕ → Ω → ℝ} (h_mg : Martingale Y 𝒢 μ)
    {i j : ℕ} (h_ij : i ≤ j) [IsProbabilityMeasure μ] : μ[Y j] = μ[Y i]"""

MART_L2_PROOF = """by
  rw [eq_comm]
  exact martingale_expectation_const h_mg i j h_ij"""

MART_L2_DECL = MART_L2_STATEMENT + " := " + MART_L2_PROOF

MART_L3_STATEMENT = """theorem doob_decomposition {X : ℕ → Ω → ℝ} (h_adapted : Adapted X ℱ)
    (h_int : ∀ n, Integrable (X n) μ) [IsProbabilityMeasure μ] :
    ∃ (M : ℕ → Ω → ℝ) (A : ℕ → Ω → ℝ), Martingale M ℱ μ ∧ A 0 =ᵐ[μ] 0 ∧
      (∀ n, A n ≤ᵐ[μ] A (n + 1)) ∧ ∀ n, X n =ᵐ[μ] M n + A n"""

MART_L3_PROOF = """by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro n; exact X n - ∑ k in Finset.range n, (μ[X (k+1)|ℱ k] - X k)
  · intro n; exact ∑ k in Finset.range n, (μ[X (k+1)|ℱ k] - X k)
  · -- M is a martingale
    refine martingale_sub h_adapted ?_
    exact predictable_sum h_adapted h_int
  · -- A starts at 0
    simp
  · -- A is increasing (predictable)
    intro n
    refine h_adapted.predictable ?_
    exact h_int
  · -- X = M + A
    intro n; simp [sub_add_cancel]"""

MART_L3_DECL = MART_L3_STATEMENT + " := " + MART_L3_PROOF


# ── group 10: characteristic_function ──────────────────────────────────────

CF_L1_STATEMENT = """theorem characteristicFunction_uniqueness {X Y : Ω → ℝ}
    (hX : Measurable X) (hY : Measurable Y) [IsProbabilityMeasure μ] [IsProbabilityMeasure ν]
    (h_eq : ∀ t : ℝ, cf X μ t = cf Y ν t) : IdentDistrib X Y μ ν"""

CF_L1_PROOF = """by
  refine identDistrib_of_cf_eq hX hY ?_
  intro t
  exact h_eq t"""

CF_L1_DECL = CF_L1_STATEMENT + " := " + CF_L1_PROOF

CF_L2_STATEMENT = """theorem cf_determines_distribution {U V : Ω → ℝ}
    (hU : Measurable U) (hV : Measurable V) [IsProbabilityMeasure P] [IsProbabilityMeasure Q]
    (h_cf : ∀ s : ℝ, cf U P s = cf V Q s) : IdentDistrib U V P Q"""

CF_L2_PROOF = """by
  apply characteristicFunction_uniqueness hU hV
  exact h_cf"""

CF_L2_DECL = CF_L2_STATEMENT + " := " + CF_L2_PROOF

CF_L3_STATEMENT = """theorem levy_continuity_simple {X : ℕ → Ω → ℝ} (hX : ∀ n, Measurable (X n))
    (h_cf_cv : ∀ t : ℝ, Tendsto (fun n => cf (X n) μ t) atTop (𝓝 (cf X μ t)))
    [IsProbabilityMeasure μ] : Tendsto (fun n => μ.map (X n)) atTop (𝓝 (μ.map X))"""

CF_L3_PROOF = """by
  refine Filter.Tendsto.metric ?_
  intro ε hε
  have h := levy_continuity hX h_cf_cv
  rcases h (Metric.ball (μ.map X) ε) (Metric.ball_mem_nhds _ hε) with ⟨N, hN⟩
  refine ⟨N, fun n hn => ?_⟩
  exact hN n hn"""

CF_L3_DECL = CF_L3_STATEMENT + " := " + CF_L3_PROOF


# ── assemble entries ────────────────────────────────────────────────────────

GROUPS = [
    # (family, l1_statement, l1_proof, l2_statement, l2_proof, l3_statement, l3_proof, l1_binders, l2_transform, l3_strategy)
    {
        "family": "monotone_convergence",
        "l1_statement": MCT_L1_STATEMENT,
        "l1_proof": MCT_L1_PROOF,
        "l2_statement": MCT_L2_STATEMENT,
        "l2_proof": MCT_L2_PROOF,
        "l3_statement": MCT_L3_STATEMENT,
        "l3_proof": MCT_L3_PROOF,
        "l1_binders": ["f", "hf", "h_mono"],
        "l2_transform": "alpha_rename(f↦g, hf↦h_meas, h_mono↦h_nondec), equality_flip, binder_permute",
        "l3_strategy": "one-sided inequality of MCT via iSup_le and lintegral_mono",
    },
    {
        "family": "inequalities",
        "l1_statement": MARKOV_L1_STATEMENT,
        "l1_proof": MARKOV_L1_PROOF,
        "l2_statement": MARKOV_L2_STATEMENT,
        "l2_proof": MARKOV_L2_PROOF,
        "l3_statement": MARKOV_L3_STATEMENT,
        "l3_proof": MARKOV_L3_PROOF,
        "l1_binders": ["X", "hX", "h_nonneg", "a", "ha"],
        "l2_transform": "alpha_rename(X↦Y, a↦c), inequality_rearrangement (multiply both sides by ENNReal.ofReal c)",
        "l3_strategy": "Chebyshev via Markov with squared deviation; uses variance definition",
    },
    {
        "family": "law_of_large_numbers",
        "l1_statement": WLLN_L1_STATEMENT,
        "l1_proof": WLLN_L1_PROOF,
        "l2_statement": WLLN_L2_STATEMENT,
        "l2_proof": WLLN_L2_PROOF,
        "l3_statement": WLLN_L3_STATEMENT,
        "l3_proof": WLLN_L3_PROOF,
        "l1_binders": ["X", "h_iid", "h_sq_int", "n", "hn"],
        "l2_transform": "alpha_rename(X↦Y, n↦m), equality_flip (≤ becomes ≥), binder_reorder",
        "l3_strategy": "convergence in probability to 0 via WLLN bound and squeeze theorem",
    },
    {
        "family": "bayes_theorem",
        "l1_statement": BAYES_L1_STATEMENT,
        "l1_proof": BAYES_L1_PROOF,
        "l2_statement": BAYES_L2_STATEMENT,
        "l2_proof": BAYES_L2_PROOF,
        "l3_statement": BAYES_L3_STATEMENT,
        "l3_proof": BAYES_L3_PROOF,
        "l1_binders": ["A", "B", "hA", "hB", "hμA", "hμB"],
        "l2_transform": "alpha_rename(A↦S, B↦T), algebraic_rearrangement (isolate μ[T|S] on RHS)",
        "l3_strategy": "law of total probability via measure additivity on partition A, Aᶜ",
    },
    {
        "family": "borel_cantelli",
        "l1_statement": BC_L1_STATEMENT,
        "l1_proof": BC_L1_PROOF,
        "l2_statement": BC_L2_STATEMENT,
        "l2_proof": BC_L2_PROOF,
        "l3_statement": BC_L3_STATEMENT,
        "l3_proof": BC_L3_PROOF,
        "l1_binders": ["A", "hA", "h_sum"],
        "l2_transform": "alpha_rename(A↦E), equality_flip, binder_reorder",
        "l3_strategy": "BC → almost surely only finitely many events occur",
    },
    {
        "family": "jensen_inequality",
        "l1_statement": JENSEN_L1_STATEMENT,
        "l1_proof": JENSEN_L1_PROOF,
        "l2_statement": JENSEN_L2_STATEMENT,
        "l2_proof": JENSEN_L2_PROOF,
        "l3_statement": JENSEN_L3_STATEMENT,
        "l3_proof": JENSEN_L3_PROOF,
        "l1_binders": ["X", "hX", "hφ", "hφ_meas"],
        "l2_transform": "alpha_rename(X↦Y, φ↦ψ), inequality_flip (≤ becomes ≥), binder_reorder",
        "l3_strategy": "conditional Jensen via ae_trim and conditional expectation properties",
    },
    {
        "family": "independence",
        "l1_statement": INDEP_L1_STATEMENT,
        "l1_proof": INDEP_L1_PROOF,
        "l2_statement": INDEP_L2_STATEMENT,
        "l2_proof": INDEP_L2_PROOF,
        "l3_statement": INDEP_L3_STATEMENT,
        "l3_proof": INDEP_L3_PROOF,
        "l1_binders": ["X", "Y", "hX", "hY"],
        "l2_transform": "alpha_rename(X↦U, Y↦V), binder_reorder, statement_compression",
        "l3_strategy": "generalization from random variables to sigma-algebras",
    },
    {
        "family": "conditional_expectation",
        "l1_statement": CONDEXP_L1_STATEMENT,
        "l1_proof": CONDEXP_L1_PROOF,
        "l2_statement": CONDEXP_L2_STATEMENT,
        "l2_proof": CONDEXP_L2_PROOF,
        "l3_statement": CONDEXP_L3_STATEMENT,
        "l3_proof": CONDEXP_L3_PROOF,
        "l1_binders": ["X", "hX", "m", "hm"],
        "l2_transform": "alpha_rename(X↦Y, m↦𝒢), equality_flip, binder_reorder",
        "l3_strategy": "tower property (iterated conditioning) via subalgebra argument",
    },
    {
        "family": "martingales",
        "l1_statement": MART_L1_STATEMENT,
        "l1_proof": MART_L1_PROOF,
        "l2_statement": MART_L2_STATEMENT,
        "l2_proof": MART_L2_PROOF,
        "l3_statement": MART_L3_STATEMENT,
        "l3_proof": MART_L3_PROOF,
        "l1_binders": ["X", "h_mart", "n", "m", "h_le"],
        "l2_transform": "alpha_rename(X↦Y, ℱ↦𝒢, n↦i, m↦j), equality_flip",
        "l3_strategy": "Doob decomposition: every adapted integrable process = martingale + predictable",
    },
    {
        "family": "characteristic_functions",
        "l1_statement": CF_L1_STATEMENT,
        "l1_proof": CF_L1_PROOF,
        "l2_statement": CF_L2_STATEMENT,
        "l2_proof": CF_L2_PROOF,
        "l3_statement": CF_L3_STATEMENT,
        "l3_proof": CF_L3_PROOF,
        "l1_binders": ["X", "Y", "hX", "hY", "h_eq"],
        "l2_transform": "alpha_rename(X↦U, Y↦V, μ↦P, ν↦Q, t↦s), binder_reorder",
        "l3_strategy": "Levy continuity theorem (simple case): pointwise cf convergence → weak convergence",
    },
]


def lemma_name(statement: str) -> str:
    """Extract the lemma/theorem name from a Lean statement."""
    for prefix in ("theorem ", "lemma "):
        if statement.startswith(prefix):
            rest = statement[len(prefix):].strip()
            name_end = 0
            for i, ch in enumerate(rest):
                if ch in (" ", "(", "{", ":", "\n", "["):
                    name_end = i
                    break
            else:
                name_end = len(rest)
            return rest[:name_end]
    return "unknown"


def make_entry(
    level: str,
    idx: int,
    family: str,
    statement: str,
    proof: str,
    binders: list[str],
    parent_id: str | None,
    transformation: str | None,
    proof_strategy: str,
    split: str,
) -> dict:
    decl_name = lemma_name(statement)
    decl = statement + " := " + proof
    return {
        "id": f"prob_manual_{level}_{idx:03d}",
        "level": level,
        "domain": DOMAIN,
        "theorem_family": family,
        "lean_declaration": decl,
        "lean_statement": statement,
        "lean_proof": proof,
        "lean_version": LEAN_VERSION,
        "mathlib_version": MATHLIB_VERSION,
        "source_dataset": SOURCE_DATASET,
        "source_file": f"manual/{family}.lean",
        "source_line_start": 1,
        "source_line_end": len(decl.split("\n")),
        "source_mathlib_decl": f"ProofMem.Manual.{decl_name}",
        "binder_names": binders,
        "parent_theorem": parent_id,
        "transformation": transformation or "manual_construction",
        "proof_strategy": proof_strategy,
        "training_split": split,
        "verification_method": "lake env lean manual .lean file after importing Mathlib",
        "verified": False,
        "author": AUTHOR,
        "difficulty": "advanced_undergraduate_to_graduate",
    }


def main() -> None:
    entries: list[dict] = []

    for gidx, group in enumerate(GROUPS, start=1):
        family = group["family"]

        l1_id = f"prob_manual_L1_{gidx:03d}"
        l2_id = f"prob_manual_L2_{gidx:03d}"
        l3_id = f"prob_manual_L3_{gidx:03d}"

        # L1: original theorem — split across train/dev/test (8/1/1)
        if gidx <= 8:
            l1_split = "train_manual"
        elif gidx == 9:
            l1_split = "dev_manual"
        else:
            l1_split = "test_manual"

        entries.append(make_entry(
            "L1", gidx, family,
            group["l1_statement"], group["l1_proof"],
            group["l1_binders"],
            None, None,
            f"original manual proof: {group['l3_strategy'][:80]}",
            l1_split,
        ))

        # L2: perturbation of L1
        entries.append(make_entry(
            "L2", gidx, family,
            group["l2_statement"], group["l2_proof"],
            group["l1_binders"],  # L2 keeps same semantic binders
            l1_id,
            group["l2_transform"],
            f"perturbation of {l1_id}",
            l1_split,  # same split as parent L1
        ))

        # L3: sibling theorem
        entries.append(make_entry(
            "L3", gidx, family,
            group["l3_statement"], group["l3_proof"],
            group["l1_binders"],  # approximate
            l1_id,
            "sibling_selection",
            group["l3_strategy"],
            l1_split,
        ))

    OUT.parent.mkdir(parents=True, exist_ok=True)
    with OUT.open("w", encoding="utf-8") as f:
        for entry in entries:
            f.write(json.dumps(entry, ensure_ascii=False) + "\n")

    # Print summary
    from collections import Counter
    level_counts = Counter(e["level"] for e in entries)
    family_counts = Counter(e["theorem_family"] for e in entries)
    print(f"Wrote {len(entries)} entries to {OUT}")
    print(f"Levels: {dict(level_counts)}")
    print(f"Families: {list(family_counts.keys())}")
    print(f"All verified=False — run verification before merging into main dataset.")


if __name__ == "__main__":
    main()

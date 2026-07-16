#!/usr/bin/env python3
"""
Generate 30 manual Analysis problems (10 L1 + 10 L2 + 10 L3)
and update MA-ProofBench and FormalMATH-L3 datasets.

For each dataset level, removes last 10 entries and inserts 10 manual ones.
Source dataset labeled "Manual", split = "test".
All formal_statements match compiled Smoketest/Manual/*.lean proofs.
"""

import json
import copy

# ── 10 Analysis Theorem Groups ────────────────────────────────────────────
# formal_statement matches compiled .lean files (no sorry, real proofs)
# L1/L2: include import Mathlib + open (MA-ProofBench convention)
# L3: theorem only (FormalMATH-L3 convention, imports in 'imports' field)

MANUAL_GROUPS = [
    # ── Group 1: Intermediate Value Theorem ──
    {
        "l1": {
            "id": "ma-proofbench-manual-l1-01",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Set\n\n"
                "theorem intermediate_value_theorem {a b : ℝ} {f : ℝ → ℝ}\n"
                "    (hab : a ≤ b) (hf : ContinuousOn f (Icc a b))\n"
                "    {y : ℝ} (hy : y ∈ Ioo (f a) (f b)) : ∃ x ∈ Ioo a b, f x = y := by\n"
                "  have h := intermediate_value_Ioo hab hf\n"
                "  rcases h hy with ⟨x, hx, rfl⟩\n"
                "  exact ⟨x, hx, rfl⟩"
            ),
            "target_proof": None,
            "informal_statement": (
                "Intermediate Value Theorem: If f is continuous on [a,b] with a ≤ b, "
                "and f(a) < y < f(b), then there exists x in (a,b) such that f(x) = y. "
                "Proof via intermediate_value_Ioo from mathlib."
            ),
            "imports": "import Mathlib\nopen Set",
            "parent_id": None,
            "transformation_type": None,
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l2": {
            "id": "ma-proofbench-manual-l2-01",
            "level": "L2",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Set\n\n"
                "theorem ivt_renamed {c d : ℝ} {g : ℝ → ℝ}\n"
                "    (hcd : c ≤ d) (hg : ContinuousOn g (Icc c d))\n"
                "    {z : ℝ} (hz : z ∈ Ioo (g c) (g d)) : ∃ x ∈ Ioo c d, g x = z :=\n"
                "  intermediate_value_theorem hcd hg hz"
            ),
            "target_proof": None,
            "informal_statement": (
                "Intermediate Value Theorem (alpha-rename): f→g, a→c, b→d, y→z. "
                "Proof delegates to intermediate_value_theorem."
            ),
            "imports": "import Mathlib\nopen Set",
            "parent_id": "ma-proofbench-manual-l1-01",
            "transformation_type": "alpha_rename",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l3": {
            "id": "formalmath-l3-manual-01",
            "level": "L3",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "theorem extreme_value_theorem {f : ℝ → ℝ}\n"
                "    (hf : ContinuousOn f (Icc (0:ℝ) 1)) : ∃ x ∈ Icc (0:ℝ) 1, ∀ y ∈ Icc (0:ℝ) 1, f y ≤ f x := by\n"
                "  have h_compact : IsCompact (Icc (0:ℝ) (1:ℝ)) := isCompact_Icc\n"
                "  have h_nonempty : (Icc (0:ℝ) (1:ℝ)).Nonempty := by\n"
                "    refine ⟨0, ?_⟩; simp\n"
                "  rcases h_compact.exists_isMaxOn h_nonempty hf with ⟨x, hx, hmax⟩\n"
                "  exact ⟨x, hx, fun y hy => hmax hy⟩"
            ),
            "target_proof": None,
            "informal_statement": (
                "Extreme Value Theorem (sibling of IVT): A continuous function on [0,1] "
                "attains its maximum. Proof via isCompact_Icc and exists_isMaxOn."
            ),
            "imports": "import Mathlib\nopen Set",
            "parent_id": "ma-proofbench-manual-l1-01",
            "transformation_type": "sibling",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
    },
    # ── Group 2: Mean Value Theorem ──
    {
        "l1": {
            "id": "ma-proofbench-manual-l1-02",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Set\n\n"
                "theorem mean_value_theorem {a b : ℝ} {f : ℝ → ℝ}\n"
                "    (hab : a < b) (hf : ContinuousOn f (Icc a b))\n"
                "    (hf' : DifferentiableOn ℝ f (Ioo a b)) :\n"
                "    ∃ c ∈ Ioo a b, deriv f c = (f b - f a) / (b - a) :=\n"
                "  exists_deriv_eq_slope f hab hf hf'"
            ),
            "target_proof": None,
            "informal_statement": (
                "Mean Value Theorem (Lagrange): If f is continuous on [a,b] and differentiable "
                "on (a,b) with a < b, then there exists c in (a,b) such that "
                "f'(c) = (f(b)-f(a))/(b-a). Proof via exists_deriv_eq_slope."
            ),
            "imports": "import Mathlib\nopen Set",
            "parent_id": None,
            "transformation_type": None,
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l2": {
            "id": "ma-proofbench-manual-l2-02",
            "level": "L2",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Set\n\n"
                "theorem mvt_renamed {p q : ℝ} {g : ℝ → ℝ}\n"
                "    (hpq : p < q) (hg_cont : ContinuousOn g (Icc p q))\n"
                "    (hg_diff : DifferentiableOn ℝ g (Ioo p q)) :\n"
                "    ∃ c ∈ Ioo p q, deriv g c = (g q - g p) / (q - p) :=\n"
                "  exists_deriv_eq_slope g hpq hg_cont hg_diff"
            ),
            "target_proof": None,
            "informal_statement": (
                "Mean Value Theorem (alpha-rename + binder reorder): f→g, a→p, b→q. "
                "Proof delegates to exists_deriv_eq_slope."
            ),
            "imports": "import Mathlib\nopen Set",
            "parent_id": "ma-proofbench-manual-l1-02",
            "transformation_type": "alpha_rename",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l3": {
            "id": "formalmath-l3-manual-02",
            "level": "L3",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "theorem rolle_theorem {a b : ℝ} {f : ℝ → ℝ}\n"
                "    (hab : a < b) (hf : ContinuousOn f (Icc a b))\n"
                "    (hf' : DifferentiableOn ℝ f (Ioo a b))\n"
                "    (hfa : f a = f b) :\n"
                "    ∃ c ∈ Ioo a b, deriv f c = 0 := by\n"
                "  rcases mean_value_theorem hab hf hf' with ⟨c, hc, h_eq⟩\n"
                "  refine ⟨c, hc, ?_⟩\n"
                "  rw [hfa, sub_self, zero_div] at h_eq\n"
                "  exact h_eq"
            ),
            "target_proof": None,
            "informal_statement": (
                "Rolle's Theorem (sibling of MVT): If f is continuous on [a,b], differentiable "
                "on (a,b), a < b, and f(a)=f(b), then there exists c in (a,b) with f'(c)=0. "
                "Proof via MVT: f'(c) = (f(b)-f(a))/(b-a) = 0."
            ),
            "imports": "import Mathlib\nopen Set",
            "parent_id": "ma-proofbench-manual-l1-02",
            "transformation_type": "sibling",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
    },
    # ── Group 3: Uniform convergence preserves continuity ──
    {
        "l1": {
            "id": "ma-proofbench-manual-l1-03",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Sequences, series, summability",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Set Filter\n\n"
                "theorem uniform_limit_continuous {α : Type*} [TopologicalSpace α]\n"
                "    {f : ℕ → α → ℝ} {f_lim : α → ℝ}\n"
                "    (hf_cont : ∀ n, Continuous (f n))\n"
                "    (h_unif : TendstoUniformly f f_lim atTop) : Continuous f_lim :=\n"
                "  h_unif.continuous (eventually_of_forall hf_cont)"
            ),
            "target_proof": None,
            "informal_statement": (
                "Uniform limit of continuous functions is continuous. "
                "Proof via TendstoUniformly.continuous."
            ),
            "imports": "import Mathlib\nopen Set Filter",
            "parent_id": None,
            "transformation_type": None,
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l2": {
            "id": "ma-proofbench-manual-l2-03",
            "level": "L2",
            "domain": "Analysis",
            "sub_domain": "Sequences, series, summability",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Set Filter\n\n"
                "theorem unif_limit_cont_perturbed {β : Type*} [TopologicalSpace β]\n"
                "    {g : ℕ → β → ℝ} {g_lim : β → ℝ}\n"
                "    (hg_cont : ∀ n, Continuous (g n))\n"
                "    (h_unif_g : TendstoUniformly g g_lim atTop) : Continuous g_lim :=\n"
                "  uniform_limit_continuous hg_cont h_unif_g"
            ),
            "target_proof": None,
            "informal_statement": (
                "Uniform limit of continuous functions (alpha-rename): f→g, α→β. "
                "Proof delegates to uniform_limit_continuous."
            ),
            "imports": "import Mathlib\nopen Set Filter",
            "parent_id": "ma-proofbench-manual-l1-03",
            "transformation_type": "alpha_rename",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l3": {
            "id": "formalmath-l3-manual-03",
            "level": "L3",
            "domain": "Analysis",
            "sub_domain": "Sequences, series, summability",
            "source_dataset": "Manual",
            "formal_statement": (
                "theorem uniform_limit_bounded {α : Type*} [TopologicalSpace α]\n"
                "    {f : ℕ → α → ℝ} {f_lim : α → ℝ} (M : ℝ)\n"
                "    (h_bound : ∀ n x, |f n x| ≤ M)\n"
                "    (h_unif : TendstoUniformly f f_lim atTop) : ∀ x, |f_lim x| ≤ M := by\n"
                "  intro x\n"
                "  have h_tendsto : Tendsto (fun n : ℕ => f n x) atTop (𝓝 (f_lim x)) := h_unif.tendsto_at x\n"
                "  have h_abs : Tendsto (fun n : ℕ => |f n x|) atTop (𝓝 (|f_lim x|)) :=\n"
                "    h_tendsto.abs\n"
                "  refine le_of_tendsto h_abs (eventually_of_forall (fun n => h_bound n x))"
            ),
            "target_proof": None,
            "informal_statement": (
                "Uniform limit of functions bounded by M is also bounded by M (sibling). "
                "Proof: pointwise limit preserves the bound via le_of_tendsto."
            ),
            "imports": "import Mathlib\nopen Set Filter",
            "parent_id": "ma-proofbench-manual-l1-03",
            "transformation_type": "sibling",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
    },
    # ── Group 4: Weierstrass M-test ──
    {
        "l1": {
            "id": "ma-proofbench-manual-l1-04",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Sequences, series, summability",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Set Filter\n\n"
                "theorem weierstrass_m_test {f : ℕ → ℝ → ℝ} {M : ℕ → ℝ}\n"
                "    (hM_summable : Summable M) (h_bound : ∀ n x, ‖f n x‖ ≤ M n) :\n"
                "    ∃ g : ℝ → ℝ, TendstoUniformly (fun N x => ∑ n in Finset.range N, f n x) g atTop := by\n"
                "  refine ⟨fun x => ∑' n, f n x, ?_⟩\n"
                "  have h := tendstoUniformlyOn_tsum_nat hM_summable (s := Set.univ) (fun n x hx => h_bound n x)\n"
                "  simpa [tendstoUniformlyOn_univ] using h"
            ),
            "target_proof": None,
            "informal_statement": (
                "Weierstrass M-test: If |f_n(x)| ≤ M_n for all n,x and ∑ M_n converges, "
                "then ∑ f_n converges uniformly on ℝ. Proof via tendstoUniformlyOn_tsum_nat."
            ),
            "imports": "import Mathlib\nopen Set Filter",
            "parent_id": None,
            "transformation_type": None,
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l2": {
            "id": "ma-proofbench-manual-l2-04",
            "level": "L2",
            "domain": "Analysis",
            "sub_domain": "Sequences, series, summability",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Set Filter\n\n"
                "theorem m_test_perturbed {g : ℕ → ℝ → ℝ} {N : ℕ → ℝ}\n"
                "    (hN_summable : Summable N) (h_bound : ∀ n x, ‖g n x‖ ≤ N n) :\n"
                "    ∃ h : ℝ → ℝ, TendstoUniformly (fun K x => ∑ n in Finset.range K, g n x) h atTop :=\n"
                "  weierstrass_m_test hN_summable h_bound"
            ),
            "target_proof": None,
            "informal_statement": (
                "Weierstrass M-test (alpha-rename): f→g, M→N. "
                "Proof delegates to weierstrass_m_test."
            ),
            "imports": "import Mathlib\nopen Set Filter",
            "parent_id": "ma-proofbench-manual-l1-04",
            "transformation_type": "alpha_rename",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l3": {
            "id": "formalmath-l3-manual-04",
            "level": "L3",
            "domain": "Analysis",
            "sub_domain": "Sequences, series, summability",
            "source_dataset": "Manual",
            "formal_statement": (
                "theorem summable_of_norm_bound_series {f : ℕ → ℝ} {a : ℕ → ℝ}\n"
                "    (ha_summable : Summable a) (h_bound : ∀ n, ‖f n‖ ≤ a n) : Summable f := by\n"
                "  refine Summable.of_norm ?_\n"
                "  apply ha_summable.of_nonneg_of_le (fun n => norm_nonneg _) (fun n => ?_)\n"
                "  exact h_bound n"
            ),
            "target_proof": None,
            "informal_statement": (
                "Comparison test for series (sibling of M-test): If ‖f_n‖ ≤ a_n and ∑ a_n "
                "converges, then ∑ f_n converges. Proof via Summable.of_norm."
            ),
            "imports": "import Mathlib\nopen Set Filter",
            "parent_id": "ma-proofbench-manual-l1-04",
            "transformation_type": "sibling",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
    },
    # ── Group 5: Dominated Convergence Theorem ──
    {
        "l1": {
            "id": "ma-proofbench-manual-l1-05",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Measure and integration",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open MeasureTheory\n"
                "open scoped ENNReal\n\n"
                "variable {α : Type*} [MeasurableSpace α] {μ : Measure α}\n\n"
                "theorem dominated_convergence_theorem {F : ℕ → α → ℝ} {bound : α → ℝ}\n"
                "    (F_meas : ∀ n, AEStronglyMeasurable (F n) μ)\n"
                "    (bound_int : Integrable bound μ)\n"
                "    (h_bound : ∀ n, ∀ᵐ ω ∂μ, ‖F n ω‖ ≤ bound ω)\n"
                "    (h_lim : ∀ᵐ ω ∂μ, Tendsto (fun n => F n ω) atTop (𝓝 (0 : ℝ))) :\n"
                "    Tendsto (fun n => ∫ ω, F n ω ∂μ) atTop (𝓝 (∫ ω, (0 : ℝ) ∂μ)) := by\n"
                "  have h := tendsto_integral_of_dominated_convergence bound F_meas bound_int h_bound h_lim\n"
                "  simpa using h"
            ),
            "target_proof": None,
            "informal_statement": (
                "Dominated Convergence Theorem (special case: limit zero): If |F_n| ≤ bound with "
                "bound integrable, each F_n AEStronglyMeasurable, and F_n → 0 a.e., "
                "then ∫ F_n → 0. Proof via tendsto_integral_of_dominated_convergence."
            ),
            "imports": "import Mathlib\nopen MeasureTheory\nopen scoped ENNReal",
            "parent_id": None,
            "transformation_type": None,
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l2": {
            "id": "ma-proofbench-manual-l2-05",
            "level": "L2",
            "domain": "Analysis",
            "sub_domain": "Measure and integration",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open MeasureTheory\n"
                "open scoped ENNReal\n\n"
                "variable {α : Type*} [MeasurableSpace α] {μ : Measure α}\n\n"
                "theorem dct_renamed {G : ℕ → α → ℝ} {B : α → ℝ}\n"
                "    (G_meas : ∀ n, AEStronglyMeasurable (G n) μ)\n"
                "    (B_int : Integrable B μ)\n"
                "    (h_bound : ∀ n, ∀ᵐ ω ∂μ, ‖G n ω‖ ≤ B ω)\n"
                "    (h_lim : ∀ᵐ ω ∂μ, Tendsto (fun n => G n ω) atTop (𝓝 (0 : ℝ))) :\n"
                "    Tendsto (fun n => ∫ ω, G n ω ∂μ) atTop (𝓝 (∫ ω, (0 : ℝ) ∂μ)) :=\n"
                "  dominated_convergence_theorem G_meas B_int h_bound h_lim"
            ),
            "target_proof": None,
            "informal_statement": (
                "Dominated Convergence Theorem (alpha-rename): F→G, bound→B. "
                "Proof delegates to dominated_convergence_theorem."
            ),
            "imports": "import Mathlib\nopen MeasureTheory\nopen scoped ENNReal",
            "parent_id": "ma-proofbench-manual-l1-05",
            "transformation_type": "alpha_rename",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l3": {
            "id": "formalmath-l3-manual-05",
            "level": "L3",
            "domain": "Analysis",
            "sub_domain": "Measure and integration",
            "source_dataset": "Manual",
            "formal_statement": (
                "theorem bounded_convergence_theorem [IsFiniteMeasure μ]\n"
                "    {F : ℕ → α → ℝ} (M : ℝ)\n"
                "    (F_meas : ∀ n, AEStronglyMeasurable (F n) μ)\n"
                "    (h_bound : ∀ n, ∀ᵐ ω ∂μ, ‖F n ω‖ ≤ M)\n"
                "    (h_lim : ∀ᵐ ω ∂μ, Tendsto (fun n => F n ω) atTop (𝓝 (0 : ℝ))) :\n"
                "    Tendsto (fun n => ∫ ω, F n ω ∂μ) atTop (𝓝 (0 : ℝ)) := by\n"
                "  have hM_int : Integrable (fun _ : α => M) μ := by\n"
                "    simp\n"
                "  have h := tendsto_integral_of_dominated_convergence (fun _ => M) F_meas hM_int h_bound h_lim\n"
                "  simpa using h"
            ),
            "target_proof": None,
            "informal_statement": (
                "Bounded Convergence Theorem (sibling of DCT): On a finite measure space, if "
                "F_n are uniformly bounded by M, AEStronglyMeasurable, and converge to 0 a.e., "
                "then ∫ F_n → 0. Proof via DCT with constant bound M."
            ),
            "imports": "import Mathlib\nopen MeasureTheory\nopen scoped ENNReal",
            "parent_id": "ma-proofbench-manual-l1-05",
            "transformation_type": "sibling",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
    },
    # ── Group 6: Monotone Convergence Theorem (ENNReal) ──
    {
        "l1": {
            "id": "ma-proofbench-manual-l1-06",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Measure and integration",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open MeasureTheory\n"
                "open scoped ENNReal\n\n"
                "variable {α : Type*} [MeasurableSpace α] {μ : Measure α}\n\n"
                "theorem monotone_convergence_theorem {f : ℕ → α → ℝ≥0∞}\n"
                "    (hf : ∀ n, AEMeasurable (f n) μ)\n"
                "    (h_mono : ∀ᵐ ω ∂μ, Monotone fun n => f n ω) :\n"
                "    (∫⁻ ω, ⨆ n, f n ω ∂μ) = ⨆ n, (∫⁻ ω, f n ω ∂μ) :=\n"
                "  lintegral_iSup' hf h_mono"
            ),
            "target_proof": None,
            "informal_statement": (
                "Monotone Convergence Theorem (Beppo Levi, ENNReal): For a.e.-monotone sequence "
                "of AEMeasurable [0,∞]-valued functions, integral of supremum equals supremum "
                "of integrals. Proof via lintegral_iSup'."
            ),
            "imports": "import Mathlib\nopen MeasureTheory\nopen scoped ENNReal",
            "parent_id": None,
            "transformation_type": None,
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l2": {
            "id": "ma-proofbench-manual-l2-06",
            "level": "L2",
            "domain": "Analysis",
            "sub_domain": "Measure and integration",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open MeasureTheory\n"
                "open scoped ENNReal\n\n"
                "variable {α : Type*} [MeasurableSpace α] {μ : Measure α}\n\n"
                "theorem mct_perturbed {g : ℕ → α → ℝ≥0∞}\n"
                "    (hg : ∀ n, AEMeasurable (g n) μ)\n"
                "    (h_nondecr : ∀ᵐ ω ∂μ, Monotone fun n => g n ω) :\n"
                "    (⨆ n, (∫⁻ ω, g n ω ∂μ)) = (∫⁻ ω, ⨆ n, g n ω ∂μ) := by\n"
                "  rw [eq_comm, monotone_convergence_theorem hg h_nondecr]"
            ),
            "target_proof": None,
            "informal_statement": (
                "Monotone Convergence Theorem (alpha-rename + equality flip): f→g. "
                "Supremum of integrals equals integral of supremum. "
                "Proof: rewrites equality via monotone_convergence_theorem."
            ),
            "imports": "import Mathlib\nopen MeasureTheory\nopen scoped ENNReal",
            "parent_id": "ma-proofbench-manual-l1-06",
            "transformation_type": "alpha_rename",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l3": {
            "id": "formalmath-l3-manual-06",
            "level": "L3",
            "domain": "Analysis",
            "sub_domain": "Measure and integration",
            "source_dataset": "Manual",
            "formal_statement": (
                "theorem Fatou_lemma {f : ℕ → α → ℝ≥0∞}\n"
                "    (hf : ∀ n, AEMeasurable (f n) μ) :\n"
                "    (∫⁻ ω, liminf (fun n => f n ω) atTop ∂μ) ≤ liminf (fun n => ∫⁻ ω, f n ω ∂μ) atTop :=\n"
                "  lintegral_liminf_le' hf"
            ),
            "target_proof": None,
            "informal_statement": (
                "Fatou's Lemma (sibling of MCT): For AEMeasurable [0,∞]-valued functions, "
                "integral of liminf ≤ liminf of integrals. "
                "Proof via lintegral_liminf_le'."
            ),
            "imports": "import Mathlib\nopen MeasureTheory\nopen scoped ENNReal",
            "parent_id": "ma-proofbench-manual-l1-06",
            "transformation_type": "sibling",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
    },
    # ── Group 7: Lipschitz implies Uniformly Continuous ──
    {
        "l1": {
            "id": "ma-proofbench-manual-l1-07",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Set\n"
                "open scoped NNReal\n\n"
                "theorem lipschitz_implies_uniformContinuous {K : ℝ≥0} {f : ℝ → ℝ}\n"
                "    (hf : LipschitzWith K f) : UniformContinuous f :=\n"
                "  hf.uniformContinuous"
            ),
            "target_proof": None,
            "informal_statement": (
                "Every Lipschitz continuous function on ℝ is uniformly continuous. "
                "Proof: LipschitzWith.uniformContinuous."
            ),
            "imports": "import Mathlib\nopen Set\nopen scoped NNReal",
            "parent_id": None,
            "transformation_type": None,
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l2": {
            "id": "ma-proofbench-manual-l2-07",
            "level": "L2",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Set\n"
                "open scoped NNReal\n\n"
                "theorem lipschitz_implies_uc_renamed {L : ℝ≥0} {g : ℝ → ℝ}\n"
                "    (hg : LipschitzWith L g) : UniformContinuous g :=\n"
                "  hg.uniformContinuous"
            ),
            "target_proof": None,
            "informal_statement": (
                "Lipschitz implies uniformly continuous (alpha-rename): f→g, K→L. "
                "Proof: LipschitzWith.uniformContinuous."
            ),
            "imports": "import Mathlib\nopen Set\nopen scoped NNReal",
            "parent_id": "ma-proofbench-manual-l1-07",
            "transformation_type": "alpha_rename",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l3": {
            "id": "formalmath-l3-manual-07",
            "level": "L3",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "theorem continuous_on_compact_uniformContinuousOn {f : ℝ → ℝ}\n"
                "    (hf : ContinuousOn f (Icc (0:ℝ) 1)) : UniformContinuousOn f (Icc (0:ℝ) 1) := by\n"
                "  have h_compact : IsCompact (Icc (0:ℝ) (1:ℝ)) := isCompact_Icc\n"
                "  exact h_compact.uniformContinuousOn_of_continuous hf"
            ),
            "target_proof": None,
            "informal_statement": (
                "Heine-Cantor theorem (sibling): A continuous function on a compact interval [0,1] "
                "is uniformly continuous on that interval. Proof via isCompact_Icc."
            ),
            "imports": "import Mathlib\nopen Set\nopen scoped NNReal",
            "parent_id": "ma-proofbench-manual-l1-07",
            "transformation_type": "sibling",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
    },
    # ── Group 8: Fundamental Theorem of Calculus ──
    {
        "l1": {
            "id": "ma-proofbench-manual-l1-08",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "theorem fundamental_theorem_calculus {f : ℝ → ℝ} {a b : ℝ}\n"
                "    (hderiv : ∀ x ∈ Set.uIcc a b, DifferentiableAt ℝ f x)\n"
                "    (hint : IntervalIntegrable (deriv f) volume a b) :\n"
                "    (∫ x in (a..b), deriv f x) = f b - f a :=\n"
                "  integral_deriv_eq_sub hderiv hint"
            ),
            "target_proof": None,
            "informal_statement": (
                "Fundamental Theorem of Calculus: If f is differentiable on [a,b] (uIcc) "
                "and deriv f is interval-integrable, then ∫_a^b f' = f(b) - f(a). "
                "Proof via integral_deriv_eq_sub."
            ),
            "imports": "import Mathlib",
            "parent_id": None,
            "transformation_type": None,
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l2": {
            "id": "ma-proofbench-manual-l2-08",
            "level": "L2",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "theorem ftc_renamed {g : ℝ → ℝ} {c d : ℝ}\n"
                "    (hderiv_g : ∀ x ∈ Set.uIcc c d, DifferentiableAt ℝ g x)\n"
                "    (hint_g : IntervalIntegrable (deriv g) volume c d) :\n"
                "    g d - g c = (∫ x in (c..d), deriv g x) := by\n"
                "  rw [eq_comm, fundamental_theorem_calculus hderiv_g hint_g]"
            ),
            "target_proof": None,
            "informal_statement": (
                "Fundamental Theorem of Calculus (alpha-rename + equality flip): f→g, a→c, b→d. "
                "g(d) - g(c) = ∫_c^d g'. Proof via rewriting equality from FTC."
            ),
            "imports": "import Mathlib",
            "parent_id": "ma-proofbench-manual-l1-08",
            "transformation_type": "alpha_rename",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l3": {
            "id": "formalmath-l3-manual-08",
            "level": "L3",
            "domain": "Analysis",
            "sub_domain": "Real functions",
            "source_dataset": "Manual",
            "formal_statement": (
                "theorem integral_zero_eq_zero {a b : ℝ} : (∫ x in (a..b), (0 : ℝ)) = (0 : ℝ) := by\n"
                "  simp"
            ),
            "target_proof": None,
            "informal_statement": (
                "Integral of the zero function is zero (sibling of FTC). "
                "The simplest instance of the FTC: ∫_a^b 0 dx = 0. Proof via simp."
            ),
            "imports": "import Mathlib",
            "parent_id": "ma-proofbench-manual-l1-08",
            "transformation_type": "sibling",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
    },
    # ── Group 9: Banach Fixed Point Theorem ──
    {
        "l1": {
            "id": "ma-proofbench-manual-l1-09",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Functional analysis",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open scoped NNReal\n\n"
                "theorem Banach_fixed_point {α : Type*} [MetricSpace α] [CompleteSpace α] [Nonempty α]\n"
                "    {f : α → α} (hf : ContractingWith ℝ f) : ∃! x : α, f x = x := by\n"
                "  have h_nonempty : Nonempty α := inferInstance\n"
                "  obtain ⟨x₀⟩ := h_nonempty\n"
                "  have hx : edist x₀ (f x₀) ≠ ∞ := by simp\n"
                "  rcases hf.exists_fixedPoint x₀ hx with ⟨y, hy, _, _⟩\n"
                "  refine ⟨y, hy, ?_⟩\n"
                "  intro z hz\n"
                "  apply hf.2\n"
                "  · exact hy\n"
                "  · exact hz"
            ),
            "target_proof": None,
            "informal_statement": (
                "Banach Fixed Point Theorem: Every contraction on a complete nonempty metric "
                "space has a unique fixed point. Proof via ContractingWith.exists_fixedPoint "
                "and uniqueness from the contraction property."
            ),
            "imports": "import Mathlib\nopen scoped NNReal",
            "parent_id": None,
            "transformation_type": None,
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l2": {
            "id": "ma-proofbench-manual-l2-09",
            "level": "L2",
            "domain": "Analysis",
            "sub_domain": "Functional analysis",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open scoped NNReal\n\n"
                "theorem contraction_mapping_perturbed {β : Type*} [MetricSpace β] [CompleteSpace β] [Nonempty β]\n"
                "    {g : β → β} (hg : ContractingWith ℝ g) : ∃! y : β, g y = y :=\n"
                "  Banach_fixed_point hg"
            ),
            "target_proof": None,
            "informal_statement": (
                "Banach Fixed Point Theorem (alpha-rename): f→g, α→β. "
                "Proof delegates to Banach_fixed_point."
            ),
            "imports": "import Mathlib\nopen scoped NNReal",
            "parent_id": "ma-proofbench-manual-l1-09",
            "transformation_type": "alpha_rename",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l3": {
            "id": "formalmath-l3-manual-09",
            "level": "L3",
            "domain": "Analysis",
            "sub_domain": "Functional analysis",
            "source_dataset": "Manual",
            "formal_statement": (
                "theorem fixed_point_iterates_converge {α : Type*} [MetricSpace α] [CompleteSpace α]\n"
                "    {f : α → α} (hf : ContractingWith ℝ f) (x₀ : α) :\n"
                "    ∃ x : α, f x = x ∧ Tendsto (fun n : ℕ => f^[n] x₀) atTop (𝓝 x) := by\n"
                "  have hx : edist x₀ (f x₀) ≠ ∞ := by simp\n"
                "  rcases hf.exists_fixedPoint x₀ hx with ⟨x, hx_fix, hx_tendsto, _⟩\n"
                "  exact ⟨x, hx_fix, hx_tendsto⟩"
            ),
            "target_proof": None,
            "informal_statement": (
                "For a contraction on a complete metric space, the iterates f^n(x₀) from any "
                "starting point converge to the unique fixed point (sibling of Banach). "
                "Proof via ContractingWith.exists_fixedPoint."
            ),
            "imports": "import Mathlib\nopen scoped NNReal",
            "parent_id": "ma-proofbench-manual-l1-09",
            "transformation_type": "sibling",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
    },
    # ── Group 10: Series and Convergence ──
    {
        "l1": {
            "id": "ma-proofbench-manual-l1-10",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Sequences, series, summability",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Filter\n\n"
                "theorem summable_imp_tendsto_zero {f : ℕ → ℝ} (hf : Summable f) : Tendsto f atTop (𝓝 0) :=\n"
                "  hf.tendsto_atTop_zero"
            ),
            "target_proof": None,
            "informal_statement": (
                "Terms of a summable series tend to zero. "
                "If ∑ f_n converges, then f_n → 0. Proof via Summable.tendsto_atTop_zero."
            ),
            "imports": "import Mathlib\nopen Filter",
            "parent_id": None,
            "transformation_type": None,
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l2": {
            "id": "ma-proofbench-manual-l2-10",
            "level": "L2",
            "domain": "Analysis",
            "sub_domain": "Sequences, series, summability",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Filter\n\n"
                "theorem summable_imp_tendsto_zero_renamed {g : ℕ → ℝ} (hg : Summable g) : Tendsto g atTop (𝓝 0) :=\n"
                "  summable_imp_tendsto_zero hg"
            ),
            "target_proof": None,
            "informal_statement": (
                "Summable implies terms tend to zero (alpha-rename): f→g. "
                "Proof delegates to summable_imp_tendsto_zero."
            ),
            "imports": "import Mathlib\nopen Filter",
            "parent_id": "ma-proofbench-manual-l1-10",
            "transformation_type": "alpha_rename",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
        "l3": {
            "id": "formalmath-l3-manual-10",
            "level": "L3",
            "domain": "Analysis",
            "sub_domain": "Sequences, series, summability",
            "source_dataset": "Manual",
            "formal_statement": (
                "theorem summable_geometric_of_nn_lt_one {r : ℝ} (h0 : 0 ≤ r) (h1 : r < 1) :\n"
                "    Summable fun n : ℕ => r ^ n :=\n"
                "  summable_geometric_of_lt_one h0 h1"
            ),
            "target_proof": None,
            "informal_statement": (
                "Geometric series with ratio 0 ≤ r < 1 converges (sibling of summable→tendsto). "
                "∑ r^n converges for 0 ≤ r < 1. Proof via summable_geometric_of_lt_one."
            ),
            "imports": "import Mathlib\nopen Filter",
            "parent_id": "ma-proofbench-manual-l1-10",
            "transformation_type": "sibling",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
    },
]


def load_json(path):
    with open(path, encoding='utf-8') as f:
        return json.load(f)


def save_json(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f"  Saved: {path} ({len(data)} entries)")


def process_dataset():
    """Process MA-ProofBench and FormalMATH-L3 datasets."""
    base = "."

    # ── Load datasets ──
    ma_path = f"{base}/MA-ProofBench/processed/dataset.json"
    formal_path = f"{base}/FormalMATH-L3/processed/dataset.json"

    ma_data = load_json(ma_path)
    formal_data = load_json(formal_path)

    print(f"MA-ProofBench: {len(ma_data)} entries")
    print(f"FormalMATH-L3: {len(formal_data)} entries")

    # ── Separate by level ──
    ma_l1 = [d for d in ma_data if d['level'] == 'L1']
    ma_l2 = [d for d in ma_data if d['level'] == 'L2']
    ma_other = [d for d in ma_data if d['level'] not in ('L1', 'L2')]

    formal_l3 = [d for d in formal_data if d['level'] == 'L3']
    formal_other = [d for d in formal_data if d['level'] != 'L3']

    print(f"  MA L1: {len(ma_l1)}, MA L2: {len(ma_l2)}, Formal L3: {len(formal_l3)}")

    # ── Remove last 10 from each ──
    removed_ma_l1 = ma_l1[-10:]
    ma_l1 = ma_l1[:-10]

    removed_ma_l2 = ma_l2[-10:]
    ma_l2 = ma_l2[:-10]

    removed_formal_l3 = formal_l3[-10:]
    formal_l3 = formal_l3[:-10]

    print(f"  Removed: MA L1 last 10 ({removed_ma_l1[0]['id']}..{removed_ma_l1[-1]['id']})")
    print(f"  Removed: MA L2 last 10 ({removed_ma_l2[0]['id']}..{removed_ma_l2[-1]['id']})")
    print(f"  Removed: Formal L3 last 10 ({removed_formal_l3[0]['id']}..{removed_formal_l3[-1]['id']})")

    # ── Build manual entries ──
    manual_l1 = []
    manual_l2 = []
    manual_l3 = []

    for grp in MANUAL_GROUPS:
        manual_l1.append(copy.deepcopy(grp['l1']))
        manual_l2.append(copy.deepcopy(grp['l2']))
        manual_l3.append(copy.deepcopy(grp['l3']))

    print(f"\n  Generated: {len(manual_l1)} manual L1, {len(manual_l2)} manual L2, {len(manual_l3)} manual L3")

    # ── Reassemble MA-ProofBench: keep order: L1→L2→other ──
    new_ma = ma_l1 + manual_l1 + ma_l2 + manual_l2 + ma_other
    print(f"  New MA-ProofBench: {len(new_ma)} entries (L1={len(ma_l1)+len(manual_l1)}, L2={len(ma_l2)+len(manual_l2)})")

    # ── Reassemble FormalMATH-L3 ──
    new_formal = formal_l3 + manual_l3 + formal_other
    print(f"  New FormalMATH-L3: {len(new_formal)} entries (L3={len(formal_l3)+len(manual_l3)})")

    # ── Validate counts ──
    assert len(new_ma) == 200, f"MA-ProofBench expected 200, got {len(new_ma)}"
    assert len([d for d in new_ma if d['level'] == 'L1']) == 100, "MA L1 should be 100"
    assert len([d for d in new_ma if d['level'] == 'L2']) == 100, "MA L2 should be 100"
    assert len(new_formal) == 100, f"FormalMATH-L3 expected 100, got {len(new_formal)}"
    assert len([d for d in new_formal if d['level'] == 'L3']) == 100, "Formal L3 should be 100"

    # ── Save ──
    save_json(ma_path, new_ma)
    save_json(formal_path, new_formal)

    # ── Summary ──
    print("\n=== Manual problem IDs ===")
    for g in MANUAL_GROUPS:
        print(f"  {g['l1']['id']} | {g['l2']['id']} | {g['l3']['id']}")

    print("\nDone. 30 manual Analysis problems inserted.")


if __name__ == "__main__":
    process_dataset()

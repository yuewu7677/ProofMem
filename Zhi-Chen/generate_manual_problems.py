#!/usr/bin/env python3
"""
Generate 30 manual Analysis problems (10 L1 + 10 L2 + 10 L3)
and update MA-ProofBench and FormalMATH-L3 datasets.

For each dataset level, removes last 10 entries and inserts 10 manual ones.
Source dataset labeled "Manual", split = "test".
"""

import json
import copy

# ── 10 Analysis Theorem Groups ────────────────────────────────────────────
# Each group: (L1, L2, L3) = (original theorem, perturbation, sibling)

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
                "open Real\n\n"
                "theorem intermediate_value_theorem {a b : ℝ} {f : ℝ → ℝ}\n"
                "    (hf : ContinuousOn f (Set.Ioo a b))\n"
                "    (ha : a < b) {y : ℝ} (hy : y ∈ Set.Ioo (f a) (f b)) :\n"
                "    ∃ x ∈ Set.Ioo a b, f x = y :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Intermediate Value Theorem: Let f be a continuous function on the interval (a,b). "
                "If f(a) < y < f(b) (or f(b) < y < f(a)), then there exists x in (a,b) such that f(x) = y."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "open Real\n\n"
                "theorem ivt_renamed {c d : ℝ} {g : ℝ → ℝ}\n"
                "    (hg : ContinuousOn g (Set.Ioo c d))\n"
                "    (hc : c < d) {z : ℝ} (hz : z ∈ Set.Ioo (g c) (g d)) :\n"
                "    ∃ x ∈ Set.Ioo c d, g x = z :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Intermediate Value Theorem (alpha-rename): Let g be continuous on (c,d). "
                "If g(c) < z < g(d), then there exists x in (c,d) with g(x) = z. "
                "Perturbation: f→g, a→c, b→d, y→z."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "theorem extreme_value_theorem {f : ℝ → ℝ} (hf : ContinuousOn f (Set.Icc 0 1)) :\n"
                "    ∃ x ∈ Set.Icc 0 1, ∀ y ∈ Set.Icc 0 1, f y ≤ f x :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Extreme Value Theorem (sibling of IVT): A continuous function on a closed interval "
                "[0,1] attains its maximum. Sibling theorem in the continuity family."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "open Real\n\n"
                "theorem mean_value_theorem {a b : ℝ} {f : ℝ → ℝ}\n"
                "    (hf : ContinuousOn f (Set.Icc a b))\n"
                "    (hf' : DifferentiableOn ℝ f (Set.Ioo a b))\n"
                "    (hlt : a < b) :\n"
                "    ∃ c ∈ Set.Ioo a b, deriv f c = (f b - f a) / (b - a) :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Mean Value Theorem: If f is continuous on [a,b] and differentiable on (a,b), "
                "then there exists c in (a,b) such that f'(c) = (f(b)-f(a))/(b-a)."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "open Real\n\n"
                "theorem mvt_renamed {p q : ℝ} {g : ℝ → ℝ}\n"
                "    (hg_cont : ContinuousOn g (Set.Icc p q))\n"
                "    (hg_diff : DifferentiableOn ℝ g (Set.Ioo p q))\n"
                "    (hpq : p < q) :\n"
                "    ∃ c ∈ Set.Ioo p q, deriv g c = (g q - g p) / (q - p) :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Mean Value Theorem (alpha-rename + binder reorder): "
                "Perturbation: f→g, a→p, b→q, hlt→hpq."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "    (hf : ContinuousOn f (Set.Icc a b))\n"
                "    (hf' : DifferentiableOn ℝ f (Set.Ioo a b))\n"
                "    (hfa : f a = f b) (hlt : a < b) :\n"
                "    ∃ c ∈ Set.Ioo a b, deriv f c = 0 :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Rolle's Theorem (sibling of MVT): If f is continuous on [a,b], differentiable on (a,b), "
                "and f(a)=f(b), then there exists c in (a,b) such that f'(c)=0."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "theorem uniform_limit_continuous {α : Type*} [MetricSpace α]\n"
                "    {f : ℕ → α → ℝ} {f_lim : α → ℝ}\n"
                "    (hf_cont : ∀ n, Continuous (f n))\n"
                "    (h_unif : TendstoUniformly f f_lim atTop) :\n"
                "    Continuous f_lim :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "The uniform limit of a sequence of continuous functions is continuous. "
                "If each f_n is continuous and f_n → f uniformly, then f is continuous."
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
                "theorem unif_limit_cont_perturbed {β : Type*} [MetricSpace β]\n"
                "    {g : ℕ → β → ℝ} {g_lim : β → ℝ}\n"
                "    (hg_cont : ∀ n, Continuous (g n))\n"
                "    (h_unif : TendstoUniformly g g_lim atTop) :\n"
                "    Continuous g_lim :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Uniform limit of continuous functions (alpha-rename): f→g, α→β. "
                "If each g_n is continuous and g_n → g uniformly, then g is continuous."
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
                "theorem uniform_limit_bounded {α : Type*} [MetricSpace α]\n"
                "    {f : ℕ → α → ℝ} {f_lim : α → ℝ}\n"
                "    (hf_bdd : ∀ n, ∃ M, ∀ x, |f n x| ≤ M)\n"
                "    (h_unif : TendstoUniformly f f_lim atTop) :\n"
                "    ∃ M, ∀ x, |f_lim x| ≤ M :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Uniform limit of bounded functions is bounded (sibling): "
                "If each f_n is bounded and f_n → f uniformly, then f is bounded."
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
                "theorem weierstrass_m_test {α : Type*} [MetricSpace α]\n"
                "    {f : ℕ → α → ℝ} (M : ℕ → ℝ)\n"
                "    (h_bound : ∀ n x, ‖f n x‖ ≤ M n) (h_summable : Summable M) :\n"
                "    ∃ g : α → ℝ, TendstoUniformly (fun N x => ∑ n in Finset.range N, f n x) g atTop :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Weierstrass M-test: If |f_n(x)| ≤ M_n for all n,x and ∑ M_n converges, "
                "then ∑ f_n converges uniformly on α."
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
                "theorem m_test_perturbed {β : Type*} [MetricSpace β]\n"
                "    {g : ℕ → β → ℝ} (N : ℕ → ℝ)\n"
                "    (h_bound : ∀ n x, ‖g n x‖ ≤ N n) (h_summable : Summable N) :\n"
                "    ∃ h : β → ℝ, TendstoUniformly (fun K x => ∑ n in Finset.range K, g n x) h atTop :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Weierstrass M-test (alpha-rename): f→g, M→N, α→β, g→h."
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
                "theorem Dini_theorem {f : ℕ → ℝ → ℝ} {f_lim : ℝ → ℝ}\n"
                "    (h_cont : ∀ n, Continuous (f n)) (h_cont_lim : Continuous f_lim)\n"
                "    (h_mono : ∀ n x, f n x ≤ f (n+1) x) (h_point : ∀ x, Tendsto (fun n => f n x) atTop (𝓝 (f_lim x)))\n"
                "    [h_compact : CompactSpace ℝ] :\n"
                "    TendstoUniformly f f_lim atTop :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Dini's Theorem (sibling of M-test convergence): If a monotone sequence of continuous functions "
                "converges pointwise to a continuous function on a compact space, the convergence is uniform."
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
                "open MeasureTheory\n\n"
                "theorem dominated_convergence_theorem {α : Type*} [MeasurableSpace α] {μ : Measure α}\n"
                "    {f : ℕ → α → ℝ} {F : α → ℝ}\n"
                "    (h_bound : ∀ n, ∀ᵐ ω ∂μ, |f n ω| ≤ F ω)\n"
                "    (hF_int : Integrable F μ)\n"
                "    (h_lim : ∀ᵐ ω ∂μ, Tendsto (fun n => f n ω) atTop (𝓝 (0 : ℝ))) :\n"
                "    Tendsto (fun n => ∫ ω, f n ω ∂μ) atTop (𝓝 (∫ ω, (0 : ℝ) ∂μ)) :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Dominated Convergence Theorem: If |f_n| ≤ F with F integrable, and f_n → 0 a.e., "
                "then ∫ f_n → 0. Here stated for the special case of limit zero."
            ),
            "imports": "import Mathlib\nopen MeasureTheory",
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
                "open MeasureTheory\n\n"
                "theorem dct_renamed {β : Type*} [MeasurableSpace β] {ν : Measure β}\n"
                "    {g : ℕ → β → ℝ} {G : β → ℝ}\n"
                "    (h_bound : ∀ n, ∀ᵐ ω ∂ν, |g n ω| ≤ G ω)\n"
                "    (hG_int : Integrable G ν)\n"
                "    (h_lim : ∀ᵐ ω ∂ν, Tendsto (fun n => g n ω) atTop (𝓝 (0 : ℝ))) :\n"
                "    Tendsto (fun n => ∫ ω, g n ω ∂ν) atTop (𝓝 (∫ ω, (0 : ℝ) ∂ν)) :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Dominated Convergence Theorem (alpha-rename): f→g, F→G, α→β, μ→ν."
            ),
            "imports": "import Mathlib\nopen MeasureTheory",
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
                "theorem bounded_convergence_theorem {α : Type*} [MeasurableSpace α] {μ : Measure α}\n"
                "    [IsFiniteMeasure μ] {f : ℕ → α → ℝ}\n"
                "    (h_bound : ∃ M, ∀ n, ∀ᵐ ω ∂μ, |f n ω| ≤ M)\n"
                "    (h_lim : ∀ᵐ ω ∂μ, Tendsto (fun n => f n ω) atTop (𝓝 (0 : ℝ))) :\n"
                "    Tendsto (fun n => ∫ ω, f n ω ∂μ) atTop (𝓝 (0 : ℝ)) :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Bounded Convergence Theorem (sibling of DCT): If |f_n| ≤ M (uniformly bounded) on a finite "
                "measure space and f_n → 0 a.e., then ∫ f_n → 0."
            ),
            "imports": "import Mathlib\nopen MeasureTheory",
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
                "theorem monotone_convergence_theorem {α : Type*} [MeasurableSpace α] {μ : Measure α}\n"
                "    {f : ℕ → α → ℝ≥0∞} (hf : ∀ n, AEMeasurable (f n) μ)\n"
                "    (h_mono : ∀ n, f n ≤ᵐ[μ] f (n + 1)) :\n"
                "    (∫⁻ ω, ⨆ n, f n ω ∂μ) = ⨆ n, (∫⁻ ω, f n ω ∂μ) :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Monotone Convergence Theorem (Beppo Levi): For a monotone sequence of non-negative "
                "measurable functions, the integral of the supremum equals the supremum of the integrals."
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
                "theorem mct_perturbed {β : Type*} [MeasurableSpace β] {ν : Measure β}\n"
                "    {g : ℕ → β → ℝ≥0∞} (hg : ∀ n, AEMeasurable (g n) ν)\n"
                "    (h_nondecr : ∀ n, g n ≤ᵐ[ν] g (n + 1)) :\n"
                "    (⨆ n, (∫⁻ ω, g n ω ∂ν)) = (∫⁻ ω, ⨆ n, g n ω ∂ν) :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Monotone Convergence Theorem (alpha-rename + equality flip): f→g, α→β, μ→ν. "
                "Supremum of integrals equals integral of supremum (equality reversed)."
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
                "theorem Fatou_lemma {α : Type*} [MeasurableSpace α] {μ : Measure α}\n"
                "    {f : ℕ → α → ℝ≥0∞} (hf : ∀ n, AEMeasurable (f n) μ) :\n"
                "    (∫⁻ ω, liminf (fun n => f n ω) atTop ∂μ) ≤ liminf (fun n => ∫⁻ ω, f n ω ∂μ) atTop :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Fatou's Lemma (sibling of MCT): For a sequence of non-negative measurable functions, "
                "the integral of the liminf is bounded above by the liminf of the integrals."
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
                "open Real\n\n"
                "theorem Lipschitz_uniformContinuous {α β : Type*} [PseudoMetricSpace α]\n"
                "    [PseudoMetricSpace β] {f : α → β} {K : ℝ≥0}\n"
                "    (hf : LipschitzWith K f) : UniformContinuous f :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Every Lipschitz continuous function is uniformly continuous. "
                "If f satisfies d(f(x),f(y)) ≤ K·d(x,y), then f is uniformly continuous."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "open Real\n\n"
                "theorem lipschitz_implies_uc_renamed {X Y : Type*} [PseudoMetricSpace X]\n"
                "    [PseudoMetricSpace Y] {g : X → Y} {L : ℝ≥0}\n"
                "    (hg : LipschitzWith L g) : UniformContinuous g :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Lipschitz implies uniformly continuous (alpha-rename): f→g, K→L, α→X, β→Y."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "theorem continuous_on_compact_uniformContinuous {f : ℝ → ℝ}\n"
                "    (hf : ContinuousOn f (Set.Icc 0 1)) :\n"
                "    UniformContinuousOn f (Set.Icc 0 1) :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Heine-Cantor theorem (sibling): A continuous function on a compact interval [0,1] "
                "is uniformly continuous on that interval."
            ),
            "imports": "import Mathlib\nopen Real Set",
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
                "open Real\n\n"
                "theorem fundamental_theorem_calculus {f : ℝ → ℝ} (hf : ContDiff ℝ 1 f)\n"
                "    (a b : ℝ) :\n"
                "    (∫ x in a..b, deriv f x) = f b - f a :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Fundamental Theorem of Calculus: If f is continuously differentiable, "
                "then ∫_a^b f'(x) dx = f(b) - f(a)."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "open Real\n\n"
                "theorem ftc_renamed {g : ℝ → ℝ} (hg : ContDiff ℝ 1 g)\n"
                "    (c d : ℝ) :\n"
                "    g d - g c = (∫ x in c..d, deriv g x) :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Fundamental Theorem of Calculus (alpha-rename + equality flip): f→g, a→c, b→d. "
                "g(d) - g(c) = ∫_c^d g'(x) dx (equality reversed)."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "theorem integral_deriv_zero_constant {f : ℝ → ℝ}\n"
                "    (hf : ∀ x, HasDerivAt f (0 : ℝ) x) :\n"
                "    ∃ c : ℝ, f = fun _ => c :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "If a function has derivative zero everywhere, then it is constant (sibling of FTC). "
                "This is the converse direction: f' = 0 ⇒ f is constant."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "theorem Banach_fixed_point {α : Type*} [MetricSpace α] [CompleteSpace α]\n"
                "    [Nonempty α] {f : α → α} (hf : ContractingWith ℝ f) :\n"
                "    ∃! x : α, f x = x :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Banach Fixed Point Theorem (Contraction Mapping Principle): In a complete metric space, "
                "every contraction mapping has a unique fixed point."
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
            "id": "ma-proofbench-manual-l2-09",
            "level": "L2",
            "domain": "Analysis",
            "sub_domain": "Functional analysis",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "theorem contraction_mapping_perturbed {β : Type*} [MetricSpace β] [CompleteSpace β]\n"
                "    [Nonempty β] {g : β → β} (hg : ContractingWith ℝ g) :\n"
                "    ∃! y : β, g y = y :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Banach Fixed Point Theorem (alpha-rename): f→g, α→β, x→y."
            ),
            "imports": "import Mathlib",
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
                "    [Nonempty α] {f : α → α} (hf : ContractingWith ℝ f) (x₀ : α) :\n"
                "    ∃ x : α, f x = x ∧ Tendsto (fun n => Nat.iterate f n x₀) atTop (𝓝 x) :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "For a contraction mapping, the iterates from any starting point converge to the unique "
                "fixed point (sibling of Banach fixed point theorem)."
            ),
            "imports": "import Mathlib",
            "parent_id": "ma-proofbench-manual-l1-09",
            "transformation_type": "sibling",
            "proof_strategy": [],
            "lean_version": "Lean4",
            "mathlib_version": "4.32.0",
            "verified": False,
            "split": "test",
        },
    },
    # ── Group 10: Power Series / Radius of Convergence ──
    {
        "l1": {
            "id": "ma-proofbench-manual-l1-10",
            "level": "L1",
            "domain": "Analysis",
            "sub_domain": "Sequences, series, summability",
            "source_dataset": "Manual",
            "formal_statement": (
                "import Mathlib\n\n"
                "open Real\n\n"
                "theorem term_by_term_differentiation {a : ℕ → ℝ} {R : ℝ}\n"
                "    (hR : 0 < R)\n"
                "    (h_conv : ∀ x, |x| < R → Summable (fun n => a n * x ^ n)) :\n"
                "    ∀ x, |x| < R → HasDerivAt (fun x => ∑' n, a n * x ^ n)\n"
                "      (∑' n, (n+1 : ℝ) * a (n+1) * x ^ n) x :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Term-by-term differentiation of power series: Within the radius of convergence, "
                "a power series can be differentiated term by term."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "open Real\n\n"
                "theorem power_series_diff_perturbed {b : ℕ → ℝ} {S : ℝ}\n"
                "    (hS : 0 < S)\n"
                "    (h_conv : ∀ x, |x| < S → Summable (fun n => b n * x ^ n)) :\n"
                "    ∀ x, |x| < S → HasDerivAt (fun x => ∑' n, b n * x ^ n)\n"
                "      (∑' m, (m+1 : ℝ) * b (m+1) * x ^ m) x :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Power series differentiation (alpha-rename + binder reorder): a→b, R→S, n→m."
            ),
            "imports": "import Mathlib\nopen Real",
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
                "theorem Abel_limit_theorem {a : ℕ → ℝ}\n"
                "    (h_conv : Summable a) :\n"
                "    Tendsto (fun x : ℝ => ∑' n, a n * x ^ n) (𝓝[Set.Ioo (-1 : ℝ) 1] 1) (𝓝 (∑' n, a n)) :=\n"
                "  by\n  sorry"
            ),
            "target_proof": None,
            "informal_statement": (
                "Abel's Limit Theorem (sibling of power series differentiation): If ∑ a_n converges, then "
                "∑ a_n x^n → ∑ a_n as x → 1⁻ along the real axis."
            ),
            "imports": "import Mathlib\nopen Real Set Filter",
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

/-
  L2 (Theorem Perturbation) set, generated from AlgebraQuals_L1.lean
  by scripts/perturb_l2.py --seed 20260720.

  Each theorem is alpha-renamed, and its binders are reordered where
  the dependency graph permits. Statements are mathematically
  equivalent to their L1 parents; see perturbation_report.json for the
  per-theorem record of what changed. Any record tagged
  `constant_substitution` is a manual sibling variant, NOT a
  meaning-preserving perturbation -- see its semantic note.

  Generated mechanically by a textual transform. Verify before use.
-/

import Mathlib

set_option linter.style.setOption false      -- unscoped maxHeartbeats
set_option linter.style.longLine false       -- reordered binder lines
set_option linter.unusedFintypeInType false  -- carried [Fintype _] hypotheses
set_option linter.unnecessarySimpa false     -- carried simpa phrasing

set_option maxHeartbeats 1000000

section L2Thm001
/- --------------------------------------------------------------------------
  001.  Module Theory
  Source: University of Oregon, Fall 2025, Part I, Problem 3
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: surjective_endomorphism_bijective_of_isNoetherian
-------------------------------------------------------------------------- -/

theorem surjective_endomorphism_bijective_of_isNoetherian_l2
    {A A₁ : Type*} [Ring A] [AddCommGroup A₁] [Module A A₁] [IsNoetherian A A₁]
    (u : A₁ →ₗ[A] A₁) (hu : Function.Surjective u) : Function.Bijective u :=
  ⟨IsNoetherian.injective_of_surjective_endomorphism u hu, hu⟩

end L2Thm001

section L2Thm002
/- --------------------------------------------------------------------------
  002.  Commutative Algebra
  Source: University of Oregon, Fall 2025, Part I, Problem 4
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: mul_eq_inf_of_isRadical_mul
-------------------------------------------------------------------------- -/

theorem mul_eq_inf_of_isRadical_mul_l2 {u : ℕ}
    (u₁ u₂ : Ideal (MvPolynomial (Fin u) ℂ)) (hu : (u₁ * u₂).IsRadical) :
    u₁ * u₂ = u₁ ⊓ u₂ := by
  refine le_antisymm Ideal.mul_le_inf ?_
  intro x hx
  obtain ⟨hxI, hxJ⟩ := Submodule.mem_inf.mp hx
  have h2 : x ^ 2 ∈ u₁ * u₂ := by
    rw [pow_two]
    exact Ideal.mul_mem_mul hxI hxJ
  -- `Ideal.IsRadical I` unfolds to `I.radical ≤ I`, a Pi type, so dot-notation
  -- resolves into `Function`, not `Ideal.IsPrime`.  Apply `h` directly:
  -- `x ∈ (I*J).radical` is definitionally `∃ n, x ^ n ∈ I * J` (`mem_radical_iff`).
  exact hu ⟨2, h2⟩

end L2Thm002

section L2Thm003
/- --------------------------------------------------------------------------
  003.  Commutative Algebra
  Source: University of Oregon, Fall 2021, Part II, Problem 2(a)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: ker_aeval_t2_t3_t4_isPrime
-------------------------------------------------------------------------- -/

theorem ker_aeval_t3_t5_t7_isPrime_l2 :
    (RingHom.ker (MvPolynomial.aeval
        ![(Polynomial.X : Polynomial ℂ) ^ 3, (Polynomial.X : Polynomial ℂ) ^ 5,
          (Polynomial.X : Polynomial ℂ) ^ 7] :
      MvPolynomial (Fin 3) ℂ →ₐ[ℂ] Polynomial ℂ)).IsPrime :=
  RingHom.ker_isPrime _

end L2Thm003

section L2Thm004
/- --------------------------------------------------------------------------
  004.  Field Theory
  Source: University of Oregon, Winter 2024, Part III, Problem 1(a)
  Confidence: MEDIUM - multi-step but standard API
  Name: artin_schreier_add_natCast_is_root
-------------------------------------------------------------------------- -/

theorem artin_schreier_add_natCast_is_root_l2 {A : Type*} [Field A] {u : ℕ} [Fact u.Prime] [CharP A u] (u₁ u₂ : A) (u₃ : ℕ) (hu : u₂ ^ u - u₂ - u₁ = 0) :
    (u₂ + (u₃ : A)) ^ u - (u₂ + (u₃ : A)) - u₁ = 0 := by
  have hp : u ≠ 0 := (Fact.out : Nat.Prime u).ne_zero
  have key : ∀ k : ℕ, ((k : A)) ^ u = (k : A) := by
    intro k
    induction k with
    | zero => simp [zero_pow hp]
    | succ j ih =>
        have hstep : (((j : A) + 1)) ^ u = ((j : A)) ^ u + (1 : A) ^ u := by
          rw [add_pow_char]
        push_cast
        rw [hstep, ih, one_pow]
  have hsum : (u₂ + (u₃ : A)) ^ u = u₂ ^ u + ((u₃ : A)) ^ u := by
    rw [add_pow_char]
  rw [hsum, key u₃]
  linear_combination hu

end L2Thm004

section L2Thm005
/- --------------------------------------------------------------------------
  005.  Ring Theory
  Source: University of Oregon, Fall 2024, Part III, Problem 1
  Confidence: LOW    - most likely to need Mathlib name/signature adjustment
  Name: isSemisimpleRing_iff_forall_leftIdeal_span_idempotent
-------------------------------------------------------------------------- -/

theorem isSemisimpleRing_iff_forall_leftIdeal_span_idempotent_l2 (A : Type*) [Ring A] :
    IsSemisimpleRing A ↔
      ∀ I : Submodule A A, ∃ e : A, IsIdempotentElem e ∧ I = Submodule.span A {e} := by
  constructor
  · intro _ I
    obtain ⟨J, hJ⟩ := ComplementedLattice.exists_isCompl I
    have h1 : (1 : A) ∈ I ⊔ J := by
      rw [hJ.sup_eq_top]; trivial
    obtain ⟨e, he, f, hf, hef⟩ := Submodule.mem_sup.mp h1
    have hkey : ∀ x ∈ I, x = x * e := by
      intro x hx
      have hxe : x * e ∈ I := by simpa [smul_eq_mul] using I.smul_mem x he
      have hxf : x * f ∈ J := by simpa [smul_eq_mul] using J.smul_mem x hf
      have hadd : x * e + x * f = x := by rw [← mul_add, hef, mul_one]
      have hsub : x * f = x - x * e := eq_sub_of_add_eq' hadd
      have hmemI : x * f ∈ I := by rw [hsub]; exact I.sub_mem hx hxe
      have hzero : x * f = 0 := by
        have : x * f ∈ I ⊓ J := ⟨hmemI, hxf⟩
        rw [hJ.inf_eq_bot] at this
        simpa using this
      -- `rw [← hadd]` unrestricted would rewrite the `x` on *both* sides
      -- (and inside the replacement), leaving `x * e = x * e * e`.
      -- Restrict the rewrite to the left-hand side.
      conv_lhs => rw [← hadd]
      rw [hzero, add_zero]
    refine ⟨e, (hkey e he).symm, le_antisymm ?_ ?_⟩
    · intro x hx
      rw [Submodule.mem_span_singleton]
      exact ⟨x, by rw [smul_eq_mul]; exact (hkey x hx).symm⟩
    · rw [Submodule.span_le, Set.singleton_subset_iff]
      exact he
  · intro h
    -- `IsSemisimpleModule` is `@[mk_iff] class ... extends ComplementedLattice
    -- (Submodule R M)`.  Rather than guess the arity of the anonymous
    -- constructor, go through the generated iff, which is how Mathlib itself
    -- builds this instance (SimpleModule/Basic.lean:77).
    refine (isSemisimpleModule_iff A A).mpr ⟨fun I => ?_⟩
    obtain ⟨e, he, hIe⟩ := h I
    refine ⟨Submodule.span A {1 - e}, ?_, ?_⟩
    · rw [disjoint_iff_inf_le]
      rintro r ⟨hr1, hr2⟩
      -- `rw` could not match `Submodule.span R {e}` against the `R ∙ y` pattern
      -- in `mem_span_singleton`.  Stating the intermediate type explicitly lets
      -- the elaborator unify it instead of pattern-matching syntactically.
      have hr1' : r ∈ Submodule.span A {e} := hIe ▸ hr1
      obtain ⟨a, ha⟩ := Submodule.mem_span_singleton.mp hr1'
      obtain ⟨b, hb⟩ := Submodule.mem_span_singleton.mp hr2
      rw [smul_eq_mul] at ha hb
      have h1 : r * e = r := by rw [← ha, mul_assoc, he.eq]
      have h2 : r * e = 0 := by
        rw [← hb, mul_assoc, sub_mul, one_mul, he.eq, sub_self, mul_zero]
      rw [h1] at h2
      simpa using h2
    · rw [codisjoint_iff_le_sup]
      intro r _
      have hr : r = r * e + r * (1 - e) := by
        rw [mul_sub, mul_one]; abel
      rw [hr]
      refine Submodule.add_mem_sup ?_ ?_
      · rw [hIe, Submodule.mem_span_singleton]; exact ⟨r, by rw [smul_eq_mul]⟩
      · rw [Submodule.mem_span_singleton]; exact ⟨r, by rw [smul_eq_mul]⟩

end L2Thm005

section L2Thm006
/- --------------------------------------------------------------------------
  006.  Ring Theory
  Source: University of Oregon, Fall 2020, Problem 4(i)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: isNilpotent_mem_jacobson_bot
-------------------------------------------------------------------------- -/

theorem isNilpotent_mem_jacobson_bot_l2 {A : Type*} [CommRing A] {u : A}
    (hu : IsNilpotent u) : u ∈ (⊥ : Ideal A).jacobson := by
  rw [Ideal.jacobson, Ideal.mem_sInf]
  rintro M ⟨-, hM⟩
  obtain ⟨n, hn⟩ := hu
  have hprime : M.IsPrime := hM.isPrime
  refine hprime.mem_of_pow_mem n ?_
  rw [hn]
  exact M.zero_mem

end L2Thm006

section L2Thm007
/- --------------------------------------------------------------------------
  007.  Ring Theory
  Source: University of Oregon, Fall 2020, Problem 4(v)
  Confidence: MEDIUM - multi-step but standard API
  Name: jacobson_pow_eq_bot_of_pow_eq_pow_succ
-------------------------------------------------------------------------- -/

theorem jacobson_pow_eq_bot_of_pow_eq_pow_succ_l2
    {A : Type*} [CommRing A] [IsNoetherianRing A] (u : ℕ)
    (hu : (Ideal.jacobson (⊥ : Ideal A)) ^ u = (Ideal.jacobson (⊥ : Ideal A)) ^ (u + 1)) :
    (Ideal.jacobson (⊥ : Ideal A)) ^ u = ⊥ := by
  set J := Ideal.jacobson (⊥ : Ideal A) with hJ
  have hfg : (J ^ u).FG := IsNoetherian.noetherian _
  have hle : J ^ u ≤ J • J ^ u := by
    rw [Ideal.smul_eq_mul, ← pow_succ']
    exact le_of_eq hu
  exact Submodule.eq_bot_of_le_smul_of_le_jacobson_bot J (J ^ u) hfg hle le_rfl

end L2Thm007

section L2Thm008
/- --------------------------------------------------------------------------
  008.  Algebraic Geometry
  Source: University of Oregon, Fall 2020, Problem 5(i)
  Confidence: MEDIUM - multi-step but standard API
  Name: eval_eq_zero_of_mem_colon
-------------------------------------------------------------------------- -/

theorem eval_eq_zero_of_mem_colon_l2 {A : Type*} [Field A] {A₁ : Type*} (u₂ : A₁ → A) (u u₁ : Ideal (MvPolynomial A₁ A)) (hu : ∀ f ∈ u, MvPolynomial.eval u₂ f = 0) (hu₁ : ∃ g ∈ u₁, MvPolynomial.eval u₂ g ≠ 0) :
    ∀ r ∈ u.colon u₁, MvPolynomial.eval u₂ r = 0 := by
  obtain ⟨g, hgJ, hg⟩ := hu₁
  intro r hr
  have hrg : r * g ∈ u := by
    have := Submodule.mem_colon.mp hr g hgJ
    simpa [smul_eq_mul] using this
  have : MvPolynomial.eval u₂ r * MvPolynomial.eval u₂ g = 0 := by
    rw [← map_mul]
    exact hu _ hrg
  rcases mul_eq_zero.mp this with h | h
  · exact h
  · exact absurd h hg

end L2Thm008

section L2Thm009
/- --------------------------------------------------------------------------
  009.  Commutative Algebra
  Source: University of Oregon, Fall 2020, Problem 5(iv)
  Confidence: MEDIUM - multi-step but standard API
  Name: colon_eq_self_of_isPrime_of_not_le
-------------------------------------------------------------------------- -/

theorem colon_eq_self_of_isPrime_of_not_le_l2 {A : Type*} [CommRing A] (u u₁ : Ideal A) (hu₁ : ¬ u₁ ≤ u) (hu : u.IsPrime) : u.colon u₁ = u := by
  obtain ⟨j, hjJ, hjI⟩ := Set.not_subset.mp hu₁
  apply le_antisymm
  · intro r hr
    have hrj : r * j ∈ u := by
      have := Submodule.mem_colon.mp hr j hjJ
      simpa [smul_eq_mul] using this
    rcases hu.mem_or_mem hrj with h | h
    · exact h
    · exact absurd h hjI
  · intro r hr
    rw [Submodule.mem_colon]
    intro p _
    simpa [smul_eq_mul] using u.mul_mem_right p hr

end L2Thm009

section L2Thm010
/- --------------------------------------------------------------------------
  010.  Commutative Algebra
  Source: University of Oregon, Fall 2022, Part III, Problem 4
  Confidence: MEDIUM - multi-step but standard API
  Name: exists_nontrivial_idempotent_of_isCoprime
-------------------------------------------------------------------------- -/

theorem exists_nontrivial_idempotent_of_isCoprime_l2 {A : Type*} [CommRing A] (u u₁ : Ideal A) (hu₁ : u ≠ ⊤) (hu₂ : u₁ ≠ ⊤) (hu : u ⊔ u₁ = ⊤) :
    ∃ e : A ⧸ (u ⊓ u₁), IsIdempotentElem e ∧ e ≠ 0 ∧ e ≠ 1 := by
  have hmem : (1 : A) ∈ u ⊔ u₁ := by rw [hu]; trivial
  obtain ⟨a₁, ha₁, a₂, ha₂, hsum⟩ := Submodule.mem_sup.mp hmem
  refine ⟨Ideal.Quotient.mk _ a₂, ?_, ?_, ?_⟩
  · -- idempotent
    have hdiff : a₂ * a₂ - a₂ ∈ u ⊓ u₁ := by
      have hfac : a₂ * a₂ - a₂ = -(a₂ * a₁) := by
        -- `R` is a bare `CommRing` with no order, so `linarith` cannot apply.
        -- `linear_combination` is the commutative-ring analogue.
        have : a₁ = 1 - a₂ := by linear_combination hsum
        rw [this]; ring
      rw [hfac]
      refine Submodule.neg_mem _ ⟨?_, ?_⟩
      · exact u.mul_mem_left a₂ ha₁
      · exact u₁.mul_mem_right a₁ ha₂
    unfold IsIdempotentElem
    rw [← map_mul, Ideal.Quotient.eq]
    simpa using hdiff
  · -- nonzero
    intro hzero
    rw [Ideal.Quotient.eq_zero_iff_mem] at hzero
    apply hu₁
    rw [Ideal.eq_top_iff_one, ← hsum]
    exact u.add_mem ha₁ hzero.1
  · -- not one
    intro hone
    apply hu₂
    rw [Ideal.eq_top_iff_one, ← hsum]
    have : (1 : A) - a₂ ∈ u ⊓ u₁ := by
      rw [← Ideal.Quotient.eq_zero_iff_mem]
      simp [hone]
    have ha₁' : a₁ ∈ u₁ := by
      have heq : a₁ = 1 - a₂ := by linear_combination hsum
      rw [heq]; exact this.2
    exact u₁.add_mem ha₁' ha₂

end L2Thm010

section L2Thm011
/- --------------------------------------------------------------------------
  011.  Algebraic Geometry
  Source: University of Oregon, Fall 2020, Problem 5(ii)
  Confidence: LOW    - most likely to need Mathlib name/signature adjustment
  Name: colon_eq_vanishingIdeal_sdiff
-------------------------------------------------------------------------- -/

theorem colon_eq_vanishingIdeal_sdiff_l2 {A : Type*} [Field A] [IsAlgClosed A]
    {A₁ : Type*} [Finite A₁] (u u₁ : Ideal (MvPolynomial A₁ A)) (hu : u.IsRadical) :
    u.colon u₁ =
      MvPolynomial.vanishingIdeal A
        (MvPolynomial.zeroLocus A u \ MvPolynomial.zeroLocus A u₁) := by
  apply le_antisymm
  · intro r hr
    rw [MvPolynomial.mem_vanishingIdeal_iff]
    rintro a ⟨haI, haJ⟩
    rw [MvPolynomial.mem_zeroLocus_iff] at haI
    rw [MvPolynomial.mem_zeroLocus_iff] at haJ
    push Not at haJ
    obtain ⟨g, hgJ, hg⟩ := haJ
    have hrg : r * g ∈ u := by
      simpa [smul_eq_mul] using Submodule.mem_colon.mp hr g hgJ
    have : MvPolynomial.eval a r * MvPolynomial.eval a g = 0 := by
      rw [← map_mul]; exact haI _ hrg
    rcases mul_eq_zero.mp this with h | h
    · exact h
    · exact absurd h hg
  · intro r hr
    rw [Submodule.mem_colon]
    intro g hgJ
    rw [smul_eq_mul]
    have hvan : r * g ∈ MvPolynomial.vanishingIdeal A (MvPolynomial.zeroLocus A u) := by
      rw [MvPolynomial.mem_vanishingIdeal_iff]
      intro a haI
      by_cases hJ : a ∈ MvPolynomial.zeroLocus A u₁
      · rw [MvPolynomial.mem_zeroLocus_iff] at hJ
        rw [map_mul, hJ g hgJ, mul_zero]
      · have := (MvPolynomial.mem_vanishingIdeal_iff.mp hr) a ⟨haI, hJ⟩
        rw [map_mul, this, zero_mul]
    rw [MvPolynomial.vanishingIdeal_zeroLocus_eq_radical] at hvan
    exact hu hvan

end L2Thm011

section L2Thm012
/- --------------------------------------------------------------------------
  012.  Ring Theory
  Source: University of Oregon, Fall 2019, Problem 2(b)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: invariant_form_commutator
-------------------------------------------------------------------------- -/

theorem invariant_form_commutator_l2 {A₁ A₂ : Type*} [CommRing A₁] [Ring A₂] [Algebra A₁ A₂] (u₁ u₂ u₃ : A₂) (u : A₂ →ₗ[A₁] A₂ →ₗ[A₁] A₁) (hu₁ : ∀ x y z : A₂, u (x * y) z = u x (y * z)) (hu : ∀ x y : A₂, u x y = u y x) :
    u (u₁ * u₂ - u₂ * u₁) u₃ = u u₁ (u₂ * u₃ - u₃ * u₂) := by
  have h1 : u (u₂ * u₁) u₃ = u u₁ (u₃ * u₂) := by
    rw [hu (u₂ * u₁) u₃, ← hu₁ u₃ u₂ u₁, hu (u₃ * u₂) u₁]
  rw [map_sub, LinearMap.sub_apply, hu₁, h1, ← map_sub]

end L2Thm012

section L2Thm013
/- --------------------------------------------------------------------------
  013.  Ring Theory
  Source: University of Oregon, Winter 2021, Problem 3(a)
  Confidence: MEDIUM - multi-step but standard API
  Name: traceForm_symm_and_assoc
-------------------------------------------------------------------------- -/

theorem traceForm_symm_and_assoc_l2 {A₁ A₂ : Type*} [Field A₁] [Ring A₂] [Algebra A₁ A₂]
    [Module.Finite A₁ A₂] [Module.Free A₁ A₂] (u u₁ u₂ : A₂) :
    LinearMap.trace A₁ A₂ (LinearMap.mulLeft A₁ u * LinearMap.mulLeft A₁ u₁)
        = LinearMap.trace A₁ A₂ (LinearMap.mulLeft A₁ u₁ * LinearMap.mulLeft A₁ u)
      ∧ LinearMap.trace A₁ A₂ (LinearMap.mulLeft A₁ (u * u₁) * LinearMap.mulLeft A₁ u₂)
        = LinearMap.trace A₁ A₂ (LinearMap.mulLeft A₁ u * LinearMap.mulLeft A₁ (u₁ * u₂)) := by
  constructor
  · exact LinearMap.trace_mul_comm A₁ _ _
  · congr 1
    simp [LinearMap.mulLeft_mul, Module.End.mul_eq_comp, LinearMap.comp_assoc]

end L2Thm013

section L2Thm014
/- --------------------------------------------------------------------------
  014.  Ring Theory
  Source: University of Oregon, Winter 2021, Problem 3(b)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: radical_form_two_sided
-------------------------------------------------------------------------- -/

theorem radical_form_two_sided_l2 {A₁ A₂ : Type*} [CommRing A₁] [Ring A₂] [Algebra A₁ A₂] (u : A₂ →ₗ[A₁] A₂ →ₗ[A₁] A₁) {u₁ : A₂} (hu₂ : ∀ b : A₂, u u₁ b = 0) (hu₁ : ∀ x y z : A₂, u (x * y) z = u x (y * z)) (hu : ∀ x y : A₂, u x y = u y x) (u₂ : A₂) :
    (∀ b : A₂, u (u₁ * u₂) b = 0) ∧ (∀ b : A₂, u (u₂ * u₁) b = 0) := by
  constructor
  · intro b
    rw [hu₁]
    exact hu₂ (u₂ * b)
  · intro b
    rw [hu (u₂ * u₁) b, ← hu₁ b u₂ u₁, hu (b * u₂) u₁]
    exact hu₂ (b * u₂)

end L2Thm014

section L2Thm015
/- --------------------------------------------------------------------------
  015.  Linear Algebra
  Source: University of Oregon, Fall 2017, Part II, Problem 1
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: hom_dual_equiv_hom_dual
-------------------------------------------------------------------------- -/

theorem hom_dual_equiv_hom_dual_l2 (A A₁ A₂ : Type*) [Field A] [AddCommGroup A₁] [Module A A₁]
    [AddCommGroup A₂] [Module A A₂] :
    Nonempty ((A₁ →ₗ[A] Module.Dual A A₂) ≃ₗ[A] (A₂ →ₗ[A] Module.Dual A A₁)) :=
  ⟨LinearMap.lflip⟩

end L2Thm015

section L2Thm016
/- --------------------------------------------------------------------------
  016.  Ring Theory
  Source: University of Southern California, Spring 2024, Problem 4
  Confidence: MEDIUM - multi-step but standard API
  Name: map_jacobson_le_jacobson_of_surjective
-------------------------------------------------------------------------- -/

theorem map_jacobson_le_jacobson_of_surjective_l2 {A A₁ : Type*} [CommRing A] [CommRing A₁] {u₁ : A} (u : A →+* A₁) (hu₁ : u₁ ∈ (⊥ : Ideal A).jacobson) (hu : Function.Surjective u) :
    u u₁ ∈ (⊥ : Ideal A₁).jacobson := by
  rw [Ideal.jacobson, Ideal.mem_sInf]
  rintro m ⟨-, hm⟩
  haveI : m.IsMaximal := hm
  have hcomap : (Ideal.comap u m).IsMaximal := Ideal.comap_isMaximal_of_surjective u hu
  rw [Ideal.jacobson, Ideal.mem_sInf] at hu₁
  exact hu₁ ⟨bot_le, hcomap⟩

end L2Thm016

section L2Thm017
/- --------------------------------------------------------------------------
  017.  Commutative Algebra
  Source: University of Southern California, Spring 2024, Problem 3
  Confidence: MEDIUM - multi-step but standard API
  Name: dvd_pow_of_vanishes_on_zeroLocus
-------------------------------------------------------------------------- -/

theorem dvd_pow_of_vanishes_on_zeroLocus_l2 {u : ℕ} (u₁ u₂ : MvPolynomial (Fin u) ℂ)
    (hu : ∀ z : Fin u → ℂ, MvPolynomial.eval z u₁ = 0 → MvPolynomial.eval z u₂ = 0) :
    ∃ m : ℕ, u₁ ∣ u₂ ^ m := by
  have hg : u₂ ∈ MvPolynomial.vanishingIdeal ℂ
      (MvPolynomial.zeroLocus ℂ (Ideal.span {u₁} : Ideal (MvPolynomial (Fin u) ℂ))) := by
    rw [MvPolynomial.mem_vanishingIdeal_iff]
    intro z hz
    rw [MvPolynomial.mem_zeroLocus_iff] at hz
    exact hu z (hz u₁ (Ideal.subset_span (Set.mem_singleton u₁)))
  rw [MvPolynomial.vanishingIdeal_zeroLocus_eq_radical, Ideal.mem_radical_iff] at hg
  obtain ⟨m, hm⟩ := hg
  exact ⟨m, Ideal.mem_span_singleton.mp hm⟩

end L2Thm017

section L2Thm018
/- --------------------------------------------------------------------------
  018.  Group Theory
  Source: University of Southern California, Fall 2023, Problem 6(a)
  Confidence: LOW    - most likely to need Mathlib name/signature adjustment
  Name: commutator_normal_and_quotient_comm
-------------------------------------------------------------------------- -/

-- `Bracket G G` (the element-level `⁅g₁, g₂⁆`) is a *scoped* instance:
-- `attribute [scoped instance] commutatorElement` in Mathlib/Algebra/Group/Commutator.lean.
-- `import Mathlib` alone does not bring it into scope.
open scoped commutatorElement

theorem commutator_normal_and_quotient_comm_l2 (A : Type*) [Group A] :
    (commutator A).Normal ∧ ∀ x y : A ⧸ commutator A, x * y = y * x := by
  refine ⟨inferInstance, ?_⟩
  intro x y
  induction x using QuotientGroup.induction_on with
  | H a =>
    induction y using QuotientGroup.induction_on with
    | H b =>
      rw [← QuotientGroup.mk_mul, ← QuotientGroup.mk_mul, QuotientGroup.eq]
      have hrw : (a * b)⁻¹ * (b * a) = ⁅b⁻¹, a⁻¹⁆ := by
        rw [commutatorElement_def]; group
      rw [hrw]
      exact Subgroup.commutator_mem_commutator (Subgroup.mem_top _) (Subgroup.mem_top _)

end L2Thm018

section L2Thm019
/- --------------------------------------------------------------------------
  019.  Group Theory
  Source: University of Southern California, Fall 2023, Problem 6(b)
  Confidence: LOW    - most likely to need Mathlib name/signature adjustment
  Name: commutator_le_of_quotient_comm
-------------------------------------------------------------------------- -/

theorem commutator_le_of_quotient_comm_l2 {A : Type*} [Group A] (u : Subgroup A) [u.Normal]
    (hu : ∀ x y : A ⧸ u, x * y = y * x) : commutator A ≤ u := by
  rw [commutator_def, Subgroup.commutator_le]
  intro a _ b _
  rw [← QuotientGroup.eq_one_iff, commutatorElement_def]
  simp only [QuotientGroup.mk_mul, QuotientGroup.mk_inv]
  rw [hu ((a : A ⧸ u)) ((b : A ⧸ u))]
  group

end L2Thm019

section L2Thm020
/- --------------------------------------------------------------------------
  020.  Commutative Algebra
  Source: University of Southern California, Fall 2021, Problem 4 (first part)
  Confidence: MEDIUM - multi-step but standard API
  Name: isUnit_one_sub_of_mem_maximalIdeal
-------------------------------------------------------------------------- -/

theorem isUnit_one_sub_of_mem_maximalIdeal_l2 {A : Type*} [CommRing A] [IsLocalRing A]
    {u : A} (hu : u ∈ IsLocalRing.maximalIdeal A) : IsUnit (1 - u) := by
  by_contra h
  have h1 : (1 - u) ∈ IsLocalRing.maximalIdeal A :=
    (IsLocalRing.mem_maximalIdeal _).mpr (mem_nonunits_iff.mpr h)
  have hone : (1 : A) ∈ IsLocalRing.maximalIdeal A := by
    have := Ideal.add_mem (IsLocalRing.maximalIdeal A) h1 hu
    simpa using this
  exact (Ideal.ne_top_iff_one _).mp
    (IsLocalRing.maximalIdeal.isMaximal A).ne_top hone

end L2Thm020

section L2Thm021
/- --------------------------------------------------------------------------
  021.  Commutative Algebra
  Source: University of Southern California, Fall 2021, Problem 4 (second part)
  Confidence: MEDIUM - multi-step but standard API
  Name: ideal_eq_bot_of_sq_eq_self
-------------------------------------------------------------------------- -/

theorem ideal_eq_bot_of_sq_eq_self_l2 {A : Type*} [CommRing A] [IsLocalRing A] [IsNoetherianRing A] (u : Ideal A) (hu₁ : u * u = u) (hu : u ≠ ⊤) : u = ⊥ := by
  have hfg : (u : Submodule A A).FG := IsNoetherian.noetherian u
  have hsub : u ≤ IsLocalRing.maximalIdeal A := IsLocalRing.le_maximalIdeal hu
  have hle : u ≤ IsLocalRing.maximalIdeal A • u := by
    rw [Ideal.smul_eq_mul]
    calc u = u * u := hu₁.symm
      _ ≤ IsLocalRing.maximalIdeal A * u := Ideal.mul_mono_left hsub
  refine Submodule.eq_bot_of_le_smul_of_le_jacobson_bot _ u hfg hle ?_
  exact le_of_eq (IsLocalRing.jacobson_eq_maximalIdeal ⊥ bot_ne_top).symm

end L2Thm021

section L2Thm022
/- --------------------------------------------------------------------------
  022.  Commutative Algebra
  Source: University of California, Los Angeles, Problem 3 (Noetherian domain factorization)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: exists_irreducible_factors_of_noetherian_domain
-------------------------------------------------------------------------- -/

theorem exists_irreducible_factors_of_noetherian_domain_l2
    {A : Type*} [CommRing A] [IsDomain A] [IsNoetherianRing A] {u : A} (hu : u ≠ 0) :
    ∃ f : Multiset A, (∀ b ∈ f, Irreducible b) ∧ Associated f.prod u :=
  WfDvdMonoid.exists_factors u hu

end L2Thm022

section L2Thm023
/- --------------------------------------------------------------------------
  023.  Field Theory
  Source: University of California, Los Angeles, Problem (finite field cardinality)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: finite_field_card_eq_prime_pow
-------------------------------------------------------------------------- -/

theorem finite_field_card_eq_prime_pow_l2 (A : Type*) [Field A] [Fintype A] :
    ∃ p n : ℕ, p.Prime ∧ 0 < n ∧ Fintype.card A = p ^ n := by
  -- `FiniteField.card'` is `∃ p, CharP K p ∧ ∃ n : ℕ+, p.Prime ∧ card K = p ^ n`,
  -- so the char-p witness must be bound before `n`.
  obtain ⟨p, _hchar, n, hp, hcard⟩ := FiniteField.card' A
  exact ⟨p, (n : ℕ), hp, n.property, hcard⟩

end L2Thm023

section L2Thm024
/- --------------------------------------------------------------------------
  024.  Commutative Algebra
  Source: University of Southern California, Spring 2020, Problem 3(a)
  Confidence: MEDIUM - multi-step but standard API
  Name: localization_injective_of_domain
-------------------------------------------------------------------------- -/

theorem localization_injective_of_domain_l2 {A : Type*} [CommRing A] [IsDomain A]
    (u : Submonoid A) (hu : (0 : A) ∉ u) :
    Function.Injective (algebraMap A (Localization u)) := by
  have hS' : u ≤ nonZeroDivisors A := by
    intro s hs
    rw [mem_nonZeroDivisors_iff_ne_zero]
    rintro rfl
    exact hu hs
  exact IsLocalization.injective (Localization u) hS'

end L2Thm024

section L2Thm025
/- --------------------------------------------------------------------------
  025.  Field Theory
  Source: University of Oregon, Fall 2017, Part II, Problem 5
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: fixedPoints_isIntegral
-------------------------------------------------------------------------- -/

-- `FixedPoints.isIntegral` (Mathlib/FieldTheory/Fixed.lean:251) only requires
-- `[Finite G]`; it derives a `Fintype` internally via `nonempty_fintype`. So the
-- weaker, more general `[Finite G]` is the right hypothesis here.
theorem fixedPoints_isIntegral_l2 (A : Type*) [Group A] [Finite A] (A₁ : Type*) [Field A₁]
    [MulSemiringAction A A₁] (u : A₁) : IsIntegral (FixedPoints.subfield A A₁) u :=
  FixedPoints.isIntegral A A₁ u

end L2Thm025

section L2Thm026
/- --------------------------------------------------------------------------
  026.  Commutative Algebra
  Source: University of Southern California, Spring 2020, Problem 5
  Confidence: MEDIUM - multi-step but standard API
  Name: radical_span_singleton_eq_iff_dvd_pow
-------------------------------------------------------------------------- -/

theorem radical_span_singleton_eq_iff_dvd_pow_l2 {A : Type*} [CommRing A] (u u₁ : A) :
    Ideal.radical (Ideal.span {u}) = Ideal.radical (Ideal.span {u₁}) ↔
      ((∃ M : ℕ, u₁ ∣ u ^ M) ∧ (∃ N : ℕ, u ∣ u₁ ^ N)) := by
  constructor
  · intro h
    constructor
    · have hf : u ∈ Ideal.radical (Ideal.span {u₁}) := by
        rw [← h]
        exact Ideal.le_radical (Ideal.mem_span_singleton_self u)
      obtain ⟨M, hM⟩ := hf
      exact ⟨M, Ideal.mem_span_singleton.mp hM⟩
    · have hg : u₁ ∈ Ideal.radical (Ideal.span {u}) := by
        rw [h]
        exact Ideal.le_radical (Ideal.mem_span_singleton_self u₁)
      obtain ⟨N, hN⟩ := hg
      exact ⟨N, Ideal.mem_span_singleton.mp hN⟩
  · rintro ⟨⟨M, hM⟩, ⟨N, hN⟩⟩
    apply le_antisymm
    · apply Ideal.radical_le_radical_iff.mpr
      rw [Ideal.span_le, Set.singleton_subset_iff]
      exact ⟨M, Ideal.mem_span_singleton.mpr hM⟩
    · apply Ideal.radical_le_radical_iff.mpr
      rw [Ideal.span_le, Set.singleton_subset_iff]
      exact ⟨N, Ideal.mem_span_singleton.mpr hN⟩

end L2Thm026

section L2Thm027
/- --------------------------------------------------------------------------
  027.  Module Theory
  Source: University of Southern California, Fall 2020, Problem 5
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: free_of_finite_torsionFree_over_pid
-------------------------------------------------------------------------- -/

theorem free_of_finite_torsionFree_over_pid_l2 {A A₁ : Type*} [CommRing A] [IsDomain A]
    [IsPrincipalIdealRing A] [AddCommGroup A₁] [Module A A₁] [Module.Finite A A₁]
    [NoZeroSMulDivisors A A₁] : Module.Free A A₁ :=
  Module.free_of_finite_type_torsion_free'

end L2Thm027

section L2Thm028
/- --------------------------------------------------------------------------
  028.  Group Theory
  Source: University of Southern California, Spring 2020, Problem 2(a)
  Confidence: LOW    - most likely to need Mathlib name/signature adjustment
  Name: exists_fixedPointFree_of_pretransitive
-------------------------------------------------------------------------- -/

open MulAction Finset

-- `[Fintype G]` is not needed in the statement, only in the counting argument
-- below. State it with the weaker `[Finite G]` and materialize a `Fintype`
-- inside the proof, where the Burnside sum over `G` requires it.
theorem exists_fixedPointFree_of_pretransitive_l2 {A A₁ : Type*} [Group A] [Finite A]
    [MulAction A A₁] [Fintype A₁] [MulAction.IsPretransitive A A₁] [Nonempty A₁]
    (hu : 1 < Fintype.card A₁) : ∃ g : A, ∀ x : A₁, g • x ≠ x := by
  classical
  haveI : Fintype A := Fintype.ofFinite A
  by_contra hcon
  push Not at hcon
  -- every g fixes some point, so every fixedBy set is nonempty
  have hpos : ∀ g : A, 1 ≤ Fintype.card (fixedBy A₁ g) := by
    intro g
    obtain ⟨x, hx⟩ := hcon g
    exact Fintype.card_pos_iff.mpr ⟨⟨x, hx⟩⟩
  -- Burnside: the sum of fixed points equals (number of orbits) * |G| = |G|
  have hburn : ∑ g : A, Fintype.card (fixedBy A₁ g)
      = Fintype.card (orbitRel.Quotient A A₁) * Fintype.card A :=
    sum_card_fixedBy_eq_card_orbits_mul_card_group A A₁
  have horb : Fintype.card (orbitRel.Quotient A A₁) = 1 := by
    rw [Fintype.card_eq_one_iff]
    obtain ⟨x⟩ := ‹Nonempty A₁›
    refine ⟨Quotient.mk'' x, ?_⟩
    intro y
    induction y using Quotient.inductionOn' with
    -- `orbitRel` is `r a b := a ∈ orbit G b`, i.e. `z ≈ x ↔ ∃ g, g • x = z`,
    -- so the arguments run x-then-z, not z-then-x.
    | h z => exact Quotient.sound' (MulAction.exists_smul_eq A x z)
  rw [horb, one_mul] at hburn
  -- but the identity alone contributes card X > 1, and every other term is ≥ 1
  have hid : Fintype.card (fixedBy A₁ (1 : A)) = Fintype.card A₁ := by
    simp [fixedBy]
  have hlt : Fintype.card A < ∑ g : A, Fintype.card (fixedBy A₁ g) := by
    calc Fintype.card A
        = ∑ _g : A, 1 := by simp
      _ < ∑ g : A, Fintype.card (fixedBy A₁ g) := by
          refine Finset.sum_lt_sum (fun g _ => hpos g) ⟨1, Finset.mem_univ 1, ?_⟩
          rw [hid]
          exact hu
  omega

end L2Thm028

section L2Thm029
/- --------------------------------------------------------------------------
  029.  Module Theory
  Source: University of Southern California, Fall 2022, Problem 2
  Confidence: LOW    - most likely to need Mathlib name/signature adjustment
  Name: ker_projective_of_span_eq_top
-------------------------------------------------------------------------- -/

theorem ker_projective_of_span_eq_top_l2 {A : Type*} [CommRing A] {u : ℕ} (u₁ : Fin u → A)
    (hu : Ideal.span (Set.range u₁) = ⊤) :
    Function.Surjective (Fintype.linearCombination A u₁) ∧
      Module.Projective A (LinearMap.ker (Fintype.linearCombination A u₁)) := by
  classical
  set f := Fintype.linearCombination A u₁ with hf
  -- extract a partition of unity
  have h1 : (1 : A) ∈ Ideal.span (Set.range u₁) := by rw [hu]; trivial
  rw [Ideal.mem_span_range_iff_exists_fun] at h1
  obtain ⟨c, hc⟩ := h1
  -- the splitting
  let s : A →ₗ[A] (Fin u → A) :=
    { toFun := fun x i => x * c i
      -- after `funext i` the RHS is still `(g + h) i`; `Pi.add_apply` is what
      -- lets `ring` see `x * c i + y * c i`.
      map_add' := by intro x y; funext i; simp only [Pi.add_apply]; ring
      map_smul' := by intro a x; funext i; simp [smul_eq_mul]; ring }
  have hfs : ∀ x : A, f (s x) = x := by
    intro x
    simp only [hf, s, Fintype.linearCombination_apply, LinearMap.coe_mk, AddHom.coe_mk,
      smul_eq_mul]
    calc ∑ i, x * c i * u₁ i = x * ∑ i, c i * u₁ i := by
          rw [Finset.mul_sum]; exact Finset.sum_congr rfl (fun i _ => by ring)
      _ = x := by rw [hc]; ring
  have hsurj : Function.Surjective f := fun x => ⟨s x, hfs x⟩
  refine ⟨hsurj, ?_⟩
  -- ker f is a direct summand of the free module (Fin n → R)
  let p : (Fin u → A) →ₗ[A] (Fin u → A) := LinearMap.id - s.comp f
  have hp : ∀ v, p v ∈ LinearMap.ker f := by
    intro v
    simp only [p, LinearMap.sub_apply, LinearMap.id_apply, LinearMap.comp_apply,
      LinearMap.mem_ker, map_sub, hfs]
    ring
  let q : (Fin u → A) →ₗ[A] LinearMap.ker f := p.codRestrict (LinearMap.ker f) hp
  refine Module.Projective.of_split (LinearMap.ker f).subtype q ?_
  ext w
  have hw : f w.1 = 0 := w.2
  simp [q, p, hw]

end L2Thm029

section L2Thm030
/- --------------------------------------------------------------------------
  030.  Ring Theory
  Source: University of California, Los Angeles, Problem (f.g. module, surjective endomorphism)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: injective_of_surjective_endomorphism_of_finite
-------------------------------------------------------------------------- -/

theorem injective_of_surjective_endomorphism_of_finite_l2
    {A A₁ : Type*} [CommRing A] [AddCommGroup A₁] [Module A A₁] [Module.Finite A A₁]
    (u : A₁ →ₗ[A] A₁) (hu : Function.Surjective u) : Function.Injective u :=
  -- `[CommRing R]` supplies `OrzechProperty R` via the instance in
  -- Mathlib/RingTheory/FiniteType.lean:635.
  OrzechProperty.injective_of_surjective_endomorphism u hu

end L2Thm030

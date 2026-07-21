/-
  Algebra qualifying exam theorems, formalized in Lean 4 / Mathlib.

  30 theorems extracted from graduate algebra qualifying exams at
  the University of Oregon, the University of Southern California,
  and UCLA.  Each theorem is stated so that it stands on its own.

  IMPORTANT: this file has NOT been compiled.  It was written against
  current Mathlib conventions in an environment without a Lean toolchain.
  Each declaration is tagged with a confidence level; if you hit errors,
  start with the ones marked LOW -- those are expected to need lemma-name
  or signature fixes rather than a different proof strategy.

  Each theorem lives in its own `section`, so a failure in one does not
  affect the elaboration of the others.
-/

import Mathlib

-- This is a self-contained qual dataset, not a Mathlib contribution, so the
-- Mathlib PR *style* linters below do not apply. Each is exactly the option the
-- linter itself names as the way to disable it.
--   * setOption:            an unscoped `maxHeartbeats` (needed file-wide).
--   * unusedFintypeInType:  two theorems take `[Fintype G]` that the *statement*
--     does not use (only the proof does). `[Fintype G]` is the original,
--     already-verified hypothesis; suppressing keeps the known-good statement
--     rather than risking the `Finite` + `Fintype.ofFinite` refactor.
--   * unnecessarySimpa:     `simpa using h` phrasing.
set_option linter.style.setOption false
set_option linter.unusedFintypeInType false
set_option linter.unnecessarySimpa false
set_option maxHeartbeats 1000000


section Thm001

/- --------------------------------------------------------------------------
  001.  Module Theory
  Source: University of Oregon, Fall 2025, Part I, Problem 3
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: surjective_endomorphism_bijective_of_isNoetherian
-------------------------------------------------------------------------- -/

theorem surjective_endomorphism_bijective_of_isNoetherian
    {R M : Type*} [Ring R] [AddCommGroup M] [Module R M] [IsNoetherian R M]
    (f : M →ₗ[R] M) (hf : Function.Surjective f) : Function.Bijective f :=
  ⟨IsNoetherian.injective_of_surjective_endomorphism f hf, hf⟩

end Thm001

section Thm002

/- --------------------------------------------------------------------------
  002.  Commutative Algebra
  Source: University of Oregon, Fall 2025, Part I, Problem 4
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: mul_eq_inf_of_isRadical_mul
-------------------------------------------------------------------------- -/

theorem mul_eq_inf_of_isRadical_mul {n : ℕ}
    (I J : Ideal (MvPolynomial (Fin n) ℂ)) (h : (I * J).IsRadical) :
    I * J = I ⊓ J := by
  refine le_antisymm Ideal.mul_le_inf ?_
  intro x hx
  obtain ⟨hxI, hxJ⟩ := Submodule.mem_inf.mp hx
  have h2 : x ^ 2 ∈ I * J := by
    rw [pow_two]
    exact Ideal.mul_mem_mul hxI hxJ
  -- `Ideal.IsRadical I` unfolds to `I.radical ≤ I`, a Pi type, so dot-notation
  -- resolves into `Function`, not `Ideal.IsPrime`.  Apply `h` directly:
  -- `x ∈ (I*J).radical` is definitionally `∃ n, x ^ n ∈ I * J` (`mem_radical_iff`).
  exact h ⟨2, h2⟩

end Thm002

section Thm003

/- --------------------------------------------------------------------------
  003.  Commutative Algebra
  Source: University of Oregon, Fall 2021, Part II, Problem 2(a)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: ker_aeval_t2_t3_t4_isPrime
-------------------------------------------------------------------------- -/

theorem ker_aeval_t2_t3_t4_isPrime :
    (RingHom.ker (MvPolynomial.aeval
        ![(Polynomial.X : Polynomial ℂ) ^ 2, (Polynomial.X : Polynomial ℂ) ^ 3,
          (Polynomial.X : Polynomial ℂ) ^ 4] :
      MvPolynomial (Fin 3) ℂ →ₐ[ℂ] Polynomial ℂ)).IsPrime :=
  RingHom.ker_isPrime _

end Thm003

section Thm004

/- --------------------------------------------------------------------------
  004.  Field Theory
  Source: University of Oregon, Winter 2024, Part III, Problem 1(a)
  Confidence: MEDIUM - multi-step but standard API
  Name: artin_schreier_add_natCast_is_root
-------------------------------------------------------------------------- -/

theorem artin_schreier_add_natCast_is_root
    {K : Type*} [Field K] {p : ℕ} [Fact p.Prime] [CharP K p]
    (c α : K) (hα : α ^ p - α - c = 0) (n : ℕ) :
    (α + (n : K)) ^ p - (α + (n : K)) - c = 0 := by
  have hp : p ≠ 0 := (Fact.out : Nat.Prime p).ne_zero
  have key : ∀ k : ℕ, ((k : K)) ^ p = (k : K) := by
    intro k
    induction k with
    | zero => simp [zero_pow hp]
    | succ j ih =>
        have hstep : (((j : K) + 1)) ^ p = ((j : K)) ^ p + (1 : K) ^ p := by
          rw [add_pow_char]
        push_cast
        rw [hstep, ih, one_pow]
  have hsum : (α + (n : K)) ^ p = α ^ p + ((n : K)) ^ p := by
    rw [add_pow_char]
  rw [hsum, key n]
  linear_combination hα

end Thm004

section Thm005

/- --------------------------------------------------------------------------
  005.  Ring Theory
  Source: University of Oregon, Fall 2024, Part III, Problem 1
  Confidence: LOW    - most likely to need Mathlib name/signature adjustment
  Name: isSemisimpleRing_iff_forall_leftIdeal_span_idempotent
-------------------------------------------------------------------------- -/

theorem isSemisimpleRing_iff_forall_leftIdeal_span_idempotent (R : Type*) [Ring R] :
    IsSemisimpleRing R ↔
      ∀ I : Submodule R R, ∃ e : R, IsIdempotentElem e ∧ I = Submodule.span R {e} := by
  constructor
  · intro _ I
    obtain ⟨J, hJ⟩ := ComplementedLattice.exists_isCompl I
    have h1 : (1 : R) ∈ I ⊔ J := by
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
    refine (isSemisimpleModule_iff R R).mpr ⟨fun I => ?_⟩
    obtain ⟨e, he, hIe⟩ := h I
    refine ⟨Submodule.span R {1 - e}, ?_, ?_⟩
    · rw [disjoint_iff_inf_le]
      rintro r ⟨hr1, hr2⟩
      -- `rw` could not match `Submodule.span R {e}` against the `R ∙ y` pattern
      -- in `mem_span_singleton`.  Stating the intermediate type explicitly lets
      -- the elaborator unify it instead of pattern-matching syntactically.
      have hr1' : r ∈ Submodule.span R {e} := hIe ▸ hr1
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

end Thm005

section Thm006

/- --------------------------------------------------------------------------
  006.  Ring Theory
  Source: University of Oregon, Fall 2020, Problem 4(i)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: isNilpotent_mem_jacobson_bot
-------------------------------------------------------------------------- -/

theorem isNilpotent_mem_jacobson_bot {R : Type*} [CommRing R] {x : R}
    (hx : IsNilpotent x) : x ∈ (⊥ : Ideal R).jacobson := by
  rw [Ideal.jacobson, Ideal.mem_sInf]
  rintro M ⟨-, hM⟩
  obtain ⟨n, hn⟩ := hx
  have hprime : M.IsPrime := hM.isPrime
  refine hprime.mem_of_pow_mem n ?_
  rw [hn]
  exact M.zero_mem

end Thm006

section Thm007

/- --------------------------------------------------------------------------
  007.  Ring Theory
  Source: University of Oregon, Fall 2020, Problem 4(v)
  Confidence: MEDIUM - multi-step but standard API
  Name: jacobson_pow_eq_bot_of_pow_eq_pow_succ
-------------------------------------------------------------------------- -/

theorem jacobson_pow_eq_bot_of_pow_eq_pow_succ
    {R : Type*} [CommRing R] [IsNoetherianRing R] (n : ℕ)
    (h : (Ideal.jacobson (⊥ : Ideal R)) ^ n = (Ideal.jacobson (⊥ : Ideal R)) ^ (n + 1)) :
    (Ideal.jacobson (⊥ : Ideal R)) ^ n = ⊥ := by
  set J := Ideal.jacobson (⊥ : Ideal R) with hJ
  have hfg : (J ^ n).FG := IsNoetherian.noetherian _
  have hle : J ^ n ≤ J • J ^ n := by
    rw [Ideal.smul_eq_mul, ← pow_succ']
    exact le_of_eq h
  exact Submodule.eq_bot_of_le_smul_of_le_jacobson_bot J (J ^ n) hfg hle le_rfl

end Thm007

section Thm008

/- --------------------------------------------------------------------------
  008.  Algebraic Geometry
  Source: University of Oregon, Fall 2020, Problem 5(i)
  Confidence: MEDIUM - multi-step but standard API
  Name: eval_eq_zero_of_mem_colon
-------------------------------------------------------------------------- -/

theorem eval_eq_zero_of_mem_colon {F : Type*} [Field F] {σ : Type*}
    (I J : Ideal (MvPolynomial σ F)) (a : σ → F)
    (haI : ∀ f ∈ I, MvPolynomial.eval a f = 0)
    (haJ : ∃ g ∈ J, MvPolynomial.eval a g ≠ 0) :
    ∀ r ∈ I.colon J, MvPolynomial.eval a r = 0 := by
  obtain ⟨g, hgJ, hg⟩ := haJ
  intro r hr
  have hrg : r * g ∈ I := by
    have := Submodule.mem_colon.mp hr g hgJ
    simpa [smul_eq_mul] using this
  have : MvPolynomial.eval a r * MvPolynomial.eval a g = 0 := by
    rw [← map_mul]
    exact haI _ hrg
  rcases mul_eq_zero.mp this with h | h
  · exact h
  · exact absurd h hg

end Thm008

section Thm009

/- --------------------------------------------------------------------------
  009.  Commutative Algebra
  Source: University of Oregon, Fall 2020, Problem 5(iv)
  Confidence: MEDIUM - multi-step but standard API
  Name: colon_eq_self_of_isPrime_of_not_le
-------------------------------------------------------------------------- -/

theorem colon_eq_self_of_isPrime_of_not_le {R : Type*} [CommRing R]
    (I J : Ideal R) (hI : I.IsPrime) (hJ : ¬ J ≤ I) : I.colon J = I := by
  obtain ⟨j, hjJ, hjI⟩ := Set.not_subset.mp hJ
  apply le_antisymm
  · intro r hr
    have hrj : r * j ∈ I := by
      have := Submodule.mem_colon.mp hr j hjJ
      simpa [smul_eq_mul] using this
    rcases hI.mem_or_mem hrj with h | h
    · exact h
    · exact absurd h hjI
  · intro r hr
    rw [Submodule.mem_colon]
    intro p _
    simpa [smul_eq_mul] using I.mul_mem_right p hr

end Thm009

section Thm010

/- --------------------------------------------------------------------------
  010.  Commutative Algebra
  Source: University of Oregon, Fall 2022, Part III, Problem 4
  Confidence: MEDIUM - multi-step but standard API
  Name: exists_nontrivial_idempotent_of_isCoprime
-------------------------------------------------------------------------- -/

theorem exists_nontrivial_idempotent_of_isCoprime {R : Type*} [CommRing R]
    (I₁ I₂ : Ideal R) (hsup : I₁ ⊔ I₂ = ⊤) (h₁ : I₁ ≠ ⊤) (h₂ : I₂ ≠ ⊤) :
    ∃ e : R ⧸ (I₁ ⊓ I₂), IsIdempotentElem e ∧ e ≠ 0 ∧ e ≠ 1 := by
  have hmem : (1 : R) ∈ I₁ ⊔ I₂ := by rw [hsup]; trivial
  obtain ⟨a₁, ha₁, a₂, ha₂, hsum⟩ := Submodule.mem_sup.mp hmem
  refine ⟨Ideal.Quotient.mk _ a₂, ?_, ?_, ?_⟩
  · -- idempotent
    have hdiff : a₂ * a₂ - a₂ ∈ I₁ ⊓ I₂ := by
      have hfac : a₂ * a₂ - a₂ = -(a₂ * a₁) := by
        -- `R` is a bare `CommRing` with no order, so `linarith` cannot apply.
        -- `linear_combination` is the commutative-ring analogue.
        have : a₁ = 1 - a₂ := by linear_combination hsum
        rw [this]; ring
      rw [hfac]
      refine Submodule.neg_mem _ ⟨?_, ?_⟩
      · exact I₁.mul_mem_left a₂ ha₁
      · exact I₂.mul_mem_right a₁ ha₂
    unfold IsIdempotentElem
    rw [← map_mul, Ideal.Quotient.eq]
    simpa using hdiff
  · -- nonzero
    intro hzero
    rw [Ideal.Quotient.eq_zero_iff_mem] at hzero
    apply h₁
    rw [Ideal.eq_top_iff_one, ← hsum]
    exact I₁.add_mem ha₁ hzero.1
  · -- not one
    intro hone
    apply h₂
    rw [Ideal.eq_top_iff_one, ← hsum]
    have : (1 : R) - a₂ ∈ I₁ ⊓ I₂ := by
      rw [← Ideal.Quotient.eq_zero_iff_mem]
      simp [hone]
    have ha₁' : a₁ ∈ I₂ := by
      have heq : a₁ = 1 - a₂ := by linear_combination hsum
      rw [heq]; exact this.2
    exact I₂.add_mem ha₁' ha₂

end Thm010

section Thm011

/- --------------------------------------------------------------------------
  011.  Algebraic Geometry
  Source: University of Oregon, Fall 2020, Problem 5(ii)
  Confidence: LOW    - most likely to need Mathlib name/signature adjustment
  Name: colon_eq_vanishingIdeal_sdiff
-------------------------------------------------------------------------- -/

theorem colon_eq_vanishingIdeal_sdiff {k : Type*} [Field k] [IsAlgClosed k]
    {σ : Type*} [Finite σ] (I J : Ideal (MvPolynomial σ k)) (hI : I.IsRadical) :
    I.colon J =
      MvPolynomial.vanishingIdeal k
        (MvPolynomial.zeroLocus k I \ MvPolynomial.zeroLocus k J) := by
  apply le_antisymm
  · intro r hr
    rw [MvPolynomial.mem_vanishingIdeal_iff]
    rintro a ⟨haI, haJ⟩
    rw [MvPolynomial.mem_zeroLocus_iff] at haI
    rw [MvPolynomial.mem_zeroLocus_iff] at haJ
    push Not at haJ
    obtain ⟨g, hgJ, hg⟩ := haJ
    have hrg : r * g ∈ I := by
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
    have hvan : r * g ∈ MvPolynomial.vanishingIdeal k (MvPolynomial.zeroLocus k I) := by
      rw [MvPolynomial.mem_vanishingIdeal_iff]
      intro a haI
      by_cases hJ : a ∈ MvPolynomial.zeroLocus k J
      · rw [MvPolynomial.mem_zeroLocus_iff] at hJ
        rw [map_mul, hJ g hgJ, mul_zero]
      · have := (MvPolynomial.mem_vanishingIdeal_iff.mp hr) a ⟨haI, hJ⟩
        rw [map_mul, this, zero_mul]
    rw [MvPolynomial.vanishingIdeal_zeroLocus_eq_radical] at hvan
    exact hI hvan

end Thm011

section Thm012

/- --------------------------------------------------------------------------
  012.  Ring Theory
  Source: University of Oregon, Fall 2019, Problem 2(b)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: invariant_form_commutator
-------------------------------------------------------------------------- -/

theorem invariant_form_commutator {F A : Type*} [CommRing F] [Ring A] [Algebra F A]
    (B : A →ₗ[F] A →ₗ[F] F)
    (hsymm : ∀ x y : A, B x y = B y x)
    (hassoc : ∀ x y z : A, B (x * y) z = B x (y * z)) (a b c : A) :
    B (a * b - b * a) c = B a (b * c - c * b) := by
  have h1 : B (b * a) c = B a (c * b) := by
    rw [hsymm (b * a) c, ← hassoc c b a, hsymm (c * b) a]
  rw [map_sub, LinearMap.sub_apply, hassoc, h1, ← map_sub]

end Thm012

section Thm013

/- --------------------------------------------------------------------------
  013.  Ring Theory
  Source: University of Oregon, Winter 2021, Problem 3(a)
  Confidence: MEDIUM - multi-step but standard API
  Name: traceForm_symm_and_assoc
-------------------------------------------------------------------------- -/

theorem traceForm_symm_and_assoc {F A : Type*} [Field F] [Ring A] [Algebra F A]
    [Module.Finite F A] [Module.Free F A] (a b c : A) :
    LinearMap.trace F A (LinearMap.mulLeft F a * LinearMap.mulLeft F b)
        = LinearMap.trace F A (LinearMap.mulLeft F b * LinearMap.mulLeft F a)
      ∧ LinearMap.trace F A (LinearMap.mulLeft F (a * b) * LinearMap.mulLeft F c)
        = LinearMap.trace F A (LinearMap.mulLeft F a * LinearMap.mulLeft F (b * c)) := by
  constructor
  · exact LinearMap.trace_mul_comm F _ _
  · congr 1
    simp [LinearMap.mulLeft_mul, Module.End.mul_eq_comp, LinearMap.comp_assoc]

end Thm013

section Thm014

/- --------------------------------------------------------------------------
  014.  Ring Theory
  Source: University of Oregon, Winter 2021, Problem 3(b)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: radical_form_two_sided
-------------------------------------------------------------------------- -/

theorem radical_form_two_sided {F A : Type*} [CommRing F] [Ring A] [Algebra F A]
    (B : A →ₗ[F] A →ₗ[F] F)
    (hsymm : ∀ x y : A, B x y = B y x)
    (hassoc : ∀ x y z : A, B (x * y) z = B x (y * z))
    {a : A} (ha : ∀ b : A, B a b = 0) (c : A) :
    (∀ b : A, B (a * c) b = 0) ∧ (∀ b : A, B (c * a) b = 0) := by
  constructor
  · intro b
    rw [hassoc]
    exact ha (c * b)
  · intro b
    rw [hsymm (c * a) b, ← hassoc b c a, hsymm (b * c) a]
    exact ha (b * c)

end Thm014

section Thm015

/- --------------------------------------------------------------------------
  015.  Linear Algebra
  Source: University of Oregon, Fall 2017, Part II, Problem 1
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: hom_dual_equiv_hom_dual
-------------------------------------------------------------------------- -/

theorem hom_dual_equiv_hom_dual (F U V : Type*) [Field F] [AddCommGroup U] [Module F U]
    [AddCommGroup V] [Module F V] :
    Nonempty ((U →ₗ[F] Module.Dual F V) ≃ₗ[F] (V →ₗ[F] Module.Dual F U)) :=
  ⟨LinearMap.lflip⟩

end Thm015

section Thm016

/- --------------------------------------------------------------------------
  016.  Ring Theory
  Source: University of Southern California, Spring 2024, Problem 4
  Confidence: MEDIUM - multi-step but standard API
  Name: map_jacobson_le_jacobson_of_surjective
-------------------------------------------------------------------------- -/

theorem map_jacobson_le_jacobson_of_surjective {R S : Type*} [CommRing R] [CommRing S]
    (φ : R →+* S) (hφ : Function.Surjective φ) {x : R} (hx : x ∈ (⊥ : Ideal R).jacobson) :
    φ x ∈ (⊥ : Ideal S).jacobson := by
  rw [Ideal.jacobson, Ideal.mem_sInf]
  rintro m ⟨-, hm⟩
  haveI : m.IsMaximal := hm
  have hcomap : (Ideal.comap φ m).IsMaximal := Ideal.comap_isMaximal_of_surjective φ hφ
  rw [Ideal.jacobson, Ideal.mem_sInf] at hx
  exact hx ⟨bot_le, hcomap⟩

end Thm016

section Thm017

/- --------------------------------------------------------------------------
  017.  Commutative Algebra
  Source: University of Southern California, Spring 2024, Problem 3
  Confidence: MEDIUM - multi-step but standard API
  Name: dvd_pow_of_vanishes_on_zeroLocus
-------------------------------------------------------------------------- -/

theorem dvd_pow_of_vanishes_on_zeroLocus {n : ℕ} (f g : MvPolynomial (Fin n) ℂ)
    (h : ∀ z : Fin n → ℂ, MvPolynomial.eval z f = 0 → MvPolynomial.eval z g = 0) :
    ∃ m : ℕ, f ∣ g ^ m := by
  have hg : g ∈ MvPolynomial.vanishingIdeal ℂ
      (MvPolynomial.zeroLocus ℂ (Ideal.span {f} : Ideal (MvPolynomial (Fin n) ℂ))) := by
    rw [MvPolynomial.mem_vanishingIdeal_iff]
    intro z hz
    rw [MvPolynomial.mem_zeroLocus_iff] at hz
    exact h z (hz f (Ideal.subset_span (Set.mem_singleton f)))
  rw [MvPolynomial.vanishingIdeal_zeroLocus_eq_radical, Ideal.mem_radical_iff] at hg
  obtain ⟨m, hm⟩ := hg
  exact ⟨m, Ideal.mem_span_singleton.mp hm⟩

end Thm017

section Thm018

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

theorem commutator_normal_and_quotient_comm (G : Type*) [Group G] :
    (commutator G).Normal ∧ ∀ x y : G ⧸ commutator G, x * y = y * x := by
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

end Thm018

section Thm019

/- --------------------------------------------------------------------------
  019.  Group Theory
  Source: University of Southern California, Fall 2023, Problem 6(b)
  Confidence: LOW    - most likely to need Mathlib name/signature adjustment
  Name: commutator_le_of_quotient_comm
-------------------------------------------------------------------------- -/

theorem commutator_le_of_quotient_comm {G : Type*} [Group G] (H : Subgroup G) [H.Normal]
    (h : ∀ x y : G ⧸ H, x * y = y * x) : commutator G ≤ H := by
  rw [commutator_def, Subgroup.commutator_le]
  intro a _ b _
  rw [← QuotientGroup.eq_one_iff, commutatorElement_def]
  simp only [QuotientGroup.mk_mul, QuotientGroup.mk_inv]
  rw [h ((a : G ⧸ H)) ((b : G ⧸ H))]
  group

end Thm019

section Thm020

/- --------------------------------------------------------------------------
  020.  Commutative Algebra
  Source: University of Southern California, Fall 2021, Problem 4 (first part)
  Confidence: MEDIUM - multi-step but standard API
  Name: isUnit_one_sub_of_mem_maximalIdeal
-------------------------------------------------------------------------- -/

theorem isUnit_one_sub_of_mem_maximalIdeal {R : Type*} [CommRing R] [IsLocalRing R]
    {x : R} (hx : x ∈ IsLocalRing.maximalIdeal R) : IsUnit (1 - x) := by
  by_contra h
  have h1 : (1 - x) ∈ IsLocalRing.maximalIdeal R :=
    (IsLocalRing.mem_maximalIdeal _).mpr (mem_nonunits_iff.mpr h)
  have hone : (1 : R) ∈ IsLocalRing.maximalIdeal R := by
    have := Ideal.add_mem (IsLocalRing.maximalIdeal R) h1 hx
    simp at this
  exact (Ideal.ne_top_iff_one _).mp
    (IsLocalRing.maximalIdeal.isMaximal R).ne_top hone

end Thm020

section Thm021

/- --------------------------------------------------------------------------
  021.  Commutative Algebra
  Source: University of Southern California, Fall 2021, Problem 4 (second part)
  Confidence: MEDIUM - multi-step but standard API
  Name: ideal_eq_bot_of_sq_eq_self
-------------------------------------------------------------------------- -/

theorem ideal_eq_bot_of_sq_eq_self {R : Type*} [CommRing R] [IsLocalRing R]
    [IsNoetherianRing R] (a : Ideal R) (hne : a ≠ ⊤) (h : a * a = a) : a = ⊥ := by
  have hfg : (a : Submodule R R).FG := IsNoetherian.noetherian a
  have hsub : a ≤ IsLocalRing.maximalIdeal R := IsLocalRing.le_maximalIdeal hne
  have hle : a ≤ IsLocalRing.maximalIdeal R • a := by
    rw [Ideal.smul_eq_mul]
    calc a = a * a := h.symm
      _ ≤ IsLocalRing.maximalIdeal R * a := Ideal.mul_mono_left hsub
  refine Submodule.eq_bot_of_le_smul_of_le_jacobson_bot _ a hfg hle ?_
  exact le_of_eq (IsLocalRing.jacobson_eq_maximalIdeal ⊥ bot_ne_top).symm

end Thm021

section Thm022

/- --------------------------------------------------------------------------
  022.  Commutative Algebra
  Source: University of California, Los Angeles, Problem 3 (Noetherian domain factorization)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: exists_irreducible_factors_of_noetherian_domain
-------------------------------------------------------------------------- -/

theorem exists_irreducible_factors_of_noetherian_domain
    {R : Type*} [CommRing R] [IsDomain R] [IsNoetherianRing R] {a : R} (ha : a ≠ 0) :
    ∃ f : Multiset R, (∀ b ∈ f, Irreducible b) ∧ Associated f.prod a :=
  WfDvdMonoid.exists_factors a ha

end Thm022

section Thm023

/- --------------------------------------------------------------------------
  023.  Field Theory
  Source: University of California, Los Angeles, Problem (finite field cardinality)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: finite_field_card_eq_prime_pow
-------------------------------------------------------------------------- -/

theorem finite_field_card_eq_prime_pow (F : Type*) [Field F] [Fintype F] :
    ∃ p n : ℕ, p.Prime ∧ 0 < n ∧ Fintype.card F = p ^ n := by
  -- `FiniteField.card'` is `∃ p, CharP K p ∧ ∃ n : ℕ+, p.Prime ∧ card K = p ^ n`,
  -- so the char-p witness must be bound before `n`.
  obtain ⟨p, _hchar, n, hp, hcard⟩ := FiniteField.card' F
  exact ⟨p, (n : ℕ), hp, n.property, hcard⟩

end Thm023

section Thm024

/- --------------------------------------------------------------------------
  024.  Commutative Algebra
  Source: University of Southern California, Spring 2020, Problem 3(a)
  Confidence: MEDIUM - multi-step but standard API
  Name: localization_injective_of_domain
-------------------------------------------------------------------------- -/

theorem localization_injective_of_domain {R : Type*} [CommRing R] [IsDomain R]
    (S : Submonoid R) (hS : (0 : R) ∉ S) :
    Function.Injective (algebraMap R (Localization S)) := by
  have hS' : S ≤ nonZeroDivisors R := by
    intro s hs
    rw [mem_nonZeroDivisors_iff_ne_zero]
    rintro rfl
    exact hS hs
  exact IsLocalization.injective (Localization S) hS'

end Thm024

section Thm025

/- --------------------------------------------------------------------------
  025.  Field Theory
  Source: University of Oregon, Fall 2017, Part II, Problem 5
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: fixedPoints_isIntegral
-------------------------------------------------------------------------- -/

theorem fixedPoints_isIntegral (G : Type*) [Group G] [Fintype G] (F : Type*) [Field F]
    [MulSemiringAction G F] (x : F) : IsIntegral (FixedPoints.subfield G F) x :=
  FixedPoints.isIntegral G F x

end Thm025

section Thm026

/- --------------------------------------------------------------------------
  026.  Commutative Algebra
  Source: University of Southern California, Spring 2020, Problem 5
  Confidence: MEDIUM - multi-step but standard API
  Name: radical_span_singleton_eq_iff_dvd_pow
-------------------------------------------------------------------------- -/

theorem radical_span_singleton_eq_iff_dvd_pow {R : Type*} [CommRing R] (f g : R) :
    Ideal.radical (Ideal.span {f}) = Ideal.radical (Ideal.span {g}) ↔
      ((∃ M : ℕ, g ∣ f ^ M) ∧ (∃ N : ℕ, f ∣ g ^ N)) := by
  constructor
  · intro h
    constructor
    · have hf : f ∈ Ideal.radical (Ideal.span {g}) := by
        rw [← h]
        exact Ideal.le_radical (Ideal.mem_span_singleton_self f)
      obtain ⟨M, hM⟩ := hf
      exact ⟨M, Ideal.mem_span_singleton.mp hM⟩
    · have hg : g ∈ Ideal.radical (Ideal.span {f}) := by
        rw [h]
        exact Ideal.le_radical (Ideal.mem_span_singleton_self g)
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

end Thm026

section Thm027

/- --------------------------------------------------------------------------
  027.  Module Theory
  Source: University of Southern California, Fall 2020, Problem 5
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: free_of_finite_torsionFree_over_pid
-------------------------------------------------------------------------- -/

theorem free_of_finite_torsionFree_over_pid {R M : Type*} [CommRing R] [IsDomain R]
    [IsPrincipalIdealRing R] [AddCommGroup M] [Module R M] [Module.Finite R M]
    [NoZeroSMulDivisors R M] : Module.Free R M :=
  Module.free_of_finite_type_torsion_free'

end Thm027

section Thm028

/- --------------------------------------------------------------------------
  028.  Group Theory
  Source: University of Southern California, Spring 2020, Problem 2(a)
  Confidence: LOW    - most likely to need Mathlib name/signature adjustment
  Name: exists_fixedPointFree_of_pretransitive
-------------------------------------------------------------------------- -/

open MulAction Finset

theorem exists_fixedPointFree_of_pretransitive {G X : Type*} [Group G] [Fintype G]
    [MulAction G X] [Fintype X] [MulAction.IsPretransitive G X] [Nonempty X]
    (hX : 1 < Fintype.card X) : ∃ g : G, ∀ x : X, g • x ≠ x := by
  classical
  by_contra hcon
  push Not at hcon
  -- every g fixes some point, so every fixedBy set is nonempty
  have hpos : ∀ g : G, 1 ≤ Fintype.card (fixedBy X g) := by
    intro g
    obtain ⟨x, hx⟩ := hcon g
    exact Fintype.card_pos_iff.mpr ⟨⟨x, hx⟩⟩
  -- Burnside: the sum of fixed points equals (number of orbits) * |G| = |G|
  have hburn : ∑ g : G, Fintype.card (fixedBy X g)
      = Fintype.card (orbitRel.Quotient G X) * Fintype.card G :=
    sum_card_fixedBy_eq_card_orbits_mul_card_group G X
  have horb : Fintype.card (orbitRel.Quotient G X) = 1 := by
    rw [Fintype.card_eq_one_iff]
    obtain ⟨x⟩ := ‹Nonempty X›
    refine ⟨Quotient.mk'' x, ?_⟩
    intro y
    induction y using Quotient.inductionOn' with
    -- `orbitRel` is `r a b := a ∈ orbit G b`, i.e. `z ≈ x ↔ ∃ g, g • x = z`,
    -- so the arguments run x-then-z, not z-then-x.
    | h z => exact Quotient.sound' (MulAction.exists_smul_eq G x z)
  rw [horb, one_mul] at hburn
  -- but the identity alone contributes card X > 1, and every other term is ≥ 1
  have hid : Fintype.card (fixedBy X (1 : G)) = Fintype.card X := by
    simp [fixedBy]
  have hlt : Fintype.card G < ∑ g : G, Fintype.card (fixedBy X g) := by
    calc Fintype.card G
        = ∑ _g : G, 1 := by simp
      _ < ∑ g : G, Fintype.card (fixedBy X g) := by
          refine Finset.sum_lt_sum (fun g _ => hpos g) ⟨1, Finset.mem_univ 1, ?_⟩
          rw [hid]
          exact hX
  omega

end Thm028

section Thm029

/- --------------------------------------------------------------------------
  029.  Module Theory
  Source: University of Southern California, Fall 2022, Problem 2
  Confidence: LOW    - most likely to need Mathlib name/signature adjustment
  Name: ker_projective_of_span_eq_top
-------------------------------------------------------------------------- -/

theorem ker_projective_of_span_eq_top {R : Type*} [CommRing R] {n : ℕ} (r : Fin n → R)
    (hr : Ideal.span (Set.range r) = ⊤) :
    Function.Surjective (Fintype.linearCombination R r) ∧
      Module.Projective R (LinearMap.ker (Fintype.linearCombination R r)) := by
  classical
  set f := Fintype.linearCombination R r with hf
  -- extract a partition of unity
  have h1 : (1 : R) ∈ Ideal.span (Set.range r) := by rw [hr]; trivial
  rw [Ideal.mem_span_range_iff_exists_fun] at h1
  obtain ⟨c, hc⟩ := h1
  -- the splitting
  let s : R →ₗ[R] (Fin n → R) :=
    { toFun := fun x i => x * c i
      -- after `funext i` the RHS is still `(g + h) i`; `Pi.add_apply` is what
      -- lets `ring` see `x * c i + y * c i`.
      map_add' := by intro x y; funext i; simp only [Pi.add_apply]; ring
      map_smul' := by intro a x; funext i; simp [smul_eq_mul]; ring }
  have hfs : ∀ x : R, f (s x) = x := by
    intro x
    simp only [hf, s, Fintype.linearCombination_apply, LinearMap.coe_mk, AddHom.coe_mk,
      smul_eq_mul]
    calc ∑ i, x * c i * r i = x * ∑ i, c i * r i := by
          rw [Finset.mul_sum]; exact Finset.sum_congr rfl (fun i _ => by ring)
      _ = x := by rw [hc]; ring
  have hsurj : Function.Surjective f := fun x => ⟨s x, hfs x⟩
  refine ⟨hsurj, ?_⟩
  -- ker f is a direct summand of the free module (Fin n → R)
  let p : (Fin n → R) →ₗ[R] (Fin n → R) := LinearMap.id - s.comp f
  have hp : ∀ v, p v ∈ LinearMap.ker f := by
    intro v
    simp only [p, LinearMap.sub_apply, LinearMap.id_apply, LinearMap.comp_apply,
      LinearMap.mem_ker, map_sub, hfs]
    ring
  let q : (Fin n → R) →ₗ[R] LinearMap.ker f := p.codRestrict (LinearMap.ker f) hp
  refine Module.Projective.of_split (LinearMap.ker f).subtype q ?_
  ext w
  have hw : f w.1 = 0 := w.2
  simp [q, p, hw]

end Thm029

section Thm030

/- --------------------------------------------------------------------------
  030.  Ring Theory
  Source: University of California, Los Angeles, Problem (f.g. module, surjective endomorphism)
  Confidence: HIGH   - one-line Mathlib application or short elementary proof
  Name: injective_of_surjective_endomorphism_of_finite
-------------------------------------------------------------------------- -/

theorem injective_of_surjective_endomorphism_of_finite
    {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M] [Module.Finite R M]
    (f : M →ₗ[R] M) (hf : Function.Surjective f) : Function.Injective f :=
  -- `[CommRing R]` supplies `OrzechProperty R` via the instance in
  -- Mathlib/RingTheory/FiniteType.lean:635.
  OrzechProperty.injective_of_surjective_endomorphism f hf

end Thm030

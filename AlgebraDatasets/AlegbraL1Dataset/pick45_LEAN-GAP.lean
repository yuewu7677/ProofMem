import Mathlib.Algebra.Category.ModuleCat.Basic
import Mathlib.Algebra.Category.ModuleCat.EnoughInjectives
import Mathlib.Algebra.Category.ModuleCat.ExteriorPower
import Mathlib.Algebra.EuclideanDomain.Field
import Mathlib.Algebra.Field.IsField
import Mathlib.Algebra.Field.Subfield.Defs
import Mathlib.Algebra.Homology.ShortComplex.ShortExact
import Mathlib.Algebra.Lie.OfAssociative
import Mathlib.Algebra.Module.Injective
import Mathlib.Algebra.Module.LinearMap.Defs
import Mathlib.Algebra.Module.LocalizedModule.Basic
import Mathlib.Algebra.Module.Projective
import Mathlib.Algebra.Module.Submodule.Defs
import Mathlib.Algebra.Module.Submodule.Pointwise
import Mathlib.Algebra.MvPolynomial.CommRing
import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Splits
import Mathlib.Algebra.Ring.BooleanRing
import Mathlib.Analysis.Complex.Trigonometric
import Mathlib.Analysis.Normed.Field.Lemmas
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Fin.VecNotation
import Mathlib.Data.Fintype.Card
import Mathlib.Data.Matrix.Mul
import Mathlib.Data.Nat.Prime.Defs
import Mathlib.Data.Nat.Totient
import Mathlib.Data.Real.Basic
import Mathlib.Data.ZMod.Defs
import Mathlib.FieldTheory.Finite.GaloisField
import Mathlib.FieldTheory.PolynomialGaloisGroup
import Mathlib.FieldTheory.SplittingField.Construction
import Mathlib.GroupTheory.FreeGroup.Basic
import Mathlib.GroupTheory.Index
import Mathlib.GroupTheory.Nilpotent
import Mathlib.GroupTheory.OrderOfElement
import Mathlib.GroupTheory.PresentedGroup
import Mathlib.GroupTheory.SpecificGroups.Alternating
import Mathlib.GroupTheory.SpecificGroups.Dihedral
import Mathlib.GroupTheory.SpecificGroups.Quaternion
import Mathlib.GroupTheory.Subgroup.Center
import Mathlib.GroupTheory.Sylow
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.Dimension.StrongRankCondition
import Mathlib.LinearAlgebra.Dual.Defs
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.FreeModule.Basic
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.NumberTheory.NumberField.Basic
import Mathlib.NumberTheory.Zsqrtd.GaussianInt
import Mathlib.Order.CompletePartialOrder
import Mathlib.RepresentationTheory.FDRep
import Mathlib.RepresentationTheory.Induced
import Mathlib.RingTheory.AdjoinRoot
import Mathlib.RingTheory.Artinian.Module
import Mathlib.RingTheory.Coprime.Basic
import Mathlib.RingTheory.DiscreteValuationRing.Basic
import Mathlib.RingTheory.Finiteness.Defs
import Mathlib.RingTheory.Flat.Basic
import Mathlib.RingTheory.FractionalIdeal.Basic
import Mathlib.RingTheory.Ideal.AssociatedPrime.Basic
import Mathlib.RingTheory.Ideal.Maps
import Mathlib.RingTheory.Ideal.Maximal
import Mathlib.RingTheory.Ideal.MinimalPrime.Basic
import Mathlib.RingTheory.Ideal.Prime
import Mathlib.RingTheory.Ideal.Quotient.Defs
import Mathlib.RingTheory.Ideal.Span
import Mathlib.RingTheory.MvPolynomial.Homogeneous
import Mathlib.RingTheory.Nilpotent.Defs
import Mathlib.RingTheory.Polynomial.Resultant.Basic
import Mathlib.RingTheory.PowerSeries.Basic
import Mathlib.RingTheory.SimpleModule.Basic
import Mathlib.RingTheory.SimpleRing.Principal
import Mathlib.RingTheory.Spectrum.Prime.Noetherian

/-
==============================================================================
MERGED LEAN DATASET
==============================================================================
Total Lean files discovered : 83
Number of files selected    : 45
Generated (UTC)             : 2026-07-07T07:19:34.655404+00:00
==============================================================================
Selected files:
  [  1] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_0\DF_0_1.lean
  [  2] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_0\DF_0_3.lean
  [  3] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_10\DF_10_2.lean
  [  4] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_10\DF_10_5.lean
  [  5] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_11\DF_11_2.lean
  [  6] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_11\DF_11_3.lean
  [  7] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_11\DF_11_5.lean
  [  8] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_12\DF_12_2.lean
  [  9] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_13\DF_13_1.lean
  [ 10] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_13\DF_13_4.lean
  [ 11] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_13\DF_13_5.lean
  [ 12] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_14\DF_14_1.lean
  [ 13] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_14\DF_14_4.lean
  [ 14] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_14\DF_14_6.lean
  [ 15] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_15\DF_15_1.lean
  [ 16] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_15\DF_15_2.lean
  [ 17] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_15\DF_15_4.lean
  [ 18] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_16\DF_16_1.lean
  [ 19] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_16\DF_16_3.lean
  [ 20] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_18\DF_18_1.lean
  [ 21] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_18\DF_18_2.lean
  [ 22] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_19\DF_19_1.lean
  [ 23] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_19\DF_19_3.lean
  [ 24] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_1\DF_1_2.lean
  [ 25] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_1\DF_1_4.lean
  [ 26] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_1\DF_1_6.lean
  [ 27] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_2\DF_2_1.lean
  [ 28] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_2\DF_2_3.lean
  [ 29] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_2\DF_2_5.lean
  [ 30] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_3\DF_3_2.lean
  [ 31] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_3\DF_3_3.lean
  [ 32] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_3\DF_3_5.lean
  [ 33] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_4\DF_4_3.lean
  [ 34] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_4\DF_4_5.lean
  [ 35] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_5\DF_5_1.lean
  [ 36] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_5\DF_5_4.lean
  [ 37] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_6\DF_6_1.lean
  [ 38] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_6\DF_6_3.lean
  [ 39] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_7\DF_7_2.lean
  [ 40] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_7\DF_7_4.lean
  [ 41] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_7\DF_7_5.lean
  [ 42] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_8\DF_8_2.lean
  [ 43] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_9\DF_9_1.lean
  [ 44] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_9\DF_9_3.lean
  [ 45] C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_9\DF_9_5.lean
==============================================================================
-/

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_0\DF_0_1.lean -/
/-
Let $M = \begin{pmatrix} 1 & 1 \\ 0 & 1 \end{pmatrix}$, and
$\mathcal{B} = \{X \in \mathrm{Mat}_{2\times 2}(\mathbb{R}) \mid MX = XM\}$.
If $P, Q \in \mathcal{B}$, then $P + Q \in \mathcal{B}$.
Also, if $P, Q \in \mathcal{B}$, then $PQ \in \mathcal{B}$.
Contributor: anonymous
-/
def DF_0_1_aux_M : Matrix (Fin 2) (Fin 2) ℝ := ![![1, 1], ![0, 1]]
def DF_0_1_aux_B : Set (Matrix (Fin 2) (Fin 2) ℝ) := {X | DF_0_1_aux_M * X = X * DF_0_1_aux_M}

theorem DF_0_1_2 (P Q : DF_0_1_aux_B) :
    P.val + Q.val ∈ DF_0_1_aux_B := by
  sorry

theorem DF_0_1_3 (P Q : DF_0_1_aux_B) :
    P.val * Q.val ∈ DF_0_1_aux_B := by
  sorry

/-
Let $A, B$ be two sets, and $f : A \to B$ a surjective map.
Then the relation
\[
  a \sim b \iff f(a) = f(b)
\]
is an equivalence relation.
Contributor: anonymous
-/
def DF_0_1_7 {A B : Type*} {f : A → B} (hf : Function.Surjective f) :
    Equivalence (fun a1 a2 => f a1 = f a2) where
  refl := sorry
  symm := sorry
  trans := sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_0\DF_0_3.lean -/
/--
The squares of the elements in $\mathbb{Z}/4\mathbb{Z}$ are just $\bar{0}$ and $\bar{1}$.
Contributor: anonymous
-/
theorem DF_0_3_6 : {x : ZMod 4 | IsSquare x} = {0, 1} := by
  sorry

/--
If $\bar{a}, \bar{b} \in(\mathbb{Z} / n \mathbb{Z})^{\times}$,
then $\bar{a} \cdot \bar{b} \in(\mathbb{Z} / n \mathbb{Z})^{\times}$.
Contributor: anonymous
-/
theorem DF_0_3_11 {n : ℕ} (a b : ZMod n) (ha : IsUnit a) (hb : IsUnit b) : IsUnit (a * b) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_10\DF_10_2.lean -/
/-
Let $R$ be a ring with unity, and $M, N$ be $R$-modules.
Let $\phi:M \rightarrow N$ be an $R$-module homomorphism.
Then the kernel of $\phi$ is an $R$-submodule of $M$,
and the image of $\phi$ is an $R$-submodule of $N$.
Contributor: anonymous
-/
theorem DF_10_2_1 {R : Type*} [Semiring R]
    {M N : Type*} [AddCommMonoid M] [Module R M]
    [AddCommMonoid N] [Module R N] (φ : M →ₗ[R] N) :
    (∃ S : Submodule R M, ∀ x : M, x ∈ S ↔ φ x = 0) ∧
    (∃ T : Submodule R N, ∀ y : N, y ∈ T ↔ ∃ x : M, φ x = y) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_10\DF_10_5.lean -/
/--
Let $R$ be a ring, and $P_1, P_2$ be $R$-modules.
Then $P_1 \oplus P_2$ is projective if and only if $P_1$ and $P_2$ are projective.
Contributor: anonymous
-/
theorem DF_10_5_3 {R : Type*} [Ring R] {P₁ P₂ : Type*} [AddCommMonoid P₁]
    [AddCommMonoid P₂] [Module R P₁] [Module R P₂] :
    Module.Projective R (P₁ × P₂) ↔ Module.Projective R P₁ ∧ Module.Projective R P₂ := by
  sorry

/--
Let $R$ be a ring, and $I_1, I_2$ be $R$-modules.
Then $I_1 \oplus I_2$ is injective if and only if $I_1$ and $I_2$ are injective.
Contributor: anonymous
-/
theorem DF_10_5_4 {R : Type*} [Ring R] {I₁ I₂ : Type*} [AddCommGroup I₁]
    [AddCommGroup I₂] [Module R I₁] [Module R I₂] :
    Module.Injective R (I₁ × I₂) ↔ Module.Injective R I₁ ∧ Module.Injective R I₂ := by
  sorry

/--
Let $R$ be a ring.
Then every $R$-module is projective if and only if every $R$-module is injective.
Contributor: anonymous
-/
theorem DF_10_5_6 {R : Type*} [Ring R] :
    ∀ M : ModuleCat R, CategoryTheory.Projective M ↔
    ∀ M : ModuleCat R, CategoryTheory.Injective M := by
  sorry

/--
Let $R$ be a commutative ring. Then $R[x]$ is a flat $R$-module.
Contributor: anonymous
-/
theorem DF_10_5_20 {R : Type*} [CommRing R] :
    Module.Flat R (Polynomial R) := by
  sorry

/--
Let $R$ be a commutative ring, and $M, N$ be flat $R$-modules.
Then $M \otimes_R N$ is also a flat $R$-module.
Contributor: anonymous
-/
theorem DF_10_5_22 {R : Type*} [CommRing R] {M N : Type*} [AddCommGroup M] [AddCommGroup N] [Module R M] [Module R N] :
    Module.Flat R M ∧ Module.Flat R N → Module.Flat R (TensorProduct R M N) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_11\DF_11_2.lean -/
open scoped Matrix TensorProduct
open LinearMap


/--
Let $V$ and $W$ be finite-dimensional vector spaces over a field $K$ with
dimensions $n$ and $m$, respectively.
Then for any $m \times n$ matrix $A$ over $K$, $A$ is nonsingular if and only if
there exists a linear transformation $\phi : V \to W$ and bases $B$ and $E$
of $V$ and $W$, respectively, such that $\ker(\phi) = 0$ (i.e. $\phi$ is
nonsingular) and the matrix representation of $\phi$ with respect to
these bases is $A$.
Contributor: anonymous
-/
theorem DF_11_2_5
    {K : Type*} [Field K] {n m : ℕ}
    (V W : Type*) [AddCommGroup V] [Module K V] [AddCommGroup W] [Module K W]
    [FiniteDimensional K V] [FiniteDimensional K W]
    (hV : Module.finrank K V = n) (hW : Module.finrank K W = m)
    (A : Matrix (Fin m) (Fin n) K) :
    (∀ (v : Fin n → K), A.mulVec v = 0 → v = 0) ↔
    ∃ (φ : V →ₗ[K] W)
      (B : Module.Basis (Fin n) K V) (E : Module.Basis (Fin m) K W),
      ker φ = 0 ∧ LinearMap.toMatrix B E φ = A := by
  sorry

/--
Let $F$ be a field, $\phi : F^n \to F^m$ be a linear transformation.
Then the image of $\phi$ is spanned by the set of column vectors of the
matrix representation of $\phi$ with respect to the standard bases of
$F^n$ and $F^m$.
Also, the rank of $\phi$ is equal to the column rank of the matrix
representation of $\phi$ with respect to the standard bases of $F^n$ and $F^m$.
Contributor: anonymous
-/
theorem DF_11_2_6_1 {F : Type*} [Field F] {n m : ℕ}
    (φ : (Fin n → F) →ₗ[F] (Fin m → F)) :
    LinearMap.range φ =
    Submodule.span F (Set.range (fun j : Fin n => fun i : Fin m =>
      (LinearMap.toMatrix
        (Pi.basisFun F (Fin n)) (Pi.basisFun F (Fin m)) φ) i j)) := by
  sorry

theorem DF_11_2_6_2 {F : Type*} [Field F] {n m : ℕ}
    (φ : (Fin n → F) →ₗ[F] (Fin m → F)) :
    φ.rank =
    Module.finrank F (Submodule.span F (Set.range
      (fun j : Fin n => fun i : Fin m =>
        (LinearMap.toMatrix
          (Pi.basisFun F (Fin n)) (Pi.basisFun F (Fin m)) φ) i j))) := by
    sorry

/--
Any two similar matrices have the same row rank and the same column rank.
Contributor: anonymous
-/
theorem DF_11_2_7
    {F n : Type*} [Field F] [Fintype n] [DecidableEq n] (A B : Matrix n n F)
    (hAB : ∃ P : Matrix n n F, ∃ hP : Invertible P, A = P * B * P⁻¹) :
    A.rank = B.rank ∧ Aᵀ.rank = Bᵀ.rank := by
  sorry

/--
Let $V$ be a finite-dimensional vector space over a field $K$.
Let $\phi :V \to V$ be a linear map such that $\phi^{2} = \phi$.

(a) Image and kernel of $\phi$ intersect trivially.
(b) $V$ is the direct sum of the image and the kernel of $\phi$.
(c) There exists a basis of $V$ such that the matrix representation of $\phi$
    with respect to this basis is a diagonal matrix with diagonal entries
    either $0$ or $1$.
Contributor: anonymous
-/
theorem DF_11_2_11_a
    {K V} [Field K] [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (φ : V →ₗ[K] V) (hφ : φ^2 = φ) :
    range φ ⊓ ker φ = ⊥ := by
  sorry

theorem DF_11_2_11_b
    {K V} [Field K] [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (φ : V →ₗ[K] V) (hφ : φ^2 = φ) :
    Nonempty ((range φ) ⊕ (ker φ) ≃ₗ[K] V) := by
  sorry

theorem DF_11_2_11_c
    {K V} [Field K] [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (φ : V →ₗ[K] V) (hφ : φ^2 = φ) :
    ∃ (b : Module.Basis (Fin (Module.finrank K V)) K V)
      (s : Fin (Module.finrank K V) → K),
      LinearMap.toMatrix b b φ = Matrix.diagonal s
        ∧ ∀ i, s i = (0 : K) ∨ s i = 1 := by
  sorry

/--
The row rank and the column rank of any matrix are equal.
Contributor: anonymous
-/
theorem DF_11_2_24
    {K : Type*} [Field K] {m n : ℕ} (A : Matrix (Fin m) (Fin n) K) :
    Module.finrank K (Submodule.span K (Set.range A.row)) =
    Module.finrank K (Submodule.span K (Set.range A.col)) := by
  sorry

/--
For square matrices $A$ and $B$, the trace of the Kronecker product
$A \otimes B$ is equal to the product of the traces of $A$ and $B$.
Contributor: anonymous
-/
theorem DF_11_2_38
    {F : Type*} [Field F] {m n : ℕ}
    (A : Matrix (Fin m) (Fin m) F) (B : Matrix (Fin n) (Fin n) F) :
    Matrix.trace (Matrix.kronecker A B) = Matrix.trace A * Matrix.trace B := by
  sorry

/--
Let $F$ be a subfield of a field $K$.
Let $V$ and $W$ be finite-dimensional vector spaces over $F$.
Let $\psi : V \to W$ be a linear transformation over $F$.

(a) $1 \otimes \psi : K \otimes_F V \to K \otimes_F W$ defined by
    $(1 \otimes \psi)(k \otimes v) = k \otimes \psi(v)$
    for all $k \in K$ and $v \in V$ is a linear map from $K \otimes_F V$
    to $K \otimes_F W$ over $K$.
(b) Let $B$ and $E$ be bases of $V$ and $W$ over $F$, respectively.
    Then the matrix representation of $1 \otimes \psi$ with respect to
    the bases $1 \otimes B$ and $1 \otimes E$ is equal to
    the matrix representation of $\psi$ with respect to $B$ and $E$.
Contributor: anonymous
-/
theorem DF_11_2_39_a {F K V W : Type*} [Field K] {F : Subfield K}
    [AddCommGroup V] [Module F V] [FiniteDimensional F V]
    [AddCommGroup W] [Module F W] [FiniteDimensional F W] (ψ : V →ₗ[F] W) :
    ∃ T : (K ⊗[F] V →ₗ[K] K ⊗[F] W),
    ∀ (k : K) (v : V),
      T (TensorProduct.tmul F k v) = TensorProduct.tmul F k (ψ v) := by
  sorry

theorem DF_11_2_39_b {F K V W : Type*} [Field K] {F : Subfield K}
    [AddCommGroup V] [Module F V] [FiniteDimensional F V]
    [AddCommGroup W] [Module F W] [FiniteDimensional F W]
    {n m : ℕ} (B : Module.Basis (Fin n) F V) (E : Module.Basis (Fin m) F W)
    (ψ : V →ₗ[F] W) :
    LinearMap.toMatrix (B.baseChange K) (E.baseChange K)
      (LinearMap.baseChange K ψ) =
    Matrix.map (LinearMap.toMatrix B E ψ) (algebraMap F K) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_11\DF_11_3.lean -/
universe u -- this is needed for DF_11_3_5_2

open LinearMap Module


/--
For a finite-dimensional vector space $V$ over a field $F$,
the dual map $\phi \mapsto \phi^*$ gives an isomorphism between
the endomorphism ring of $V$ and the endomorphism ring of its dual space
$V^*$.
Contributor: anonymous
-/
theorem DF_11_3_1 {K V : Type*} [Field F] [AddCommGroup V] [Module F V]
    [FiniteDimensional F V] :
    ∃ e : (End F V) ≃+* (End F (Dual F V)),
      ∀ (φ : End F V) (l : Dual F V), e φ l = l ∘ φ := by
  sorry

/--
If $V$ is an infinite-dimensional vector space over a field $F$ with basis
$A$, then the set $A^* = \{v^* | v \in A\}$ of dual vectors does not span the
dual space $V^*$.
Contributor: anonymous
-/
theorem DF_11_3_4 {F V ι : Type*} [Field F] [AddCommGroup V] [Module F V]
    (hV : ¬ FiniteDimensional F V) (A : Basis ι F V) :
    Submodule.span F (Set.range (fun i : ι => A.coord i)) ≠ ⊤ := by
  sorry

/--
If $V$ is an infinite-dimensional vector space over a field $F$ with basis
$A$, then there exists an isomorphism between the dual space $V^*$ and the
direct product of $F$ over the indexing set $A$.
Also, the dimension of $V$ is strictly less than the dimension of its dual
space $V^*$.
Contributor: anonymous
-/
theorem DF_11_3_5_1
    {F V ι : Type*} [Field F] [AddCommGroup V] [Module F V]
    (hV : ¬ FiniteDimensional F V) (A : Basis ι F V) :
    Nonempty (Dual F V ≃ₗ[F] ((A : Set V) → F)) := by
  sorry

theorem DF_11_3_5_2
    {F V : Type u} [Field F] [AddCommGroup V] [Module F V]
    (hV : ¬ FiniteDimensional F V) :
    Module.rank F V < Module.rank F (Dual F V) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_11\DF_11_5.lean -/
/--
Let $R$ be a commutative ring with 1, and $M$ a cyclic $R$-module.
Then the tensor algebra $\mathcal{T}(M)$ is commutative.
Contributor: anonymous
-/
theorem DF_11_5_1 {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M] (hcyclic : ∃ m : M, Submodule.span R ({m} : Set M) = ⊤) : ∀ x y : TensorAlgebra R M, x * y = y * x := by
  sorry


/--
Let $R$ be a commutative ring with 1, and $M$ a free $R$-module of rank $n$.
Then for $i=0,1,2,\dots$, the exterior power $\bigwedge^{i}(M)$ is a free $R$-module of rank $\binom{n}{i}$.
Contributor: anonymous
-/
theorem DF_11_5_5 {R : Type*} [CommRing R] {M : ModuleCat R} [Module.Free R M] {n : ℕ} (hrank : Module.rank R M = n) : ∀ i : ℕ, Module.rank R (M.exteriorPower i) = Nat.choose n i := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_12\DF_12_2.lean -/
/--
Let $F$ be a field. Let $A$ and $B$ be two 2 by 2 matrices over $F$ that are
not scalar matrices. Then $A$ and $B$ are similar if and only if they have
the same characteristic polynomial.
Contributor: anonymous
-/
theorem DF_12_2_3 {F : Type*} [Field F] (A B : Matrix (Fin 2) (Fin 2) F)
    (hA : ¬ ∃ c : F, A = c • 1) (hB : ¬ ∃ c : F, B = c • 1) :
    (∃ P : (Matrix (Fin 2) (Fin 2) F)ˣ, A = P⁻¹ * B * P) ↔
    A.charpoly = B.charpoly := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_13\DF_13_1.lean -/
open Polynomial

/--
$p(x) = x^3 + 9x + 6$ is irreducible in $\mathbb{Q}[x]$.
Contributor: anonymous
-/
theorem DF_13_1_1 : Irreducible (X ^ 3 + 9 * X + 6 : ℚ[X]) := by
  sorry

/--
$p(x) = x^3 - 2x - 2$ is irreducible in $\mathbb{Q}[x]$.
Contributor: anonymous
-/
theorem DF_13_1_2 : Irreducible (X ^ 3 - 2 * X - 2 : ℚ[X]) := by
  sorry

/--
$p(x) = x^3 + x + 1$ is irreducible in $\mathbb{F}_2[x]$.
Contributor: anonymous
-/
theorem DF_13_1_3 : Irreducible (X ^ 3 + X + 1 : (GaloisField 2 1)[X]) := by
  sorry

/--
The map $a+b \sqrt{2} \mapsto a-b \sqrt{2}$ is an isomorphism of $\mathbb{Q}(\sqrt{2})$ with itself.
Contributor: anonymous
-/
theorem DF_13_1_4 :
    let f : ℚ[X] := X ^ 2 - 2
    ∃ e : AdjoinRoot f ≃ₐ[ℚ] AdjoinRoot f,
      e (AdjoinRoot.root f) = - AdjoinRoot.root f := by
  sorry

/--
Suppose $\alpha$ is a rational root of a monic polynomial in $\mathbb{Z}[x]$.
Then $\alpha$ is an integer.
Contributor: anonymous
-/
theorem DF_13_1_5 {α : ℚ} {f : ℤ[X]}
    (monic_f : f.Monic) (α_root : (f.map (Int.castRingHom ℚ)).eval α = 0) :
    ∃ (n : ℤ), α = n := by
  sorry
/--
If $\alpha$ is a root of $a_n x^n + a_{n-1} x^{n-1} + \cdots + a_0$, then
$a_n \alpha$ is a root of $x^n + a_{n-1} x^{n-1} + a_{n} a_{n-2} x^{n-2}
+ \cdots + a_{n}^{n-2} a_{1} x + a_{n}^{n-1} a_0$.
Contributor: anonymous
-/
theorem DF_13_1_6 {k : Type*} [Field k] (α : k) (f : k[X]) (α_root : f.IsRoot α) :
    (
      X ^ (f.natDegree) + ∑ (i ∈ Finset.range f.natDegree),
      ((f.coeff (f.natDegree)) ^ (f.natDegree - 1 - i) * (f.coeff i))
      • (Polynomial.X ^ i)
    ).eval (f.coeff f.natDegree * α) = 0 := by
  sorry

/--
$x^3 - nx + 2$ is irreducible over $\mathbb{Z}$ for $n \ne -1, 3, 5$.
Contributor: anonymous
-/
theorem DF_13_1_7 (n : ℤ) (hn : n ≠ -1 ∧ n ≠ 3 ∧ n ≠ 5) :
    Irreducible (X ^ 3 - n • X + 2 : ℤ[X]) := by
  sorry

/--
$x^5 - ax - 1$ is irreducible over $\mathbb{Z}$ for $a \ne 0, 2, -1$.
Contributor: anonymous
-/
theorem DF_13_1_8 (a : ℤ) (ha : a ≠ 0 ∧ a ≠ 2 ∧ a ≠ -1) :
    Irreducible (X ^ 5 - a • X - 1 : ℤ[X]) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_13\DF_13_4.lean -/
open Polynomial


/--
Let $K$ be a finite extension of a field $F$.
Then $K$ is a splitting field over $F$ if and only if
every irreducible polynomial in $F[x]$ that has at least one root in $K$
splits completely in $K$.
Contributor: anonymous
-/
theorem DF_13_4_5 {K : Type*} [Field K] {F : Subfield K}
    [FiniteDimensional F K] :
    ∃ f : F[X], IsSplittingField F K f ↔
    ∀ g : F[X], Irreducible g → (∃ a : K, g.aeval a = 0) → g.Splits := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_13\DF_13_5.lean -/
open scoped Polynomial

/--
Derivative of polynomial $D_x$ satisfies
a) $D_x (f + g) = D_x f + D_x g$,
b) $D_x (f \cdot g) = D_x f \cdot g + f \cdot D_x g$.
Contributor: anonymous
-/
theorem DF_13_5_1_a {F : Type*} [Field F] (f g : F[X]) :
    (f + g).derivative = f.derivative + g.derivative := by
  sorry

theorem DF_13_5_1_b {F : Type*} [Field F] (f g : F[X]) :
    (f * g).derivative = f.derivative * g + f * g.derivative := by
  sorry

/--
$d$ divides $n$ if and only if $x^d - 1$ divides $x^n - 1$.
Contributor: anonymous
-/
theorem DF_13_5_3 {d n : ℕ} : d ∣ n ↔ X ^ d - 1 ∣ X ^ n - 1 := by
  sorry

/--
For an integer $a > 1$ and positive integers $n, d$, $d$ divides $n$ if and
only if $a^d - 1$ divides $a^n - 1$.
Contributor: anonymous
-/
theorem DF_13_5_4_a {a : ℤ} (h : a > 1) {d n : ℕ} :
    d ∣ n ↔ a ^ d - 1 ∣ a ^ n - 1 := by
  sorry

/--
$\mathbb{F}_{p^d} \subseteq \mathbb{F}_{p^n}$ if and only if $d \mid n$.
Contributor: anonymous
-/
theorem DF_13_5_4_b {p d n : ℕ} [Fact (Nat.Prime p)] :
    ∃ (ι : GaloisField p d →+* GaloisField p n), Function.Injective ι
    ↔ d ∣ n := by
  sorry

/--
For any prime $p$ and any nonzero $a \in \mathbb{F}_p$, $x^p - x + a$ is irreducible.
Contributor: anonymous
-/
theorem DF_13_5_5_1 {p : ℕ} [Fact p.Prime] {a : GaloisField p 1} [NeZero a] :
    Irreducible (.X ^ p - .X + .C a : (GaloisField p 1)[X]) := by
  sorry

/--
For any prime $p$ and any nonzero $a \in \mathbb{F}_p$, $x^p - x + a$ is separable.
Contributor: anonymous
-/
theorem DF_13_5_5_2 {p : ℕ} [Fact p.Prime] {a : GaloisField p 1} [NeZero a] :
    (.X ^ p - .X + .C a : (GaloisField p 1)[X]).Separable := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_14\DF_14_1.lean -/
open Polynomial

/--
The map $a + bi \mapsto a - bi$ is an automorphism of $\mathbb{C}$.
Contributor: anonymous
-/
def DF_14_1_2_aux_tau (z : ℂ) : ℂ := ⟨z.re, -z.im⟩

theorem DF_14_1_2 : ∃ (φ : ℂ ≃+* ℂ), φ = DF_14_1_2_aux_tau := by
  sorry

/--
$\mathbb{Q}(\sqrt{2})$ and $\mathbb{Q}(\sqrt{3})$ are not isomorphic.
Contributor: anonymous
-/
noncomputable def DF_14_1_4_aux_poly2 : ℚ[X] := X^2 - 2

abbrev DF_14_1_4_aux_Qsqrt2 := AdjoinRoot DF_14_1_4_aux_poly2

instance DF_14_1_4_aux_fact_irred_poly2 :
    Fact (Irreducible DF_14_1_4_aux_poly2) := by
  sorry

noncomputable instance : Field DF_14_1_4_aux_Qsqrt2 :=
  AdjoinRoot.instField

noncomputable def DF_14_1_4_aux_poly3 : ℚ[X] := X^2 - 3

abbrev DF_14_1_4_aux_Qsqrt3 := AdjoinRoot DF_14_1_4_aux_poly3

instance DF_14_1_4_aux_fact_irred_poly3 :
    Fact (Irreducible DF_14_1_4_aux_poly3) := by
  sorry

noncomputable instance : Field DF_14_1_4_aux_Qsqrt3 :=
  AdjoinRoot.instField

theorem DF_14_1_4 :
    ¬ Nonempty (DF_14_1_4_aux_Qsqrt2 ≃+* DF_14_1_4_aux_Qsqrt3) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_14\DF_14_4.lean -/
/--
If $F$ is a field contained in the ring of $n \times n$ matrices over $\mathbb{Q}$,
then the dimension of $F$ as a vector space over $\mathbb{Q}$ is at most $n$.
Contributor: anonymous
-/
theorem DF_14_4_3 {F : Type*} {n : ℕ} [Field F] [Algebra ℚ F]
    (φ : F →ₐ[ℚ] Matrix (Fin n) (Fin n) ℚ) (hφ : Function.Injective φ)
    [FiniteDimensional ℚ F] : Module.finrank ℚ F ≤ n := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_14\DF_14_6.lean -/
open Polynomial

/--
For any $a,b \in \mathbb{F}_{p^n}$, if $x^3 + ax + b$ is irreducible,
then $-4a^3 - 27b^2$ is a square in $\mathbb{F}_{p^n}$.
Contributor: anonymous
-/
theorem DF_14_6_3 {n p : ℕ} [Fact (Nat.Prime p)] {hn : n ≥ 1}
    {a b : GaloisField p n} {h : Irreducible (X ^ 3 + C a * X + C b : Polynomial (GaloisField p n))} :
    ∃ r : GaloisField p n, r^2 = -4*a^3 - 27*b^2 := by
  sorry

/--
Let $p$ and $q$ be distinct odd primes.
Then $x^4 - px^2 + q$ is irreducible over $\mathbb{Q}$, and its Galois group
is the dihedral group of order $8$.
Contributor: anonymous
-/
theorem DF_14_6_14 {p q : ℕ} [Fact (Nat.Prime p)] [Fact (Nat.Prime q)] (h_distinct : p ≠ q) (h_odd : Odd p ∧ Odd q) :
    let f : Polynomial ℚ := X ^ 4 - C (p : ℚ) * X ^ 2 + C (q : ℚ)
    Irreducible f ∧ Nonempty (f.Gal ≃* DihedralGroup 4) := by
  sorry

/--
Let $p$ be a prime. Then the polynomial $x^4 + px + p$ is irreducible over $\mathbb{Q}$.
Moreover, if $p\neq 3, 5$, then the Galois group is $S_4$,
If $p=3$, then the Galois group is $D_4$, the dihedral group of order $8$.
If $p=5$, then the Galois group is cyclic of order $4$.
Contributor: anonymous
-/
theorem DF_14_6_15_1 {p : ℕ} [Fact (Nat.Prime p)] :
    Irreducible (X ^ 4 + C (p : ℚ) * X + C (p : ℚ)) := by
  sorry

theorem DF_14_6_15_2 {p : ℕ} [Fact (Nat.Prime p)] :
    (p ≠ 3 ∧ p ≠ 5) → Nonempty ((X ^ 4 + C (p : ℚ) * X + C (p : ℚ) : Polynomial ℚ).Gal ≃* Equiv.Perm (Fin 4)) := by
  sorry

theorem DF_14_6_15_3 :
    Nonempty ((X ^ 4 + 3 * X + 3 : Polynomial ℚ).Gal ≃* DihedralGroup 4) := by
  sorry

theorem DF_14_6_15_4 :
    Nonempty ((X ^ 4 + 5 * X + 5 : Polynomial ℚ).Gal ≃* Multiplicative (ZMod 4)) := by
  sorry

/--
An $n\times n$ matrix $A$ over a field of characteristic $0$ is nilpotent
if and only if the trace of $A^k$ is equal to $0$ for all $k\ge 0$.
Contributor: anonymous
-/
theorem DF_14_6_24 {F : Type*} [Field F] [CharZero F] {n : ℕ} {A : Matrix (Fin n) (Fin n) F} :
    IsNilpotent A ↔ (∀ k : ℕ, (A^k).trace = 0) := by
  sorry

/--
Two $n\times n$ matrices $A$ and $B$ over a field of char $0$ have
the same characteristic polynomial if and only if the trace of $A^k$ equals
the trace of $B^k$ for all $k\ge 0$.
Contributor: anonymous
-/
theorem DF_14_6_25 {F : Type*} [Field F] [CharZero F] {n : ℕ} {A B : Matrix (Fin n) (Fin n) F} :
    A.charpoly = B.charpoly ↔ (∀ k : ℕ, (A^k).trace = (B^k).trace) := by
  sorry

/--
For any $n\times n$ matrices $A$ and $B$ over a field of char $0$,
the characteristic polynomials of $AB$ and $BA$ are the same.
Contributor: anonymous
-/
theorem DF_14_6_26 {F : Type*} [Field F] [CharZero F] {n : ℕ} {A B : Matrix (Fin n) (Fin n) F} :
    (A*B).charpoly = (B*A).charpoly := by
  sorry

/--
The discriminant of $x^n + n x^{n-1} + n(n-1) x^{n-2} + \cdots + n!$ is
equal to $(-1)^{n(n-1)/2} (n!)^n$.
Contributor: anonymous
-/
theorem DF_14_6_36 {n : ℕ} {h : n ≥ 1} :
    (∑ i ∈ Finset.range (n+1), C (n.factorial / i.factorial : ℤ) * X ^ i : Polynomial ℤ).discr
      = (-1 : ℤ)^(n*(n-1)/2) * (n.factorial)^n := by
  sorry

/--
If $f(x) = x^3 + px + q ∈ \mathbb{Z}[x]$ is irreducible, then its discriminant
$D = -4 p^3 - 27 q^2$ is an integer not equal to $0, \pm1$.
Contributor: anonymous
-/
theorem DF_14_6_45 {p q : ℤ} (h : Irreducible (X ^ 3 + p • X + C q : ℤ[X])) :
    -4 * p ^ 3 - 27 * q ^ 2 ∉ ({0, 1, -1} : Set ℤ) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_15\DF_15_1.lean -/
open Polynomial

/--
Let $R$ be a commutative ring.
If $R[x]$ is Noetherian, then $R$ is Noetherian.
Contributor: anonymous
-/
theorem DF_15_1_1 {R : Type*} [CommRing R]
    (h : IsNoetherianRing R[X]) : IsNoetherianRing R := by
  sorry

/--
Let $R$ be a commutative ring.
Let $0 \rightarrow M' \rightarrow M \rightarrow M'' \rightarrow 0$ be
an exact sequence of $R$-modules.
Then $M$ is Noetherian if and only if $M'$ and $M''$ are Noetherian.
Contributor: anonymous
-/
theorem DF_15_1_6 {R : Type*} [CommRing R] {S : CategoryTheory.ShortComplex (ModuleCat R)} (hS : S.ShortExact) :
    IsNoetherian R S.X₂ ↔ IsNoetherian R S.X₁ ∧ IsNoetherian R S.X₃ := by
  sorry

/--
If $R = \mathbb{Z}$ and $M = \mathbb{Z} / n\mathbb{Z}$, then the set of
associated prime ideals of $M$ is the set of prime ideals $(p)$ such that
$p$ is a prime divisor of $n$.
Contributor: anonymous
-/
theorem DF_15_1_29 {n : ℕ} (hn : 1 ≤ n) :
    associatedPrimes ℤ (ℤ ⧸ Ideal.span {(n : ℤ)}) =
    {I | ∃ (p : ℕ), I = Ideal.span {(p : ℤ)} ∧ p.Prime ∧ p ∣ n} := by
  sorry

/--
If $R$ is a Noetherian ring and $M \ne 0$ is an $R$-module,
then $\mathrm{Ass}_R(M)$ is non-empty.
Contributor: anonymous
-/
theorem DF_15_1_33 {R M : Type*} [CommRing R] [IsNoetherianRing R]
    [AddCommGroup M] [Module R M] [Nontrivial M] :
    (associatedPrimes R M).Nonempty := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_15\DF_15_2.lean -/
open MvPolynomial


/--
Let $R$ be a commutative ring with unity.
Intersection of two radical ideals of $R$ is a radical ideal.
Contributor: anonymous
-/
theorem DF_15_2_3 [CommRing R] {I J : Ideal R} (hI : I.IsRadical)
    (hJ : J.IsRadical) : (I ⊓ J).IsRadical := by
  sorry

/--
$I = \mathfrac{m}_1 \mathfrak{m}_2$ with $\mathfrak{m}_1 = (x, y)$ and
$\mathfrak{m}_2 = (x-1, y-1)$ is a radical ideal in $\mathbb{F}_2[x, y]$.
Also, $(x^3 - y^2)$ is a radical ideal in $\mathbb{F}_2[x, y]$.
Contributor: anonymous
-/
theorem DF_15_2_4_1 :
    let m₁ : Ideal (MvPolynomial (Fin 2) (ZMod 2)) := Ideal.span {X 0, X 1}
    let m₂ : Ideal (MvPolynomial (Fin 2) (ZMod 2)) :=
      Ideal.span {X 0 - 1, X 1 - 1}
    (m₁ * m₂).IsRadical := by
  sorry

theorem DF_15_2_4_2 :
    let I : Ideal (MvPolynomial (Fin 2) (ZMod 2)) :=
      Ideal.span {X 0 ^ 3 - X 1 ^ 2}
    I.IsRadical := by
  sorry

/--
Let $R$ and $S$ be commutative rings, and $f: R\rightarrow S$ a ring homomorphism.
Let $I$ be an ideal of $R$. Then $f(rad(I)) \subseteq rad(f(I))$, where $rad(J)$ is the radical of an ideal $J$.
Contributor: anonymous
-/
theorem DF_15_2_7_1 [CommRing R] [CommRing S] (f : R →+* S) (I : Ideal R) :
    Ideal.map f (I.radical) ≤ (Ideal.map f I).radical := by
  sorry

/--
Let $R$ and $S$ be commutative rings, and $f: R\rightarrow S$ a surjective ring homomorphism.
Let $I$ be an ideal of $R$ such that $I$ contains the kernel of $f$.
Then $f(rad(I)) = rad(f(I))$, where $rad(J)$ is the radical of an ideal $J$.
Contributor: anonymous
-/
theorem DF_15_2_7_2 [CommRing R] [CommRing S] (f : R →+* S)
    (hf : Function.Surjective f) (I : Ideal R) (hI : RingHom.ker f ≤ I) :
    Ideal.map f (I.radical) = (Ideal.map f I).radical := by
  sorry

/--
Let $R$ be a commutative ring with unity and let $I$ be an ideal of $R$.
If a prime ideal $P$ of $R$ contains $I$, then $P$ contains the radical of $I$.
Contributor: anonymous
-/
theorem DF_15_2_8 [CommRing R] {I P : Ideal R} (hP : P.IsPrime)
    (hIP : I ≤ P) : I.radical ≤ P := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_15\DF_15_4.lean -/
open MvPolynomial

/--
Let $R$ be a commutative ring and $M$ be a finitely generated $R$-module.
Let $D$ be a multiplicative subset of $R$.
Then the localization $D^{-1} M$ is the zero module if and only if
there exists $d \in D$ such that $d m = 0$ for all $m \in M$.
Contributor: anonymous
-/
theorem DF_15_4_1 {R M: Type*} [CommRing R] (D : Submonoid R)
    [AddCommMonoid M] [Module R M] [Module.Finite R M] :
    (∀ x : LocalizedModule D M, x = 0) ↔ ∃ d : D, ∀ m : M, d • m = 0 := by
  sorry

/--
The ideal $I = (y^3 - x z, x y^2 - z^2)$ of $\mathbb{Q}[x, y, z]$ is not prime.
There exists $a, b \in \mathbb{Q}[x, y, z]$ such that $a b \in I$ but $a \notin I$ and $b \notin I$.
Contributor: anonymous
-/

theorem DF_15_4_6 :
    let R := MvPolynomial (Fin 3) ℚ
    let x : R := MvPolynomial.X 0
    let y : R := MvPolynomial.X 1
    let z : R := MvPolynomial.X 2
    let I := Ideal.span {y ^ 3 - x * z, x * y ^ 2 - z ^ 2}
    ¬ I.IsPrime ∧ ∃ a b : R, a * b ∈ I ∧ a ∉ I ∧ b ∉ I := by
  sorry

/--
The ideal $P = (y^3 - xz, xy^2 - z^2, x^2 - yz)$
of $\mathbb{Q}[x, y, z]$ is prime.
Contributor: anonymous
-/
theorem DF_15_4_7 :
    let R := MvPolynomial (Fin 3) ℚ
    let x : R := MvPolynomial.X 0
    let y : R := MvPolynomial.X 1
    let z : R := MvPolynomial.X 2
    (Ideal.span {y ^ 3 - x * z, x * y ^ 2 - z ^ 2, x ^ 2 - y * z}).IsPrime := by
  sorry

/--
The ideal $P = (x^2 - yz, w^2 - x^4 z)$ of $\mathbb{Q}[x, y, z, w]$ is prime.
Contributor: anonymous
-/
theorem DF_15_4_8 :
    let R := MvPolynomial (Fin 4) ℚ
    let x : R := MvPolynomial.X 0
    let y : R := MvPolynomial.X 1
    let z : R := MvPolynomial.X 2
    let w : R := MvPolynomial.X 3
    (Ideal.span {x ^ 2 - y * z, w ^ 2 - x ^ 4 * z}).IsPrime := by
  sorry

/--
The ideal $P = (xz^2 - w^3, xw^2 - y^4, y^4 z^2 - w^5)$
of $\mathbb{Q}[x, y, z, w]$ is prime.
Contributor: anonymous
-/
theorem DF_15_4_9 :
    let R := MvPolynomial (Fin 4) ℚ
    let x : R := MvPolynomial.X 0
    let y : R := MvPolynomial.X 1
    let z : R := MvPolynomial.X 2
    let w : R := MvPolynomial.X 3
    (Ideal.span
      {x * z ^ 2 - w ^ 3, x * w ^ 2 - y ^ 4, y ^ 4 * z ^ 2 - w ^ 5}).IsPrime
    := by
  sorry

/--
The ideal $I = (xy - w^3, y^2 - zw)$ of $\mathbb{Q}[x, y, z, w]$ is not prime.
There exists $a, b \in \mathbb{Q}[x, y, z, w]$ such that $a b \in I$
but $a \notin I$ and $b \notin I$.
Contributor: anonymous
-/
theorem DF_15_4_10 :
    let R := MvPolynomial (Fin 4) ℚ
    let x : R := MvPolynomial.X 0
    let y : R := MvPolynomial.X 1
    let z : R := MvPolynomial.X 2
    let w : R := MvPolynomial.X 3
    let I := Ideal.span {x * y - w ^ 3, y ^ 2 - z * w}
    ¬ I.IsPrime ∧ ∃ a b : R, a * b ∈ I ∧ a ∉ I ∧ b ∉ I := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_16\DF_16_1.lean -/
/--
Let $R$ be a commutative ring with 1, and $I$ an ideal of $R$.
In addition, suppose that $R$ is Artinian.
Then $R/I$ is also Artinian.
Contributor: anonymous
-/
theorem DF_16_1_1 {R : Type*} [CommRing R] [IsArtinianRing R] (I : Ideal R) : IsArtinianRing (R ⧸ I) := by
  sorry

/--
Every finite commutative ring with 1 is Artinian.
Contributor: anonymous
-/
theorem DF_16_1_2 {R : Type*} [CommRing R] [Fintype R] : IsArtinianRing R := by
  sorry

/--
Artinian integral domain is a field.
Contributor: anonymous
-/
theorem DF_16_1_4 {R : Type*} [CommRing R] [IsDomain R] [IsArtinianRing R] :
    IsField R := by
  sorry

/--
Let $I$ be a nilpotent ideal of a commutative ring $R$ and $M$ be a $R$-module
with $M = IM$. Then $M = 0$
Contributor: anonymous
-/
theorem DF_16_1_5 {R M : Type*} [CommRing R] [AddCommGroup M] [Module R M]
    (I : Ideal R) (hI : IsNilpotent I)
    (hM : (⊤ : Submodule R M) = I • (⊤ : Submodule R M)) :
    (⊤ : Submodule R M) = ⊥ := by
  sorry

/--
Let $R$ be a commutative ring.
Let $0 \to M' \to M \to M'' \to 0$ be a short exact sequence of $R$-modules.
Then $M$ is Artinian if and only if $M'$ and $M''$ are Artinian.
Contributor: anonymous
-/
theorem DF_16_1_6 {R : Type*} [CommRing R]
    {S : CategoryTheory.ShortComplex (ModuleCat R)} (hS : S.ShortExact) :
    IsArtinian R S.X₂ ↔ IsArtinian R S.X₁ ∧ IsArtinian R S.X₃ := by
  sorry

/--
Let $F$ be a field and $M$ be a $F$-module (i.e. $F$-vector space).
$M$ is Artinian if and only if $M$ is Noetherian
if and only if $M$ is a finite dimensional vector space over $F$.
Contributor: anonymous
-/
theorem DF_16_1_7 {F M : Type*} [Field F] [AddCommGroup M] [Module F M] :
    [IsArtinian F M, IsNoetherian F M, FiniteDimensional F M].TFAE := by
  sorry

/--
If $R$ is a Noetherian ring, the Zariski topology on $\mathrm{Spec} R$ is discrete if and only if
$R$ is Artinian.
Contributor: anonymous
-/
theorem DF_16_1_13 {R : Type*} [CommRing R] [IsNoetherianRing R] :
    DiscreteTopology (PrimeSpectrum R) ↔ IsArtinianRing R := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_16\DF_16_3.lean -/
abbrev FractionalIdealOfDomain (R : Type*) [CommRing R] [IsDomain R] :=
  FractionalIdeal (nonZeroDivisors R) (FractionRing R)

/--
Let $R$ be an integral domain.
Every fractional ideal of $R$ is invertible if and only if every integral ideal
of $R$ is invertible.
Contributor: anonymous
-/
theorem DF_16_3_1 {R : Type*} [CommRing R] [IsDomain R] :
    (∀ I : FractionalIdealOfDomain R, I ≠ ⊥ → IsUnit I) ↔
    (∀ I : Ideal R, I ≠ ⊥ → IsUnit (I : FractionalIdealOfDomain R)) := by
  sorry

/--
Let $R$ be a Noetherian integral domain that is not a field.
Then $R$ is a Dedekind domain if and only if for each maximal ideal $M$ of $R$,
there are no ideals $I$ of $R$ with $M^2 \subseteq I \subseteq M$.
Contributor: anonymous
-/
theorem DF_16_3_7 {R : Type*} [CommRing R] [IsDomain R] [IsNoetherianRing R]
    (hR : ¬ IsField R) :
    IsDedekindDomain R ↔
    (∀ M : Ideal R, M.IsMaximal → ¬ ∃ I : Ideal R, M ^ 2 ≤ I ∧ I ≤ M) := by
  sorry

/--
Let $R$ be an integral domain.
Then $R_P$ is a DVR for every nonzero prime ideal $P$ if and only if
$R_M$ is a DVR for every nonzero maximal ideal $M$.
Contributor: anonymous
-/
theorem DF_16_3_9
    {R : Type*} [CommRing R] [IsDomain R] :
    (∀ (P : Ideal R), [P.IsPrime] → P ≠ ⊥ →
      IsDiscreteValuationRing (Localization.AtPrime P)) ↔
    (∀ (M : Ideal R), [M.IsMaximal] → M ≠ ⊥ →
      IsDiscreteValuationRing (Localization.AtPrime M)) := by
  sorry

/--
Let $R$ be a Dedekind domain. Then any nonzero fractional ideal of $R$
is projective.
Contributor: anonymous
-/
theorem DF_16_3_19 {R : Type*} [CommRing R] [IsDedekindDomain R]
    {I : FractionalIdealOfDomain R} (hI : I ≠ ⊥) :
    Module.Projective R I := by
  sorry

/--
Let $R$ be an integral domain, and $I, J$ be fractional ideals of $R$.
If $I^n = J^n$ for some $n \ne 0$, then $I = J$.
Contributor: anonymous
-/
theorem DF_16_3_20 {R : Type*} [CommRing R] [IsDomain R]
    {I J : FractionalIdealOfDomain R} (h : ∃ n, n ≠ 0 ∧ I ^ n = J ^ n) :
    I = J := by
  sorry

/--
Let $K$ be a number field and $P$ be a nonzero prime ideal of the ring of
integers $\mathcal{O}_K$ of $K$. Then there exists a rational prime $p$
and $\pi \in \mathcal{O}_K$ such that $P = (p, \pi)$.
Contributor: anonymous
-/
theorem DF_16_3_21 {K : Type*} [Field K] [NumberField K]
    {P : Ideal (NumberField.RingOfIntegers K)} (hnz : P ≠ ⊥)
    (hprime : Ideal.IsPrime P) :
    ∃ (p : ℕ) (π : NumberField.RingOfIntegers K),
      p.Prime ∧ P = Ideal.span {(p : NumberField.RingOfIntegers K), π} := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_18\DF_18_1.lean -/
universe u


noncomputable def quotientRep (G K : Type u) [Group G] [Field K] (V : FDRep K G) : FDRep K (G ⧸ V.ρ.ker) :=
  FDRep.of (QuotientGroup.lift _ V.ρ fun _g => MonoidHom.mem_ker.mp)

/--
If $\phi : G \rightarrow \mathrm{GL}(V) is any representation, then $\phi$ gives a
faithful representation of $G / \mathrm{ker} \phi$.
Contributor: anonymous
-/
theorem DF_18_1_1  {G K : Type u} [Group G] [Field K] (V : FDRep K G) :
    Function.Injective (quotientRep G K V).ρ := by
  sorry

/--
Let $F$ be a field, let $G$ be a finite group and let $n \in \mathbb{Z}^+$.
If $|G| > 1$ then every irreducible $FG$-module has dimension $< |G|$.
Contributor: anonymous
-/
theorem DF_18_1_5 {G K : Type u} [Group G] [Field K] [Fintype G]
    {V : FDRep K G} [CategoryTheory.Simple V] (hCardG : Fintype.card G > 1) :
    Module.rank K V < Fintype.card G := by
  sorry

/--
There is no subgroup of $\mathrm{GL}_2(\mathbb{R})$ isomorphic to
the quaternion group $Q_8$.
Contributor: anonymous
-/
theorem DF_18_1_10 : ¬ ∃ (H : Subgroup (GL (Fin 2) ℝ)),
    Nonempty (H ≃* QuaternionGroup 2) :=
  by sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_18\DF_18_2.lean -/
/--
Let $R$ be a nonzero ring. Then every $R$-module is projective if and only if
every $R$-module is injective.
Contributor: anonymous
-/
theorem DF_18_2_1 {R : Type*} [Ring R] [Nontrivial R] :
    (∀ (M : Type*) [AddCommGroup M] [Module R M], Module.Projective R M) ↔
    (∀ (M : Type*) [AddCommGroup M] [Module R M], Module.Injective R M) := by
  sorry

/--
Let $R$ be a nonzero ring. If every $R$-module is completely reducible,
then every $R$-module is injective.
Contributor: anonymous
-/
theorem DF_18_2_2 (R : Type*) [Ring R] [Nontrivial R] :
    (∀ (M : Type*) [AddCommGroup M] [Module R M], IsSemisimpleModule R M) →
    (∀ (M : Type*) [AddCommGroup M] [Module R M], Module.Injective R M) := by
  sorry

/--
Let $R$ be a ring with 1.
If any $R$-module is free, then $R$ is a division ring.
Contributor: anonymous
-/
theorem DF_18_2_11 {R : Type*} [Ring R] [Nontrivial R] :
    ∀ (M : Type*) [AddCommGroup M] [Module R M], Module.Free R M →
    Nonempty (DivisionRing R) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_19\DF_19_1.lean -/
/--
The symmetric group $S_6$ has an irreducible character of degree 5 over $\mathbb{C}$.
Contributor: anonymous
-/
theorem DF_19_1_7 : ∃ V : FDRep ℂ (Equiv.Perm (Fin 6)),
  CategoryTheory.Simple V ∧ (Module.finrank ℂ V = 5) := by
    sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_19\DF_19_3.lean -/
/--
Let $G$ be a finite group, and $H, N$ subgroups of $G$.
Moreover, suppose that $N$ is normal in $G$ and $N \le H$.
Let $\rho$ be a representation of $H$ such that $N \le \ker \rho$.
Then $N$ is also contained in the kernel of the induced representation $\rho \uparrow_H^G$.
Contributor: anonymous
-/
theorem DF_19_3_4 {G : Type} [Group G] [Fintype G] {H N : Subgroup G} (h_normal : N.Normal) (hHN : N ≤ H)
    {V : Rep ℂ H} (hN : N ≤ V.ρ.ker.map H.subtype) : N ≤ (Representation.ind H.subtype V.ρ).ker := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_1\DF_1_2.lean -/
/--
Let $D_{2n} = \langle r, s \mid r^{n} = s^2 = 1, rs = sr^{-1} \rangle$.
If $x$ is any element of $D_{2n}$ which is not a power of $r$,
then $rx = xr^{-1}$.
Contributor: anonymous
-/
theorem DF_1_2_2 (n : ℕ) (x : DihedralGroup n) :
    (∀ (k : ℕ), x ≠ (DihedralGroup.r (k : ZMod n))) →
    (DihedralGroup.r 1) * x = x * (DihedralGroup.r 1)⁻¹ := by
  sorry

/--
Let $D_{2n} = \langle r, s \mid r^{n} = s^2 = 1, rs = sr^{-1} \rangle$.
If $x$ is any element of $D_{2n}$ which is not a power of $r$,
then it has order $2$.
$D_{2n}$ is generated by $s$ and $sr$.
Contributor: anonymous
-/
theorem DF_1_2_3_1 (n : ℕ) (x : DihedralGroup n) :
    (∀ (k : ℕ), x ≠ (DihedralGroup.r (k : ZMod n))) →
    orderOf x = 2 := by
  sorry

theorem DF_1_2_3_2 (n : ℕ) :
    DihedralGroup n = Subgroup.closure ({(DihedralGroup.sr 1)*(DihedralGroup.r 1)⁻¹, DihedralGroup.sr 1} : Set (DihedralGroup n)) := by
  sorry

/--
If $n = 2k$ is even and $n \geq 4$, the element $z = r^k$ has order $2$
and commutes with all elements of $D_{2n}$
and $z = r^k$ is the only nonidentity element of $D_{2n}$
which commutes with all elements of $D_{2n}$.
Contributor: anonymous
-/
theorem DF_1_2_4_1 (k : ℕ) (n := 2 * k) (hn : 4 ≤ n)
    (rk := DihedralGroup.r (k : ZMod n)) :
    orderOf rk = 2 := by
  sorry

theorem DF_1_2_4_2 (k : ℕ) (n := 2 * k) (hn : 4 ≤ n)
    (rk := DihedralGroup.r (k : ZMod n)) (x : DihedralGroup n) :
    rk * x = x * rk := by
  sorry

theorem DF_1_2_4_3 (k : ℕ) (n := 2 * k) (hn : 4 ≤ n)
    (rk := DihedralGroup.r (k : ZMod n)) (x : DihedralGroup n) (hx1 : x ≠ 1)
    (hx2 : ∀ y : DihedralGroup n, x * y = y * x) : x = rk := by
  sorry

/--
If $n$ is odd and $n ≥ 3$, the identity is the only element of $D_{2n}$
which commutes with all elements of $D_{2n}$.
Contributor: anonymous
-/
theorem DF_1_2_5 (n : ℕ) (hn : 3 ≤ n) (hn2 : Odd n)
    (x : DihedralGroup n) (hx : ∀ y : DihedralGroup n, x * y = y * x) :
    x = 1 := by
  sorry

/--
Let $x$ and $y$ be elements of order $2$ in any group $G$.
If $t = xy$, then $tx = xt^{-1}$.
Contributor: anonymous
-/
theorem DF_1_2_6 (G : Type*) [Group G] (x y : G) (hx : orderOf x = 2)
    (hy : orderOf y = 2) (t := x * y) : t * x = x * t⁻¹ := by
  sorry

/--
$\langle x, y \mid a^2 = b^2 = (ab)^n = 1 \rangle$ gives a presentation
for the dihedral group $D_{2n}$ in terms of the two generators $a = s$
and $b = sr$ of order $2$.
Contributor: anonymous
-/
theorem DF_1_2_7_1 (n : ℕ) :
    Nonempty (PresentedGroup {
      (FreeGroup.of "a") ^ 2,
      (FreeGroup.of "b") ^ 2,
      (FreeGroup.of "a" * FreeGroup.of "b") ^ n
    } ≃* DihedralGroup n) := by
  sorry

theorem DF_1_2_7_2 (n : ℕ)
    (s := (DihedralGroup.sr 1) * (DihedralGroup.r 1)⁻¹) (sr := DihedralGroup.sr 1) :
    Subgroup.closure ({s, sr} : Set (DihedralGroup n)) = ⊤ := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_1\DF_1_4.lean -/
/--
$\mathrm{GL}_{2}(\mathbb{F}_{2})$ has 6 elements.
Contributor: anonymous
-/
theorem DF_1_4_1 : Nat.card
    (Matrix.GeneralLinearGroup (Fin 2) (GaloisField 2 1)) = 6 := by
  sorry

/--
$\mathrm{GL}_2(\mathbb{F}_2)$ is non-abelian.
Contributor: anonymous
-/
theorem DF_1_4_3 : ¬ IsMulCommutative (GL (Fin 2) (GaloisField 2 1)) := by
  sorry

/--
If $n$ is not prime then $\mathbb{Z} / n \mathbb{Z}$ is not a field.
Contributor: anonymous
-/
theorem DF_1_4_4 {n : ℕ} (hn : ¬ Nat.Prime n) : ¬ IsField (ZMod n) := by
  sorry

/--
\mathrm{GL}_{n}(\mathbb{F})$ is a finite group if and only if $\mathbb{F}$ has a finite number of elements.
Contributor: anonymous
-/
theorem DF_1_4_5 {n : ℕ} {F : Type*} [Field F] :
    Finite (Matrix.GeneralLinearGroup (Fin n) F) ↔ Finite F := by
  sorry

/--
If $|\mathbb{F}|=q$ is finite, then $|\mathrm{GL}_{n}(\mathbb{F})| < q^{n^{2}}$.
Contributor: anonymous
-/
theorem DF_1_4_6 {n : ℕ} {F : Type*} [Field F] [Finite F] {q : ℕ} (hq : q = Nat.card F):
    Nat.card (Matrix.GeneralLinearGroup (Fin n) F) < q ^ (n ^ 2) := by
  sorry

/--
For a prime $p$, $\mathrm{GL}_{2}(\mathbb{F}_{p})$ has $p^{4} - p^{3} - p^{2} + p$ elements.
Contributor: anonymous
-/
theorem DF_1_4_7 {p : ℕ} [Fact (Nat.Prime p)] : Nat.card (Matrix.GeneralLinearGroup (Fin 2) (GaloisField p 1))
    = p^4 - p^3 - p^2 + p := by
  sorry

/--
$\mathrm{GL}_{n}(F)$ is non-abelian for any $n \geq 2$.
Contributor: anonymous
-/
theorem DF_1_4_8 {n : ℕ} {F : Type*} [Field F] (hn : n ≥ 2) :
    ¬ IsMulCommutative (Matrix.GeneralLinearGroup (Fin n) F) := by
  sorry

/--
The binary operation of matrix multiplication of $2 \times 2$ matrices with real entries is
associative.
Contributor: anonymous
-/
theorem DF_1_4_9 : Std.Associative (· * · : _ → _ → Matrix (Fin 2) (Fin 2) ℝ) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_1\DF_1_6.lean -/
/--
Let $G, H$ be groups and $f : G \to H$ be a homomorphism. Then $f(x^n) = f(x)^n$ for all $n \in \mathbb{Z}^+$.
Contributor: anonymous
-/
theorem DF_1_6_1_a [Group G] [Group H] (f : G →* H) (x : G) (n : ℤ) (hn : n > 0) : f (x ^ n) = (f x) ^ n := by
  sorry

/--
Let $G, H$ be groups and $f : G \to H$ be a homomorphism. Then $f(x^n) = f(x)^n$ for all $n \in \mathbb{Z}$.
Contributor: anonymous
-/
theorem DF_1_6_1_b [Group G] [Group H] (f : G →* H) (x : G) (n : ℤ) : f (x ^ n) = (f x) ^ n := by
  sorry

/--
Let $G, H$ be groups and $f : G \to H$ be a isomorphism. Then $|f(x)| = |x|$ for all $x \in G$.
Contributor: anonymous
-/
theorem DF_1_6_2_a [Group G] [Group H] (f : G ≃* H) (x : G) : orderOf (f x) = orderOf x := by
  sorry

/--
Any two isomorphic groups have the same number of elements of order $n$ for each $n \in \mathbb{Z}^+$.
Contributor: anonymous
-/
theorem DF_1_6_2_b [Group G] [Group H] (f : G ≃* H) (n : ℤ) (hn : n > 0) : Nonempty ({g : G | orderOf g = n} ≃ {h : H | orderOf h = n}) := by
  sorry

/--
Let $G, H$ be groups and $f : G \to H$ be an isomorphism. Then $G$ is abelian if and only if $H$ is abelian.
Contributor: anonymous
-/
theorem DF_1_6_3 [Group G] [Group H] (f : G ≃* H) : Nonempty (CommGroup G) ↔ Nonempty (CommGroup H) := by
  sorry

theorem DF_1_6_3' [Group G] [Group H] (f : G ≃* H) : IsMulCommutative G ↔ IsMulCommutative H := by
  sorry

/--
The multiplicative groups $\mathbb{R} - \{0\}$ and $\mathbb{C} - \{0\}$ are not isomorphic.
Contributor: anonymous
-/
theorem DF_1_6_4 : IsEmpty (ℝˣ ≃* ℂˣ) := by sorry

/--
The additive groups $\mathbb{R}$ and $\mathbb{Q}$ are not isomorphic.
Contributor: anonymous
-/
theorem DF_1_6_5 : IsEmpty (ℝ ≃+ ℚ) := by sorry

/--
The additive groups $\mathbb{Z}$ and $\mathbb{Q}$ are not isomorphic.
Contributor: anonymous
-/
theorem DF_1_6_6 : IsEmpty (ℤ ≃+ ℚ) := by sorry

/--
$D_8$ and $Q_8$ are not isomorphic.
Contributor: anonymous
-/
theorem DF_1_6_7 : IsEmpty (DihedralGroup 4 ≃* QuaternionGroup 2) := by sorry

/--
If $n \ne m$, then $S_n$ and $S_m$ are not isomorphic.
Contributor: anonymous
-/
theorem DF_1_6_8 (n m : ℕ) (h : n ≠ m) : IsEmpty (Equiv.Perm (Fin n) ≃* Equiv.Perm (Fin m)) := by sorry

/--
$D_{24}$ and $S_4$ are not isomorphic.
Contributor: anonymous
-/
theorem DF_1_6_9 : IsEmpty (DihedralGroup 12 ≃* Equiv.Perm (Fin 4)) := by sorry

/--
For groups $G$ and $H$, $G \times H \cong H \times G$.
Contributor: anonymous
-/
theorem DF_1_6_11 [Group G] [Group H] : Nonempty (G × H ≃* H × G) := by
  sorry

/--
For groups $A, B, C$, $(A \times B) \times C \cong A \times (B \times C)$.
Contributor: anonymous
-/
theorem DF_1_6_12 [Group A] [Group B] [Group C] : Nonempty ((A × B) × C ≃* A × (B × C)) := by sorry

/--
Let $G, H$ be groups and $f: G \to H$ be a homomorphism. Then the image of $f$ is a subgroup of $H$.
Contributor: anonymous
-/
theorem DF_1_6_13_a [Group G] [Group H] (f : G →* H) : ∃ (A : Subgroup H), A = f.range := by
  sorry

def DF_1_6_13_a' [Group G] [Group H] (f : G →* H) : Subgroup H where
  carrier := f.range
  mul_mem' := by sorry
  one_mem' := by sorry
  inv_mem' := by sorry

/--
Let $G, H$ be groups and $f: G \to H$ be a homomorphism. If $f$ is injective, then $G \cong f(G)$.
Contributor: anonymous
-/
theorem DF_1_6_13_b [Group G] [Group H] (f : G →* H) (h : Function.Injective f) : Nonempty (G ≃* f.range) := by
  sorry

/--
Let $G, H$ be groups and $f: G \to H$ be a homomorphism. Then the kernel of $f$ is a subgroup of $G$.
Contributor: anonymous
-/
theorem DF_1_6_14_a [Group G] [Group H] (f: G →* H) : ∃ (A : Subgroup G), A = f.ker := by
  sorry

def DF_1_6_14_a' [Group G] [Group H] (f: G →* H) : Subgroup G where
  carrier := f.ker
  mul_mem' := by sorry
  one_mem' := by sorry
  inv_mem' := by sorry

/--
Let $G, H$ be groups and $f: G \to H$ be a homomorphism. Then $f$ is injective if and only if the kernel of $f$ is the identity subgroup of $G$.
Contributor: anonymous
-/
theorem DF_1_6_14_b [Group G] [Group H] (f: G →* H) : Function.Injective f ↔ f.ker = ⊥ := by
  sorry

/--
A projection map $\pi : \mathbb{R} \times \mathbb{R} \to \mathbb{R}$, defined by $\pi(x,y) = x$, is a homomorphism.
Contributor: anonymous
-/
theorem DF_1_6_15_a : ∃ (π : AddMonoidHom (ℝ × ℝ) ℝ), ∀ x, π x = Prod.fst x := by
  sorry

def DF_1_6_15_a' : AddMonoidHom (ℝ × ℝ) ℝ where
  toFun := Prod.fst
  map_zero' := by sorry
  map_add' := by sorry

/--
A kernel of a projection map $\pi : \mathbb{R} \times \mathbb{R} \to \mathbb{R}$, defined by $\pi(x,y) = x$, is $\mathbb{R}$.
Contributor: anonymous
-/
theorem DF_1_6_15_b (π : AddMonoidHom (ℝ × ℝ) ℝ) (h : ∀ x y : ℝ, π (x, y) = x) : Nonempty (π.ker ≃+ ℝ) := by
  sorry

/--
For groups $G, H$, a projection map $\pi_1 : G \times H \to G$, defined by $\pi_1(a,b) = a$, is a homomorphism.
Contributor: anonymous
-/
theorem DF_1_6_16_a [Group G] [Group H]: ∃ (π₁ : MonoidHom (G × H) G), ∀ x, π₁ x = Prod.fst x := by
  sorry

def DF_1_6_16_a' [Group G] [Group H] : MonoidHom (G × H) G where
  toFun := Prod.fst
  map_one' := by sorry
  map_mul' := by sorry

/--
For groups $G, H$, a projection map $\pi_2 : G \times H \to H$, defined by $\pi_2(a,b) = b$, is a homomorphism.
Contributor: anonymous
-/
theorem DF_1_6_16_b [Group G] [Group H]: ∃ (π₂ : MonoidHom (G × H) H), ∀ x, π₂ x = Prod.snd x := by
  sorry

def DF_1_6_16_b' [Group G] [Group H] : MonoidHom (G × H) H where
  toFun := Prod.snd
  map_one' := by sorry
  map_mul' := by sorry

/--
For groups $G, H$, a kernel of a projection map $\pi_1 : G \times H \to G$, defined by $\pi_1(a,b) = a$, is $H$.
Contributor: anonymous
-/
theorem DF_1_6_16_c {G H} [Group G] [Group H] (π₁ : MonoidHom (G × H) G) (h : ∀ x, π₁ x = Prod.fst x) : Nonempty (π₁.ker ≃* H) := by
  sorry

/--
For groups $G, H$, a kernel of a projection map $\pi_2 : G \times H \to H$, defined by $\pi_1(a,b) = b$, is $G$.
Contributor: anonymous
-/
theorem DF_1_6_16_d {G H} [Group G] [Group H] (π₂ : MonoidHom (G × H) H) (h : ∀ x, π₂ x = Prod.snd x) : Nonempty (π₂.ker ≃* G) := by
  sorry

/--
Let $G$ be a group and $f : G \to G$ be a map defined by $g \mapsto g^{-1}$. Then $f$ is a homomorphism if and only if $G$ is abelian.
Contributor: anonymous
-/
def DF_1_6_17_UnitMap (G : Type*) [Group G] : G → G := fun g ↦ g⁻¹

theorem DF_1_6_17 {G} [Group G] : (∃ (f : MonoidHom G G), (f : G → G) = DF_1_6_17_UnitMap G) ↔ IsMulCommutative G := by
  sorry

/--
Let $G$ be a group and $f : G \to G$ be a map defined by $g \mapsto g^2$. Then $f$ is a homomorphism if and only if $G$ is abelian.
Contributor: anonymous
-/
def DF_1_6_18_SquareMap (G : Type*) [Group G] : G → G := fun g ↦ g * g

theorem DF_1_6_18 {G} [Group G] : (∃ (f : MonoidHom G G), (f : G → G) = DF_1_6_18_SquareMap G) ↔ IsMulCommutative G := by
  sorry

/--
Let $G = \{z \in \mathbb{C} : z^n = 1 \text{ for some } n \in \mathbb{Z}^+ \}$.
Then for any fixed integer $k > 1$, the map from $G$ to itself defined by $z \mapsto z^k$ is a surjective homomorphism.
Contributor: anonymous
-/
def DF_1_6_19_rootsOfUnity : Subgroup ℂˣ := ⨆ (n : ℕ+), rootsOfUnity n ℂ

def DF_1_6_19_a (k : ℤ) (h : k > 1) : MonoidHom DF_1_6_19_rootsOfUnity DF_1_6_19_rootsOfUnity where
  toFun := fun (x : DF_1_6_19_rootsOfUnity) => x ^ k
  map_one' := by sorry
  map_mul' := by sorry

theorem DF_1_6_19_b (k : ℤ) (h : k > 1) : Function.Surjective (DF_1_6_19_a k h) := by sorry

/--
Let $G$ be a group and $Aut(G)$ be the set of all isomorphisms from $G$ onto $G$. Then $Aut(G)$ is a group under function composition.
Contributor: anonymous
-/
def DF_1_6_20 (G : Type*) [Group G]: Group (G ≃* G) where
  mul := MulEquiv.trans
  one := by sorry
  inv := by sorry
  mul_assoc := by sorry
  one_mul := by sorry
  mul_one := by sorry
  div_eq_mul_inv := by sorry
  inv_mul_cancel := by sorry

/--
For each fixed nonzero $k \in \mathbb{Q}$, the map from $Q$ to itself defined by $x \mapsto k*x$ is an automorphism of $Q$.
Contributor: anonymous
-/
def DF_1_6_21 (k : ℚ) (h : k ≠ 0) : AddAut ℚ where
  toFun := fun (x : ℚ) => k * x
  map_add' := by sorry
  invFun := by sorry
  left_inv := by sorry
  right_inv := by sorry

/--
Let $A$ be an abelian group and fix some $k \in \mathbb{Z}$.
The map $a \mapsto a^k$ is a homomorphism from $A$ to itself.
If $k = -1$ then this homomorphism is an isomorphism.
Contributor: anonymous
-/
theorem DF_1_6_22 {A : Type*} [CommGroup A] {k : ℤ} :
    ∃ φ : A →* A, (φ.toFun = fun a ↦ a ^ k) ∧ (k = -1 → ∃ e : MulAut A, e.toFun = φ) := by
  sorry

def DF_1_6_22_a [CommGroup A] (k : ℤ) : MonoidHom A A where
  toFun := fun (a : A) => a ^ k
  map_one' := by sorry
  map_mul' := by sorry

def DF_1_6_22_b [CommGroup A] : MulEquiv A A where
  toFun := fun (a : A) => a⁻¹
  invFun := by sorry
  left_inv := by sorry
  right_inv := by sorry
  map_mul' := by sorry

/--
Let $G$ be a finite group which possesses an automorphism $\sigma$ such that $\sigma(g) = g$ if and only if $g=1$.
If $\sigma^2$ is the identity map from $G$ to $G$, then $G$ is abelian.
Contributor: anonymous
-/
structure DF_1_6_23_GPwAut (G : Type*) [Group G] [Fintype G] where
  auto : G ≃* G
  fix_iff_id : ∀ g : G, auto g = g ↔ g = 1

theorem DF_1_6_23 {G : Type*} [Group G] [Fintype G] (h_aut : DF_1_6_23_GPwAut G)
(h_sq : h_aut.auto ∘ h_aut.auto = 1) : IsMulCommutative G := by sorry

/--
Let $G$ be a finite group and let $x$ and $y$ be distinct elements of order $2$ in $G$ that generate $G$.
Then $G \cong D_{2n}$, where $n = \lvert x y \rvert$.
Contributor: anonymous
-/
structure DF_1_6_24_GPgenbyxy (G : Type*) [Group G] [Fintype G] where
  x : G
  y : G
  distinct : x ≠ y
  x_order2 : x ^ 2 = 1
  y_order2 : y ^ 2 = 1
  gen : Subgroup.closure {x, y} = ⊤

theorem DF_1_6_24 {G : Type*} [Group G] [Fintype G] (h : DF_1_6_24_GPgenbyxy G) :
∃ (n : ℕ) (h_iso : G ≃* DihedralGroup n), orderOf (h.x * h.y) = n := by sorry

/--
Let $n \in \mathbb{Z}^+$. Let $r$ and $s$ be the usual generators of $D_{2n}$ and let $\theta = 2 \pi/n$.
Then the map $f : D_{2n} → GL_2 (\mathbb{R})$ defined on generators by
\begin{equation*}
  f (r) = \begin{matrix} \cos \theta & - \sin \theta \\ \sin \theta \cos \theta \end{matrix} \quad \text{and} \quad f(s) = \begin{matrix} 0 & 1 \\ 1 & 0 \end{matrix}
\end{equation*}
extends to an injective homomorphism of $D_{2n}$ into $GL_2 (\mathbb{R})$.
Contributor: anonymous
-/
noncomputable def DF_1_6_25_RotationMatrix (θ : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  Matrix.of fun i j =>
    match i, j with
    | 0, 0 => Real.cos θ
    | 0, 1 => -Real.sin θ
    | 1, 0 => Real.sin θ
    | 1, 1 => Real.cos θ

def DF_1_6_25_ReflectionMatrix : Matrix (Fin 2) (Fin 2) ℝ :=
    !![1, 0;
      0, -1]

structure DF_1_6_25_DihedtoGL (n : ℕ) where
    R : GL (Fin 2) ℝ
    S : GL (Fin 2) ℝ
    theta_def : R = DF_1_6_25_RotationMatrix (2 * π / n)
    S_def : S = DF_1_6_25_ReflectionMatrix

theorem DF_1_6_25 (n : ℕ) (h : DF_1_6_25_DihedtoGL n) : ∃ f : DihedralGroup n →* GL (Fin 2) ℝ,
    f (DihedralGroup.r 1) = h.R ∧ f (DihedralGroup.sr 0) = h.S ∧ Function.Injective f := by
  sorry

/--
Let $i$ and $j$ be the generators of $Q_8$.
Then the map $f$ from $Q_8$ to $GL_2 (\mathbb{C})$ defined on generators by
\begin{equation*}
f(i) = \begin{matrix} \sqrt{-1} & 0 \\ 0 & -\sqrt{-1} \end{matrix} \quad \text{and} \quad f(j) = \begin{matrix} 0 & -1 \\ 1 & 0 \end{matrix}
\end{equation*}
extends to an injective homomorphism.
Contributor: anonymous
-/
noncomputable def DF_1_6_26_f_i : GL (Fin 2) ℂ :=
  Units.mk
    (!![Complex.I, 0; 0, -Complex.I])
    (!![-Complex.I, 0; 0, Complex.I])
    (by sorry)
    (by sorry)

noncomputable def DF_1_6_26_f_j : GL (Fin 2) ℂ :=
  Units.mk
    (!![0, -1; 1, 0])
    (!![0, 1; -1, 0])
    (by sorry)
    (by sorry)

theorem DF_1_6_26 (n : ℕ) : ∃ f : QuaternionGroup n →* GL (Fin 2) ℂ,
    f (QuaternionGroup.a 1) = DF_1_6_26_f_i ∧
    f (QuaternionGroup.xa 0) = DF_1_6_26_f_j ∧
    Function.Injective f := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_2\DF_2_1.lean -/
/--
A group $G$ cannot have a subgroup $H$ with $|H|=n-1$, where $n=|G|>2$.
Contributor: anonymous
-/
theorem DF_2_1_5 [Group G] (h : Nat.card G > 2) :
    ¬∃ (H : Subgroup G), Nat.card H = Nat.card G - 1 := by
  sorry

/--
Let $H$ and $K$ be subgroups of a group $G$.
Then, $H \cup K$ is a subgroup of $G$ if and only if $H \subseteq K$ or $K \subseteq H$.
Contributor: anonymous
-/
theorem DF_2_1_8 {G : Type*} [Group G] (H K : Subgroup G) :
    (∃ L : Subgroup G, L.carrier = H.carrier ∪ K.carrier) ↔
    H.carrier ⊆ K.carrier ∨ K.carrier ⊆ H.carrier := by
  sorry

/--
Let $A$ be an abelian group and $n$ be an integer.
(a) $\{a^n : a \in A\}$ is a subgroup of $A$.
(b) $\{a \in A : a^n = 1\}$ is a subgroup of $A$.
Contributor: anonymous
-/
theorem DF_2_1_12_a {A : Type*} [CommGroup A] (n : ℤ) :
    ∃ H : Subgroup A, H.carrier = {a : A | ∃ b : A, a = b ^ n} := by
  sorry

theorem DF_2_1_12_b {A : Type*} [CommGroup A] (n : ℤ) :
    ∃ H : Subgroup A, H.carrier = {a : A | a ^ n = 1} := by
  sorry

/--
Let $H$ be an additive subgroup of $\mathbb{Q}$ such that for every
nonzero element $x$ in $H$, its inverse $1/x$ is also in $H$.
Then, $H$ is either the trivial subgroup or the whole group.
Contributor: anonymous
-/
theorem DF_2_1_13 (H : AddSubgroup ℚ)
    (h_inv : ∀ (x : ℚ), x ∈ H → x ≠ 0 → (1 / x) ∈ H) : H = ⊥ ∨ H = ⊤ := by
  sorry

/--
Let $n \ge 3$ be an integer.
Then, the set of elements of order 1 or 2 in the dihedral group $D_n$
does not form a subgroup.
Contributor: anonymous
-/
theorem DF_2_1_14 {n : ℕ} (hn : 3 ≤ n) :
    ¬ ∃ H : Subgroup (DihedralGroup n),
      H.carrier = {x : DihedralGroup n | x ^ 2 = 1} := by
  sorry

/--
Let $\{H_i\}_{i \in \mathbb{N}}$ be an ascending chain of subgroups
of a group $G$. Then, the union $\bigcup_{i \in \mathbb{N}} H_i$
is also a subgroup of $G$.
Contributor: anonymous
-/
theorem DF_2_1_15 {G : Type*} [Group G] (H : ℕ → Subgroup G)
    (hchain : ∀ i, H i ≤ H (i + 1)) :
    ∃ K : Subgroup G, K.carrier = ⋃ i, (H i).carrier := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_2\DF_2_3.lean -/
/--
For a finite group $G$, if there exists an element $x$ in $G$ such that the order of $x$
is equal to the order of $G$, then $G$ is a cyclic group generated by $x$.
Also, there exists an infinite group $G$ and an element $x$ in $G$ such that the order of $x$ is also infinite, while the subgroup generated by $x$ is a proper subgroup of $G$.
Contributor: anonymous
-/
theorem DF_2_3_2_1 {G : Type*} [Group G] [Fintype G] {x : G}
    (hx : orderOf x = Fintype.card G) :
    Subgroup.closure ({x} : Set G) = (⊤ : Subgroup G) := by
  sorry

theorem DF_2_3_2_2 : ∃ (G : Type*) (_ : Group G) (_ : Infinite G) (x : G),
    orderOf x = 0 ∧
    Subgroup.closure ({x} : Set G) ≠ (⊤ : Subgroup G) := by
  sorry

/--
The following groups are not cyclic:
(a) $Z_2 \times Z_2$
(b) $Z_2 \times \mathbb{Z}$
(c) $\mathbb{Z} \times \mathbb{Z}$
Contributor: anonymous
-/

theorem DF_2_3_12_a : ¬ IsAddCyclic ((ZMod 2) × (ZMod 2)) := by
  sorry

theorem DF_2_3_12_b : ¬ IsAddCyclic ((ZMod 2) × ℤ) := by
  sorry

theorem DF_2_3_12_c : ¬ IsAddCyclic (ℤ × ℤ) := by
  sorry

/--
The following groups are not isomorphic:
(a) $\mathbb{Z} times Z_2$ and $\mathbb{Z}$
(b) $\mathbb{Q} times Z_2$ and $\mathbb{Q}$
Contributor: anonymous
-/

theorem DF_2_3_13_a : ¬ Nonempty (ℤ × (ZMod 2) ≃+ ℤ) := by
  sorry

theorem DF_2_3_13_b : ¬ Nonempty (ℚ × (ZMod 2) ≃+ ℚ) := by
  sorry

/--
$\mathbb{Q} \times \mathbb{Q}$ is not cyclic.
Contributor: anonymous
-/

theorem DF_2_3_15 : ¬ IsAddCyclic (ℚ × ℚ) := by
  sorry


/--
Let $G$ be a group and let $x, y \in G$ be elements of finite order
$n$ and $m$ respectively. If $x$ and $y$ commute, then the order of $xy$
divides the least common multiple of $n$ and $m$.
Also, determine whether the statement is true or false without the
commutativity condition.
At last, there exists a group $G$ and elements $x, y \in G$ of finite order
$n$ and $m$ respectively such that $x$ and $y$ commute, but the order of $xy$
is not equal to the least common multiple of $n$ and $m$.
Contributor: anonymous
-/
theorem DF_2_3_16_1 {G : Type*} [Group G] (x y : G) {n m : ℕ} (hn : 0 < n)
    (hm : 0 < m) (hx : orderOf x = n) (hy : orderOf y = m) (hxy : Commute x y) :
    orderOf (x * y) ∣ Nat.lcm n m := by
  sorry

def DF_2_3_16_2_ans : Bool := sorry

theorem DF_2_3_16_2 : DF_2_3_16_2_ans ↔
    ∃ (G : Type*) (_ : Group G) (x y : G) (n m : ℕ) (hn : 0 < n) (hm : 0 < m),
      orderOf x = n ∧ orderOf y = m ∧ ¬ Commute x y ∧
      ¬ (orderOf (x * y) ∣ Nat.lcm n m) := by
  sorry

theorem DF_2_3_16_3 :
  ∃ (G : Type*) (_ : Group G) (x y : G) (n m : ℕ) (hn : 0 < n) (hm : 0 < m),
    orderOf x = n ∧ orderOf y = m ∧
    Commute x y ∧ orderOf (x * y) ≠ Nat.lcm n m := by
  sorry

/--
Let $p$ be a prime and let $n$ be a positive integer.
If $x$ is an element of the group $G$ such that $x^{p^{n}}=1$ then $|x|=p^{m}$
for some $m \leq n$.
Contributor: anonymous
-/
theorem DF_2_3_20 {G : Type*} [Group G] {p : ℕ} (hp : Nat.Prime p) {n : ℕ}
    (hn : 0 < n) {x : G} (hx : x ^ (p ^ n) = 1) :
    ∃ m ≤ n, orderOf x = p ^ m := by
  sorry

/--
Let $p$ be an odd prime and $n \ge 2$ be an integer.
Then $(1 + p)^{p^{n-1}} \equiv 1 \pmod{p^n}$ but
$(1 + p)^{p^{n-2}} \not\equiv 1 \pmod{p^n}$. From this, we can conclude that
$1 + p$ is an element of order $p^{n-1}$ in the group
$(\mathbb{Z}/p^n\mathbb{Z})^\times$.
Contributor: anonymous
-/
theorem DF_2_3_21_1 {p n : ℕ} (hp : p.Prime) (hodd : Odd p) (hn : 2 ≤ n) :
    (1 + p) ^ (p ^ (n - 1)) ≡ 1 [ZMOD (p ^ n)] ∧
    ¬ (1 + p) ^ (p ^ (n - 2)) ≡ 1 [ZMOD (p ^ n)] := by
  sorry

theorem DF_2_3_21_2 {p n : ℕ} (hp : p.Prime) (hodd : Odd p) (hn : 2 ≤ n) :
    ∃ (u : (ZMod (p ^ n))ˣ), u = (1 + p : ZMod (p ^ n)) ∧
    orderOf u = p ^ (n - 1) := by
  sorry

/--
For integer $n \ge 3$, $(1 + 2^2)^{2^{n-2}} \equiv 1 \pmod{2^n}$ but
$(1 + 2^2)^{2^{n-3}} \not\equiv 1 \pmod{2^n}$.
From this, we can conclude that 5 is an element of order $2^{n-2}$ in the group
$(\mathbb{Z}/2^n\mathbb{Z})^\times$.
Contributor: anonymous
-/
theorem DF_2_3_22_1 {n : ℕ} (hn : 3 ≤ n) :
    (1 + 2 ^ 2) ^ (2 ^ (n - 2)) ≡ 1 [ZMOD (2 ^ n)] ∧
    ¬ (1 + 2 ^ 2) ^ (2 ^ (n - 3)) ≡ 1 [ZMOD (2 ^ n)] := by
  sorry

theorem DF_2_3_22_2 {n : ℕ} (hn : 3 ≤ n) :
    ∃ (u : (ZMod (2 ^ n))ˣ), u = (5 : ZMod (2 ^ n)) ∧
    orderOf u = 2 ^ (n - 2) := by
  sorry

/--
$\left(\mathbb{Z} / 2^{n} \mathbb{Z}\right)^{\times}$ is not cyclic
for any $n \geq 3$.
Contributor: anonymous
-/

theorem DF_2_3_23 {n : ℕ} (hn : 3 ≤ n) : ¬ IsCyclic (Units (ZMod (2^n))) := by
  sorry

/--
Let $G$ be a finite group and let $x \in G$.
Then, an element $g$ normalizes the subgroup generated by $x$ if and only if
there exists an integer $a$ such that $g x g^{-1} = x^{a}$.
Also, the converse holds.
Contributor: anonymous
-/
theorem DF_2_3_24_a {G : Type*} [Group G] [Fintype G] {x g : G}
    (hg : g ∈ Subgroup.normalizer (Subgroup.zpowers x : Set G)) :
    ∃ a : ℤ, g * x * g⁻¹ = x ^ a := by
  sorry

theorem DF_2_3_24_b {G : Type*} [Group G] [Fintype G] {x g : G}
    (h : ∃ a : ℤ, g * x * g⁻¹ = x ^ a) :
    g ∈ Subgroup.normalizer (Subgroup.zpowers x : Set G) := by
  sorry

/--
Let $G$ be a finite cyclic group of order $n$ and let $k$ be an integer
that is coprime to $n$. Then the map $x \mapsto x^{k}$ from $G$ to itself
is surjective.
The same conclusion holds even if $G$ is not cyclic.
Contributor: anonymous
-/
theorem DF_2_3_25_1 {G : Type*} [Group G] [Fintype G]
    (hG : IsCyclic G) {n : ℕ} {k : ℤ} (hc : Fintype.card G = n)
    (hcoprime : IsCoprime k n) : Function.Surjective (fun x : G => x ^ k) := by
  sorry

theorem DF_2_3_25_2 {G : Type*} [Group G] [Fintype G]
    {n : ℕ} {k : ℤ} (hc : Fintype.card G = n)
    (hcoprime : IsCoprime k n) : Function.Surjective (fun x : G => x ^ k) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_2\DF_2_5.lean -/
/--
Let $D_4$ be the dihedral group of order $8$.
Let $r$ be a rotation of 90 degrees and $s$ be a reflection.
Then the subgroup generated by $r^2$ and $s$ is isomorphic to $V_4$, the Klein four-group.
Contributor: anonymous
-/
abbrev D₄ := DihedralGroup 4

def DF_2_5_3 {V₄} [Group V₄] [IsKleinFour V₄] : Subgroup.closure {(DihedralGroup.r 2 : D₄), (DihedralGroup.sr 0 : D₄)} ≃* V₄ := by
  sorry

/--
Define $QD$ to be the group of order $16$ generated by two elements $\sigma$ and $\tau$
with relations $\sigma^8 = \tau^2 = 1$ and $\sigma \tau = \tau \sigma^3$.
Let $G_0, G_1, G_2, H_0, H_1, H_2, H_3$ be the subgroups of $QD$ given by
\begin{align*}
  G_0 &:= \langle \sigma^2, \tau \rangle, \\
  G_1 &:= \langle \sigma \rangle, \\
  G_2 &:= \langle \sigma^2, \tau \sigma \rangle, \\
  H_0 &:= \langle \sigma^4, \tau \rangle, \\
  H_1 &:= \langle \tau \sigma^2 \rangle, \\
  H_2 &:= \langle \tau \rangle, \\
  H_3 &:= \langle \sigma^4 \rangle.
\end{align*}
Then there are $6$ missing nontrivial proper subgroups $K_i$ of $QD$
where $i=0,\dots,5$, and they satisfy the following relations:
\begin{align*}
  H_1, H_3, K_4 < K_0 < G_0, \\
  H_3 < K_1 < G_0, G_1, G_2, \\
  H_3 < K_2 < G_2, \\
  H_3 < K_3 < G_2, \\
  \mathbf{1} < K_4 < K_0, \\
  \mathbf{1} < K_5 < H_0,
\end{align*}
where $\mathbf{1}$ denotes the trivial subgroup.
Find generators of the missing subgroups $K_i$ where each of them is generated
by at most two elements.
Contributor: anonymous
-/
inductive QDGen | σ | τ deriving DecidableEq, Repr

open FreeGroup in
def QD := PresentedGroup {
  (of QDGen.σ)^8,
  (of QDGen.τ)^2,
  (of QDGen.σ) * (of QDGen.τ) * (of QDGen.σ)^(-3 : ℤ) * (of QDGen.τ)^(-1 : ℤ)
}

deriving instance Group for QD


abbrev QD.of (x : QDGen) : QD := PresentedGroup.of x

abbrev σ : QD := PresentedGroup.of QDGen.σ
abbrev τ : QD := PresentedGroup.of QDGen.τ

def DF_2_5_11_ans : Fin 6 → Set QD
  | 0 => sorry
  | 1 => sorry
  | 2 => sorry
  | 3 => sorry
  | 4 => sorry
  | 5 => sorry

def DF_2_5_11_groups : Fin 6 → Subgroup QD := fun i ↦ Subgroup.closure (DF_2_5_11_ans i)

def G₀ := Subgroup.closure {σ ^ 2, τ}

def G₁ := Subgroup.closure {σ}

def G₂ := Subgroup.closure {σ ^ 2, τ * σ}

def H₀ := Subgroup.closure {σ ^ 4, τ}

def H₁ := Subgroup.closure {τ * σ ^ 2}

def H₂ := Subgroup.closure {τ}

def H₃ := Subgroup.closure {σ ^ 4}

theorem DF_2_5_11_1 : ∀ i : Fin 6, Finite (DF_2_5_11_ans i) ∧ (DF_2_5_11_ans i).ncard ≤ 2 := by
  sorry

theorem DF_2_5_11_2 :
    DF_2_5_11_groups 0 < G₀ ∧
    H₁ < DF_2_5_11_groups 0 ∧
    H₃ < DF_2_5_11_groups 0 ∧
    DF_2_5_11_groups 1 < G₀ ∧
    DF_2_5_11_groups 1 < G₁ ∧
    DF_2_5_11_groups 1 < G₂ ∧
    H₃ < DF_2_5_11_groups 1 ∧
    DF_2_5_11_groups 2 < G₂ ∧
    H₃ < DF_2_5_11_groups 2 ∧
    DF_2_5_11_groups 3 < G₂ ∧
    H₃ < DF_2_5_11_groups 3 ∧
    DF_2_5_11_groups 2 ≠ DF_2_5_11_groups 3 ∧
    DF_2_5_11_groups 4 < DF_2_5_11_groups 0 ∧
    ⊥ < DF_2_5_11_groups 4 ∧
    DF_2_5_11_groups 5 < H₀ ∧
    ⊥ < DF_2_5_11_groups 5 := by
  sorry

/--
Let $M$ be a group generated by two elements $u, v$ with relations
$u^2 = v^8 = 1$ and $vu = uv^5 \Leftrightarrow uv^5 * u^{-1} v^{-1} = 1$.
The subgroup of $M$ generated by $u$ and $v^2$ is isomorphic to
$Z_2 \times Z_4$, the subgroup generated by $v$ is isomorphic to $Z_8$,
and subgroup generated by $uv$ is isomorphic to $Z_8$.
The lattice of subgroups of $M$ is isomorphic to that of $Z_2 \times Z_8$.
However, $M$ and $Z_2 \times Z_8$ are not isomorphic.
Contributor: anonymous
-/
inductive MGen | u | v deriving DecidableEq, Repr

open FreeGroup in
def M := PresentedGroup {
  (of MGen.u)^2,
  (of MGen.v)^8,
  (of MGen.u) * (of MGen.v)^5 * (of MGen.u)^(-1 : ℤ) * (of MGen.v)^(-1 : ℤ)
}

deriving instance Group for M

abbrev M.of (x : MGen) : M := PresentedGroup.of x

theorem DF_2_5_14_1 :
    Nonempty
      (Subgroup.closure {M.of MGen.u, (M.of MGen.v)^2} ≃*
        Multiplicative ((ZMod 2) × (ZMod 4))) := by
  sorry

theorem DF_2_5_14_2 :
    Nonempty (Subgroup.closure {M.of MGen.v} ≃*
      Multiplicative (ZMod 8)) := by
  sorry

theorem DF_2_5_14_3 :
    Nonempty (Subgroup.closure {M.of MGen.u * M.of MGen.v} ≃*
      Multiplicative (ZMod 8)) := by
  sorry

theorem DF_2_5_14_4 :
    Nonempty
      ((Subgroup M) ≃o
        AddSubgroup ((ZMod 2) × (ZMod 8))) := by
  sorry

theorem DF_2_5_14_5 :
    ¬Nonempty (M ≃* Multiplicative ((ZMod 2) × (ZMod 8))) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_3\DF_3_2.lean -/
/-
If $|G| = pq$ for primes $p$ and $q$, then either $G$ is abelian or $Z(G) = 1$.
Contributor: anonymous
-/
theorem DF_3_2_4 {G : Type*} [Group G] {p q : Nat} (hp : p.Prime) (hq : q.Prime)
    (hG : Nat.card G = p * q) :
    IsMulCommutative G ∨ Subgroup.center G = ⊥ := by
  sorry

/-
If $H$ and $K$ are finite subgroups of $G$ with relatively prime orders,
then $H \cap K = 1$.
Contributor: anonymous
-/
theorem DF_3_2_8 {G : Type*} [Group G] {H K : Subgroup G} (hH : Finite H)
    (hK : Finite K) (h : (Nat.card H).Coprime (Nat.card K)) :
    H ⊓ K = ⊥ := by
  sorry

/-
Let $H, K$ be subgroups of finite index in $G$. If $|G:H| = m$ and $|G:K| = n$,
then $\lcm(m, n) ≤ |G:H \cap K| ≤ mn$.
If $m$ and $n$ are coprime, then $|G:H \cap K| = |G:H| \cdot |G:K|$.
Contributor: anonymous
-/
theorem DF_3_2_10_1 {G : Type*} [Group G] {H K : Subgroup G}
    (hH : H.FiniteIndex) (hK : K.FiniteIndex) (h : H.index.Coprime K.index) :
    H.index.lcm K.index ≤ (H ⊓ K).index ∧
    (H ⊓ K).index ≤ H.index * K.index := by
  sorry

theorem DF_3_2_10_2 {G : Type*} [Group G] {H K : Subgroup G}
    (hH : H.FiniteIndex) (hK : K.FiniteIndex) (h : H.index.Coprime K.index) :
    (H ⊓ K).index = H.index * K.index := by
  sorry

/-
Let $H \le K \le G$ be groups. Then $|G:H| = |G:K| \cdot |K:H|$.
Contributor: anonymous
-/
theorem DF_3_2_11 {G : Type*} [Group G] {H K : Subgroup G} {h : H ≤ K} :
    H.index = (H.subgroupOf K).index * K.index := by
  sorry

/-
$S_4$ does not have a normal subgroup of order 8 or order 3.
Contributor: anonymous
-/
theorem DF_3_2_14_1 : ¬∃ (H : Subgroup (Equiv.Perm (Fin 4))),
    H.Normal ∧ Nat.card H = 8 := by
  sorry

theorem DF_3_2_14_2 : ¬∃ (H : Subgroup (Equiv.Perm (Fin 4))),
    H.Normal ∧ Nat.card H = 3 := by
  sorry

/-
Let $G = S_n$ and for a fixed $i\in \{1, 2, \dots, n\}$, let $G_i$ be the
stabilizer of $i$. Then $G_i$ is isomorphic to $S_{n-1}$.
Contributor: anonymous
-/
theorem DF_3_2_15 {n : ℕ} (hn : 1 < n) (i : Fin n) :
    Nonempty (MulAction.stabilizer (Equiv.Perm (Fin n)) i ≃*
      Equiv.Perm (Fin (n - 1))) := by
  sorry

/-
Fermat's little theorem: For a prime $p$ and any integer $a$,
we have $a^p \equiv a \pmod p$.
Contributor: anonymous
-/
theorem DF_3_2_16 {p : ℕ} (hp : p.Prime) (a : ℤ) : a ^ p ≡ a [ZMOD p] := by
  sorry

/- Another version that can assume Lagrange's theorem -/
def DF_3_2_16_Lagrange : Prop := ∀ (G : Type*) [Group G] [Finite G], ∀ (H : Subgroup G),
    Nat.card H ∣ Nat.card G

def DF_3_2_16' (h : DF_3_2_16_Lagrange) {p : ℕ} (hp : p.Prime) (a : ℤ) :
    a ^ p ≡ a [ZMOD p] := by
  sorry

/-
Let $p$ be a prime and $n$ be a positive integer.
Then $n$ divides $\phi(p^n - 1)$.
Contributor: anonymous
-/
theorem DF_3_2_17 {p n : ℕ} (hp : p.Prime) (hn : 1 ≤ n) :
    n ∣ Nat.totient (p ^ n - 1) := by
  sorry

/-
Let $G$ be a finite group, $H$ be a subgroup, and $N$ be a normal subgroup
of $G$. If $|H|$ and $|G:N|$ are relatively prime, then $H \le N$.
Contributor: anonymous
-/
theorem DF_3_2_18 {G : Type*} [Group G] {H N : Subgroup G}
    (hG : Finite G) (hN : N.Normal) (h : (Nat.card H).Coprime N.index) :
    H ≤ N := by
  sorry

/-
If $N$ is a normal subgroup of a finite group $G$ and $\gcd(|N|, |G:N|) = 1$,
then $N$ is a unique subgroup of $G$ of order $|N|$.
Contributor: anonymous
-/
theorem DF_3_2_19 {G : Type*} [Group G] {N : Subgroup G}
    (hG : Finite G) (hN : N.Normal) (h : Nat.gcd (Nat.card N) N.index = 1) :
    ∀ (H : Subgroup G) (hH : Nat.card H = Nat.card N), H = N := by
  sorry

/-
Let $G$ be a group and $A$ be a normal abelian subgroup of $G$.
Then for any subgroup $B$ of $G$, $A \cap B$ is a normal subgroup of $AB$.
Contributor: anonymous
-/
theorem DF_3_2_20 {G : Type*} [Group G] {A B : Subgroup G}
    (hA : A.Normal) (hAab : CommGroup A) :
    ((A ⊓ B).subgroupOf (A ⊔ B)).Normal := by
  sorry

/-
$\mathbb{Q}$ has no proper subgroups of finite index.
Also, $\mathbb{Q} / \mathbb{Z}$ has no proper subgroups of finite index.
Contributor: anonymous
-/
theorem DF_3_2_21_a (G : AddSubgroup ℚ) (hG : G.FiniteIndex) :
    G = ⊤ := by
  sorry

theorem DF_3_2_21_b (G : AddSubgroup (ℚ ⧸ (Int.castAddHom ℚ).range))
    (hG : G.FiniteIndex) : G = ⊤ := by
  sorry

/-
$a^{\phi(n)} \equiv 1 \text{mod} n$ for every integer $a$ relatively prime to $n$,
where $\phi$ denotes Euler's $\phi$-function.
Contributor: anonymous
-/
theorem DF_3_2_22 {n : ℕ} {a : ℤ} (h : IsCoprime ↑n a) :
    a ^ n.totient ≡ 1 [ZMOD n] := by
  sorry

/-
Determine the last two digits of $3^{3^{100}}$.
Contributor: anonymous
-/
instance DF_3_2_23_ans : ℕ := sorry

theorem DF_3_2_23 : DF_3_2_23_ans < 100 ∧
    3 ^ (3 ^ 100) ≡ DF_3_2_23_ans [ZMOD 100] := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_3\DF_3_3.lean -/
/--
If $H$ is a normal subgroup of $G$ of prime index $p$
then for all $K \leq G$ either $K \leq H$ or, $G = HK$ and $|K : K \cap H| = p$.
Contributor: anonymous
-/
theorem DF_3_3_3
    {G : Type*} [Group G] {H : Subgroup G} [H.Normal]
    {p : ℕ} (hp : p.Prime) (h : H.index = p) (K : Subgroup G) :
    K ≤ H ∨ ((⊤ : Subgroup G) = H ⊔ K ∧ H.relIndex K = p) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_3\DF_3_5.lean -/
/--
$A_n$ contains a subgroup isomorphic to $S_{n - 2}$ for each $n \geq 3$.
Contributor: anonymous
-/
theorem DF_3_5_12 {n : ℕ} (hn : 3 ≤ n) :
    ∃ φ : Equiv.Perm (Fin (n - 2)) →* alternatingGroup (Fin n),
    Function.Injective φ := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_4\DF_4_3.lean -/
/--
$Z(S_n) = 1$ for all $3 \leq n$.
Contributor: anonymous
-/
def DF_4_3_8
    {ι : Type*} [Fintype ι] (hι : 3 ≤ Fintype.card ι) :
    Subgroup.center (Equiv.Perm ι) ≃* (⊥ : Subgroup (Equiv.Perm ι)) := by
  sorry

/--
Let $A$ be a nonempty set and let $X$ be any subset of $S_A$. Let
\begin{equation*}
F(X) = \{a \in A \mid \sigma(a) = a \text{ for all }\sigma \in X\}
\text{- the \textit{fixed set} of $X$.}
\end{equation*}
Let $M(X) = A - F(X)$ be the elements which are moved by some element of $X$.
Let $D = \{\sigma \in S_A \mid |M(\sigma)| < \infty\}$.
Then $D$ is a normal subgroup of $S_A$.
Contributor: anonymous
-/
theorem DF_4_3_17 {A : Type*} [Nonempty A] :
    ∃ D : Subgroup (Equiv.Perm A),
      D.carrier = {σ | {a | ¬ Function.IsFixedPt σ.toFun a}.Finite} ∧ D.Normal := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_4\DF_4_5.lean -/
/--
Finite group of order 6545 is not simple.
Contributor: anonymous
-/
theorem DF_4_5_19 [Group G] (h: Nat.card G = 6545) : ¬ IsSimpleGroup G := by
  sorry

/--
Finite group of order 1365 is not simple.
Contributor: anonymous
-/
theorem DF_4_5_20 [Group G] (h: Nat.card G = 1365) : ¬ IsSimpleGroup G := by
  sorry

/--
Finite group of order 2907 is not simple.
Contributor: anonymous
-/
theorem DF_4_5_21 [Group G] (h: Nat.card G = 2907) : ¬ IsSimpleGroup G := by
  sorry

/--
Finite group of order 132 is not simple.
Contributor: anonymous
-/
theorem DF_4_5_22 [Group G] (h: Nat.card G = 132) : ¬ IsSimpleGroup G := by
  sorry

/--
Finite group of order 462 is not simple.
Contributor: anonymous
-/
theorem DF_4_5_23 [Group G] (h: Nat.card G = 462) : ¬ IsSimpleGroup G := by
  sorry

/--
The only non-abelian simple group of order less than 100 is $A_5$.
Contributor: anonymous
-/

theorem DF_4_5_29 [Group G] (hCard: Nat.card G < 100)
    (hSimple: IsSimpleGroup G) (hNonAb: ¬ IsMulCommutative G) :
    Nonempty (G ≃* alternatingGroup (Fin 5)) := by
  sorry

/--
Let $P$ be a normal Sylow $p$-subgroup of $G$ and let $H$ be any subgroup of $G$.
Then $P \cap H$ is the unique Sylow $p$-subgroup of $H$.
Contributor: anonymous
-/
theorem DF_4_5_33
    {G : Type*} [Group G] {p : ℕ} [Fact p.Prime] (P : Sylow p G) [P.Normal] (H : Subgroup G) :
    Nonempty (Sylow p H) ∧ ∀ HP : Sylow p H, HP = P.subgroupOf H := by
  sorry

/--
Let $G$ be a finite group and let $p$ be a prime.
If $N$ is a normal subgroup of $G$, then $n_p(G/N) \leq n_p(G)$.
Contributor: anonymous
-/
theorem DF_4_5_36
    {G : Type*} [Finite G] [Group G] {p : ℕ} [Fact p.Prime] {N : Subgroup G} [N.Normal] :
    Nat.card (Sylow p (G ⧸ N)) ≤ Nat.card (Sylow p G) :=
  sorry

#min_imports

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_5\DF_5_1.lean -/
/--
The center of a finite direct product of groups is the direct product of center of groups.
Also, the finite direct product of groups is abelian if and only if each of the factors is abelian.
Contributor: anonymous
-/
theorem DF_5_1_1_1 {ι : Type*} [Fintype ι] {G : ι → Type*} [∀ i, Group (G i)] :
    Subgroup.center (Π i, G i) = Subgroup.pi (@Set.univ ι) (fun i ↦ Subgroup.center (G i)) := by
  sorry

theorem DF_5_1_1_2 {ι : Type*} [Fintype ι] {G : ι → Type*} [∀ i, Group (G i)] :
    IsMulCommutative (Π i, G i) ↔ ∀ i, IsMulCommutative (G i) := by
  sorry

/--
Find a formula for the number of subgroups of order p of (Z/pZ)^n.
Contributor: anonymous
-/
def DF_5_1_11_ans (p n : ℕ) [Fact p.Prime] (hn : 0 < n) : ℕ := sorry

theorem DF_5_1_11 (p n : ℕ) [Fact p.Prime] (hn : 0 < n) :
    Nat.card { H : Submodule (ZMod p) (Fin n → ZMod p) // Set.ncard (H : Set (Fin n → ZMod p)) = p }
      = DF_5_1_11_ans p n hn := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_5\DF_5_4.lean -/
open scoped commutatorElement

/--
Let $G$ be a group.
(a) If $x, y \in G$, then $[y,x] = [x,y]^{-1}$.
(b) For subsets $A$ and $B$ of $G$, we have $[A, B] = [B, A]$.
Contributor: anonymous
-/
theorem DF_5_4_1_a {G : Type*} [Group G] {x y : G} : ⁅y, x⁆ = ⁅x, y⁆⁻¹ := by
  sorry

instance DF_5_4_1_aux_commutator_subsets [Group G] : Bracket (Set G) (Set G) where
  bracket A B :=
    Subgroup.closure { g | ∃ a ∈ A, ∃ b ∈ B, ⁅a, b⁆ = g }

theorem DF_5_4_1_b {G : Type*} [Group G] {A B : Set G} : ⁅A, B⁆ = ⁅B, A⁆ := by
  sorry

/--
Let $G$ be a group, and $H$ a subgroup of $G$.
Then $H$ is a normal subgroup if and only if $[G, H] \le H$.
Contributor: anonymous
-/
theorem DF_5_4_2 {G : Type*} [Group G] {H : Subgroup G} : H.Normal ↔ ⁅(⊤: Subgroup G), H⁆ ≤ H := by
  sorry

/--
Let $G$ be a group.
Then $[a, bc] = [a, c](c^{-1} [a, b] c)$ for every $a, b, c \in G$.
Contributor: anonymous
-/
theorem DF_5_4_3_a {G : Type*} [Group G] {a b c : G} :
    ⁅a, b * c⁆ = ⁅a, c⁆ * (c⁻¹ * ⁅a, b⁆ * c) := by
  sorry

/--
Let $G$ be a group.
Then $[ab, c] = (b^{-1} [a, c] b)[b, c]$ for every $a, b, c \in G$.
Contributor: anonymous
-/
theorem DF_5_4_3_b {G : Type*} [Group G] {a b c : G} :
    ⁅a * b, c⁆ = (b⁻¹ * ⁅a, c⁆ * b) * ⁅b, c⁆ := by
  sorry

/--
For $n \ge 5$, $A_n$ is the commutator subgroup of $S_n$.
Contributor: anonymous
-/
theorem DF_5_4_5 {n : ℕ} (hn : n ≥ 5) :
    commutator (Equiv.Perm (Fin n)) = alternatingGroup (Fin n) := by
  sorry

/--
Let $p$ be a prime. If $P$ is a nonabelian group of order $p^3$,
then its commutator subgroup $[P, P]$ is the center $Z(P)$.
Contributor: anonymous
-/
theorem DF_5_4_7 {p : ℕ} [hp : Fact (Nat.Prime p)] {P : Type*}
    [Group P] (hP : Nat.card P = p ^ 3) (hPna : ¬IsMulCommutative P) :
    commutator P = Subgroup.center P := by
  sorry

/--
Let $G$ be a group, and assume $x, y \in G$ and both $x$ and $y$ commute with $[x, y]$.
Then for all $n \in \mathbb{Z}^+$, $(xy)^n = x^n y^n [y, x]^{\frac{n(n - 1)}{2}}.
Contributor: anonymous
-/
theorem DF_5_4_8
    {G : Type*} [Group G] {x y : G} (hx : x * ⁅x, y⁆ = ⁅x, y⁆ * x) (hy : y * ⁅x, y⁆ = ⁅x, y⁆ * y)
    {n : ℕ} (hn : 0 < n) :
    (x * y) ^ n = x ^ n * y ^ n * ⁅y, x⁆ ^ (n * (n - 1) / 2) := by
  sorry

/--
A finite abelian group is isomorphic to the direct product of its Sylow p-subgroups.
Contributor: anonymous
-/
theorem DF_5_4_10 {G : Type*} [Group G] [Fintype G] [IsMulCommutative G] :
    Nonempty (G ≃*
      Π p : (Fintype.card G).primeFactors, (default : Sylow p.1 G).1) := by
  sorry

/--
The dihedral group $D_{4n}$ (of order $8n$) is not isomorphic to
$D_{2n} \times C_2$ for any integer $n \ge 1$.
Contributor: anonymous
-/
theorem DF_5_4_13 {n : ℕ} (hn : n ≥ 1) :
    ¬ Nonempty (DihedralGroup (4 * n) ≃*
      DihedralGroup (2 * n) × Multiplicative (ZMod 2)) := by
  sorry

/--
If $A$ and $B$ are normal subgroups of $G$ such that $G / A$ and $G / B$ are
abelian, then the $G / (A \cap B)$ is also abelian.
Contributor: anonymous
-/
theorem DF_5_4_15 {G : Type*} [Group G] {A B : Subgroup G} (hAn : A.Normal)
    (hBn : B.Normal) (hAc : IsMulCommutative (G ⧸ A))
    (hBc : IsMulCommutative (G ⧸ B)) :
    IsMulCommutative (G ⧸ (A ⊓ B)) := by
  sorry

/--
If $K$ is a normal subgroup of $G$ then the commutator subgroup $[K, K]$
is also a normal subgroup of $G$.
Contributor: anonymous
-/
theorem DF_5_4_16 {G : Type*} [Group G] {K : Subgroup G} (hK : K.Normal) :
    (commutator K).Normal := by
  sorry

/--
If $K$ is a normal subgroup of $G$ and $K$ is cyclic, then $[G, G]$ is
a subgroup of the centralizer $C_G(K)$.
Contributor: anonymous
-/
theorem DF_5_4_17 {G : Type*} [Group G] {K : Subgroup G}
    (hK : K.Normal) (hKc : IsCyclic K) :
    commutator G ≤ Subgroup.centralizer K := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_6\DF_6_1.lean -/
/--
Let $G$ be a finite group. Then $G$ is nilpotent if and only if for each
divisor $m$ of $|G|$, $G$ has a normal subgroup of order $m$.
Also, $G$ is cyclic if and only if for each divisor $m$ of $|G|$,
$G$ has a unique subgroup of order $m$.
Contributor: anonymous
-/
theorem DF_6_1_3_1 {G : Type*} [Group G] [Fintype G] :
    Group.IsNilpotent G ↔
      (∀ n : ℕ, n ∣ Fintype.card G →
        ∃ H : Subgroup G, H.Normal ∧ Nat.card H = n) := by
  sorry

theorem DF_6_1_3_2 {G : Type*} [Group G] [Fintype G] :
    IsCyclic G ↔
      (∀ n : ℕ, n ∣ Fintype.card G →
        ∃! H : Subgroup G, Nat.card H = n) := by
  sorry

/--
Let $G$ be a finite nilpotent group. Then a maximal subgroup of $G$ has
prime index in $G$.
Contributor: anonymous
-/
theorem DF_6_1_4 {G : Type*} [Group G] [Fintype G]
    (h : Group.IsNilpotent G) (M : Subgroup G) (hM : M ⋖ (⊤ : Subgroup G)) :
    Nat.Prime (M.index) := by
  sorry

/--
If $G / Z(G)$ is nilpotent, then $G$ is nilpotent.
Contributor: anonymous
-/
theorem DF_6_1_6 {G : Type*} [Group G]
    (h : Group.IsNilpotent (G ⧸ (Subgroup.center G))) :
    Group.IsNilpotent G := by
  sorry

/--
If $G$ is nilpotent, then subgroups and quotient groups of $G$ are nilpotent.
Also, there exists a group $G$ and a normal subgroup $H$ of $G$ such that $H$
and $G / H$ are nilpotent but $G$ is not nilpotent.
Contributor: anonymous
-/

theorem DF_6_1_7_1 {G : Type*} [Group G]
    (h : Group.IsNilpotent G) : (∀ H : Subgroup G, Group.IsNilpotent H) := by
  sorry

theorem DF_6_1_7_2 {G : Type*} [Group G]
    (h : Group.IsNilpotent G) (H : Subgroup G) [H.Normal] :
    Group.IsNilpotent (G ⧸ H) := by
  sorry

theorem DF_6_1_7_3 :
    ∃ (G : Type*) (_ : Group G), ∃ (H : Subgroup G) (_ : H.Normal),
      Group.IsNilpotent H ∧ Group.IsNilpotent (G ⧸ H) ∧ ¬ Group.IsNilpotent G := by
  sorry

/--
If $p$ is a prime and $P$ is a non-abelian group of order $p^3$
then $|Z(P)| = p$ and $P / Z(P) \equiv Z_p \times Z_p$.
Contributor: anonymous
-/
theorem DF_6_1_8_1 {p : ℕ} (hp : p.Prime) {P : Type*} [Group P]
    (hP₁ : ¬ IsMulCommutative P) (hP₂ : Nat.card P = p ^ 3) :
    Nat.card (Subgroup.center P) = p := by
  sorry

def DF_6_1_8_2 {p : ℕ} (hp : p.Prime) {P : Type*} [Group P]
    (hP₁ : ¬ IsMulCommutative P) (hP₂ : Nat.card P = p ^ 3) :
    P ⧸ (Subgroup.center P) ≃* Multiplicative (ZMod p) × Multiplicative (ZMod p) :=
  sorry

/--
A finite group $G$ is nilpotent if and only if
whenever $a, b \in G$ with $(|a|, |b|) = 1$, then $ab = ba$.
Contributor: anonymous
-/
theorem DF_6_1_9 {G : Type*} [Fintype G] [Group G] :
    Group.IsNilpotent G ↔
    (∀ a b : G, (orderOf a).gcd (orderOf b) = 1 → a * b = b * a) := by
  sorry

/--
$D_n$ is nilpotent if and only if $n$ is a power of 2.
Contributor: anonymous
-/
theorem DF_6_1_10 {n : ℕ} : Group.IsNilpotent (DihedralGroup n) ↔
    n.isPowerOfTwo := by
  sorry

/--
If $G$ is a finite abelian group such that for all positive integers $n$ dividing its order,
$G$ contains at most $n$ elements $x$ satisfying $x^n = 1$, then $G$ is cyclic.
Contributor: anonymous
-/
theorem DF_6_1_11 {G : Type*} [Fintype G] [CommGroup G]
    (h : ∀ n, n ∣ Fintype.card G → Nat.card {x : G | x ^ n = 1} ≤ n) :
    IsCyclic G := by
  sorry

/--
$\mathbb{Q}$ has no maximal proper subgroups.
Contributor: anonymous
-/
theorem DF_6_1_16 :
    ∀ M : AddSubgroup ℚ, M ≠ ⊤ → ¬ (M ⋖ (⊤ : AddSubgroup ℚ)) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_6\DF_6_3.lean -/
/--
Let $S$ be a set. If $|S| > 1$ then the free group $F(S)$ of $S$ is non-abelian.
Contributor: anonymous
-/
theorem DF_6_3_2 {S : Type*} [Nonempty S] (h : Nat.card S ≠ 1) :
    ¬ IsMulCommutative (FreeGroup S) := by
  sorry

/--
Let $S$ be a set, then any nonidentity element of a free group $F(S)$ is of infinite order.
Contributor: anonymous
-/
theorem DF_6_3_4 {S : Type*} [Nonempty S] {s : FreeGroup S} (hs : s ≠ 1) :
    orderOf s = 0 := by
  sorry

/--
$\text{Aut}(Q_8) \equiv S_4$.
Contributor: anonymous
-/
def DF_6_3_9 : MulAut (QuaternionGroup 2) ≃* Equiv.Perm (Fin 4) :=
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_7\DF_7_2.lean -/
/--
Let $R$ be a commutative ring with identity 1.
If $R$ is an integral domain then the ring of formal power series $R[[x]]$
is also an integral domain.
Contributor: anonymous
-/
instance DF_7_2_4 {R : Type*} [CommRing R] [IsDomain R] :
    IsDomain (PowerSeries R) := by
  sorry

/--
Let $S$ be a ring and $n \ge 2$ be an integer.
If an $n \times n$ matrix over $S$ is strictly upper triangular,
then $A^n = 0$.
Contributor: anonymous
-/
theorem DF_7_2_8 {S : Type*} [Ring S] {n : ℕ} (hn : n ≥ 2)
    (A : Matrix (Fin n) (Fin n) S)
    (hA : ∀ i j : Fin n, i ≥ j → A i j = 0) :
    A ^ n = 0 := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_7\DF_7_4.lean -/
open Polynomial
/-
Let $R$ be a commutative ring with identity $1 \neq 0$.
Then $R$ is a field if and only if $0$ is a maximal ideal.
Contributor: anonymous
-/

theorem DF_7_4_4 {R : Type*} [CommRing R] [Nontrivial R] :
    IsField R ↔ (0 : Ideal R).IsMaximal := by
  sorry


/-
Let $R$ be a ring with identity $1 \neq 0$.
$R$ is a division ring if and only if its only left ideals are $(0)$ and $R$.
Contributor: anonymous
-/
theorem DF_7_4_6 {R : Type*} [Ring R] [Nontrivial R] :
    Nonempty (DivisionRing R) ↔ ∀ I : Ideal R, I = ⊥ ∨ I = ⊤ := by
  sorry

/-
Let $R$ be a commutative ring with identity $1 \neq 0$.
The principal ideal $(x)$ generated by $x \in R[x]$ is a prime ideal if and only if $R$ is an integral domain.
$(x)$ is a maximal ideal if and only if $R$ is a field.
Contributor: anonymous
-/
theorem DF_7_4_7_1 {R : Type*} [CommRing R] [Nontrivial R] :
    (Ideal.span {(X : R[X])}).IsPrime ↔ IsDomain R := by
  sorry

theorem DF_7_4_7_2 {R : Type*} [CommRing R] [Nontrivial R] :
    (Ideal.span {(X : R[X])}).IsMaximal ↔ IsField R := by
  sorry

/-
Let $R$ be an integral domain.
Then $(a) = (b)$ for two elements $a, b \in R$ if and only if $a = ub$
for some unit $u \in R$.
Contributor: anonymous
-/
theorem DF_7_4_8 {R : Type*} [CommRing R] [IsDomain R] (a b : R) :
    Ideal.span {a} = Ideal.span {b} ↔ ∃ u : R, IsUnit u ∧ a = u * b := by
  sorry

/-
Let $R$ be a boolean ring. Then any prime ideal of $R$ is maximal.
Contributor: anonymous
-/
theorem DF_7_4_23 {R : Type*} [BooleanRing R] (p : Ideal R)
    (hp : p.IsPrime) : p.IsMaximal := by
  sorry

/-
Let $R$ be a boolean ring.
Then any finitely generated ideal of $R$ is principal.
Contributor: anonymous
-/
theorem DF_7_4_24 {R : Type*} [BooleanRing R] (I : Ideal R)
    (hI : I.FG) : I.IsPrincipal := by
  sorry

/-
Let $R$ be a commutative ring. For each $a \in R$, assume that there is
an integer $n > 1$ (depending on $a$) such that $a^n = a$.
Then any prime ideal of $R$ is maximal.
Contributor: anonymous
-/
theorem DF_7_4_25 {R : Type*} [CommRing R] (h : ∀ a : R, ∃ n > 1, a ^ n = a)
    (p : Ideal R) (hp : p.IsPrime) : p.IsMaximal := by
  sorry

/-
Let $R$ be a commutative ring with identity $1 \neq 0$.
If $a \in R$ is nilpotent, then $1 - ab$ is a unit for any $b \in R$.
Contributor: anonymous
-/
theorem DF_7_4_27 {R : Type*} [CommRing R] [Nontrivial R] (a : R)
    (ha : IsNilpotent a) (b : R) : IsUnit (1 - a * b) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_7\DF_7_5.lean -/
/-
Any subfield of $\mathbb{R}$ contains $\mathbb{Q}$.
Contributor: anonymous
-/
theorem DF_7_5_4 [Field ℝ] (K : Subfield ℝ) :
    ∀ q : ℚ, (q : ℝ) ∈ K := by sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_8\DF_8_2.lean -/
/-
A quotient of a PID by a prime ideal is a PID.
Contributor: anonymous
-/
theorem DF_8_2_3 {R : Type*} [CommRing R] [IsDomain R] [IsPrincipalIdealRing R]
    (p : Ideal R) (hp : p.IsPrime) :
    IsPrincipalIdealRing (R ⧸ p) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_9\DF_9_1.lean -/
open MvPolynomial


/--
Ideals $(x)$ and $(x, y)$ in $\mathbb{Q}[x, y]$ are prime ideals,
but only the latter is maximal.
Contributor: anonymous
-/
theorem DF_9_1_4_1 :
    (Ideal.span {X 0} : Ideal (MvPolynomial (Fin 2) ℚ)).IsPrime ∧
    (Ideal.span {X 0, X 1} : Ideal (MvPolynomial (Fin 2) ℚ)).IsPrime := by
  sorry

theorem DF_9_1_4_2 :
    ¬ (Ideal.span {X 0} : Ideal (MvPolynomial (Fin 2) ℚ)).IsMaximal ∧
    (Ideal.span {X 0, X 1} : Ideal (MvPolynomial (Fin 2) ℚ)).IsMaximal := by
  sorry

/--
Ideals $(x, y)$ and $(2, x, y)$ in $\mathbb{Z}[x, y]$ are prime ideals,
but only the latter is maximal.
Contributor: anonymous
-/
theorem DF_9_1_5_1 :
    (Ideal.span {X 0, X 1} : Ideal (MvPolynomial (Fin 2) ℤ)).IsPrime ∧
    (Ideal.span {2, X 0, X 1} : Ideal (MvPolynomial (Fin 2) ℤ)).IsPrime := by
  sorry

theorem DF_9_1_5_2 :
    ¬ (Ideal.span {X 0, X 1} : Ideal (MvPolynomial (Fin 2) ℚ)).IsMaximal ∧
    (Ideal.span {2, X 0, X 1} : Ideal (MvPolynomial (Fin 2) ℚ)).IsMaximal := by
  sorry

/--
$(x, y)$ is not a principal ideal in $\mathbb{Q}[x, y]$.
Contributor: anonymous
-/
theorem DF_9_1_6 :
    ¬ (Ideal.span {X 0, X 1} : Ideal (MvPolynomial (Fin 2) ℚ)).IsPrincipal := by
  sorry

/--
For a commutative ring $R$ with 1, a polynomial ring over $R$ in more than
one variable is not a principal ideal domain.
Contributor: anonymous
-/
theorem DF_9_1_7 {R : Type*} [CommRing R] {σ : Type*} (hσ : ∃ i j : σ, i ≠ j) :
    ¬ (IsPrincipalIdealRing (MvPolynomial σ R) ∧
       IsDomain (MvPolynomial σ R)) := by
  sorry

/--
A polynomial ring in infinitely many variables with coefficients in any commutative
ring contains ideals that are not finitely generated.
Contributor: anonymous
-/
theorem DF_9_1_9
    (R : Type*) [CommRing R] (σ : Type*) [Infinite σ] :
    ∃ I : Ideal (MvPolynomial σ R),
      ¬ ∃ s : Finset (MvPolynomial σ R),
        I = Ideal.span (s : Set (MvPolynomial σ R)) := by
  sorry

/--
The ring $\mathbb{Z}[x_1, x_2, x_3, \dots]/(x_1 x_2, x_3 x_4, x_5 x_6, \dots)$ contains infinitely many minimal prime ideals.
Contributor: anonymous
-/
theorem DF_9_1_10 :
    let R := MvPolynomial ℕ+ ℤ
    let I : Ideal R := Ideal.span (Set.range (fun n : ℕ+ => MvPolynomial.X (2 * n - 1) * MvPolynomial.X (2 * n)))
    Set.Infinite (minimalPrimes (R ⧸ I)) := by
  sorry

/--
Two rings $F[x, y] / (x^2 - y)$ and $F[x, y] / (y^2 - x^2)$ are not isomorphic
for any field $F$.
Contributor: anonymous
-/
theorem DF_9_1_13 {F : Type*} [Field F] :
  ¬ Nonempty
    ((MvPolynomial (Fin 2) F ⧸ (Ideal.span {X 1 ^ 2 - X 0} :
      Ideal (MvPolynomial (Fin 2) F))) ≃+*
     (MvPolynomial (Fin 2) F ⧸ (Ideal.span {X 1 ^ 2 - X 0 ^ 2} :
      Ideal (MvPolynomial (Fin 2) F)))) := by
  sorry

/--
The product of two homogeneous polynomials is again homogeneous.
Contributor: anonymous
-/
theorem DF_9_1_16
    {σ R : Type*} [CommRing R]
    {p : MvPolynomial σ R} (hp : ∃ n, p.IsHomogeneous n)
    {q : MvPolynomial σ R} (hq : ∃ n, q.IsHomogeneous n) :
    ∃ n, (p * q).IsHomogeneous n := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_9\DF_9_3.lean -/
/--
Let $f(x), g(x)$ be polynomials with rational coefficients.
If every coefficient of $f(x) * g(x)$ is an integer,
then the product of any coefficient of $f(x)$ with any coefficient of $g(x)$ is an integer.
Contributor: anonymous
-/
theorem DF_9_3_2 {f g : Polynomial ℚ} {h : ∀ i : ℕ, ∃ c : ℤ, (f * g).coeff i = (c : ℚ)} :
    ∀ i j : ℕ, ∃ c : ℤ, (f.coeff i) * (g.coeff j) = (c : ℚ) := by
  sorry

/--
Let $F$ be a field.
Then the set $R$ of polynomials over $F$ whose coefficient of $x$ equals $0$
forms a subring of $F(x)$, and $R$ is not a UFD.
Contributor: anonymous
-/
theorem DF_9_3_3 {F : Type*} [Field F] :
    ∃ R : Subring (Polynomial F), (∀ f : Polynomial F, f ∈ R ↔ f.coeff 1 = 0)
    ∧ ¬ UniqueFactorizationMonoid R := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\LEAN-GAP\Formal\DF_9\DF_9_5.lean -/
open Polynomial


/--
For an odd prime $p$ and a positive integer $n$, the polynomial $x^n - p$
is irreducible over the ring of Gaussian integers.
Contributor: anonymous
-/
theorem DF_9_5_3 (p n : ℕ) (hp : Nat.Prime p) (hodd : Odd p) (hn : 0 < n) :
    Irreducible ((X : GaussianInt[X]) ^ n - p) := by
  sorry

/--
A polynomial $x^3 + 12x^2 + 18x + 6$ is irreducible over the ring of
Gaussian integers.
Contributor: anonymous
-/
theorem DF_9_5_4 :
    Irreducible (X^3 + 12 * X^2 + 18 * X + 6 : GaussianInt[X]) := by
  sorry

/--
The sum of Euler's totient function over the divisors of $n$ is $n$.
Contributor: anonymous
-/
theorem DF_9_5_5 (n : ℕ) : ∑ d ∈ n.divisors, Nat.totient d = n := by
  sorry

/--
Additive and multiplicative groups of a field are not isomorphic.
Contributor: anonymous
-/
theorem DF_9_5_7 {F : Type*} [Field F] :
    ¬ Nonempty (Multiplicative F ≃* Units F) := by
  sorry


import Mathlib

/-
==============================================================================
MERGED LEAN DATASET
==============================================================================
Total Lean files discovered : 150
Number of files selected    : 45
Generated (UTC)             : 2026-07-07T07:17:28.872436+00:00
==============================================================================
Selected files:
  [  1] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\10.lean
  [  2] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\102.lean
  [  3] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\105.lean
  [  4] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\109.lean
  [  5] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\111.lean
  [  6] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\114.lean
  [  7] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\118.lean
  [  8] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\120.lean
  [  9] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\123.lean
  [ 10] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\127.lean
  [ 11] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\13.lean
  [ 12] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\132.lean
  [ 13] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\136.lean
  [ 14] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\139.lean
  [ 15] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\141.lean
  [ 16] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\145.lean
  [ 17] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\148.lean
  [ 18] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\150.lean
  [ 19] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\19.lean
  [ 20] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\21.lean
  [ 21] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\24.lean
  [ 22] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\28.lean
  [ 23] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\30.lean
  [ 24] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\33.lean
  [ 25] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\37.lean
  [ 26] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\4.lean
  [ 27] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\42.lean
  [ 28] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\46.lean
  [ 29] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\49.lean
  [ 30] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\51.lean
  [ 31] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\55.lean
  [ 32] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\58.lean
  [ 33] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\60.lean
  [ 34] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\64.lean
  [ 35] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\67.lean
  [ 36] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\7.lean
  [ 37] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\73.lean
  [ 38] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\76.lean
  [ 39] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\79.lean
  [ 40] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\82.lean
  [ 41] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\85.lean
  [ 42] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\88.lean
  [ 43] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\91.lean
  [ 44] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\94.lean
  [ 45] C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\97.lean
==============================================================================
-/

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\10.lean -/
/--
Set $f:G\to H$ is a homomorphism between two groups.
If the range of $f$ has $n$ elements, then $x^{n} \in \operatorname{Ker} f$ for every $x \in G$.
-/
theorem pow_mem_ker_of_card_eq {G H : Type*} [Group G] [Group H] (f : G →* H) (n : ℕ)
    (h : Nat.card f.range = n) : ∀ g : G, (g ^ n) ∈ f.ker := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\102.lean -/
open Classical

/--
If $|G|=p^{3}$ and $|Z(G)| \geq p^{2}$, prove that $G$ is abelian.
-/
theorem commutative_of_center_card_eq_prime_pow_three {G : Type*} {p : ℕ} [Group G] [Fintype G]
    (pp : p.Prime) (p3 : Fintype.card G = p ^ 3) (p2 : Fintype.card (Subgroup.center G) ≥ p ^ 2) :
    ∀ a b : G, a * b = b * a := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\105.lean -/
/--
If $P$ is a $p$-Sylow subgroup of $G$, show that $N(N(P))=N(P)$.
-/
theorem Sylow.normalizer_normalizer_eq_normalizer {G : Type*} [Group G] {p : ℕ} [Fact (Nat.Prime p)]
    [Finite (Sylow p G)] (P : Sylow p G) : P.normalizer.normalizer = P.normalizer := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\109.lean -/
/--
If $R$ is an integral domain and $a b=a c$ for $a \neq 0, b, c \in R$, show that $b=c$.
-/
theorem mul_left_cancel_of_NoZeroDivisors {R :Type*} [Ring R] [NoZeroDivisors R]
    (a b c : R) (h₁ : ¬ a = 0 ∧ a * b = a * c) : b = c := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\111.lean -/
/--
If $a^{2}=0$ in $R$, show that $a x+x a$ commutes with $a$.
-/
theorem commute_of_pow_two_zero (R : Type) [Ring R] (a : R) (h : a ^ 2 = 0) :
    ∀ x : R, Commute (a * x + x * a) a := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\114.lean -/
/--
If $H$ and $K$ are subgroups of a group $G$, then $H \cup K$ cannot be a subgroup
unless $H \subseteq K$ or $K \subseteq H$.
-/
theorem union_subgroup_iff_le {G : Type*} [Group G] {A B : Subgroup G} :
    (∃ C : Subgroup G , C = (A ∪ B : Set G)) ↔ A ≤ B ∨ B ≤ A := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\118.lean -/
/--
Let $R$ be a commutative ring. $a,b\in R$ are nilpotent. Prove that $a+b$ is also nilpotent.
-/
theorem isNilpotent_add_of_isNilpotent {R : Type*} [CommRing  R] (a b : R)
    {h₁ : IsNilpotent a} {h₂ : IsNilpotent b}: IsNilpotent (a + b) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\120.lean -/
/--
Let $a, b$ be any two elements of a group $G$. If $a$, $b$ commute with their commutator $[a, b]$,
then for all integers $m$ and $n$,
\[
[a^m, b^n] = [a, b]^{mn}.
\]
-/
theorem pow_commutator_eq_commutator_pow_mul {G : Type*} [Group G] (a b : G)
    (ha : Commute a ⁅a, b⁆) (hb : Commute b ⁅a, b⁆) :
    ∀ m n : ℕ, ⁅a ^ m, b ^ n⁆ = ⁅a, b⁆ ^ (m * n) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\123.lean -/
/--
Addictive group of $\mathbb{Q}$ is not cyclic.
-/
theorem Rat.not_isAddCyclic : ¬ (IsAddCyclic ℚ) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\127.lean -/
/--
Let $G$ be a monoid with identity. An element $b \in G$ is the inverse of $a \in G$ if and only if
the following relations hold:
\[ a b a = a \quad \text{and} \quad a b^2 a = 1. \]
-/
theorem inverse_iff_relations {G : Type*} [Monoid G] (a b : G) :
    (b * a = 1 ∧ a * b = 1) ↔ (a * b * a = a ∧ a * b ^ 2 * a = 1) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\13.lean -/
/--
Let $R$ be a ring, and suppose that $a^3=a, \forall a\in R$. Prove that $R$ is commutative.
-/
theorem commutative_of_relations {R : Type*} [Ring R] : (∀ a : R, a ^ 3 = a) →
    ∀ (a b : R), a * b = b * a := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\132.lean -/
/--
Show that a ring $R$ has no nonzero nilpotent element if and only if 0 is the only solution
of $x^{2}=0$ in $R$.
-/
theorem has_no_nilpotent_iff_zero_of_pow_two_zero {R : Type*} [Ring R] :
    (∀ x : R, ∀ k : ℕ, x ≠ 0 → x ^ k ≠ 0) ↔ (∀ x : R, x ^ 2 = 0 → x = 0) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\136.lean -/
/--
If $a$ and $b$ are positive integers with $(a, b)=1$, and if $a b$ is a square,
prove that both $a$ and $b$ are squares.
-/
theorem isSquare_of_mul_isSquare_of_isCoprime {a b : ℤ} (hab : IsCoprime a b)
    (pos : a > 0 ∧ b > 0) (hn : IsSquare (a * b)) : IsSquare a ∧ IsSquare b := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\139.lean -/
/--
Prove that if $G$ is a group and has exactly one subgroup $H$ of order $n$,
then $H$ is a normal subgroup of $G$.
-/
theorem normal_of_card_eq_unique {G : Type*} [Group G] {H : Subgroup G}
    (hH : ∀ K : Subgroup G, (Nat.card K = Nat.card H) → (K = H)) : H.Normal := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\141.lean -/
/--
Prove that every subgroup of a solvable group is solvable.
-/
theorem Subgroup.solvable_of_solvable {G : Type*} [Group G] [IsSolvable G] (H : Subgroup G) :
    IsSolvable H := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\145.lean -/
/--
Prove that the order of any $p$-group is a power of $p$.
-/
theorem IsPGroup.card_eq_pow {p : ℕ} {G : Type*} [h₁ : Group G] [Fact (Nat.Prime p)]
    [h₂ : Fintype G] (h : IsPGroup p G) : ∃ n : ℕ, Fintype.card G = p ^ n := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\148.lean -/
/--
Let $R$ be a commutative ring and $a \in R$ a non-unit element.
Then there exists a maximal ideal $M$ of $R$ containing $a$.
-/
theorem mem_max_ideal_of_not_isUnit {R : Type*} [CommRing R] (a : R) {h₁ : ¬IsUnit a} :
    ∃ (I : Ideal R), a ∈ I ∧ Ideal.IsMaximal I := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\150.lean -/
/--
Show that $m \mathbb{Z}$ is a subgroup of $n \mathbb{Z}$ if and only if $n$ divides $m$.
-/
theorem zmultiples_le_iff_dvd (m n : ℤ) :
    (AddSubgroup.zmultiples m : Set ℤ) ≤ AddSubgroup.zmultiples n ↔ n ∣ m := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\19.lean -/
/--
For positive integer $n\ge 2$, show that the ring $\mathbb Z/n\mathbb Z$ is a field if and only if
$n$ is a prime number.
-/
theorem ZMod.isField_iff_prime (n : ℕ) : IsField (ZMod n) ↔ Nat.Prime n := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\21.lean -/
/--
In a field $F$, for $a\in F^\times, b\in F$, the equation $ax+b=0$ has a unique solution.
-/
theorem existUnique_linear_solution {F : Type*} [Field F] {a : Fˣ} {b : F} :
    ∃! x, a * x + b = 0 := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\24.lean -/
/--
Let $R$ be an integral domain. An element $p \in R$ is a prime element if and only if the principal
ideal $\langle p \rangle$ is a nonzero prime ideal of $R$.
-/
theorem isPrime_singleton {R : Type*} [CommRing R] [IsDomain R] {p : R} (hp : p ≠ 0) :
    Ideal.IsPrime (Ideal.span {p}) ↔ Prime p:= by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\28.lean -/
/--
Suppose $E / F$ and $K / F$ are normal extension. Prove that $E K / F$ is normal extension too.
-/
theorem IntermediateField.normal_of_normal_normal
    {F F₀ : Type*} [Field F] [Field F₀] [Algebra F F₀]
    (E K : IntermediateField F F₀) [Normal F E] [Normal F K]
    [Normal F E] [Normal F K] :
  Normal F (E ⊔ K : IntermediateField F F₀) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\30.lean -/
open Classical

/--
The order of a permutation is equal to the least common multiple of the lengths of its disjoint cycles
in the cycle decomposition.
-/
theorem lcm_eq_orderOf {α : Type*} [Fintype α] [DecidableEq α] (σ : Equiv.Perm α) :
    σ.cycleType.lcm = orderOf σ := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\33.lean -/
/--
Prove that in a Boolean ring, every prime ideal is a maximal ideal.
-/
theorem BooleanRing.isMaximal_of_isPrime {R : Type*} [BooleanRing R] {I : Ideal R}
    (hi : I.IsPrime) : I.IsMaximal := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\37.lean -/
/--
Prove that $R$ is a P.I.D. if and only if $R$ is a U.F.D. that is also a Bezout Domain.
-/
theorem isPrincipalIdealRing_iff_uniqueFactorizationMonoid_and_isBezout
    {R : Type*} [CommRing R] [IsDomain R] :
    IsPrincipalIdealRing R ↔ UniqueFactorizationMonoid R ∧ IsBezout R := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\4.lean -/
/--
Let $\phi: G \rightarrow G^{\prime}$ be a group homomorphism. Show that $ab\in \operatorname{Ker}\phi$ if and only if $ba\in \operatorname{Ker}\phi$.
-/
theorem mul_mem_ker_comm {G G' : Type*} [Group G] [Group G'] (f : G →* G') {a b : G} :
    (a * b ∈ f.ker)  ↔ (b * a ∈ f.ker) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\42.lean -/
/--
Suppose $(c, d) \in G \times H$, where $c$ has order $m$ and $d$ has order $n$.
Prove: If $m$ and $n$ are not relatively prime (hence have a common factor $q>1$ ),
then the order of $(c, d)$ is less than $m n$.
-/
theorem orderOf_prod_lt_orderOf_mul (G H : Type*) [Group G] [Group H] (c : G) (d : H)
    (h : (orderOf c).gcd (orderOf d) > 1) :
    orderOf (c, d) < (orderOf c) * (orderOf d) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\46.lean -/
open Polynomial

/--
Suppose $a(x)$ and $b(x)$ have degree $ < n$. If $a(c)=b(c)$ for $n$ values of $c$,
prove that $a(x)=b(x)$.
-/
theorem Polynomial.eq_of_roots_eq {R : Type*} [CommRing R] [IsDomain R] {n : ℕ} (a b : R[X])
    (ha : degree a < n) (hb : degree b < n) (hc : Multiset.card (roots (a - b)) = n) : a = b := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\49.lean -/
/--
Suppose that $G$ is a group and $a$ and $b$ are elements of $G$ that satisfy $a * b=b * a^{3}$.
Then the element $(a * b)^{2}$ can be written in the form $b^{k} a^{r}$.
-/
theorem mul_pow_two_eq_of_relation {G : Type*} [Group G] (a b : G) (h : a * b = b * (a ^ 3)) :
    ∃ k r : ℕ, (a * b) ^ 2 = b ^ k * a ^ r := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\51.lean -/
/--
Show that if $(a * b)^{2}=a^{2} * b^{2}$ for $a$ and $b$ in a group $G$, then $a * b=b * a$.
-/
theorem mul_comm_of_relation {G : Type*} [Group G] (a b : G) (h : (a * b) ^ 2 = a ^ 2 * b ^ 2) :
    a * b = b * a := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\55.lean -/
/--
Show that a group with no proper nontrivial subgroups is cyclic.
-/
theorem isCyclic_of_subgroup_eq_bot_or_top {G : Type*} [Group G]
    (h : ∀ H : Subgroup G, H = ⊥ ∨ H = ⊤) : IsCyclic G := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\58.lean -/
/--
Show that if $\sigma$ is a cycle of odd length, then $\sigma^{2}$ is a cycle.
-/
theorem Equiv.Perm.pow_two_isCycle_of_odd (n : ℕ) (f : Equiv.Perm (Fin n))
    (cyc : Equiv.Perm.IsCycle f) (oddcyc : Odd (orderOf f)) : Equiv.Perm.IsCycle (f ^ 2) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\60.lean -/
open scoped Pointwise

open MulOpposite

/--
Let $H$ be a subgroup of a group $G$ such that $g^{-1} h g \in H$ for all $g \in G$ and all
$h \in H$. Show that every left coset $g H$ is the same as the right coset $\mathrm{Hg}$.
-/
theorem leftCoset_eq_rightCoset_of_cong_mem {G : Type*} [Group G] (H : Subgroup G)
    (h : ∀ (h : H), ∀ (g : G), g * h * g⁻¹ ∈ H) :
    ∀ (g : G),  g • (H : Set G) = op g • (H : Set G) := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\64.lean -/
/--
Suppose that $G$ is a group and $g, h \in G$. Prove that $g x=h$ has a unique solution;
likewise, prove that $x g=h$ has a unique solution.
-/
theorem existUnique_solution {G : Type*} [Group G] (g h : G) :
    ∃! x, g * x = h ∧ ∃! x, x * g = h := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\67.lean -/
/--
Suppose that $G$ and $H$ are groups with operations $\circ$ and $*$ and suppose
$g, k \in G$ are inverses; that is, $g \circ k=e_{G}$. If $\varphi: G \rightarrow H$ is a group
isomorphism, prove that $\varphi(g)$ and $\varphi(k)$ are inverses in $H$.
-/
theorem MonoidHom.map_inv_eq_inv_map {G H : Type*} [Group G] [Group H] (φ : G →* H)
    (g k : G) (hgk : g = k⁻¹) : φ g = (φ k)⁻¹ := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\7.lean -/
/--
Let $\phi: G \rightarrow G^{\prime}$ be a group homomorphism. Show that $\phi(G)$ is Abelian
if and only if $x y x^{-1} y^{-1} \in \operatorname{Ker}(\phi)$ for all $x, y \in G$.
-/
theorem commutative_iff_commutator_mem_ker  {G H : Type} [Group G] [Group H] (f : G →* H) :
    (∀ x y : H, x ∈ f.range ∧ y ∈ f.range → x * y = y * x)
    ↔ ∀ x y : G, x * y * x⁻¹ * y⁻¹ ∈ f.ker := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\73.lean -/
/--
If $G$ is a finite group where every non-identity element is a generator of $G$,
show that the order of $G$ is prime or $1$.
-/
theorem card_prime_or_one_of_generator {G : Type*} [Group G] [Fintype G]
    (h : ∀ x : G, x ≠ 1 → Subgroup.zpowers x = ⊤) :
    (Fintype.card G).Prime ∨ Fintype.card G = 1 := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\76.lean -/
open Pointwise

/--
If $H$ is a subgroup of $G$ and two cosets of $H$ share an element, then these two cosets are equal.
-/
theorem cosets_eq_of_inter_ne_empty {G : Type*} [Group G] (H : Subgroup G) (a b : G) :
    (a • (H : Set G)) ∩ (b • (H : Set G)) ≠ ∅ →
    QuotientGroup.mk (s := H) a = QuotientGroup.mk (s := H) b  := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\79.lean -/
/--
Show that $x^{3}-2$ has only one real root.
-/
theorem Real.existUnique_pow_three_eq_two : ∃! x : ℝ, x ^ 3 = 2 := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\82.lean -/
/--
Give an example of $\alpha, \beta, \gamma \in S_{5}$, none of which is the identity (1),
with $\alpha \beta=\beta \alpha$ and $\alpha \gamma=\gamma \alpha$,
but with $\beta \gamma \neq \gamma \beta$.
-/
theorem equiv_not_commutative : ∃ α β γ : Equiv.Perm (Fin 5), α ≠ 1 ∧ β ≠ 1 ∧ γ ≠ 1 ∧
    α * β = β * α ∧ α * γ = γ * α ∧ β * γ ≠ γ * β := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\85.lean -/
open Classical

/--
If $H$ and $K$ are subgroups of a group $G$ and if $|H|$ and $|K|$ are relatively prime,
prove that $H \cap K=\{1\}$.
-/
theorem inf_eq_bot_of_card_coprime {G : Type*} [Group G] [Fintype G] (H : Subgroup G) (K : Subgroup G)
    (h : Nat.Coprime (Fintype.card H) (Fintype.card K)) : H ⊓ K = ⊥ := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\88.lean -/
/--
Let $G$ be a finite group written multiplicatively. Prove that if $|G|$ is odd, then every
$x \in G$ has a unique square root; that is, there exists exactly one $g \in G$ with $g^{2}=x$.
-/
theorem existUnique_square_root_of_odd_card {G : Type u} [Fintype G] [Group G]
    (hg : Odd (Fintype.card G)) : ∀ (x : G), ∃! (y : G), y ^ 2 = x := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\91.lean -/
/--
Let $R$ be a ring, and suppose there exists a positive even integer $n$ such that $x^{n}=x$ for all
$x \in R$. Prove that $-x=x$ for all $x \in R$.
-/
theorem neg_eq_self_of_even_pow_eq_self {R : Type*} [Ring R] [Nontrivial R] {n : ℕ} [NeZero n]
    (h : ∀ x : R, x ^ (2 * n) = x) : ∀ x : R, x = -x := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\94.lean -/
/--
Show that $a \in Z(G)$ if and only if $C(a)=G$.
-/
theorem mem_center_iff_centralizer_eq_top {G : Type*} [Group G] (a : G) :
    a ∈ Subgroup.center G ↔ Subgroup.centralizer {a} = ⊤ := by
  sorry

/- FILE: C:\Users\hyung\ProofMem\AlgebraDatasets\FATE-M\FATEM\97.lean -/
/--
Let $G$ be a group such that all subgroups of $G$ are normal in $G$. If $a, b \in G$,
prove that $b a=a^{j} b$ for some $j$.
-/
theorem mul_eq_pow_mul_of_normal (G : Type*) [Group G] (h : ∀ N : Subgroup G, N.Normal) :
    ∀ a b : G, ∃ j : ℤ, b * a = a ^ j * b := by
  sorry


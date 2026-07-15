import Mathlib

set_option linter.all false
open scoped BigOperators

section S001
variable {α β G M : Type*}
variable [CommSemigroup G]
theorem m001_t_mul_left_comm (a b c : G) : a * (b * c) = b * (a * c) := by
  rw [← mul_assoc, mul_comm a, mul_assoc]
end S001

section S002
variable {α β G M : Type*}
variable [Pow α β]
lemma m002_t_pow_ite (p : Prop) [Decidable p] (a : α) (b c : β) :
    a ^ (if p then b else c) = if p then a ^ b else a ^ c :=
  pow_dite _ _ _ _
end S002

section S003
variable {α β G M : Type*}
variable [Semigroup α]
theorem m003_t_comp_mul_left (x y : α) : (x * ·) ∘ (y * ·) = (x * y * ·) := by
  ext z
  simp [mul_assoc]
end S003

section S004
variable {α β G M : Type*}
variable [Pow α β]
lemma m004_t_pow_dite (p : Prop) [Decidable p] (a : α) (b : p → β) (c : ¬ p → β) :
    a ^ (if h : p then b h else c h) = if h : p then a ^ b h else a ^ c h := by split_ifs <;> rfl
end S004

section S005
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
lemma m005_t_eq_of_inv_mul_eq_one (h : a⁻¹ * b = 1) : a = b := by simpa using eq_inv_of_mul_eq_one_left h
end S005

section S006
open AddMonoid.End
variable {R S : Type*}
variable [NonUnitalNonAssocCommSemiring R]
lemma m006_t_mulRight_eq_mulLeft : mulRight = (mulLeft : R →+ AddMonoid.End R) :=

  AddMonoidHom.ext fun _ =>
    Eq.symm <| AddMonoidHom.mulLeft_eq_mulRight_iff_forall_commute.2 (.all _)
end S006

section S007
variable {α β G M : Type*}
variable [MulOneClass M]
theorem m007_t_one_mul_eq_id : ((1 : M) * ·) = id :=

  funext one_mul
end S007

section S008
variable {α β G M : Type*}
variable [CommSemigroup G]
theorem m008_t_mul_right_comm (a b c : G) : a * b * c = a * c * b := by
  rw [mul_assoc, mul_comm b, mul_assoc]
end S008

section S009
variable {α β G M : Type*}
variable [Pow α β]
lemma m009_t_ite_pow (p : Prop) [Decidable p] (a b : α) (c : β) :
    (if p then a else b) ^ c = if p then a ^ c else b ^ c :=
  dite_pow _ _ _ _
end S009

section S010
variable {α β G M : Type*}
variable [Semigroup α]
theorem m010_t_comp_mul_right (x y : α) : (· * x) ∘ (· * y) = (· * (y * x)) := by
  ext z
  simp [mul_assoc]
end S010

section S011
variable {α β G M : Type*}
variable [Pow α β]
lemma m011_t_dite_pow (p : Prop) [Decidable p] (a : p → α) (b : ¬ p → α) (c : β) :
    (if h : p then a h else b h) ^ c = if h : p then a h ^ c else b h ^ c := by split_ifs <;> rfl
end S011

section S012
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
lemma m012_t_eq_of_mul_inv_eq_one (h : a * b⁻¹ = 1) : a = b := by simpa using eq_inv_of_mul_eq_one_left h
end S012

section S013
variable {α β G M : Type*}
variable [MulOneClass M]
theorem m013_t_mul_one_eq_id : (· * (1 : M)) = id :=

  funext mul_one
end S013

section S014
variable {α β G M : Type*}
variable [Monoid M] {a b : M} {m n : ℕ}
lemma m014_t_pow_mul_pow_sub (a : M) (h : m ≤ n) : a ^ m * a ^ (n - m) = a ^ n := by
  rw [← pow_add, Nat.add_comm, Nat.sub_add_cancel h]
end S014

section S015
variable {α β G M : Type*}
variable [CommSemigroup G]
theorem m015_t_mul_mul_mul_comm_ (a b c d : G) : a * b * c * d = a * c * b * d := by
  grind
end S015

section S016
variable {α β G M : Type*}
variable [MulOneClass M]
theorem m016_t_ite_mul_one {P : Prop} [Decidable P] {a b : M} :
    ite P (a * b) 1 = ite P a 1 * ite P b 1 := by
  by_cases h : P <;> simp [h]
end S016

section S017
variable {α β G M : Type*}
variable [MulOneClass M]
theorem m017_t_eq_one_iff_eq_one_of_mul_eq_one {a b : M} (h : a * b = 1) : a = 1 ↔ b = 1 := by
  constructor <;> (rintro rfl; simpa using h)
end S017

section S018
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
lemma m018_t_zpow_natCast_sub_natCast (a : G) (m n : ℕ) : a ^ (m - n : ℤ) = a ^ m / a ^ n := by
  simpa [div_eq_mul_inv] using zpow_sub a m n
end S018

section S019
variable {M₀ G₀ : Type*}
variable [MulZeroClass M₀] {a b : M₀}
theorem m019_t_zero_mul_eq_const : ((0 : M₀) * ·) = Function.const _ 0 :=

  funext zero_mul
end S019

section S020
variable {α β G M : Type*}
variable [Monoid M] {a b : M} {m n : ℕ}
lemma m020_t_pow_sub_mul_pow (a : M) (h : m ≤ n) : a ^ (n - m) * a ^ m = a ^ n := by
  rw [← pow_add, Nat.sub_add_cancel h]
end S020

section S021
variable {α β G M : Type*}

section Monoid'
variable [Monoid M] {a b : M} {m n : ℕ}
lemma m021_t_pow_iterate (k : ℕ) : ∀ n : ℕ, (fun x : M ↦ x ^ k)^[n] = (· ^ k ^ n)
  | 0 => by ext; simp
  | n + 1 => by ext; simp [pow_iterate, Nat.pow_succ', pow_mul]
end Monoid'

section CommMonoid'
variable [CommMonoid M] {x y z : M}

@[to_additive]
theorem m021b_t_inv_unique (hy : x * y = 1) (hz : x * z = 1) : y = z :=

  left_inv_eq_right_inv (Trans.trans (mul_comm _ _) hy) hz
end CommMonoid'

end S021

section S022
variable {α β G M : Type*}
variable [MulOneClass M]
theorem m022_t_ite_one_mul {P : Prop} [Decidable P] {a b : M} :
    ite P 1 (a * b) = ite P 1 a * ite P 1 b := by
  by_cases h : P <;> simp [h]
end S022

section S023
variable {M₀ G₀ : Type*}
variable [MonoidWithZero M₀] {a : M₀} {n : ℕ}
lemma m023_t_pow_eq_zero_of_le : ∀ {m n}, m ≤ n → a ^ m = 0 → a ^ n = 0
  | _, _, Nat.le.refl, ha => ha
  | _, _, Nat.le.step hmn, ha => by rw [pow_succ, pow_eq_zero_of_le hmn ha, zero_mul]

lemma m023b_t_ne_zero_pow (hn : n ≠ 0) (ha : a ^ n ≠ 0) : a ≠ 0 := by rintro rfl; exact ha <| zero_pow hn
end S023

section S024
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
lemma m024_t_zpow_natCast_sub_one (a : G) (n : ℕ) : a ^ (n - 1 : ℤ) = a ^ n / a := by
  simpa [div_eq_mul_inv] using zpow_sub a n 1
end S024

section S025
variable {M₀ G₀ : Type*}
variable [MulZeroClass M₀] {a b : M₀}
theorem m025_t_mul_zero_eq_const : (· * (0 : M₀)) = Function.const _ 0 :=

  funext mul_zero
end S025

section S026
variable {α β G M : Type*}
variable [Monoid M] {a b : M} {m n : ℕ}
lemma m026_t_mul_pow_sub_one (hn : n ≠ 0) (a : M) : a * a ^ (n - 1) = a ^ n := by
  rw [← pow_succ', Nat.sub_add_cancel <| Nat.one_le_iff_ne_zero.2 hn]
end S026

section S027
variable {α β G M : Type*}
variable [Monoid M] [IsLeftCancelMul M] {a b : M}
theorem m027_t_left_eq_mul : a = a * b ↔ b = 1 :=

  eq_comm.trans mul_eq_left
end S027

section S028
variable {α β G M : Type*}
variable [CommSemigroup G]
theorem m028_t_mul_mul_mul_comm (a b c d : G) : a * b * (c * d) = a * c * (b * d) := by
  simp only [mul_left_comm, mul_assoc]
end S028

section S029
variable {M₀ G₀ : Type*}
variable [MonoidWithZero M₀] {a : M₀} {n : ℕ}
lemma m029_t_zero_pow_eq_zero [Nontrivial M₀] : (0 : M₀) ^ n = 0 ↔ n ≠ 0 :=

  ⟨by rintro h rfl; simp at h, zero_pow⟩
end S029

section S030
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
lemma m030_t_zpow_one_sub_natCast (a : G) (n : ℕ) : a ^ (1 - n : ℤ) = a / a ^ n := by
  simpa [div_eq_mul_inv] using zpow_sub a 1 n
end S030

section S031
variable {α β G M : Type*}
variable [Monoid M] {a b : M} {m n : ℕ}
lemma m031_t_pow_sub_one_mul (hn : n ≠ 0) (a : M) : a ^ (n - 1) * a = a ^ n := by
  rw [← pow_succ, Nat.sub_add_cancel <| Nat.one_le_iff_ne_zero.2 hn]
end S031

section S032
variable {α β G M : Type*}
variable [Monoid M] [IsLeftCancelMul M] {a b : M}
theorem m032_t_mul_ne_left : a * b ≠ a ↔ b ≠ 1 :=
  mul_eq_left.not
end S032

section S033
variable {α β G M : Type*}
variable [CommSemigroup G]
theorem m033_t_mul_rotate (a b c : G) : a * b * c = b * c * a := by
  simp only [mul_left_comm, mul_comm]
end S033

section S034
open AddMonoidHom
variable {R S : Type*}
variable [NonUnitalNonAssocSemiring R] [NonUnitalNonAssocSemiring S] {a b : R}
lemma m034_t_mulRight_apply (a r : R) : mulRight r a = a * r :=
  rfl
end S034

section S035
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m035_t_zpow_eq_zpow_emod_ {x : G} (m : ℤ) {n : ℕ} (h : x ^ n = 1) :
    x ^ m = x ^ (m % (n : ℤ)) :=
  zpow_eq_zpow_emod m (by simpa)
end S035

section S036
variable {α β G M : Type*}
variable [Monoid M] [IsLeftCancelMul M] {a b : M}
theorem m036_t_mul_eq_left : a * b = a ↔ b = 1 :=
calc
  a * b = a ↔ a * b = a * 1 := by rw [mul_one]
  _ ↔ b = 1 := mul_left_cancel_iff
end S036

section S037
variable {α β G M : Type*}
variable [Monoid M] [IsLeftCancelMul M] {a b : M}
theorem m037_t_left_ne_mul : a ≠ a * b ↔ b ≠ 1 :=
  left_eq_mul.not
end S037

section S038
variable {α β G M : Type*}
variable [CommSemigroup G]
theorem m038_t_mul_rotate_ (a b c : G) : a * (b * c) = b * (c * a) := by
  simp only [mul_left_comm, mul_comm]
end S038

section S039
open AddMonoidHom
variable {R S : Type*}
variable [NonUnitalNonAssocSemiring R] [NonUnitalNonAssocSemiring S] {a b : R}
lemma m039_t_mul_apply (x y : R) : mul x y = x * y :=
  rfl
end S039

section S040
variable {M₀ G₀ : Type*}
variable {R S : Type*} {x y : R}
lemma m040_t_exists_isNilpotent_of_not_isReduced {R : Type*} [Zero R] [Pow R ℕ] (h : ¬IsReduced R) :
    ∃ x : R, x ≠ 0 ∧ IsNilpotent x := by
  simpa [isReduced_iff, not_forall, and_comm] using h
end S040

section S041
variable {α β G M : Type*}
variable [Monoid M] [IsRightCancelMul M] {a b : M}
theorem m041_t_mul_eq_right : a * b = b ↔ a = 1 :=
calc
  a * b = b ↔ a * b = 1 * b := by rw [one_mul]
  _ ↔ a = 1 := mul_right_cancel_iff
end S041

section S042
variable {α β G M : Type*}
variable [Monoid M] [IsRightCancelMul M] {a b : M}
theorem m042_t_right_eq_mul : b = a * b ↔ a = 1 :=

  eq_comm.trans mul_eq_right
end S042

section S043
variable {α β G M : Type*}
variable [Monoid M] {a b : M} {m n : ℕ}
lemma m043_t_pow_boole (P : Prop) [Decidable P] (a : M) :
    (a ^ if P then 1 else 0) = if P then a else 1 := by simp only [pow_ite, pow_one, pow_zero]
end S043

section S044
variable {α : Type u} {R : Type v}
variable [NonAssocSemiring α]
theorem m044_t_two_mul (n : α) : 2 * n = n + n :=

  (congrArg₂ _ one_add_one_eq_two.symm rfl).trans <| (right_distrib 1 1 n).trans (by rw [one_mul])
end S044

section S045
variable {M₀ G₀ : Type*}
variable [GroupWithZero G₀] {a b x : G₀}
theorem m045_t_GroupWithZero_mul_right_injective (h : x ≠ 0) :
    Function.Injective fun y => x * y :=
fun y y' w => by
  simpa only [← mul_assoc, inv_mul_cancel₀ h, one_mul] using congr_arg (fun y => x⁻¹ * y) w
end S045

section S046
variable {α β G M : Type*}
variable [DivInvMonoid G]
theorem m046_t_mul_one_div (x y : G) : x * (1 / y) = x / y := by
  rw [div_eq_mul_inv, one_mul, div_eq_mul_inv]
end S046

section S047
variable {α β G M : Type*}
variable [Monoid M] [IsRightCancelMul M] {a b : M}
theorem m047_t_mul_ne_right : a * b ≠ b ↔ a ≠ 1 :=
  mul_eq_right.not
end S047

section S048
variable {α β G M : Type*}
variable [Monoid M] {a b : M} {m n : ℕ}
@[to_additive (attr :=
  simp)]
lemma m048_t_mul_left_iterate (a : M) : ∀ n : ℕ, (a * ·)^[n] = (a ^ n * ·)
  | 0 => by ext; simp
  | n + 1 => by simp [pow_succ, mul_left_iterate]
end S048

section S049
variable {α : Type u} {R : Type v}
variable [NonAssocSemiring α]
theorem m049_t_mul_two (n : α) : n * 2 = n + n :=

  (congrArg₂ _ rfl one_add_one_eq_two.symm).trans <| (left_distrib n 1 1).trans (by rw [mul_one])
end S049

section S050
variable {α β G M : Type*}
variable [DivInvMonoid G]
theorem m050_t_div_eq_mul_one_div (a b : G) : a / b = a * (1 / b) := by rw [div_eq_mul_inv, one_div]
end S050

section S051
variable {α β G M : Type*}
variable [Monoid M] [IsRightCancelMul M] {a b : M}
theorem m051_t_right_ne_mul : b ≠ a * b ↔ a ≠ 1 :=
  right_eq_mul.not
end S051

section S052
variable {α β G M : Type*}
variable [Monoid M] {a b : M} {m n : ℕ}
lemma m052_t_mul_right_iterate (a : M) : ∀ n : ℕ, (· * a)^[n] = (· * a ^ n)
  | 0 => by ext; simp
  | n + 1 => by simp [pow_succ', mul_right_iterate]

/-- Version of `mul_left_iterate` that is fully applied, for `rw`. -/
@[to_additive /-- Version of `add_left_iterate` that is fully applied, for `rw`. -/]
lemma m052b_t_mul_left_iterate_apply (a b : M) : (a * ·)^[n] b = a ^ n * b := by simp
end S052

section S053
variable {F α β : Type*}
variable [Mul α]
lemma m053_t_isSquare_iff_exists_mul_self (a : α) : IsSquare a ↔ ∃ r, a = r * r :=
  .rfl
end S053

section S054
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
theorem m054_t_eq_one_div_of_mul_eq_one_left (h : b * a = 1) : b = 1 / a := by
  rw [eq_inv_of_mul_eq_one_left h, one_div]
end S054

section S055
variable {α β G M : Type*}
variable [InvolutiveInv G] {a b : G}
theorem m055_t_inv_involutive : Function.Involutive (Inv.inv : G → G) :=

  inv_inv
end S055

section S056
variable {α β G M : Type*}
variable [Monoid M] {a b : M} {m n : ℕ}
lemma m056_t_mul_right_iterate_apply (a b : M) : (· * a)^[n] b = b * a ^ n := by simp
end S056

section S057
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
theorem m057_t_eq_one_div_of_mul_eq_one_right (h : a * b = 1) : b = 1 / a := by
  rw [eq_inv_of_mul_eq_one_right h, one_div]
end S057

section S058
variable {α β G M : Type*}
variable [InvolutiveInv G] {a b : G}
theorem m058_t_inv_bijective : Function.Bijective (Inv.inv : G → G) :=

  inv_involutive.bijective
end S058

section S059
variable {α β G M : Type*}
variable [Monoid M] {a b : M} {m n : ℕ}
lemma m059_t_mul_left_iterate_apply_one (a : M) : (a * ·)^[n] 1 = a ^ n := by simp
end S059

section S060
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
variable (a b c)
lemma m060_t_inv_zpow_ (a : α) (n : ℤ) : a⁻¹ ^ n = a ^ (-n) := by rw [inv_zpow, zpow_neg]
end S060

section S061
variable {α β G M : Type*}
variable [InvolutiveInv G] {a b : G}
theorem m061_t_inv_surjective : Function.Surjective (Inv.inv : G → G) :=

  inv_involutive.surjective
end S061

section S062
variable {α β G M : Type*}
variable [Monoid M] {a b : M} {m n : ℕ}
lemma m062_t_mul_right_iterate_apply_one (a : M) : (· * a)^[n] 1 = a ^ n := by simp [mul_right_iterate]
end S062

section S063
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
variable (a b c)
variable {a b c}
theorem m063_t_eq_of_one_div_eq_one_div (h : 1 / a = 1 / b) : a = b := by
  rw [← one_div_one_div a, h, one_div_one_div]
end S063

section S064
variable {α β G M : Type*}
variable [InvolutiveInv G] {a b : G}
theorem m064_t_inv_injective : Function.Injective (Inv.inv : G → G) :=

  inv_involutive.injective
end S064

section S065
variable {α β G M : Type*}
variable [DivInvMonoid G]
theorem m065_t_mul_div (a b c : G) : a * (b / c) = a * b / c := by simp only [mul_assoc, div_eq_mul_inv]
end S065

section S066
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
variable (a b c)
variable {a b c}
lemma m066_t_zpow_mul_ (a : α) (m n : ℤ) : a ^ (m * n) = (a ^ n) ^ m := by rw [Int.mul_comm, zpow_mul]
end S066

section S067
variable {α β G M : Type*}
variable [InvolutiveInv G] {a b : G}
theorem m067_t_inv_inj : a⁻¹ = b⁻¹ ↔ a = b :=

  inv_injective.eq_iff
end S067

section S068
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
variable (a b c)
variable {a b c}
theorem m068_t_zpow_comm (a : α) (m n : ℤ) : (a ^ m) ^ n = (a ^ n) ^ m := by rw [← zpow_mul, zpow_mul']
end S068

section S069
variable {α β G M : Type*}
variable [InvolutiveInv G] {a b : G}
theorem m069_t_inv_eq_iff_eq_inv : a⁻¹ = b ↔ a = b⁻¹ :=

  inv_involutive.eq_iff
end S069

section S070
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m070_t_div_eq_inv_self : a / b = b⁻¹ ↔ a = 1 := by rw [div_eq_mul_inv, mul_eq_right]
end S070

section S071
variable {α β G M : Type*}
variable [InvolutiveInv G] {a b : G}
variable (G)
theorem m071_t_inv_comp_inv : Inv.inv ∘ Inv.inv = @id G :=

  inv_involutive.comp_self
end S071

section S072
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m072_t_mul_eq_of_eq_inv_mul (h : b = a⁻¹ * c) : a * b = c := by rw [h, mul_inv_cancel_left]
end S072

section S073
variable {α β G M : Type*}
variable [InvolutiveInv G] {a b : G}
variable (G)
theorem m073_t_leftInverse_inv : Function.LeftInverse (fun a : G ↦ a⁻¹) fun a ↦ a⁻¹ :=

  inv_inv
end S073

section S074
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m074_t_mul_eq_one_iff_eq_inv : a * b = 1 ↔ a = b⁻¹ :=

  ⟨eq_inv_of_mul_eq_one_left, fun h ↦ by rw [h, inv_mul_cancel]⟩
end S074

section S075
variable {α β G M : Type*}
variable [InvolutiveInv G] {a b : G}
variable (G)
theorem m075_t_rightInverse_inv : Function.RightInverse (fun a : G ↦ a⁻¹) fun a ↦ a⁻¹ :=

  inv_inv
end S075

section S076
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m076_t_mul_eq_one_iff_inv_eq : a * b = 1 ↔ a⁻¹ = b := by
  rw [mul_eq_one_iff_eq_inv, inv_eq_iff_eq_inv]
end S076

section S077
variable {α β G M : Type*}
variable [DivInvMonoid G]
theorem m077_t_mul_div_assoc_ (a b c : G) : a * (b / c) = a * b / c :=

  (mul_div_assoc _ _ _).symm
end S077

section S078
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m078_t_mul_eq_one_iff_eq_inv_ : a * b = 1 ↔ b = a⁻¹ := by
  rw [mul_eq_one_iff_inv_eq, eq_comm]
end S078

section S079
variable {α β G M : Type*}
variable [DivInvOneMonoid G]
theorem m079_t_one_div_one : (1 : G) / 1 = 1 :=

  div_one _
end S079

section S080
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m080_t_mul_eq_one_iff_inv_eq_ : a * b = 1 ↔ b⁻¹ = a := by
  rw [mul_eq_one_iff_eq_inv, eq_comm]
end S080

section S081
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
theorem m081_t_eq_inv_of_mul_eq_one_right (h : a * b = 1) : b = a⁻¹ :=

  (inv_eq_of_mul_eq_one_right h).symm
end S081

section S082
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m082_t_eq_mul_inv_iff_mul_eq : a = b * c⁻¹ ↔ a * c = b :=

  ⟨fun h ↦ by rw [h, inv_mul_cancel_right], fun h ↦ by rw [← h, mul_inv_cancel_right]⟩
end S082

section S083
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
theorem m083_t_eq_of_div_eq_one (h : a / b = 1) : a = b :=

  inv_injective <| inv_eq_of_mul_eq_one_right <| by rwa [← div_eq_mul_inv]
end S083

section S084
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m084_t_eq_inv_mul_iff_mul_eq : a = b⁻¹ * c ↔ b * a = c :=

  ⟨fun h ↦ by rw [h, mul_inv_cancel_left], fun h ↦ by rw [← h, inv_mul_cancel_left]⟩
end S084

section S085
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
theorem m085_t_div_ne_one_of_ne : a ≠ b → a / b ≠ 1 :=

  mt eq_of_div_eq_one
end S085

section S086
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m086_t_inv_mul_eq_iff_eq_mul : a⁻¹ * b = c ↔ b = a * c :=

  ⟨fun h ↦ by rw [← h, mul_inv_cancel_left], fun h ↦ by rw [h, inv_mul_cancel_left]⟩
end S086

section S087
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
variable (a b c)
variable {a b c}
theorem m087_t_inv_eq_one : a⁻¹ = 1 ↔ a = 1 :=

  inv_injective.eq_iff' inv_one
end S087

section S088
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m088_t_mul_inv_eq_iff_eq_mul : a * b⁻¹ = c ↔ a = c * b :=

  ⟨fun h ↦ by rw [← h, inv_mul_cancel_right], fun h ↦ by rw [h, mul_inv_cancel_right]⟩
end S088

section S089
variable {α β G M : Type*}
variable [DivisionMonoid α] {a b c d : α}
variable (a b c)
variable {a b c}
theorem m089_t_one_eq_inv : 1 = a⁻¹ ↔ a = 1 :=

  eq_comm.trans inv_eq_one
end S089

section S090
variable {α β G M : Type*}
variable [Group G] {a b c d : G} {n : ℤ}
theorem m090_t_mul_inv_eq_one : a * b⁻¹ = 1 ↔ a = b := by rw [mul_eq_one_iff_eq_inv, inv_inv]
end S090

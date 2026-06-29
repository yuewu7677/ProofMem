import Mathlib

namespace Smoke.GroupTheory

variable {G : Type*} [Group G]

-- D1: pure group identities. `group` is designed to close all of these.
-- It proves any equation that holds in every group from the axioms.

/-- T01 -/
theorem inv_inv' (a : G) : a⁻¹⁻¹ = a := by group

/-- T02 -/
theorem mul_inv_rev' (a b : G) : (a * b)⁻¹ = b⁻¹ * a⁻¹ := by group

/-- T03 -/
theorem inv_one' : (1 : G)⁻¹ = 1 := by group

/-- T04 -/
theorem mul_one_eq' (a : G) : a * 1 = a := by group

/-- T05 -/
theorem mul_left_inv' (a : G) : a⁻¹ * a = 1 := by group

-- D2: a step beyond raw identities. These need one or two named lemmas
-- or a short manipulation. `group` alone will NOT close hypotheses-based
-- goals, so these use explicit reasoning.

/-- T06: left cancellation -/
theorem left_cancel' (a b c : G) (h : a * b = a * c) : b = c := by
  exact mul_left_cancel h

/-- T07: an element times its claimed inverse pins down the inverse -/
theorem eq_inv_of_mul_eq_one' (a b : G) (h : a * b = 1) : b = a⁻¹ := by
    calc b = 1 * b      := by rw [one_mul]
  _ = (a⁻¹ * a) * b  := by rw [<- mul_left_inv']
  _ = a⁻¹ * (a * b)  := by rw [mul_assoc]
  _ = a⁻¹ * 1        := by rw [h]
  _ = a⁻¹            := by rw [mul_one]

/-- T08: inverse is injective -/
theorem inv_inj' (a b : G) (h : a⁻¹ = b⁻¹) : a = b := by
  exact inv_injective h

-- D3: structural / genuine reasoning.

/-- T09: a group in which every element is its own inverse is abelian -/
theorem comm_of_self_inverse (h : ∀ x : G, x * x = 1) (a b : G) :
    a * b = b * a := by
  have inv_eq : ∀ x : G, x⁻¹ = x := by
    intro x
    exact inv_eq_of_mul_eq_one_right (h x)
  calc a * b = (a * b)⁻¹ := (inv_eq (a * b)).symm
    _ = b⁻¹ * a⁻¹ := mul_inv_rev a b
    _ = b * a := by rw [inv_eq a, inv_eq b]

/-- T10 If two elements commute, the inverse of one also commutes with the other. -/
theorem comm_inv (a b : G) (h : a * b = b * a) : a⁻¹ * b = b * a⁻¹ := by
  calc a⁻¹ * b = a⁻¹ * b * a * a⁻¹ := by group
    _ = a⁻¹ * (b * a) * a⁻¹ := by group
    _ = a⁻¹ * (a * b) * a⁻¹ := by rw [h]
    _ = b * a⁻¹ := by group
end Smoke.GroupTheory

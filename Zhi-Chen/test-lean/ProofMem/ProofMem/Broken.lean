import Mathlib

theorem n_eq_n_plus_one (n : Nat) : n = n + 1 := by
  rfl

theorem zero_eq_one : (0 : Nat) = 1 := by
  rfl

theorem symm_wrong (a b : Nat) (h : a = b) : b = a := by
  exact h

theorem sum_first_n (n : Nat) : (Finset.sum (Finset.range n) id) = n*(n+1)/2 := by
  simp

theorem two_plus_two_eq_four : 2 + 2 = 4 := by
  rfl

import Mathlib

-- Simple theorem: sum of first n odd numbers equals n^2
theorem sum_of_odds_eq_square (n : Nat) : (Finset.sum (Finset.range n) (λ i => 2*i+1)) = n*n := by
  induction' n with k ih
  · rfl
  · simp [Finset.sum_range_succ, ih]
    ring

-- Lemma: if a ≤ b and b ≤ a then a = b (antisymmetry of ≤ on Nats)
theorem le_antisymm_example (a b : Nat) (h1 : a ≤ b) (h2 : b ≤ a) : a = b := by
  apply Nat.le_antisymm h1 h2

-- Lemma: addition is commutative for natural numbers (custom proof using induction)
theorem add_comm_custom (n m : Nat) : n + m = m + n := by
  induction' n with k ih generalizing m
  · simp
  · rw [Nat.succ_add, ih, Nat.add_succ]
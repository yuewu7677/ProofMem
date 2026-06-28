import Mathlib

#eval 2 + 3
#check 5
def square (x : Nat) : Nat := x * x
#eval square 5
theorem one_plus_one : 1 + 1 = 2 := rfl

-- rfl - reflexivity tactic - after simplification， left side = right side
example : 5 = 2 + 3 := by rfl
-- rw - rewrite tactic - replace one side of an equation with the other
example (a b c : Nat) (h : a = b) : a + c = b + c := by
  rw [h] -- replace a with b in the equation
-- simp - simplification tactic - automatically simplify expressions
example (n : Nat) : n + 0 = n := by simp
-- intro - introduction tactic - introduce variables and hypotheses into the proof context
example : ∀ (n : Nat), n = n := by
  intro k -- introduce the variable k into the proof context
  rfl -- proof k = k

--ring - ring tactic - automatically prove ring equalities
theorem am_bm_sq (a b : Nat) : (a + b) * (a + b) = a * a + 2 * a * b + b * b := by
  ring -- expand the equation and prove the equality

-- induction - induction tactic - prove statements by mathematical induction
theorem sum_of_odds_eq_square (n : Nat) : (Finset.sum (Finset.range n) (λ i => 2*i+1)) = n*n := by
  induction' n with k ih
  · rfl -- base case
  · simp [Finset.sum_range_succ, ih] -- induction step
    ring

-- linarith - linear arithmetic tactic - automatically prove linear inequalities
example (x y : Nat) (h : x < y) : x + 1 ≤ y := by linarith

-- ih - induction hypothesis
theorem nat_lt_two_pow (n : Nat) : n < 2 ^ n := by
  induction' n with k ih
  · simp -- 1. Base case: n = 0
         -- The goal becomes: 0 < 2^0, i.e., 0 < 1
  · -- 2. Inductive step: n = k + 1
    -- Given ih: k < 2 ^ k
    -- Current goal ⊢ k + 1 < 2 ^ (k + 1)

    -- First, by the definition of exponentiation, 2 ^ (k + 1)
    -- can be expanded to 2 ^ k * 2, which is 2 ^ k + 2 ^ k.
    -- We use simp to tidy up the right-hand side a bit
    simp [pow_succ] -- theorem pow_succ (a : α) (n : Nat) : a ^ (n + 1) = a ^ n * a
    -- At this point, the goal becomes ⊢ k + 1 < 2 ^ k + 2 ^ k
    -- A key step: since we know ih : k < 2 ^ k,
    -- the inequality holds if we use ih in conjunction with the obvious fact that 1 ≤ 2 ^ k.
    -- We can simply feed ih to the linarith tactic;
    -- it will automatically combine ih with the other facts to handle the remaining inequality derivation.
    linarith

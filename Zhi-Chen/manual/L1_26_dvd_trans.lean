import Mathlib

/--
Divisibility is transitive on ℕ.

If a ∣ b and b ∣ c, then a ∣ c.

For natural numbers: b = a*k and c = b*l implies c = a*(k*l).
-/
theorem dvd_trans_nat {a b c : ℕ} (h₁ : a ∣ b) (h₂ : b ∣ c) : a ∣ c := by
  sorry

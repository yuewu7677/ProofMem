import Mathlib

/--
If d divides both a and b, then d divides their sum.

d ∣ a ∧ d ∣ b → d ∣ (a + b) for natural numbers.

Linearity property of divisibility.
-/
theorem dvd_add_nat {d a b : ℕ} (hd₁ : d ∣ a) (hd₂ : d ∣ b) : d ∣ (a + b) := by
  sorry

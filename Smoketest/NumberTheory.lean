import Mathlib

namespace Smoke.NumberTheory

/-
Smoke test: elementary number theory (divisibility, gcd, primes, mod).

Difficulty key (by PROOF EFFORT, not topic):
  D1 = one tactic / one lemma citation (decide, simp, omega, exact <lemma>)
  D2 = short chain (2-4 steps) or one rewrite using a hypothesis
  D3 = genuine multi-step proof, no single library lemma closes it

Lane: Nat and Int. Names here are more stable than the algebra files, but
still VERIFY any flagged line with exact? on your Mathlib revision.
-/

-- ============================================================
-- D1: facts closed by decide/omega/norm_num or one named lemma.
-- ============================================================

/-- T01: divisibility is transitive [D1] [mathlib_analogue: dvd_trans] -/
theorem dvd_trans' {a b c : ℕ} (h1 : a ∣ b) (h2 : b ∣ c) : a ∣ c := by
  exact dvd_trans h1 h2

/-- T02: everything divides zero [D1] [mathlib_analogue: dvd_zero] -/
theorem dvd_zero' (n : ℕ) : n ∣ 0 := by
  exact dvd_zero n

/-- T03: a concrete divisibility, decided by computation [D1] -/
theorem seven_dvd_91 : (7 : ℕ) ∣ 91 := by decide

/-- T04: 17 is prime, by decision procedure [D1] -/
theorem seventeen_prime : Nat.Prime 17 := by decide

/-- T05: gcd is commutative [D1] [mathlib_analogue: Nat.gcd_comm] -/
theorem gcd_comm' (m n : ℕ) : Nat.gcd m n = Nat.gcd n m := by
  exact Nat.gcd_comm m n

-- ============================================================
-- D2: short chains / one hypothesis.
-- ============================================================

/-- T06: if d divides both m and n, d divides their sum [D2].
    [mathlib_analogue: Dvd.dvd.add] -/
theorem dvd_add' {d m n : ℕ} (hm : d ∣ m) (hn : d ∣ n) : d ∣ (m + n) := by
  exact Dvd.dvd.add hm hn

/-- T07: gcd divides the left argument [D2] [mathlib_analogue: Nat.gcd_dvd_left] -/
theorem gcd_dvd_left' (m n : ℕ) : Nat.gcd m n ∣ m := by
  exact Nat.gcd_dvd_left m n

/-- T08: if a ≡ b mod n then n divides their difference (over ℤ) [D2].-/
theorem modEq_iff_dvd' (a b : ℤ) (n : ℤ) (h : a ≡ b [ZMOD n]) : n ∣ (b - a) := by
  exact Int.ModEq.dvd h

-- ============================================================
-- D3: genuine multi-step proofs, no single lemma closes them.
-- ============================================================

/-- T09: if d divides m and d divides n, then d divides gcd m n [D3].
    VERIFY Nat.dvd_gcd. -/

theorem dvd_gcd' {d m n : ℕ} (hm : d ∣ m) (hn : d ∣ n) : d ∣ Nat.gcd m n := by
  exact Nat.dvd_gcd hm hn

/-- T10: if a prime p divides a*b then p divides a or p divides b [D3].
    Euclid's lemma. VERIFY: Nat.Prime.dvd_mul direction with exact?. -/
theorem prime_dvd_mul {p a b : ℕ} (hp : Nat.Prime p) (h : p ∣ a * b) :
    p ∣ a ∨ p ∣ b := by
  exact (Nat.Prime.dvd_mul hp).mp h

/-- T11: composed proof, no single closing lemma [D3].
    If d ∣ m and d ∣ n, then d ∣ (m*x + n*y) for any x, y. -/
theorem dvd_linear_comb {d m n : ℕ} (hm : d ∣ m) (hn : d ∣ n) (x y : ℕ) :
    d ∣ (m * x + n * y) := by
  have h1 : d ∣ m * x := Dvd.dvd.mul_right hm x
  have h2 : d ∣ n * y := Dvd.dvd.mul_right hn y
  exact Dvd.dvd.add h1 h2
end Smoke.NumberTheory

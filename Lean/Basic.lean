--------------- Defines the language L ---------------
-- Alphabet is the set of symbols {a,b}
inductive Alphabet where -- Defines Alphabet data structure
  | a
  | b
  deriving DecidableEq, Repr
  -- DecideableEq: It is always mathematically possible to prove whether two Alphabet values are equal or not
  -- Repr: How to convert values to strings


-- Word is the set of all finite lists of Alphabet symbols
abbrev Word := List Alphabet
-- [Alphabet.a, Alphabet.a, Alphabet.b] Represents word aab


-- Count number of a's in the word
def countA : Word -> Nat
  | [] => 0
  | symbol :: rest =>
      match symbol with
        | Alphabet.a => countA rest + 1
        | Alphabet.b => countA rest


-- Count number of b's in the word
def countB : Word -> Nat
  | [] => 0
  | symbol :: rest =>
      match symbol with
        | Alphabet.a => countB rest
        | Alphabet.b => countB rest + 1


-- Check if number of a's and b's match
def countsMatch (word : Word) : Bool :=
  countA word == countB word


-- Check if the word contains at least one a
def containsA (word : Word) : Bool :=
  match word with
    | [] => false
    | Alphabet.a :: _ => true
    | Alphabet.b :: rest => containsA rest


-- Check if all a's come before all b's
def allAsBeforeBs (word : Word) : Bool :=
  match word with
  | [] => true
  | Alphabet.a :: rest => allAsBeforeBs rest
  | Alphabet.b :: rest => !(containsA rest)


-- Checks if a word is in language L
def isInLanguage (word : Word) : Bool :=
  allAsBeforeBs word && countsMatch word


-- Repeats a symbol n times
def repeatSymbol (symbol : Alphabet) : Nat -> Word
  | 0 => []
  | n + 1 => symbol :: repeatSymbol symbol n


-- Defines a canonical word as one of form a^n b^n
def canonicalWord (n : Nat) : Word :=
  repeatSymbol Alphabet.a n ++ repeatSymbol Alphabet.b n


--------------- Theorems ---------------
-- countA of empty word is zero
theorem countA_empty : countA [] = 0 := by
  rfl


-- countB of empty word is zero
theorem countB_empty : countB [] = 0 := by
  rfl


-- Prepending a increases countA by one
theorem countA_cons_a (rest : Word) :
    countA (Alphabet.a :: rest) = countA rest + 1 := by
  rfl


-- Prepending b increases countA by zero
theorem countA_cons_b (rest : Word) :
    countA (Alphabet.b :: rest) = countA rest := by
  rfl


-- Prepending a increases countB by zero
theorem countB_cons_a (rest : Word) :
    countB (Alphabet.a :: rest) = countB rest:= by
  rfl


-- Prepending b increases countB by one
theorem countB_cons_b (rest : Word) :
    countB (Alphabet.b :: rest) = countB rest + 1 := by
  rfl


-- countA <= word length
theorem countA_le_length (word : Word) :
    countA word <= word.length := by
  induction word with
  | nil =>
    simp
    rfl
  | cons symbol rest h =>
    cases symbol with
    | a =>
      simp [countA]
      exact h
    | b =>
      simp [countA]
      omega


-- countB <= word length
theorem countB_le_length (word : Word) :
    countB word <= word.length := by
  induction word with
  | nil =>
    simp
    rfl
  | cons symbol rest h =>
    cases symbol with
    | a =>
      simp [countB]
      omega
    | b =>
      simp [countB]
      exact h


-- Words in L have equal a/b counts
theorem accepted_words_eq_counts (word : Word) :
    isInLanguage word = true -> countA word = countB word := by
  simp [isInLanguage, countsMatch]


-- Words in L have all a's come before all b's
theorem accepted_words_correct_order (word : Word) :
    isInLanguage word = true -> allAsBeforeBs word = true := by
  simp [isInLanguage]
  intro h
  intro h1
  exact h


-- Words in L have equal a/b counts and all a's come before all b's
theorem accepted_words_eq_counts_correct_order (word : Word) :
    allAsBeforeBs word = true -> countsMatch word = true -> isInLanguage word = true := by
  intro h
  intro h1
  simp[isInLanguage]
  constructor
  exact h
  exact h1


-- Ordered words starting with b cannot contain an a
theorem ordered_b_cons (rest : Word) :
    allAsBeforeBs (Alphabet.b :: rest) = true -> containsA rest = false := by
  simp [allAsBeforeBs]


theorem containsA_append (x y : Word) :
    containsA (x ++ y) = true -> containsA x = true ∨ containsA y = true := by
  induction x with
  | nil =>
    simp [containsA]
  | cons symbol rest h =>
    cases symbol with
    | a =>
      simp [containsA]
    | b =>
      simp [containsA]
      exact h


theorem containsA_append_of_left (x y : Word) :
    containsA x = true -> containsA (x ++ y) = true := by
  induction x with
  | nil =>
    simp [containsA]
  | cons symbol rest h =>
    cases symbol with
    | a =>
      simp [containsA]
    | b =>
      simp[containsA]
      exact h


-- Words starting with a contain a
theorem containsA_cons_a (rest : Word) :
    containsA (Alphabet.a :: rest) = true := by
  rfl


-- repeatSymbol with n = 0 returns an empty list
theorem repeatSymbol_zero (symbol : Alphabet) :
    repeatSymbol symbol 0 = [] := by
  rfl


-- repeatSymbol with n = 1 returns a one-element list of symbol
theorem repeatSymbol_one (symbol : Alphabet) :
    repeatSymbol symbol 1 = [symbol] := by
  rfl

-- Length of repeatSymbol list is n
theorem repeatSymbol_length (symbol : Alphabet) (n : Nat) :
    (repeatSymbol symbol n).length = n := by
  induction n with
  | zero =>
    rfl
  | succ n h =>
    simp [repeatSymbol, h]


-- The length of a canonical word is 2n
theorem canonicalWord_length (n : Nat) :
    (canonicalWord n).length = 2 * n := by
  induction n with
  | zero =>
    rfl
  | succ n h =>
    simp [canonicalWord, repeatSymbol_length]
    omega


-- For a prefix of n a's, number of a's is n
theorem countA_repeat_a (n : Nat) :
    countA (repeatSymbol Alphabet.a n) = n := by
  induction n with
  | zero =>
    rfl
  | succ n h =>
    simp [repeatSymbol, countA]
    exact h


-- For a suffix of n b's, number of a's is zero
theorem countA_repeat_b (n : Nat) :
    countA (repeatSymbol Alphabet.b n) = 0 := by
  induction n with
  | zero =>
    rfl
  | succ n h =>
    simp [repeatSymbol, countA]
    exact h


-- For a prefix of n a's, number of b's is 0
theorem countB_repeat_a (n : Nat) :
    countB (repeatSymbol Alphabet.a n) = 0 := by
  induction n with
  | zero =>
    rfl
  | succ n h =>
    simp [repeatSymbol, countB]
    exact h


-- For a suffix of n b's, number of b's is n
theorem countB_repeat_b (n : Nat) :
    countB (repeatSymbol Alphabet.b n) = n := by
  induction n with
  | zero =>
    rfl
  | succ n h =>
    simp [repeatSymbol, countB]
    exact h


theorem countA_append (x y : Word) :
    countA (x ++ y) = countA x + countA y := by
  induction x with
  | nil =>
    simp
    rfl
  | cons symbol rest h =>
    cases symbol with
    | a =>
      simp [countA]
      omega
    | b =>
      simp [countA]
      omega


theorem countB_append (x y : Word) :
    countB (x ++ y) = countB x + countB y := by
  induction x with
  | nil =>
    simp
    rfl
  | cons symbol rest h =>
    cases symbol with
    | a =>
      simp [countB]
      omega
    | b =>
      simp [countB]
      omega


-- Canonical words have n a's
theorem canonicalWord_countA (n : Nat) :
    countA (canonicalWord n) = n := by
  induction n with
  | zero =>
    rfl
  | succ n h =>
    simp [canonicalWord, countA_append, countA_repeat_a, countA_repeat_b]


-- Canonical words have n b's
theorem canonicalWord_countB (n : Nat) :
    countB (canonicalWord n) = n := by
  induction n with
  | zero =>
    rfl
  | succ n h =>
    simp [canonicalWord, countB_append, countB_repeat_b, countB_repeat_a]


-- Word made of all a's satisfies ordering condition
theorem allAsBeforeBs_repeat_a (n : Nat) :
    allAsBeforeBs (repeatSymbol Alphabet.a n) = true := by
  induction n with
  | zero =>
    rfl
  | succ n h =>
    simp [repeatSymbol, allAsBeforeBs]
    exact h


-- Word made of all b's does not contain an a
theorem containsA_repeat_b (n : Nat) :
    containsA (repeatSymbol Alphabet.b n) = false := by
  induction n with
  | zero =>
    rfl
  | succ n h =>
    simp [repeatSymbol, containsA]
    exact h


-- Word made of all b's satisfies ordering condition
theorem allAsBeforeBs_repeat_b (n : Nat) :
    allAsBeforeBs (repeatSymbol Alphabet.b n) = true := by
  induction n with
  | zero =>
    rfl
  | succ n h =>
    simp [repeatSymbol, allAsBeforeBs, containsA_repeat_b]

-- Word of n a's followed by n b's satisfies ordering condition
theorem allAsBeforeBs_append_repeat_b (n m : Nat) :
    allAsBeforeBs (repeatSymbol Alphabet.a n ++ repeatSymbol Alphabet.b m) = true := by
  induction n with
  | zero =>
    simp [repeatSymbol, allAsBeforeBs_repeat_b]
  | succ n h =>
    simp [repeatSymbol, allAsBeforeBs]
    exact h


-- A canonical word has all a's before b's
theorem allAsBeforeBs_canonicalWord (n : Nat) :
    allAsBeforeBs (canonicalWord n) = true := by
  simp [canonicalWord, allAsBeforeBs_append_repeat_b]


-- A canonical word is part of the language L
theorem canonicalWord_in_language (n : Nat) :
    isInLanguage (canonicalWord n) = true := by
  simp [isInLanguage, countsMatch, canonicalWord_countA, canonicalWord_countB, allAsBeforeBs_canonicalWord]


-- Ordering condition satisfied when removing an a from the start of the word
theorem allAsBeforeBs_cons_a (rest : Word) :
    allAsBeforeBs (Alphabet.a :: rest) = true -> allAsBeforeBs rest = true := by
  simp [allAsBeforeBs]


-- If neither x nor y contains a, x ++ y doesn't either
theorem containsA_append_false (x y : Word)
    (hx : containsA x = false)
    (hy : containsA y = false) :
    containsA (x ++ y) = false := by
  induction x with
  | nil =>
    exact hy
  | cons symbol rest h =>
    cases symbol with
    | a =>
      simp [containsA] at hx
    | b =>
      simp [containsA] at hx
      simp [containsA, h hx]


-- If a word has correct ordering, once a b appears, no a can appear later
theorem allAsBeforeBs_append (x y : Word)
    (hx : allAsBeforeBs x = true)
    (hy : allAsBeforeBs y = true)
    (hxy : containsA y = false) :
    allAsBeforeBs (x ++ y) = true := by
  induction x with
  | nil =>
    simpa using hy
  | cons symbol rest h =>
    cases symbol with
    | a =>
      simp [allAsBeforeBs] at *
      exact h (by assumption)
    | b =>
      simp [allAsBeforeBs] at hx
      have hrest : containsA (rest ++ y) = false := by
        simp [containsA_append_false rest y hx hxy]
      simp [allAsBeforeBs, hrest]


theorem no_a_means_all_b (word : Word)
    (h : containsA word = false) :
    ∃ m : Nat, word = repeatSymbol Alphabet.b m := by
  induction word with
  | nil =>
    exact ⟨0, rfl⟩
  | cons symbol rest h1 =>
    cases symbol with
    | a =>
      simp [containsA] at h
    | b =>
      simp [containsA] at h
      obtain ⟨m, hm⟩ := h1 h
      refine ⟨m + 1, ?_⟩
      simp [repeatSymbol, hm]


-- A word satisfying the ordering condition can be split into a block of a's followed by a block of b's
theorem ordered_word_blocks (word : Word) :
    allAsBeforeBs word = true ->
    ∃ n m : Nat, word = repeatSymbol Alphabet.a n ++ repeatSymbol Alphabet.b m := by
  induction word with
  | nil =>
    intro h
    exact ⟨0, 0, rfl⟩
  | cons symbol rest h =>
    cases symbol with
    | a =>
      intro h1
      simp [allAsBeforeBs] at h1
      obtain ⟨n, m, hm⟩ := h h1
      refine ⟨n + 1, m, ?_⟩
      simp [repeatSymbol, hm]
    | b =>
      intro h1
      simp [allAsBeforeBs] at h1
      obtain ⟨m, hm⟩ := no_a_means_all_b rest h1
      refine ⟨0, m + 1, ?_⟩
      simp [repeatSymbol, hm]


-- An ordered word of equal counts is canonical
theorem ordered_equal_counts_implies_canonical (word : Word)
    (h1 : allAsBeforeBs word = true)
    (h2 : countA word = countB word) :
    ∃ n : Nat, word = canonicalWord n := by
  obtain ⟨n, m, hWord⟩ := ordered_word_blocks word h1
  refine ⟨n, ?_⟩
  have hCounts : n = m := by
    rw [hWord, countA_append, countB_append, countA_repeat_a, countA_repeat_b, countB_repeat_a, countB_repeat_b] at h2
    omega
  subst m
  rw[hWord]
  rfl


-- Every accepted word is canonical
theorem accepted_word_is_canonical (word : Word)
    (h : isInLanguage word = true) :
    ∃ n : Nat, word = canonicalWord n := by
  apply ordered_equal_counts_implies_canonical
  exact accepted_words_correct_order word h
  exact accepted_words_eq_counts word h


-- Proves the recognizer is correct; accepts a word only if it has the form a^n b^n
theorem recognizer_correct (word : Word) :
    isInLanguage word = true ↔
    ∃ n : Nat, word = canonicalWord n := by
  constructor
  exact accepted_word_is_canonical word
  intro h
  obtain ⟨n, hn⟩ := h
  rw [hn]
  exact canonicalWord_in_language n

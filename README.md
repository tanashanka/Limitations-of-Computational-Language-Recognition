# Limitations of Computational Language Recognition

## Overview
**For a full analysis of the project, go to ``report.md``**

This project explores the language

$L=\left\lbrace a^n b^n \;|\;n\ge 0\right\rbrace$

using MATLAB experiments and simulations combined with verification in Lean and formal mathematical proofs. The language $L$ consists of $n$ copies of $a$ followed by $n$ copies of $b$, including the empty string $\epsilon$.

This project investigates the difference between deterministic finite automata (DFAs) and pushdown automata (PDAs), verifies the correctness of a language recognizer, and examines why no DFA can recognize $L$.

## Project Goals

- Implements a recognizer for $L$ using a PDA simulation in MATLAB.
- Simulate a PDA and DFA and compare their behaviors.
- Visualize DFA state transtiions and PDA stack depths across an input.
- Formalize $L$ and prove its correctness in Lean.
- Use mathematical proofs like the pigeonhole principle and the pumping lemma to establish that $L$ is not regular.

## Structure
- ``MATLAB/`` - MATLAB experiments and simulations of the automata
- ``Lean/`` - Lean 4 definitions, lemmas, and proofs
- ``MATLAB/images/`` - Plots generated from MATLAB simulations.
- ``MATLAB/experiments/`` - Initial MATLAB experiments.
- ``README.md`` - Project overview and instructions.
- ``report.md`` - Overall report and analysis of findings, combining simulations, verification, and proof.

## MATLAB Components
The MATLAB portion simulates two types of automata
- ``simulateFA.m`` - Recognizes $R=\left\lbrace a^i b^j \;|\;i,j\ge 0\right\rbrace$, checking that all $a$'s precede all $b$;s. It does not require equal symbol counts.
- ``simulatePDA.m`` - Recognizes $L$ using stack memory: pushing a marker into a stack for every $a$ and removing one for every $b$. It rejects invalid symbol order, invalid symbols, and inputs that leave a non-empty stack.

The interactive simulations are run in ``compareAutomata.mlx``. They produce traces that can be used to visualize state transitions and stack depth for a given input.

## Lean Formalization
The Lean component defines the alphabet, words, symbol-counting functions, ordering condition, and language recognizer. It is found in ``Lean/Basic.lean``

The main correctness theorem establishes that a word is accepted if and only if it has the canonical form $a^nb^n$ for some $n\ge 0$.

Supporting lemmas establish properties of symbol counts, concatenation, ordering, and canonical words. This project also develops mathematical arguments showing that $L$ is not regular and therefore cannot be recognized by a DFA.

## Running the Project

### MATLAB (Interactive)
1. Open the project in MATLAB
2. Navigate to the ``MATLAB/`` directory.
3. Run the relevant scripts to test the recognizers and simulations generating the automata traces.

### Lean (Not Interactive)
1. Install Lean 4 and Lake, typically through [elan](https://github.com/leanprover/elan).
2. Open the ``Lean/`` directory.
3. Build the project using
```bash
lake build
```
A successful build checks the Lean files and their proofs.

### Key Result
The PDA can recognize $L$ because its stack allows it to keep track of arbitrarily many unmatched $a$'s. The DFA simulator recognizes a larger regular language that checks only symbol order. The pigeonhole argument and pumping lemma establish that no finite automaton can recognize $L$ exactly.

### Technologies
- MATLAB
- Lean 4
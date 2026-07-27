---
name: engineering-debugging
description: >
  Use when locating and proving the cause of incorrect, intermittent, or unexpected behavior after the problem has been framed.
---

# Engineering Debugging

Debugging is causal isolation, not a sequence of guesses and patches.

## Lifecycle

> Reproduce → minimize → instrument → rank hypotheses → discriminate with experiments → isolate cause → prove the fix → remove temporary instrumentation.

## Rules

- Preserve the original failure signal.
- Change one explanatory variable at a time.
- Prefer binary search across boundaries.
- Distinguish trigger, contributing condition, and root cause.
- Beware Heisenbugs: instrumentation can alter timing and state.
- Do not patch symptoms before causal evidence exists.

## Proof

A fix is supported when the reproduction fails before, passes after, and fails again when the essential correction is removed or disabled. Verify adjacent behavior.

## Gate

Do not declare root cause without a causal chain from trigger to violated invariant and evidence that competing causes do not explain the same observation.

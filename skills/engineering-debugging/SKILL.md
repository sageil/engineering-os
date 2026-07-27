---
name: engineering-debugging
description: >
  Reduce uncertainty until the smallest causal explanation consistent with all
  observations is found, corrected, and protected against recurrence.
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

## Capability handoff

Do not remain in this capability after its responsibility is complete. Use the
smallest next capability whose activation conditions are satisfied. Preserve the
evidence, assumptions, risks, and unresolved uncertainty produced here.

### Usually entered from

- a bug report or failing behavior
- Incident Response after stabilization
- Engineering Review when a failure hypothesis requires proof

### Usually hands off to

- **Engineering Investigation** when the surrounding system is not understood.
- **Engineering Decision** when multiple credible corrections exist.
- **Engineering Quality** when the root cause is proven and the correction can be implemented.
- **Incident Response** when the defect is actively harming production.
- **Engineering Memory** when the root cause reveals durable knowledge.

At every handoff, identify the next capability, the artifact or evidence being
passed, the unresolved question or required outcome, and any stop condition that
must remain visible. Return to an earlier capability whenever new evidence
invalidates the current path.

---
name: causal-debugging
description: Reproduce and causally isolate observed failures, regressions, intermittent behavior, incorrect outputs, performance anomalies, race conditions, and environment-dependent defects before choosing a correction. Use when a concrete symptom exists and competing causal explanations must be discriminated through experiments. Do not use for general system orientation, solution comparison without a failure, implementation of an already proven correction, or active incidents that still require stabilization.
---

# Causal Debugging

## Contract

Find the smallest causal explanation consistent with every material observation.
Do not patch symptoms or select a correction before the causal gate passes.
Preserve the original failure signal and distinguish observation from interpretation.

Maintain one working state or terminal verdict:

- `unreproduced`: The symptom is reported but not established in a controlled observation.
- `investigating`: A trustworthy failure signal exists and causal discrimination continues; do not stop in this state unless reporting requested progress.
- `cause-established`: The causal gate passes.
- `blocked`: A required environment, signal, input, or authority is unavailable.
- `inconclusive`: Available experiments cannot distinguish the remaining explanations.

Only `cause-established` supports correction design.

## 1. Specify the failure

Record expected behavior, observed behavior, affected invariant, environment, inputs, timing, frequency, scope, and earliest known occurrence.
Separate the failure trigger, contributing conditions, causal mechanism, and downstream effects.
Do not label the most visible failing component as the root cause without a causal chain.

## 2. Establish a reliable signal

Reproduce the symptom with the smallest safe procedure that preserves its defining behavior.
Record exact steps, environment, versions, inputs, outputs, and nondeterministic factors.
Verify that the signal distinguishes failure from success.

If reproduction is unavailable, inspect trustworthy traces and records without presenting them as a controlled reproduction.
Return `unreproduced` when the symptom itself remains unverified.

## 3. Minimize the system

Reduce inputs, components, state, and timing while keeping the failure.
Use boundary isolation and binary search across the execution path.
Remove one factor at a time.
Stop minimizing when further reduction changes the phenomenon being explained.

## 4. Build competing causal models

List only credible explanations.
For each explanation, state:

- mechanism;
- predicted observations;
- observations that would falsify it;
- assumptions;
- cheapest decisive experiment.

Include environment, configuration, state, timing, interaction, and measurement explanations when credible.
Do not generate cosmetic alternatives.

## 5. Run discriminating experiments

Read [experimental-method.md](references/experimental-method.md) for isolation, concurrency, intermittent failures, and observational limits.

Change one explanatory variable at a time when possible.
Use controls and compare against a known-good baseline.
Prefer experiments that separate multiple hypotheses over experiments that merely add more logs.
Record unexpected observations and update the causal models immediately.

Treat instrumentation as an intervention that can alter timing, load, ordering, and state.
Remove or account for observer effects.

## 6. Establish the causal chain

Trace:

`trigger -> mechanism -> violated invariant -> observed failure`

Show evidence for every link.
Demonstrate that the leading cause explains all material observations better than surviving alternatives.
Distinguish root cause from enabling conditions and amplification paths.

Apply `cause-established` only when:

- the failure signal is trustworthy;
- the causal mechanism predicts the observed behavior;
- a controlled intervention changes the outcome as predicted when practical;
- credible alternatives are contradicted, bounded, or materially weaker;
- no unexplained observation invalidates the model.

Do not require philosophical certainty.
Require enough causal evidence to constrain responsible corrections.

## 7. Define correction constraints

After `cause-established`, state what any correction must change, what it must preserve, and which regression evidence must fail before and pass after.
Do not choose among multiple corrections.
Return the causal record with `Routing request: research-before-solution` when correction options remain unresolved.
Do not activate another skill from inside this skill.

## Output

- Failure specification
- Reproduction or observational record
- Competing causal models
- Experiments and results
- Causal chain and remaining uncertainty
- `Debugging verdict: unreproduced | investigating | cause-established | blocked | inconclusive`
- Correction constraints only when the verdict is `cause-established`

## Boundaries

Do not implement a fix.
Do not turn a debugging request into a general repository audit.
Do not manage an active incident before stabilization.
Use `incident-control` first when users, data, money, security, or service availability remain at risk.

## Failure conditions

Fail the skill when guesses become patches, several variables change in one experiment without justification, the original failure signal is lost, logs are mistaken for causation, correlation is called root cause, unexplained evidence is ignored, instrumentation effects are dismissed, or a correction is recommended before `cause-established`.

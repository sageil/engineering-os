---
name: engineering-planning
description: >
  Establish an evidence-backed plan and turn justified decisions into safe,
  ordered, observable, and reversible execution strategies.
  Use when the user requests a plan or when work is ambiguous, cross-cutting,
  high-consequence, unfamiliar, difficult to reverse, affects persistent data,
  public interfaces, infrastructure, deployment, or authorization, or requires
  rollout, migration, rollback, interruption recovery, or cleanup.
  Skip only for routine, local, easily reversible work with no material
  uncertainty.
---

# Engineering Planning

Create a plan that reflects inspected reality and defines a safe journey from the current state to an observable outcome.

Use this lifecycle:

> Outcome → evidence → invariants and unknowns → decision → transition model → execution sequence → validation → rollout → cleanup

## 1. Determine the required planning depth

Use the full workflow when any of these conditions apply:

- the user explicitly requests a plan
- the implementation path has not been verified
- multiple credible approaches exist
- the work crosses components or ownership boundaries
- persistent data, public contracts, infrastructure, deployment, security, or authorization may be affected
- failure would create meaningful cleanup, recovery, or compatibility work
- material assumptions or external dependencies remain unresolved

Use a proportionally smaller plan when the work is local, explicit, reversible, and straightforward to verify.

Do not create planning ceremony for routine changes.

If routine work reveals material uncertainty or consequence, apply the full workflow before continuing.

## 2. Establish the requested outcome

Separate:

- the observable outcome
- the requested mechanism
- constraints
- preserved behavior
- failure conditions
- non-goals

Do not assume the requested mechanism is the strongest solution.

Resolve conflicts between the desired outcome and requested mechanism before implementation.

## 3. Inspect reality

Before selecting an approach, inspect the smallest evidence set needed to determine:

- current behavior
- the component that owns it
- affected callers and interfaces
- existing abstractions and configuration
- dependency and platform constraints
- relevant tests and operational tooling
- generated-file boundaries
- existing rollout or recovery behavior

Classify material conclusions as:

- **Observed:** directly inspected, executed, or measured
- **Derived:** follows from verified evidence
- **Assumed:** plausible but not verified
- **Unknown:** evidence is insufficient

Convert material assumptions into investigation steps whenever practical.

Read the relevant reference before planning specialized work:

- [`references/ambiguity-and-discovery.md`](references/ambiguity-and-discovery.md) when the outcome, mechanism, or scope is unclear
- [`references/cross-cutting-changes.md`](references/cross-cutting-changes.md) when work spans components, interfaces, generated artifacts, or owners
- [`references/data-migrations.md`](references/data-migrations.md) when schemas or persistent data change
- [`references/high-risk-planning.md`](references/high-risk-planning.md) for security, authorization, payments, sensitive data, destructive operations, infrastructure, public API breakage, or difficult rollback

## 4. Define invariants and unknowns

Identify what must remain true during and after the work.

Consider:

- correctness
- authorization and trust boundaries
- data preservation
- caller compatibility
- diagnosable failures
- retry and interruption behavior
- rollback or roll-forward capability
- unchanged unrelated behavior

For each material unknown, state:

1. what is unknown
2. why it matters
3. how it will be checked
4. which decision depends on the result

Do not include uncertainty that cannot change the plan.

## 5. Compare credible approaches

Consider, when relevant:

1. remove or clarify the requirement
2. simplify or delete existing behavior
3. use configuration
4. reuse a repository abstraction
5. use a supported platform or framework feature
6. make a small local change
7. introduce a dependency
8. introduce new infrastructure

Compare only material dimensions:

- correctness
- safety
- simplicity
- compatibility
- maintainability
- observability
- reversibility
- operational cost
- blast radius

Select the least complex approach that satisfies the outcome and preserves the invariants.

State the strongest rejected alternative and why it lost.

Do not invent alternatives merely to satisfy a quota.

## 6. Model the transition

For consequential implementation or rollout work, define:

- current state
- target state
- meaningful intermediate states
- rollout unit
- compatibility window
- observation signals
- success and abort thresholds
- interruption and retry behavior
- rollback limits
- required cleanup

Prefer backward-compatible sequencing, small rollout units, and rehearsed roll-forward or rollback paths.

Do not report success while required transition or cleanup work remains incomplete.

Do not approve rollout until partial deployment, interruption, retry, recovery, observation, and cleanup are addressed.

## 7. Define executable success criteria

Include criteria for:

- expected behavior
- rejected or invalid behavior
- preserved behavior
- failure behavior
- restart or retry behavior when relevant
- concrete verification

Each criterion must distinguish the completed change from the previous state.

Use focused checks that prove the outcome.

Do not rely only on broad commands when a narrower check is required.

## 8. Sequence execution

Prefer this order:

1. verify load-bearing assumptions
2. establish a focused failing check or baseline observation
3. make the smallest coherent implementation change
4. verify immediate behavior
5. update dependent interfaces only when required
6. exercise failure, interruption, and restart paths
7. run broader regression checks
8. inspect the final diff
9. roll out with defined observation and abort conditions
10. complete cleanup and confirm the target state

Combine or omit steps when a smaller plan preserves the same guarantees.

Order work to expose failure early, keep intermediate states coherent, and preserve safe checkpoints.

Do not combine independently risky changes.

## 9. Define scope and stop conditions

State plausible adjacent work that is intentionally excluded.

Stop and re-plan when:

- a load-bearing assumption is false
- repository evidence contradicts the selected explanation
- the ownership boundary differs from the plan
- the change becomes materially broader or riskier
- a public contract changes unexpectedly
- the approach cannot preserve an invariant
- verification cannot prove the intended outcome
- rollback or recovery is not credible
- a new high-consequence risk appears

Do not improvise past a stop condition.

## 10. Present the plan

Use the following visible structure when the user requests a plan or alignment is material:

## Goal

State the observable outcome.

## Current understanding

Summarize verified behavior and inspected evidence.

## Unknowns

List only decision-relevant unknowns, their verification methods, and the decisions they affect.

Omit this section when none remain.

## Invariants

State the important behavior, security, data, compatibility, and operational constraints.

## Approach

State the selected approach and strongest rejected alternative.

## Steps

Provide ordered, outcome-oriented execution steps.

## Success criteria

List concrete checks and observable results.

## Rollout and recovery

Describe intermediate states, observation signals, interruption behavior, and rollback limits when relevant.

## Out of scope

List only plausible adjacent work intentionally excluded.

## Stop conditions

List evidence that would invalidate the plan.

Keep the output proportional to the task.

## 11. Re-plan when reality changes

When new evidence invalidates the plan, state:

- the new fact
- the invalidated assumption or step
- the resulting change to scope, risk, or success criteria
- which completed work remains valid
- the new smallest safe path

A plan is a model of current evidence, not a commitment to outdated assumptions.

Update the visible plan only when user alignment, scope, risk, or success criteria materially change.

## Plan quality gate

Before implementation begins, confirm that the plan:

- reflects inspected reality
- defines the outcome and preserved invariants
- resolves or schedules material unknowns
- selects a justified approach
- defines observable success
- models interruption, recovery, and cleanup when relevant
- constrains scope
- identifies evidence that requires re-planning

If any material item is missing, continue investigating before editing.

## Execution discipline

Once the plan passes:

- follow the sequence unless evidence justifies deviation
- verify assumptions early
- keep changes within scope
- validate at meaningful checkpoints
- preserve reversible states where practical
- stop at defined stop conditions
- report checks truthfully
- inspect the completed diff against the outcome and invariants

Do not mistake adherence to a stale plan for discipline.

## Capability handoff

Do not remain in this capability after the plan is executable.

Preserve the evidence, assumptions, risks, unresolved questions, success criteria, and stop conditions when handing off.

### Usually entered from

- Engineering Investigation
- Engineering Decision
- Architecture and Reliability
- Incident Response for controlled recovery or permanent change

### Usually hands off to

- **Engineering Quality** when implementation can begin
- **Incident Response** when conditions become unstable or user impact becomes active
- **Engineering Communication** when coordination or approval is required
- **Engineering Investigation** when new unknowns invalidate the plan

Return to an earlier capability whenever new evidence invalidates the current path.

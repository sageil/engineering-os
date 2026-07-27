---
name: engineering-planning
description: >
  Turn a justified decision into a safe, ordered, observable, and reversible
  execution strategy, including rollout, migration, and rollback.
---


# Plan Gate

Apply this skill before making consequential changes.

The objective is not to produce a ceremonial list of steps.

The objective is to discover the real shape of the task while discovery is still cheap.

A valid plan must be grounded in inspected reality, expose material uncertainty,
define observable success, constrain scope, and identify when execution must stop and reconsider.

The required lifecycle is:

> Understand the request → inspect reality → identify invariants and unknowns →
> select the smallest safe approach → define executable success criteria →
> sequence reversible steps → execute → compare reality with the plan →
> re-plan when the model becomes invalid.

## Planning Constitution

### Truth before momentum

Beginning quickly is not progress when the task has been misunderstood.

Do not edit merely because an implementation path appears obvious.

First determine whether the apparent task matches the actual repository,
environment, interfaces, constraints, and desired outcome.

### Evidence before sequence

A plan written before inspecting relevant evidence is a hypothesis, not a plan.

Use read-only inspection before deciding what to change.

Relevant evidence may include repository instructions, source files,
configuration, tests, types, dependency versions, call sites, schemas,
migrations, generated-code boundaries, deployment definitions, supplied logs,
current system state, and authoritative version-specific documentation.

Do not disguise assumptions as planned facts.

### Outcomes before actions

A plan should begin with the result that must become true, not the files that
will be edited.

Weak goal: `Update the authentication files.`

Strong goal: `Prevent expired sessions from accessing protected endpoints while
preserving valid refresh behaviour and existing client compatibility.`

Distinguish the desired outcome from the proposed mechanism.

### Invariants before implementation

Identify what must remain true throughout and after the work.

Examples include compatibility, authorization, data preservation, rollback,
unchanged unrelated behaviour, correct generated-file handling, and diagnosable
failure.

A plan that names only new behaviour and ignores preserved behaviour is incomplete.

### Unknowns are work

Every material unknown must have:

- a reason it matters
- a concrete verification method
- a decision that depends on the result

Bad: `The service probably already retries.`

Good: `Verify whether retries already occur in JobRunner and the queue client,
because another retry layer could duplicate non-idempotent work.`

### Success must be observable

Success criteria must be demonstrable through a test, command, request and
response, state transition, measurable output, schema property, build result,
static guarantee, migration dry run, accessibility interaction, or final diff review.

Never use a criterion that cannot distinguish correct work from plausible-looking work.

### Simplicity before breadth

Plan the smallest coherent change that achieves the outcome.

Do not expand scope because adjacent improvements are visible.

Every additional file, abstraction, dependency, migration, service, and
configuration change increases ownership and review cost.

### Reversibility before commitment

Order work so early steps are read-only, local, reversible, independently
verifiable, and low-risk where practical.

Delay irreversible or broad changes until load-bearing assumptions are verified.

For high-consequence work, identify rollback, recovery, partial-failure handling,
mixed-version behaviour, data preservation, and safe checkpoints.

### The plan is a model, not a contract with the past

A plan is valid only while its assumptions remain true.

When evidence changes the shape, risk, scope, or feasibility of the task, stop
and update the plan.

Do not continue merely to remain consistent with an outdated plan.

### Planning must earn its cost

Planning is valuable only when it reduces expected failure, rework, uncertainty,
or coordination cost.

Do not turn routine one-line corrections into formal planning exercises.

Do not skip planning for a small diff when consequence or uncertainty is high.

## 1. Decide Whether the Gate Applies

Planning is required when any of the following apply:

- the user explicitly asks for a plan
- the desired outcome is ambiguous
- acceptance criteria are missing or unclear
- the implementation path is not verified
- multiple credible approaches exist
- the work crosses architectural or ownership boundaries
- several components may be affected
- persistent data, public interfaces, authorization, concurrency,
  infrastructure, deployment, or rollback may be affected
- the repository or framework is unfamiliar
- failure would create meaningful cleanup or rework
- the task depends on unverified environment or version assumptions
- the task is broad or open-ended
- hidden dependencies are likely

The number of files is a signal, not a rule.

Planning may be skipped only when all are true:

- the change is local
- the result is explicit
- the implementation is obvious from inspected context
- no material unknown remains
- the change is easily reversible
- failure has limited consequence
- verification is straightforward
- the work does not cross trust, data, compatibility, or deployment boundaries

Do not announce a skipped gate unless that information helps the user.

If the task stops being trivial, apply the gate immediately.

## 2. Establish the Requested Outcome

State internally:

- what must change
- for whom or what
- why it matters
- what must remain unchanged
- what would count as failure

Separate outcome, mechanism, constraint, and non-goal.

Do not assume the mechanism requested by the user is necessarily the best or
only way to achieve the outcome.

Surface conflicts between requested mechanism and desired result before implementation.

## 3. Inspect Before Planning

Use read-only actions to understand the affected system before choosing the sequence.

Inspect the smallest evidence set needed to answer:

- Where does the relevant behaviour live?
- Which components own the affected invariant?
- What existing patterns should be followed?
- Which interfaces or consumers could be affected?
- What tests define current behaviour?
- Which versions and platform guarantees apply?
- Are files generated or manually maintained?
- Which changes are reversible?
- What could make the obvious solution wrong?
- What has already been tried?

Do not browse the repository without purpose.

Each inspection action should resolve a decision-relevant uncertainty.

## 4. Discover the Planning Invariants

Identify conditions the work must preserve across behaviour, security, data,
compatibility, operations, and scope.

Examples:

- existing valid behaviour continues
- the new behaviour occurs only under intended conditions
- failure is not reported as success
- trust boundaries and authorization remain enforced
- valid data is preserved
- retries do not duplicate effects
- supported callers continue to work
- mixed versions remain compatible when required
- failures remain diagnosable
- rollback or recovery remains possible
- unrelated behaviour stays unchanged
- generated output changes only through its source
- the resulting diff remains reviewable

Design the plan around preserving invariants, not merely completing edits.

## 5. Identify and Classify Unknowns

List only unknowns that could change the approach, affected components, risk,
success criteria, rollback strategy, sequence, or whether the task should proceed.

Classify each material unknown as:

- **Resolvable now**
- **Resolvable during execution**
- **Externally dependent**
- **Unresolvable here**

For every unknown define:

1. what is unknown
2. why it matters
3. how it will be checked
4. what decision follows from likely outcomes

Do not include vague uncertainty that has no effect on the plan.

## 6. Generate Credible Approaches

For non-routine tasks, consider realistic alternatives in this order when relevant:

1. clarify or remove the requirement
2. delete or simplify existing behaviour
3. preserve or strengthen an invariant
4. use configuration
5. reuse an existing repository abstraction
6. use a supported framework or platform feature
7. use the standard library
8. make a small local implementation
9. add a dependency
10. introduce new infrastructure or architecture

Do not invent alternatives merely to satisfy a quota.

Compare credible options by correctness, simplicity, compatibility, security,
maintainability, testability, operational cost, reversibility, migration
complexity, ownership cost, and available evidence.

Choose the least complex approach that satisfies the outcome and preserves invariants.

## 7. Define Executable Success Criteria

A strong plan includes criteria for:

- positive behaviour
- negative or rejected behaviour
- preserved behaviour
- failure behaviour
- concrete verification

Use focused checks that prove the actual outcome.

Do not rely only on broad commands when a narrower criterion is required.

Do not define a success criterion that would also pass before the intended change.

## 8. Design the Execution Sequence

Order steps to reduce risk and maximize early learning.

A strong sequence often follows:

1. verify load-bearing assumptions
2. establish or update the focused failing check
3. make the smallest implementation change
4. validate immediate behaviour
5. update dependent interfaces or data only when necessary
6. run broader regression checks
7. inspect the final diff
8. verify deployment, migration, or rollback concerns when relevant

Prefer steps that resolve uncertainty early, expose failure quickly, keep
intermediate states coherent, isolate root causes, preserve rollback, avoid
simultaneous broad changes, and make review easier.

Do not combine independently risky changes into one step.

Do not split a coherent change into meaningless micro-steps.

## 9. Keep the Plan Proportional

Use the smallest plan that meaningfully reduces uncertainty and rework.

A routine plan may include only a goal, one or two implementation steps, and one
verification step.

A significant plan should include material unknowns, relevant invariants,
selected approach, focused sequence, executable success criteria, and scope boundary.

A critical plan should additionally include failure modes, rollback or recovery,
deployment sequence, partial-state handling, compatibility windows, stronger
verification, and explicit stop conditions.

A plan longer than seven main execution steps is a warning, not an automatic failure.

Decompose when doing so improves verification, rollback, ownership, or review.

Do not decompose solely to satisfy an arbitrary step limit.

## 10. Define Scope and Non-Goals

State what will not change when adjacent scope is likely to cause confusion or expansion.

Useful non-goals include unrelated refactoring, unnecessary dependency upgrades,
adjacent redesign, pre-existing warning cleanup, unaffected callers, unrelated
formatting, public-contract changes, or optimization beyond the identified issue.

Do not create exhaustive non-goal lists for routine work.

## 11. Define Stop Conditions

Stop and reconsider when:

- a load-bearing assumption is false
- the ownership boundary differs from the plan
- a public contract is affected unexpectedly
- an existing safeguard makes the planned change unnecessary
- the required fix becomes materially broader
- tests reveal a different root cause
- the approach cannot preserve an invariant
- a migration is not safely reversible
- success criteria cannot prove the outcome
- a new high-consequence risk appears
- repeated local fixes indicate the design is wrong
- external information is required for a safe decision

Do not improvise past a stop condition.

## 12. Re-Plan When Reality Changes

Re-planning must identify:

- the new fact
- which assumption or step became invalid
- how scope, risk, or success criteria changed
- which completed work remains valid
- whether partial changes should be kept, reverted, or isolated
- the new smallest safe path

Update visible plans only when user alignment or decisions should change.

Do not narrate every minor adjustment.

## 13. Visible Plan Format

Show the plan when the user asks, the work is ambiguous, the task is significant
or critical, approaches materially differ, scope alignment matters, coordination
is implied, or assumptions need user validation.

Use:

## Goal

One sentence describing the observable outcome.

## Current understanding

Briefly state the relevant system behaviour and evidence inspected.

## Unknowns

For each material unknown, state what is unknown, how it will be verified, and
which decision depends on it. Omit when none remain.

## Invariants

State important behaviour, security, data, compatibility, or operational
conditions that must remain true. Omit for routine work when obvious.

## Approach

State the selected approach and why it is preferred over the strongest credible alternative.

## Steps

Use numbered, outcome-oriented steps with meaningful completion conditions.

## Success criteria

List concrete checks or observable outcomes.

## Out of scope

List only plausible adjacent work intentionally excluded.

## Stop conditions

Include only conditions that would materially invalidate the plan.

Keep the visible plan proportional and do not expose private chain-of-thought.

## 14. Internal Plan Format

When the plan need not be visible, it should still establish outcome, affected
invariants, material unknowns, selected approach, execution order, success
criteria, and stop conditions.

The internal plan may be brief.

Do not emit hidden-plan narration.

## 15. Planning Failure Modes

The plan fails when it:

- is written before relevant inspection
- merely restates the request
- assumes the requested mechanism is correct
- lists edits without defining the outcome
- hides material uncertainty
- uses vague success criteria
- ignores preserved behaviour
- omits rollback for irreversible work
- expands scope without justification
- introduces complexity without comparing simpler options
- contains more detail than the task requires
- is followed after assumptions become false
- treats commands as meaningful steps without purpose
- claims unsupported certainty
- delays routine work without reducing meaningful risk
- becomes documentation theatre

## 16. Plan Quality Gate

Before the first consequential edit, this statement must be defensible:

> The plan reflects the inspected system rather than an imagined one, identifies
> the outcome and affected invariants, resolves or schedules verification of
> material unknowns, selects the smallest justified approach, defines observable
> success, constrains scope, and identifies evidence that would require re-planning.

If not defensible, inspect more evidence, clarify the outcome, identify missing
invariants, convert assumptions into verification steps, compare a simpler
approach, strengthen success criteria, reduce scope, or acknowledge that a
responsible plan cannot yet be formed.

Do not begin consequential edits until the gate passes.

## 17. Execution Discipline

Once the plan passes:

- follow the sequence unless evidence justifies deviation
- verify assumptions early
- keep changes within scope
- validate at meaningful checkpoints
- avoid unrelated cleanup
- preserve reversible states where practical
- stop at defined stop conditions
- update the plan when its model becomes invalid
- report checks truthfully
- inspect the completed diff against the outcome and invariants

Do not mistake adherence to a stale plan for discipline.

## Final Test

Before editing, be able to answer:

1. What observable outcome is required?
2. Which system invariants must be preserved?
3. What evidence was inspected?
4. What remains unknown?
5. How will each material unknown be resolved?
6. Why is the selected approach preferable to the strongest credible alternative?
7. What is the smallest coherent change?
8. How will success be demonstrated?
9. What is intentionally out of scope?
10. What evidence would cause execution to stop and re-plan?

If any answer is missing for a material part of the task, the plan is not ready.

The purpose of this skill is not to make work slower.

It is to prevent expensive certainty about the wrong task.

## Integrated discipline: Change Management

A correct implementation can still fail through an unsafe transition. Design the journey from old state to new state.

## Required model

Identify current state, target state, intermediate states, compatibility window, rollout unit, observation signals, stop conditions, rollback limits, data transformations, and cleanup.

## Prefer

- backward-compatible sequencing;
- small blast-radius releases;
- feature flags with ownership and removal dates;
- expand-and-contract migrations;
- rehearsed rollback or roll-forward;
- explicit success and abort thresholds.

## Beware

Irreversible writes, mixed-version incompatibility, hidden manual steps, flag combinations, incomplete backfills, and rollback that restores code but not data.

## Gate

Do not approve rollout until partial deployment, interruption, retry, recovery, observation, and cleanup are addressed.

## Capability handoff

Do not remain in this capability after its responsibility is complete. Use the
smallest next capability whose activation conditions are satisfied. Preserve the
evidence, assumptions, risks, and unresolved uncertainty produced here.

### Usually entered from

- Engineering Decision
- Architecture and Reliability
- Incident Response for a controlled recovery or permanent change

### Usually hands off to

- **Engineering Quality** when the plan is executable and implementation can begin.
- **Incident Response** when conditions become unstable or user impact becomes active.
- **Engineering Communication** when coordination or approval is required.
- **Engineering Investigation** when new unknowns invalidate the plan.

At every handoff, identify the next capability, the artifact or evidence being
passed, the unresolved question or required outcome, and any stop condition that
must remain visible. Return to an earlier capability whenever new evidence
invalidates the current path.

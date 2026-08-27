---
name: story-splitting
description: >-
  Split a broad requirement, epic, feature, initiative, or backlog item into small
  end-to-end child stories. Use only when the user requests product or backlog
  decomposition, a walking skeleton, an MVP sequence, vertical slices, or the first
  independently valuable increment. Do not use for implementation planning, technical
  task breakdown or routine coding. When unresolved product rules would materially
  change the split, use this skill only to identify the smallest required definition.
---

# Story Splitting

## Contract

Produce small whole outcomes that can be built, tested, demonstrated, and reconsidered independently.
Do not split work by technical layer, discipline, or delivery activity.

Maintain one verdict:

- `split-ready`
- `needs-definition`
- `blocked`

## 1. Establish the parent outcome

Identify:

- the actor or external system that receives value;
- the capability or learning outcome;
- why the outcome matters;
- the source artifact and decision owner;
- release, safety, compliance, and compatibility constraints;
- the target planning horizon for one child story.

Reframe a solution phrase into the user or operator capability it serves.
Keep a technical item as a task when no independently valuable outcome exists.

If an unresolved rule, actor, or success condition could materially change the split, return `needs-definition` with the smallest decision needed.
Do not invent the answer.

## 2. Surface examples and variation

Read the authoritative requirement and related accepted examples before proposing slices.
Identify only variation that can change value, safety, independence, or ordering:

- happy, alternate, and failure paths;
- actors, roles, and customer segments;
- data shapes, sizes, and boundaries;
- business and permission rules;
- channels, devices, and integrations;
- performance, reliability, security, accessibility, and audit needs;
- unknowns that could invalidate a slice.

Use concrete precondition, trigger, and observable-outcome examples.

## 3. Generate vertical split candidates

Consider these dimensions:

| Dimension | Question |
| --- | --- |
| Capability | What narrower capability still produces value? |
| Path | Which complete workflow path can stand alone? |
| Actor | Which role or segment can receive value first? |
| Data | Which honest data subset can be supported first? |
| Rule | Which rules can be deferred without unsafe behavior? |
| Interface | Which channel can prove the outcome first? |
| Quality | What lower but acceptable service level can ship safely? |
| Learning | What end-to-end experiment resolves the largest material risk? |

Every candidate must cross the technical layers required for its outcome.
Database, service, API, UI, testing, and deployment work can be tasks inside one child story.
They are not separate child stories unless each produces an independent external outcome.

## 4. Select the first slice

Prefer the candidate that:

1. produces the highest user, operator, business, or validated-learning value;
2. can be completed, verified, and demonstrated independently;
3. reduces a material integration or product risk early;
4. preserves the option to reorder, remove, or change later slices;
5. does not defer a safety, authorization, integrity, or compatibility requirement that must hold from the first release.

Development cost can break a tie but must not override safety, correctness, or meaningful value.

## 5. Validate every child story

Require each child story to state:

- actor and observable outcome;
- value or learning produced;
- included scope;
- intentional deferrals;
- concrete acceptance examples;
- release constraint;
- dependencies and follow-up stories.

Reject a child story when:

- it is only design, code, test, documentation, data, API, or UI work;
- every sibling must finish before it can be verified;
- it delivers no user, operator, business, or learning outcome;
- it hides an unsafe deferral;
- it prescribes an unnecessary implementation mechanism;
- acceptance wording is not observable.

## 6. Apply the verdict gate

Set `split-ready` only when the parent outcome and constraints are established, every child story passes the validation gate, the first slice is selected, and no unresolved product decision can materially change the split.
Set `needs-definition` when a specific unresolved product decision can materially change the split and an accountable owner or authoritative source can resolve it.
Set `blocked` when the authoritative parent outcome, governing constraints, or decision authority is unavailable and no responsible split or resolvable definition request can be produced.

## Output

For `split-ready`, report:

1. reframed parent outcome;
2. recommended first slice and why it wins;
3. child-story table with value, scope, deferrals, acceptance examples, release constraint, and dependencies;
4. technical tasks that remain inside each story;
5. parked decisions and owners;
6. `Story-splitting verdict: split-ready`.

For `needs-definition`, report only the established parent context, the smallest decision that can materially change the split, its accountable owner or authoritative source, and `Story-splitting verdict: needs-definition`.
Do not recommend a first slice or child-story table before that decision is resolved.

For `blocked`, report only the unavailable authoritative input or decision authority, the smallest condition needed to resume, and `Story-splitting verdict: blocked`.
Do not invent a parent outcome, first slice, or child-story table.

## Boundaries

Do not create an implementation plan or pull request sequence.
Do not select architecture or dependencies.
Do not convert every edge case into a separate story.
Do not use a spike unless it answers a named uncertainty and produces a decision.

## Failure conditions

Fail when the split is horizontal, product rules are invented, the first slice cannot be independently verified, safety is deferred without authority, tasks are relabeled as outcomes, or later required capability disappears from the parking list.

---
name: execution-planning
description: Create a safe transition plan for a selected solution when execution has material intermediate-state, migration, rollback, recovery, or coordination risks.
---

# Execution Planning

## Contract

Plan the transition from a verified current state to an approved target state.
The selected solution is an input contract, not a suggestion to reinterpret.

Do not reopen solution selection unless new evidence invalidates or materially changes the chosen option.
Do not implement while planning.

Maintain one verdict:
- `executable`
- `input-incomplete`
- `research-required`
- `authority-required`
- `no-plan-needed`
- `unsafe`

## 1. Lock the selected-solution contract

Require and restate:
- selected mechanism and decision owner;
- current owner and intended target owner;
- evidence-backed current state;
- target state and observable outcome;
- hard constraints and invariants;
- required capabilities and external contracts;
- acceptance and failure criteria;
- known risks and explicitly non-material assumptions;
- execution owners, approvals, and coordination points.

Return `input-incomplete` rather than reconstructing a missing decision from memory.

The plan may sequence, stage, verify, observe, roll out, contain, recover, and clean up the selected solution.
It may **not** quietly change:
- architecture or mechanism;
- source of truth;
- durable ownership;
- trust boundary;
- public compatibility model;
- required external capability; or
- fundamental consistency model.

If planning discovers evidence that requires changing any of those, stop and return:
`Planning verdict: research-required`

Do not hide unresolved design work as a plan task.

## 2. Choose planning depth

Return `no-plan-needed` for routine, local, reversible work with an explicit outcome and focused verification.
Use a concise transition model when one material hazard is bounded.
Use a full transition model for persistent state, security, infrastructure, public contracts, distributed work, difficult rollback, or coordinated rollout.

Do not equate diff size with consequence.

## 3. Model the transition

Read [transition-model.md](references/transition-model.md).

Define:
- current state;
- target state;
- meaningful intermediate states;
- transition owner and execution unit;
- compatibility window;
- observation signals;
- success and abort thresholds;
- interruption and retry behavior;
- rollback and roll-forward limits;
- cleanup and decommissioning.

Represent persistent workflows as explicit state transitions with invariants.
Do not hide partial completion in prose.

## 4. Test planning assumptions before sequencing

For every load-bearing prerequisite, classify:
- `verified-before-execution`;
- `execution-precondition`;
- `authority-precondition`;
- `research-required`.

A prerequisite belongs in `research-required` when its answer could change the selected mechanism, ownership, architecture, compatibility strategy, or viability.

Do not convert research into an execution step merely to keep planning moving.

## 5. Sequence work

Order steps to expose failure early and keep every intermediate state coherent:

1. Verify load-bearing execution prerequisites.
2. Establish baseline or focused failing evidence.
3. Add compatibility or observability required for safe transition.
4. Make the smallest coherent implementation unit.
5. Verify immediate behavior and preserved invariants.
6. Advance rollout in bounded units.
7. Exercise failure, interruption, retry, and recovery paths.
8. Complete cleanup and remove temporary compatibility machinery.
9. Verify target state and absence of stranded work.

Omit irrelevant steps.

## 6. Define every step as an executable contract

For each step, state:
- intended state change;
- owner or actor;
- prerequisites;
- exact artifact or surface;
- expected observation;
- focused verification;
- failure signal;
- abort or recovery action;
- safe checkpoint produced.

Avoid vague steps such as "update code", "test thoroughly", "monitor", or "deploy carefully".

## 7. Plan verification

Map each acceptance criterion and invariant to evidence.
Include expected, rejected, preserved, failure, interruption, restart, and retry behavior when relevant.
Use the narrowest check that directly exercises the claim.

## 8. Plan rollout and recovery

Define rollout unit, observation window, thresholds, decision owner, and escalation path.
Prefer backward-compatible sequencing, bounded blast radius, idempotent operations, and rehearsed recovery.

State when rollback is unsafe because persistent or external effects cannot be reversed.
Provide roll-forward, containment, or compensating action instead of promising impossible rollback.

## 9. Apply the execution gate

Set `executable` only when:
- the selected-solution contract remains unchanged by planning;
- every step preserves required invariants;
- intermediate states are valid and observable;
- partial execution and restart behavior are defined;
- verification distinguishes success from current state;
- required owners and approvals are identified;
- recovery is credible;
- cleanup has an owner and completion signal;
- no material design unknown is disguised as an execution task.

Set `input-incomplete` when a required selected-solution input is missing and the missing input is not only execution authority.
Set `research-required` when evidence could change the selected mechanism, ownership, architecture, compatibility strategy, or viability.
Set `authority-required` when the transition could be planned responsibly but authority to define or approve the plan itself is absent.
Treat approval to execute a completed plan as an execution precondition, not as planning authority.
Set `unsafe` when no credible sequence can preserve the required invariants or provide bounded containment or recovery.
Set `no-plan-needed` only for routine, local, reversible work that has no material transition hazard.

## Output

- Selected-solution contract
- Planning assumptions and their classification
- Transition model
- Ordered executable steps
- Verification matrix
- Rollout, abort, and recovery controls
- Cleanup and target-state confirmation
- `Planning verdict: executable | input-incomplete | research-required | authority-required | no-plan-needed | unsafe`

## Boundaries

Do not compare alternative solutions.
Do not perform implementation.
Do not invent execution authority.
Do not treat `executable` as authorization to execute.
Do not require a plan artifact for trivial change.

## Failure conditions

Fail when the skill plans an unselected option, changes the selected mechanism without a new research decision, hides design unknowns as tasks, leaves intermediate states undefined, promises impossible rollback, omits cleanup, ignores mixed versions or interruption, or uses verification that cannot distinguish success.

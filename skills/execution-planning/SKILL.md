---
name: execution-planning
description: Create a transition strategy for a selected, evidence-backed solution only when the user requests a plan and execution still contains a material transition hazard such as unsafe intermediate states, persistent data mutation, incompatible versions, coordinated systems or owners, irreversible effects, bounded rollout, interruption, rollback, or recovery. Do not trigger for ordinary implementation, multi-file work, building an image, running tests, starting containers, deploying through an established procedure, executing an approved plan, or substituting planning for missing authority.
---

# Execution Planning

## Contract

Plan the transition from a verified current state to an approved target state.
Do not reopen solution selection unless new evidence invalidates the chosen option.
Do not implement while planning.

Maintain one verdict:

- `executable`: The plan can be performed and verified safely with stated authority.
- `input-incomplete`: The selected option, current state, target state, or acceptance criteria are missing.
- `research-required`: New evidence invalidates or materially changes the selected option.
- `authority-required`: Execution needs permission, ownership, or coordination not yet established.
- `unsafe`: No credible transition, recovery, or data-preserving path is available.

## 1. Verify planning inputs

Require:

- selected option and decision owner;
- evidence-backed current state;
- target state and observable outcome;
- invariants and compatibility commitments;
- acceptance and failure criteria;
- known risks, assumptions, and constraints;
- authorized execution scope.

Return `input-incomplete` rather than reconstructing a missing decision from memory.
Return `research-required` when new evidence could change the chosen option.

## 2. Choose planning depth

Skip a formal plan for routine, local, reversible work with an explicit outcome and focused verification.
Use a concise plan for multi-file but low-risk changes.
Use the full transition model for persistent state, security, infrastructure, public contracts, distributed work, difficult rollback, or coordinated rollout.

Do not equate diff size with consequence.

## 3. Model the transition

Read [transition-model.md](references/transition-model.md) for migrations, deployments, interruption, retry, and recovery.

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

## 4. Sequence work

Order steps to expose failure early and keep every intermediate state coherent.
Prefer:

1. Verify load-bearing prerequisites.
2. Establish a baseline or focused failing check.
3. Add compatibility or observability needed for safe transition.
4. Make the smallest coherent implementation unit.
5. Verify immediate behavior and preserved invariants.
6. Advance rollout in bounded units.
7. Exercise failure, interruption, retry, and recovery paths.
8. Complete cleanup and remove temporary compatibility machinery.
9. Verify the target state and absence of stranded work.

Omit irrelevant steps rather than producing ceremony.

## 5. Define every step as an executable contract

For each step, state:

- intended state change;
- owner or actor;
- prerequisites;
- exact artifact or surface affected;
- expected observation;
- focused verification;
- failure signal;
- abort or recovery action;
- safe checkpoint produced.

Avoid vague steps such as update code, test thoroughly, monitor, or deploy carefully.

## 6. Plan verification

Map each acceptance criterion and invariant to evidence.
Include expected behavior, rejected behavior, preserved behavior, failure behavior, and restart or retry behavior when relevant.
Use the narrowest check that directly exercises the claim.
Do not use a broad suite as a substitute for a missing focused check.

## 7. Plan rollout and recovery

Define rollout unit, observation window, thresholds, decision owner, and escalation path.
Prefer backward-compatible sequencing, bounded blast radius, idempotent operations, and rehearsed recovery.

State when rollback is unsafe because data or external effects cannot be reversed.
Provide a roll-forward or containment path instead of promising impossible rollback.

## 8. Apply the execution gate

Set `executable` only when:

- every step preserves required invariants;
- intermediate states are valid and observable;
- partial execution and restart behavior are defined;
- verification distinguishes success from the current state;
- required authority and ownership exist;
- recovery is credible;
- cleanup has an owner and completion signal.

Do not declare a plan executable while required work is described as follow-up.

## Output

- Selected option and planning inputs
- Transition model
- Ordered executable steps
- Verification matrix
- Rollout, abort, and recovery controls
- Cleanup and target-state confirmation
- `Planning verdict: executable | input-incomplete | research-required | authority-required | unsafe`

Return the executable plan to the user or orchestrator for authorized execution without activating another skill.

## Boundaries

Do not compare alternative solutions.
Do not perform implementation.
Do not invent execution authority.
Do not require a plan artifact for a trivial change.

## Failure conditions

Fail the skill when it plans an unselected option, hides unknowns as tasks, leaves intermediate states undefined, promises impossible rollback, treats deployment as the final step, omits cleanup, ignores mixed versions or interruption, or uses vague verification that cannot distinguish success.

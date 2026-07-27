---
name: incident-response
description: >
  Protect users and restore safe service under pressure while preserving
  evidence, coordinating action, and controlling operational change.
---


# Incident Response

During an incident, the first obligation is to reduce harm without destroying evidence or creating a larger failure.

## Priorities

1. Protect people, data, money, and security.
2. Establish command, scope, and communication.
3. Stabilize and reduce blast radius with reversible actions.
4. Preserve evidence and timestamps.
5. Form and test hypotheses.
6. Recover service deliberately.
7. Verify recovery and monitor recurrence.
8. Learn without blame.

## Rules

- Do not deploy speculative fixes into an unstable system when safer mitigation exists.
- Record actions and observations separately from interpretations.
- Avoid simultaneous interventions that destroy causal information.
- Distinguish trigger, root cause, and systemic contributors.
- Communicate known facts, uncertainty, impact, ownership, and next update.

## Gate

Every action must state expected benefit, risk, reversibility, verification, and owner. Recovery is not complete until customer impact, data integrity, and monitoring are verified.

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

- active production impact
- security, data, reliability, or availability events

### Usually hands off to

- **Engineering Debugging** when fault isolation can proceed safely.
- **Engineering Decision** when mitigation or recovery alternatives must be selected.
- **Engineering Quality** when a permanent correction is ready.
- **Engineering Communication** when status, handoff, or post-incident communication is required.
- **Engineering Memory** when durable learning should be captured.

At every handoff, identify the next capability, the artifact or evidence being
passed, the unresolved question or required outcome, and any stop condition that
must remain visible. Return to an earlier capability whenever new evidence
invalidates the current path.

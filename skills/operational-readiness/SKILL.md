---
name: operational-readiness
description: Assess whether a defined system, service, release, or critical workflow is ready for sustained operation, degradation, and recovery with named ownership.
---

# Operational Readiness

## Contract

Determine whether the scoped system can deliver required outcomes, expose degradation, contain failure, and recover under named ownership.

Readiness is an evidence-backed operating state, not document completion.

Maintain one verdict:
- `ready`
- `ready-with-accepted-risk`
- `not-ready`
- `insufficient-evidence`
- `not-applicable`

## 1. Establish the readiness decision

Require exact system/release/environment/launch boundary, required outcomes, security/data/compliance/compatibility invariants, health criteria, workload/dependency/data assumptions, rollout/recovery commitments, owners/authority, and available evidence.

Return `insufficient-evidence` when a missing load-bearing input prevents a responsible verdict.
Return `not-applicable` when no meaningful operational boundary exists.

## 2. Build the readiness evidence matrix

Before narrative analysis, enumerate each release-blocking operational requirement and classify its evidence state:

- `proven`: applicable direct evidence supports the requirement in a sufficiently comparable environment;
- `bounded`: evidence supports the requirement within explicit limits that cover launch conditions;
- `accepted-risk`: a nonblocking gap has explicit authorized ownership, containment, observation, review, and expiry;
- `unverified`: a load-bearing requirement lacks sufficient evidence;
- `failed`: evidence shows the requirement is not met;
- `not-applicable`: evidence establishes the requirement does not apply.

The final verdict must be derivable from this matrix.
No prose summary may override an `unverified` or `failed` release-blocking requirement.

## 3. Trace critical journeys

Identify the few user, operator, data, and security journeys whose failure invalidates readiness.
Trace entry points, dependencies, persistence, asynchronous work, configuration, deployment, observability, and recovery.

State expected, degraded, rejected, interrupted, and recovered behavior.

## 4. Inspect operational evidence

Read [readiness-model.md](references/readiness-model.md).

When observability is needed to prove a critical journey, service objective, degradation state, or recovery outcome, read [observability-evidence.md](references/observability-evidence.md).

For each readiness claim, identify:
- requirement/invariant;
- evidence and environment;
- evidence-state classification;
- success/failure signal;
- limitation/untested condition;
- owner/action;
- condition invalidating the evidence.

Prefer observed behavior and exercised recovery over intended configuration or document presence.

## 5. Challenge healthy-path confidence

Inspect applicable dependency partial failure, overload, retry amplification, queue growth, version skew, drift, credential failure, corruption, interrupted rollout, rollback limits, operator error, and observability loss.

Ask whether the system fails safely, distinguishes degradation from success, preserves critical invariants, and gives operators bounded recovery action.

## 6. Evaluate ownership and sustainability

Identify who receives signals, makes rollout/recovery decisions, owns dependencies/capacity, maintains runbooks/access, and completes cleanup.
Treat an unowned critical control, alert, dependency, or recovery step as a readiness gap.

## 7. Calibrate findings

For every finding require requirement/invariant, inspected/missing evidence, reachable condition, consequence, safeguards, blocking status, confidence, owner, correction direction, and closure evidence.

Do not report generic best-practice gaps without material operational consequence.

## 8. Handle accepted risk

Accept nonblocking risk only with decision owner, scope, consequence, containment, observation signal, review condition, and expiry/removal event.

Accepted risk cannot hide a violated critical invariant, unavailable recovery path, or unverified release-blocking requirement.

## 9. Apply the readiness gate

Set `ready` only when every release-blocking matrix row is `proven`, `bounded`, or `not-applicable`, and no unaccepted blocking risk remains.

Set `ready-with-accepted-risk` only when every release-blocking row passes and remaining gaps meet the accepted-risk contract.

Set `not-ready` when a supported blocking gap survives or a release-blocking requirement is `failed`.

Use `insufficient-evidence` when any release-blocking requirement is `unverified`.

## Output

- Scope, environment, outcomes, invariants, authority
- Readiness evidence matrix
- Critical journeys
- Blocking findings with closure evidence
- Accepted risks with review conditions
- Rollout, observability, recovery, ownership summary
- Verification performed and unavailable checks
- `Readiness verdict: ready | ready-with-accepted-risk | not-ready | insufficient-evidence | not-applicable`

## Boundaries

Do not review an individual patch.
Do not execute deployment, load tests, failure injection, or recovery exercises without authority.
Do not command active incidents.
Do not create implementation/transition plans.
Do not implement remediation.
Do not perform a full threat model when that is a separate unresolved responsibility.

## Failure conditions

Fail when readiness is inferred from document presence, unit tests substitute for operational evidence, an unverified release-blocking row is lost in narrative, nominal health hides data/security failure, unexercised recovery is called proven, accepted risk lacks owner/expiry, follow-up hides blocking work, or verdict exceeds inspected environment/evidence.

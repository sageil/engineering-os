# Readiness Model

## Evidence-state discipline

Each release-blocking requirement must have exactly one state:
`proven | bounded | accepted-risk | unverified | failed | not-applicable`.

Use `accepted-risk` only for genuinely nonblocking risk.
An unverified critical requirement is not accepted risk.

## Outcomes and objectives

Define critical user/operator journeys, service objectives, correctness requirements, security objectives, data invariants, compliance obligations, compatibility commitments, and explicit degraded behavior.
Do not use availability alone when the system can be available while returning unauthorized, stale, duplicate, or corrupt results.

## Observability and control

Require signals that distinguish healthy, degraded, failed, and recovering states.
Map each critical signal to owner, threshold, action, escalation path, and blind spot.
Verify operators can identify affected scope and control blast radius.

## Capacity and load

State workload shape, concurrency, data volume, growth, limits, saturation signals, backpressure, queue bounds, rate limits, and degradation behavior.
Use evidence from a comparable environment and explain differences.
Do not infer capacity from average utilization or one nominal test.

## Dependencies

Identify critical sync/async dependencies, objectives, timeout budgets, retry behavior, shedding controls, failure isolation, fallback semantics, and ownership.
Check partial failure, stale success, duplication, delayed work, and recovery order.
Verify that replicas, queues, control planes, credentials, and failover paths do not share an undocumented failure domain that defeats the intended redundancy.

## Deployment and configuration

Inspect artifact identity, configuration ownership, secret readiness, compatibility, mixed versions, rollout unit, health gates, abort thresholds, rollback limits, roll-forward, and cleanup.

## Security and access

Verify production identities, authority, secrets, admin access, tenant isolation, auditability, revocation, emergency access, dependency trust, and monitoring when applicable.
Treat unresolved high-impact threat paths as blockers unless an authorized decision accepts them.

## Data integrity and recovery

Define sources of truth, validation, consistency, backups, restore scope/testing, point-in-time limits, reconciliation, duplicate/loss detection, corruption containment, and recovery authority.
Require semantic recovery evidence, not only backup completion.
When recovery objectives apply, record the accepted recovery time and recovery point as numeric bounds.
Distinguish intended recovery capability from the last measured restore, failover, replay, or reconciliation exercise.
Treat an untested recovery path as unverified unless equivalent evidence proves it.

## Operations and ownership

Identify service owner, on-call owner, dependency contacts, launch authority, incident path, runbook owner, capacity owner, and cleanup owner.
Verify access/procedures are usable by expected operators.

## Finding validity

Report a finding only when requirement is applicable, condition is reachable, evidence or its absence is established, safeguards do not close the gap, and consequence can affect readiness.
Reject checklist findings without operational consequence.

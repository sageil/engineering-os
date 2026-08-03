# Readiness Model

## Outcomes and objectives

Define critical user and operator journeys, service objectives, correctness requirements, security objectives, data invariants, compliance obligations, compatibility commitments, and explicit degraded behavior.
Do not use availability alone when the system can be available while returning unauthorized, stale, duplicate, or corrupt results.

## Observability and control

Require signals that distinguish healthy, degraded, failed, and recovering states.
Map each critical signal to an owner, threshold, action, escalation path, and known blind spot.
Verify that operators can identify affected scope and control the relevant blast radius.

## Capacity and load

State workload shape, concurrency, data volume, growth, resource limits, saturation signals, backpressure, queue bounds, rate limits, and degradation behavior.
Use evidence from a comparable environment and explain differences.
Do not infer capacity from average utilization or a single nominal test.

## Dependencies

Identify critical synchronous and asynchronous dependencies, their objectives, timeout budgets, retry behavior, circuit or load-shedding controls, failure isolation, fallback semantics, and ownership.
Check partial failure, stale success, duplication, delayed work, and recovery order.

## Deployment and configuration

Inspect artifact identity, configuration ownership, secret readiness, compatibility, mixed versions, rollout unit, health gates, abort thresholds, rollback limits, roll-forward, and cleanup.
Distinguish code rollback from data, message, credential, payment, notification, and external-system effects.

## Security and access

Verify production identities, least authority, secret handling, administrative access, tenant isolation, auditability, revocation, emergency access, dependency trust, and security monitoring when applicable.
Treat unresolved high-impact threat paths as readiness blockers unless an authorized decision explicitly accepts them.

## Data integrity and recovery

Define sources of truth, validation, consistency, backups, restore scope, restore testing, point-in-time limits, reconciliation, duplicate and loss detection, corruption containment, and recovery authority.
Require semantic recovery evidence, not only successful backup completion.

## Operations and ownership

Identify service owner, on-call owner, dependency contacts, launch authority, incident command path, runbook owner, capacity owner, and cleanup owner.
Verify that access and procedures are usable by the people expected to operate the system.

## Readiness finding validity

Report a finding only when the requirement is applicable, the operational condition is reachable, evidence or its absence is established, existing safeguards do not close the gap, and the consequence can affect readiness.
Reject checklist findings that lack an operational consequence.

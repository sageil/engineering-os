# Observability Evidence

Use this method when observability is load-bearing for a launch or sustained-operation verdict.
Assess deployed evidence and operator action.
Do not redesign the telemetry system during a readiness review.

## Map evidence to critical outcomes

For each critical journey, service objective, integrity condition, and recovery commitment, identify signals that distinguish:

- healthy completion;
- degradation or delay;
- explicit rejection;
- incorrect, stale, duplicate, or lost outcomes;
- failed or uncertain completion; and
- recovery and reconciliation.

Do not infer outcome visibility from process health or dashboard presence.

## Verify the signal path

Require applicable evidence that:

- the owning execution path emits the expected semantic signal;
- context propagates across required synchronous and asynchronous boundaries;
- logs, events, metrics, traces, audit records, and domain records correlate where operators need them to;
- dimensions stay within known cardinality bounds;
- sampling, aggregation, and dropped telemetry do not invalidate service indicators;
- telemetry-path loss is itself detected; and
- operator access and query paths work in the reviewed environment.

Use controlled requests, failure exercises, replay, synthetic checks, or representative production evidence as authority and safety permit.
Configuration, instrumentation code, or a dashboard screenshot proves intent, not end-to-end availability or accuracy.

## Verify service objectives

For each release-blocking objective, establish:

- valid-event population and good-event condition;
- measurement source and environment;
- threshold, window, and exclusions;
- treatment of missing, late, sampled, or invalid data;
- error-budget owner and response; and
- evidence that the indicator detects the named user or operator outcome.

An objective is `unverified` when its measurement can silently omit the failure it claims to bound.

## Verify alert actionability

For each release-blocking alert or budget policy, establish:

- affected outcome and reachable trigger;
- threshold or condition;
- named receiving owner and escalation path;
- verified delivery path;
- runbook or bounded first action;
- blast-radius or affected-scope information; and
- evidence from an exercise, replay, or representative event.

An alert definition without delivery and action evidence is not `proven`.

## Verify privacy, retention, and sustainability

Inspect applicable controls for secrets, credentials, personal data, tenant isolation, access, retention, deletion, and audit.
Establish expected signal volume, storage or query limits, cost ownership, and the response to limit exhaustion.
Treat unowned or unsustainable telemetry for a critical outcome as a readiness gap.

## Evidence contribution

Add each observability requirement to the readiness matrix with its evidence state, environment, limitation, owner, closure evidence, and invalidation condition.
Do not call observability ready when a release-blocking outcome remains invisible, an objective can silently lie, or the required operator cannot receive and use the signal.

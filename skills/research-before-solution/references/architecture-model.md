# Architecture Model

Read this reference only when credible options change durable system boundaries, data ownership, trust, deployment topology, consistency, or long-term operational ownership.

## Decision input

Start from the research record and viability contract.

When capacity, latency, data growth, availability, or cost can change the eligible architecture shapes, apply [capacity-estimation.md](capacity-estimation.md) before structural comparison.

State the accountable decision owner, delegated technical authority, accepted behavior, non-goals, affected callers and operators, and the conditions that can disprove success.

Write two or three representative caller or operator scenarios before detailed boundaries or interfaces.
Include expected use and the most consequential failure, retry, compatibility, or recovery scenario.
Derive the proposed shape from these scenarios and reconcile any mismatch in favor of accepted behavior.

Do not invent missing product rules, scale targets, trust assumptions, or operating requirements.

## Boundaries and ownership

For every decision-relevant component, identify its responsibility, owned state, authority, callers, dependencies, deployment unit, operator, and removal owner.

Treat ambiguous ownership as an architectural risk when failure or change requires coordination.

Prefer boundaries that align authority with responsibility.

For each proposed component or mechanism, name the evidence-backed constraint it removes and the permanent failure, state, compatibility, cost, and operating obligations it introduces.
Remove a component from consideration when it serves no established constraint.
Do not treat an absent cache, queue, service, shard, region, gateway, or integration pattern as a design gap without evidence that requires it.

## State and consistency

Identify each source of truth, derived copy, cache, index, replica, event, and durable workflow state.

State who can write, how conflicts resolve, what ordering is guaranteed, and how stale or duplicate data is detected.

Do not hide consistency decisions behind the word eventual.

Do not default to per-actor state, read-time merging, a shared database, distributed locking, or a single writer without testing that choice against the required invariants.

For shared writable state, define the authoritative owner, writer set, conflict semantics, transaction boundary, operation identity, replay behavior, reconciliation authority, and evidence that detects uncertain or divergent outcomes.

Map material access patterns, workload shape, consistency need, retention, growth, and lifecycle before selecting or separating data stores.
For each derived copy, replica, cache, index, event stream, or projection, define synchronization ownership, acceptable freshness, failure behavior, repair, and removal.
Do not prescribe a store category, replication model, partition key, or sharding scheme before evidence shows which constraint the mechanism must satisfy.

## Communication and integration

Select communication and integration behavior per boundary crossing rather than per system fashion.
For each material hop, define caller and provider ownership, synchronous or asynchronous dependence, latency and availability budget, authentication and authorization context, timeout, cancellation, retry, backpressure, compatibility, and uncertain-outcome behavior.

When messages, events, callbacks, streams, queues, or distributed workflows are involved, define delivery, ordering, duplicate, replay, idempotency, acknowledgement, poison-work, and reconciliation semantics as applicable.
Treat REST, RPC, GraphQL, streams, webhooks, gateways, outboxes, sagas, event sourcing, sidecars, and anti-corruption layers as mechanisms with specific costs and failure modes, not maturity markers.
Reject a pattern when its permanent obligations exceed the evidenced constraint it removes.
Distinguish a permanent integration boundary from a temporary transition seam.
For a temporary seam, identify the owner, compatibility interval, observation signal, removal condition, and final source of truth.

## Failure model

Consider crash, timeout, partial response, duplication, reordering, corruption, overload, dependency unavailability, version skew, credential failure, and operator error when relevant.

Trace whether failure is isolated, amplified, delayed, retried, masked, or reported as success.

Identify recovery authority and evidence of restored integrity.

## Feedback and second-order effects

Map feedback loops, delays, backpressure, incentives, adaptive behavior, and pressure accumulation.

Ask which permanent obligation appears if adoption succeeds.

Check whether retries amplify load, queues conceal overload, caches create invalidation systems, metrics distort behavior, or automation removes human visibility.

## Security and trust

Identify identities, trust transitions, authorization decisions, sensitive data flows, secrets, isolation, and auditability.

Keep authentication, authorization, validation, and encryption as distinct controls.

Place enforcement at the boundary that owns the protected resource.

## Operability

Require signals that distinguish healthy, degraded, and failed states.

Identify configuration ownership, capacity limits, deployment control, rollback or roll-forward, diagnostics, on-call burden, and recovery procedures.

Reject an option that cannot be diagnosed or recovered.

## Evolution

Evaluate current-to-target states, compatibility windows, mixed versions, data transitions, and cleanup.

Reject an option whose safe transition is less credible than its steady state.

Name the condition under which the option should be simplified, replaced, split, merged, or removed.

Preserve an exit path before dependence makes exit impractical.

Identify transition hazards without designing the transition plan.
Persistent mutation, mixed versions, compatibility windows, coordinated owners, irreversible effects, bounded rollout, or difficult recovery are reasons to request `execution-planning` only after the architecture decision is accepted.

## Risk-selected perspectives

Apply only the perspectives that the evidence signals:

- concurrency when multiple actors, async work, retries, queues, or ordering affect an invariant;
- security when identities, authorization, secrets, sensitive data, or trust transitions are present;
- data when schemas, migrations, replicas, caches, indexes, events, or retention are decision-relevant;
- operations when deployables, dependencies, capacity, telemetry, rollback, or on-call ownership change; and
- public contract when independently versioned consumers or compatibility obligations exist.

Record a clean result when an applicable perspective finds no material concern.
Do not create findings to justify a perspective or apply a review perspective that has no decision signal.

## Structural comparison

Compare each option against the same evidence-backed invariants.

When two or more materially distinct eligible shapes exist, compare at least the strongest two.
Do not manufacture a second design when evidence leaves only one eligible shape.
Do not treat differently named versions of the same ownership, state, and boundary model as distinct designs.

Make decisive differences, principal failure modes, ownership obligations, migration constraints, and conditions favoring another option explicit.

Return to research when a load-bearing structural fact remains unverified.

## Verification and fitness

For the recommended shape, define evidence that can disprove its load-bearing claims.

Map accepted behavior and invariants to the narrowest applicable checks, such as caller-observable contract tests, dependency rules, schema constraints, authorization tests, failure and replay tests, compatibility checks, runtime signals, or recovery exercises.

Do not claim that a type sketch, diagram, schema, mock, or linter proves runtime behavior outside its evidence boundary.

State who owns each check, when it runs, what failure means, and which architectural drift it detects.

## Decision gate and handoff

Set one status:

- `recommended`: evidence supports one shape, but the accountable owner has not accepted it;
- `accepted`: the accountable owner accepted the shape or explicitly delegated selection authority for this decision; or
- `unresolved`: evidence does not distinguish eligible shapes or a material owner decision remains open.

Never convert `recommended` into `accepted` because implementation is convenient or the user did not object.

The handoff must state the accepted behavior, recommended or accepted ownership and boundaries, public contracts, state and consistency model, trust decisions, failure and recovery obligations, verification duties, strongest rejected eligible alternative when one exists, transition hazards, and revisit conditions.

Treat this handoff as a decision baseline.
During implementation, internal details can change without reopening the decision only when every listed property remains preserved.
Reopen research when implementation evidence changes a listed property, reveals a material unsupported prerequisite, or repeatedly requires the same escape hatch.

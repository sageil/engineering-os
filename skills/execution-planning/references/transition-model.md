# Transition Model

## Persistent data

Define old and new representations, writers, readers, compatibility interval, backfill or transformation, validation, cutover, rollback limits, and cleanup.
Prefer expand-and-contract sequencing when old and new code must coexist.
Verify counts, constraints, semantics, rejected records, and restart behavior.
Never use an empty value, zero, or default to conceal missing required data.

## Public interfaces

Identify consumers, compatibility commitments, negotiation, deprecation, version skew, and removal criteria.
Plan consumer observation before removing compatibility.
Do not rely on undocumented coordinated deployment unless one deployment unit is verified.

## Distributed and asynchronous work

Model message or job states, ownership, delivery guarantees, idempotency, deduplication, timeouts, retries, poison work, cancellation, and recovery.
Define what happens when execution stops after every durable state transition.
Verify that retries cannot duplicate irreversible effects.

## Infrastructure and configuration

Define desired state, drift detection, credentials, dependency readiness, capacity, rollout unit, health signals, and recovery authority.
Check partial application, incompatible configuration, unavailable dependencies, and provider rollback limits.

## Feature flags and temporary compatibility

Assign an owner, purpose, default, observation signal, removal condition, and deadline or event for review.
Plan behavior for every reachable flag combination.
Treat a flag without a removal path as permanent configuration.

## Rollback and roll-forward

State which effects are reversible and until when.
Distinguish code rollback from data, message, external API, payment, notification, and security effects.
Use roll-forward, containment, or compensating action when rollback cannot restore the previous state.

## Cleanup

List temporary code, flags, dual writes, compatibility reads, old schema, backfill tooling, dashboards, alerts, access, and documentation that must be removed or updated.
Give cleanup the same ownership and verification quality as rollout.

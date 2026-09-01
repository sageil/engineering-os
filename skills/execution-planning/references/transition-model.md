# Transition Model

## Selected-solution integrity

A transition plan may operationalize the chosen mechanism but must not silently redesign it.
If a transition constraint requires a new source of truth, deployment boundary, owner, trust boundary, external capability, or compatibility model, return to research.

## Persistent data

Define old and new representations, writers, readers, compatibility interval, backfill or transformation, validation, cutover, rollback limits, and cleanup.
Prefer expand-and-contract sequencing when old and new code must coexist.
Verify counts, constraints, semantics, rejected records, and restart behavior.
Never use an empty value, zero, or default to conceal missing required data.

For backfills, define ownership, stable selection or cursor semantics, batching, rate and lock limits, checkpoints, idempotency, pause and resume, retry, rejected-record handling, progress signals, and completion proof.
Account for writes that occur during the backfill and define how old and new representations remain consistent or are reconciled.
Do not cut over from row counts alone when values, relationships, constraints, authorization, ordering, or derived state can be wrong while counts match.

For schema or index changes, establish the datastore and version-specific locking, rewrite, replication, storage, and rollback behavior before execution.
Do not label a migration online or zero-downtime from syntax or framework behavior alone.

Define exact read and write behavior for every mixed-version interval.
Avoid dual writes when one transactional owner, durable change record, or reconciliation design can preserve the selected solution's invariant.
When dual writes are part of the selected solution, define ordering, partial failure, retry, conflict, observation, repair, and removal.

## Public interfaces

Identify consumers, compatibility commitments, negotiation, deprecation, version skew, and removal criteria.
Plan consumer observation before removing compatibility.
Do not rely on undocumented coordinated deployment unless one deployment unit is verified.

## Distributed and asynchronous work

Model message or job states, ownership, delivery guarantees, idempotency, deduplication, timeouts, retries, poison work, cancellation, and recovery.
Define what happens when execution stops after every durable state transition.
Verify that retries cannot duplicate irreversible effects.

When the selected solution uses an outbox, event stream, change-data capture, saga, anti-corruption layer, strangler seam, or another integration pattern, plan its full transition obligations.
Define the relay or consumer owner, compatibility interval, ordering limits, replay behavior, reconciliation, compensation, observation, and removal conditions that apply.
Do not add an integration pattern only to make the transition plan appear safer.
Return to research if the plan needs a mechanism that the selected solution did not establish.

## Infrastructure and configuration

Define desired state, drift detection, credentials, dependency readiness, capacity, rollout unit, health signals, and recovery authority.
Check partial application, incompatible configuration, unavailable dependencies, and provider rollback limits.

## Feature flags and temporary compatibility

Assign an owner, purpose, default, observation signal, removal condition, and deadline or review event.
Plan behavior for every reachable flag combination.
Treat a flag without a removal path as permanent configuration.

## Rollback and roll-forward

State which effects are reversible and until when.
Distinguish code rollback from data, message, external API, payment, notification, and security effects.
Use roll-forward, containment, or compensating action when rollback cannot restore the previous state.

## Resilience transitions

Bound the rollout unit and the maximum affected scope for each step.
Define the observation window, success signal, abort threshold, drain behavior, and recovery authority before increasing exposure.
Keep independent failure domains independent during rollout and recovery.
When recovery objectives apply, state how each step preserves or temporarily changes the accepted recovery time and recovery point.

## Cleanup

List temporary code, flags, dual writes, compatibility reads, old schema, backfill tooling, dashboards, alerts, access, and documentation that must be removed or updated.
Give cleanup the same ownership and verification quality as rollout.

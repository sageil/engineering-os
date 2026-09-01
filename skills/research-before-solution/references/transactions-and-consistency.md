# Transactions and Consistency

Use this method when eligible options change atomicity, concurrency, isolation, ordering, idempotency, cross-boundary effects, or recovery from uncertain completion.

## Define the invariant first

State the business or system invariant, authoritative state owner, permitted writers, operation identity, accepted consistency window, and consequence of violation.
Describe normal success, rejection, conflict, duplicate, timeout, interruption, and recovery outcomes.

Do not choose a transaction, lock, queue, saga, outbox, or reconciliation mechanism before the invariant and ownership boundary are established.

## Map the state transition

For every durable state change, identify:

- preconditions and authorization;
- state read and written;
- transaction or atomicity boundary;
- concurrency and conflict behavior;
- external or irreversible effects;
- completion record and caller response;
- retry and duplicate behavior; and
- reconciliation authority when the outcome is uncertain.

Trace interruption immediately before and after every durable write or external effect that can change the outcome.

## Compare transaction shapes

For a single transactional owner, compare the required isolation, contention, locking, retry, and failure behavior against the datastore's actual contract.
Do not treat the strongest available isolation level as universally correct when it causes unacceptable blocking or retry behavior.

For multiple owners or external effects, determine whether the invariant can be expressed through ownership, sequencing, idempotency, reservation, compensation, or reconciliation.
Do not describe a distributed workflow as atomic when observers can see intermediate states or compensation can fail.

An outbox can couple one local state change to durable publication intent.
It does not prove downstream authorization, ordering, exactly-once effects, or consumer success.

A saga coordinates or observes a sequence of independently committed effects.
It does not provide isolation, and compensation is a new effect that needs authority, idempotency, failure handling, and business validity.

## Concurrency and ordering

Identify actors, resources, conflicts, permitted interleavings, stale reads, lock ownership, lease expiry, fencing, deadlock, starvation, and retry behavior when applicable.
Use optimistic control only when conflicts can be detected and safely retried.
Use pessimistic control only when blocking, lock lifetime, failure release, and operational consequences are acceptable.

Do not rely on a distributed lease as exclusive authority without a fencing or equivalent stale-owner defense when delayed actors can still write.
Do not claim global ordering from partition-local or producer-local ordering.

## Idempotency and uncertain outcomes

Define key ownership, scope, request fingerprint, claim atomicity, in-progress result, completed result, retention, replay window, and response equivalence.
Idempotency must cover the complete material effect, not only one database write.

When a timeout can occur after commitment, provide durable operation identity and an inquiry or reconciliation path.
Do not convert uncertain completion into failure if a retry can duplicate an irreversible effect.

## Verification obligations

Define evidence for:

- concurrent conflicting operations;
- duplicate and delayed delivery;
- timeout before and after each durable boundary;
- interruption and restart;
- stale writer or expired lease;
- failed compensation or reconciliation;
- preserved authorization after delay or replay; and
- detection and repair of divergent state.

Use the real supported transaction and concurrency behavior when a mock cannot reproduce isolation, locking, or failure semantics.

## Output contribution

Add to the research record:

- invariant and ownership model;
- state-transition and failure-boundary map;
- eligible transaction or coordination shapes;
- atomicity, isolation, ordering, idempotency, and recovery contracts;
- rejected shapes and evidence;
- verification and reconciliation obligations; and
- conditions that require reopening the decision.

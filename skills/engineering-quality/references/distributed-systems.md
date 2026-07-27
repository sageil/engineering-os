# Distributed Systems Review Reference

Load for queues, events, retries, remote calls, distributed locks, background workers, coordination, or eventual consistency.

Assume partial failure.

Review:

- delivery guarantees and duplicate handling
- idempotency keys and side-effect boundaries
- timeouts, cancellation, retries, exponential backoff, and jitter
- retry eligibility for non-idempotent operations
- ordering assumptions and out-of-order delivery
- poison messages, dead-letter handling, and replay
- concurrency limits, backpressure, queue growth, and load shedding
- split brain, lease expiry, clock assumptions, and fencing tokens
- transactional outbox or equivalent consistency strategy when needed
- dependency failure, degradation, circuit breaking, and recovery
- observability, correlation IDs, and operational ownership

Do not introduce distributed coordination when a local transaction, invariant, or simpler architecture is sufficient.

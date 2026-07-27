# Data and Migration Review Reference

Load for schemas, persistent state, migrations, transactions, backfills, caches, indexes, or data-contract changes.

Review:

- invariants and database-enforced constraints
- transaction boundaries, atomicity, isolation, and retry semantics
- concurrent writes, lost updates, stale reads, and ordering
- nullability, defaults, uniqueness, referential integrity, and precision
- forward compatibility during mixed-version deployment
- expand–migrate–contract sequencing where relevant
- backfill restartability, chunking, throttling, and observability
- partial application, interruption, rollback, and data preservation
- index creation cost, lock behaviour, and query plans
- validation before destructive contraction
- cache coherence and invalidation
- retention, privacy, and deletion requirements

Prefer reversible and restartable transitions. Never assume the final schema state makes the transition safe.

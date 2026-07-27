# Data and Migration Review Reference

Load when the change affects schemas, persistence, backfills, transactions, or long-lived state.

Review:

- invariant ownership: application, database, or both
- transaction boundaries and partial writes
- uniqueness and foreign-key guarantees
- backfill resumability and idempotency
- mixed-version reads and writes
- expand/migrate/contract sequencing
- rollback after new-format data exists
- lock duration, table scans, and operational observability

A final valid schema is insufficient if the transition is unsafe.

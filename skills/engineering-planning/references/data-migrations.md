# Data and Migration Planning Reference

For schema or persistent-data changes, verify:

- old and new application versions can coexist when required
- reads and writes remain compatible during rollout
- backfills are bounded, resumable, and observable
- retries are idempotent
- partial migration state is detectable
- rollback does not destroy data written by the new version
- constraints are introduced in a safe order
- success criteria include data preservation and validation

Prefer expand-and-contract migrations when compatibility windows are required.

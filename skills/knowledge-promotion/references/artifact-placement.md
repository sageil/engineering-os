# Artifact Placement

## Enforced artifact

Use code, schema, type, permission, or configuration when the rule must hold automatically.
Preserve rationale nearby only when the enforcement is non-obvious.

## Detection artifact

Use a test, lint rule, CI check, deployment guard, monitor, or alert when violation must be detected reliably.
State the invariant and ensure the check can fail for its violation.

## Documentation

Use authoritative documentation for supported behavior, setup, interfaces, architecture, operations, and contributor workflows.
Update the owning document rather than adding a detached note.

## ADR or decision record

Use for accepted choices whose rationale, alternatives, tradeoffs, authority, and reversal conditions matter after implementation.
Do not use an ADR for routine implementation details or undecided proposals.

## Runbook

Use for operational diagnosis, mitigation, recovery, verification, and escalation that must be repeatable under pressure.
Verify commands, targets, prerequisites, failure handling, and recovery.

## Issue or investigation record

Use for unresolved hypotheses, deferred work, evidence gaps, and decisions awaiting an owner.
Do not present the record as durable truth.

## Persistent memory

Use only for scoped judgment-improving context that cannot live more reliably in the system or repository.
Include source, scope, rationale, trigger, date, volatility, and revalidation or removal condition as needed.
Retrieve selectively and verify before consequential use.

## Forgetting

Delete, merge, or supersede knowledge when code or automation now enforces it, authoritative documentation replaces it, the decision changes, the constraint disappears, scope was wrong, or the entry no longer affects decisions.
Treat deletion as normal maintenance.

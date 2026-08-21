# Artifact Placement

## Enforced artifact

Use code, schema, type, permission, or configuration when the rule must hold automatically.
Preserve rationale nearby only when enforcement is non-obvious.

## Detection artifact

Use a test, lint rule, CI check, deployment guard, monitor, or alert when violation must be detected reliably.
State the invariant and ensure the check can fail for its violation.

## Documentation

Use authoritative documentation for supported behavior, setup, interfaces, architecture, operations, and contributor workflows.
Update the owning document rather than adding a detached note.
For volatile facts, include scope/version and a practical revalidation trigger.

## ADR or decision record

Use for accepted choices whose rationale, alternatives, tradeoffs, authority, and reversal conditions matter after implementation.
Include the condition that should reopen or retire the decision.

## Runbook

Use for diagnosis, mitigation, recovery, verification, and escalation that must be repeatable under pressure.
Verify commands, targets, prerequisites, failure handling, and recovery.
Include conditions that invalidate the procedure.

## Issue or investigation record

Use for unresolved hypotheses, deferred work, evidence gaps, and decisions awaiting an owner.
Do not present the record as durable truth.

## Persistent memory

Use only for scoped judgment-improving context that cannot live more reliably elsewhere.
Include source, scope, rationale, trigger, date, volatility, invalidation signal, and revalidation/removal condition.
Retrieve selectively and verify before consequential use.

## Forgetting

Delete, merge, or supersede knowledge when stronger enforcement exists, authoritative documentation replaces it, the decision changes, its invalidation condition occurs, the constraint disappears, scope was wrong, or the entry no longer affects decisions.
Treat deletion as normal maintenance.

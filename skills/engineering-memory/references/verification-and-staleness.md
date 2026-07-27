# Verification and Staleness

Verify based on consequence, volatility, uncertainty, and verification cost.

## Stable

Examples: durable team preference, accepted architectural rationale, domain invariant.
Recheck when ownership, architecture, or policy changes.

## Slow-changing

Examples: framework limitation, deployment convention, service ownership.
Recheck on major version, architecture, or ownership changes.

## Fast-changing

Examples: current branch, file path, deployed version, feature flag, endpoint, migration state.
Verify before consequential use.

Never let memory override cheap, current, authoritative evidence.

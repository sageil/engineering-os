---
name: reduce-system-complexity
description: Establish or verify a net reduction in branches, states, dependencies, layers, flags, jobs, adapters, or other mechanisms while preserving accepted behavior.
---

# Reduce System Complexity

## Contract

Conserve agreed behavior and reduce total mechanism across the selected path.
Run read-only.
Do not call moved, hidden, renamed, or uncounted complexity a reduction.

Use one mode:

- `selection`: establish the conserved contract and select a complete reduction target;
- `verification`: determine whether a completed change achieved the claimed reduction.

Maintain one verdict:

- `reduction-selected`
- `reduction-verified`
- `not-reduced`
- `insufficient-evidence`

## 1. Fix scope and conserved behavior

Identify the selected entry points, callers, outcomes, data, integrations, operations, and recovery paths.
State exclusions and what net reduction means for this scope.

Classify observed behavior:

| Class | Treatment |
| --- | --- |
| Accepted contract | Preserve unless the user authorizes a behavior change. |
| Relied-upon observable behavior | Treat as compatibility-sensitive. |
| Intended and supported behavior | Preserve with proportionate evidence. |
| Known bug or disputed behavior | Require an owner decision. Do not silently preserve or fix it. |
| Proven obsolete or unreachable behavior | Candidate for deletion after reachability evidence. |

Inventory effects, errors, ordering, persistence, authorization, security, privacy, concurrency, reliability, compatibility, retries, migration, and recovery obligations.

## 2. Build the behavior evidence ledger

For every behavior or guarantee that the proposed reduction can affect, record:

- authority or evidence source;
- affected actors and surfaces;
- preservation observation;
- required fidelity;
- current evidence gap.

Characterization tests describe observed behavior.
They do not decide which behavior is correct.

If a material behavior lacks a responsible preservation oracle, return `insufficient-evidence` with the smallest evidence needed.

## 3. Baseline the whole mechanism

Trace each conserved behavior from trigger to outcome and recovery.
Count or describe each applicable dimension with a method that can be repeated after the change:

- control decisions, error paths, retries, fallbacks, and recovery branches;
- states, transitions, mutable owners, queues, tasks, locks, and lifecycle phases;
- modules, layers, hops, dependencies, adapters, translations, and representations;
- flags, modes, configuration, deployables, jobs, migrations, monitors, and runbooks.

Include caller and operator burden.
Exclude generated artifacts unless their source or runtime mechanism changes.
Do not combine unlike counts into one synthetic score.

## 4. Derive the minimum from constraints

Answer without assuming the current design is the target:

1. Which outcomes and guarantees must remain?
2. Which domain decisions and external constraints are irreducible?
3. Who must own state, time, failure, authorization, and recovery?
4. What is the shortest coherent path from trigger to outcome?

Seek reduction in this order when evidence permits:

1. delete obsolete paths, flags, options, fallbacks, and configuration;
2. unify duplicated policy, representation, state, or ownership;
3. shrink decision and state spaces;
4. remove pass-through layers, translations, and temporal hops;
5. replace custom generic mechanism with an established primitive only when total lifecycle ownership falls.

Reject a candidate that only relocates burden to callers, operators, adapters, or recovery procedures.

## 5. Select or verify the complete reduction

In `selection` mode, record:

- exact mechanism to remove;
- conserved behaviors and evidence obligations;
- like-for-like baseline and target observations;
- affected callers, data, contracts, and operations;
- transition mechanism, owner, removal condition, and bounded lifetime;
- terminal state where superseded mechanism is absent;
- recovery needs and evidence gaps.

Prefer removal of one complete mechanism over partial hiding.
Do not claim achieved reduction in selection mode.

In `verification` mode, apply both gates.

### Behavior gate

- Every affected ledger entry has proportionate passing evidence.
- Outcomes, effects, errors, ordering, authorization, and operational guarantees remain within the accepted contract.
- Remaining fidelity gaps are explicit and do not invalidate the claim.

### Mechanism gate

- The same mechanism dimensions were observed over the same scope and method.
- Every new part replaces old mechanism or serves an irreducible constraint.
- Caller, adapter, deployment, operation, and recovery burden did not receive the removed complexity.
- Superseded mechanism and expired transition bridges are absent.
- Total lifecycle ownership fell.

Set `reduction-verified` only when both gates pass.
Set `not-reduced` when behavior changed without authority, mechanism was relocated, or the terminal mechanism remains.

## Output

Report:

1. scope, mode, and conserved contract;
2. behavior evidence ledger and gaps;
3. baseline mechanism by dimension;
4. selected target or like-for-like verification result;
5. transition and terminal-state obligations;
6. behavior-gate and mechanism-gate results when verifying;
7. `Complexity-reduction verdict: reduction-selected | reduction-verified | not-reduced | insufficient-evidence`.

## Boundaries

Do not implement the reduction.
Return an accepted target to ordinary authorized execution.
Use `research-before-solution` when a material dependency or mechanism choice remains unresolved.
Use `adversarial-review` for general change review.
Use `acceptance-review` to prove a separate authoritative feature contract.

## Failure conditions

Fail when a smaller file or diff is treated as total reduction, unlike counts are combined, behavior changes are hidden as simplification, temporary bridges have no removal condition, reduction is claimed before the terminal state, or exported operational burden is ignored.

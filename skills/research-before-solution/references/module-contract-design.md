# Module Contract Design

Read this reference only when an eligible option creates, removes, combines, splits, or materially changes an in-process module or package contract.

## Establish the complete caller burden

For each current and proposed caller, inspect:

- operations and data shapes;
- invariants and preconditions;
- call ordering and lifecycle;
- configuration and dependency construction;
- errors, retries, partial failure, cancellation, and effects;
- latency, throughput, consistency, and transaction expectations.

A short type signature is not evidence of a small contract.
The contract includes everything a caller must know to use the behavior safely.

## Find hidden and leaked knowledge

Trace where policy, sequencing, representation, provider mechanics, and recovery decisions live.
Look for repeated orchestration, pass-through chains, provider types in caller code, co-changing files, and tests that reconstruct internal collaborators.

Record counterevidence.
Similar code can represent different knowledge, ownership, authorization, deployment, transaction, or failure boundaries.

Apply the behavior-preserving inlining test:

- a module earns its place when inlining it into each caller would spread policy, sequencing, recovery, or representation knowledge;
- a module is shallow or misplaced when inlining removes pass-through indirection without duplicating knowledge.

Do not confuse deleting a module boundary with deleting the behavior it owns.

## Test responsibility and depth

Define the proposed responsibility in one sentence with explicit exclusions.

Prefer a contract when it gives callers substantial coherent behavior while hiding decisions that belong to one owner.
Reject a small contract over unrelated behavior because that creates a hidden god module.

Ask:

- Does the common caller know and coordinate less?
- Does a policy change concentrate in one owner?
- Are cohesion, ownership, authorization, transaction, deployment, and failure boundaries still honest?
- Are effects and performance costs explicit enough for safe use?
- Does the design avoid speculative options and generic command-shaped interfaces?
- Are route leaves, adapters, generated clients, CLI commands, and composition roots still intentionally thin and policy-free?

## Justify seams and dependency strategy

Require evidence for each seam, such as real substitution, independent verification, volatility isolation, ownership, trust, runtime failure, or deployment.
Do not create a seam only because a private function exists or a hypothetical adapter could exist.

For each material dependency, record:

- in-process or out-of-process;
- owned, jointly owned, or third-party;
- trust and authorization boundary;
- transaction and consistency boundary;
- stability and expected change owner;
- state, resource, concurrency, and lifecycle ownership;
- available test substitute;
- behavior the substitute cannot prove.

Keep provider and transport mechanics behind local application language when that preserves a real change boundary.
Do not wrap stable primitives by reflex.

## Design consequential contracts more than once

When reversal is expensive or several credible shapes remain, compare two or three genuinely different contracts.
Exercise every contract with the same common, failure, edge, cancellation, retry, and lifecycle scenarios.

Compare:

- caller burden;
- coherent depth and policy locality;
- failure and effect honesty;
- dependency-test fidelity;
- compatibility and migration constraints;
- support for named current variation;
- enforceability through types, exports, imports, and architecture checks.

Reject an option that wins by hiding failure, performance, or lifecycle costs.
Recommend one design when evidence distinguishes it.
Do not average incompatible contracts into a wider hybrid.

## Define durable verification

Specify caller-observable behavior tests that should survive internal restructuring.
Do not expose private helpers or collaborator graphs only to make tests convenient.

State which contract, integration, sandbox, performance, or runtime evidence closes each known fidelity gap.

Return to research when contract comparison exposes a material unverified prerequisite.

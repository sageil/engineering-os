# Threat Analysis

## Attack-surface prompts

Inspect externally reachable interfaces, authenticated surfaces, tenant transitions, administrative paths, background workers, queues, scheduled work, imports, exports, webhooks, callbacks, file processing, caches, backups, observability systems, deployment controls, build inputs, secrets, and third-party dependencies when applicable.

Use categories only as prompts, never as a required checklist.

## Threat eligibility gate

Before detailed analysis, require:
1. applicable actor;
2. reachable entry;
3. plausible action sequence;
4. relevant boundary crossing or authority abuse;
5. established security objective;
6. material consequence.

Classify:
- `credible` when all six are supported;
- `rejected` when evidence contradicts a load-bearing element;
- `research-needed` when a material element is unresolved.

Do not elaborate rejected paths.
Return to research for `research-needed`.

## Threat path structure

Trace:
`actor capability -> reachable entry -> boundary/authority change -> control interaction -> violated objective -> impact`

State evidence for every link.
Separate prerequisites from exploit mechanism and downstream amplification.

## Control analysis

Classify controls by actual function:
- prevention;
- detection;
- response;
- recovery;
- deterrence/governance.

Identify enforcement owner, protected boundary, configuration, failure mode, bypass surface, observability, and recovery behavior.
Do not treat encryption as authorization, authentication as authorization, validation as isolation, or logging as prevention.

## Multi-tenant systems

Trace tenant identity through request handling, asynchronous payloads, persistence, caches, indexes, exports, logs, and administration.
Verify enforcement at the boundary that owns the protected resource.

## Distributed and asynchronous systems

Inspect authenticity, authorization context, replay, deduplication, ordering, poison work, retries, dead letters, cancellation, and irreversible effects.
Check whether a valid message can become unauthorized when delayed/replayed or after privilege revocation.

## Operational and supply-chain paths

Inspect deployment authority, CI identities, artifact provenance, dependency substitution, secret exposure, emergency access, debug interfaces, backup restoration, and operator auditability.

## Residual risk

Record unresolved threat, objective, consequence, controls, gap, owner, decision, verification signal, and review condition.
Reject permanent acceptance without scope, authority, and revalidation trigger.

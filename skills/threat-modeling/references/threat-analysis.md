# Threat Analysis

## Attack surface prompts

Inspect externally reachable interfaces, authenticated user surfaces, tenant transitions, administrative paths, background workers, queues, scheduled work, imports, exports, webhooks, callbacks, file processing, caches, backups, observability systems, deployment controls, build inputs, secrets, and third-party dependencies when applicable.

Use the following categories as prompts, not as a required checklist:

- identity impersonation and session abuse;
- authorization bypass and privilege escalation;
- cross-tenant access and isolation failure;
- input tampering and integrity loss;
- replay, duplication, reordering, and race conditions;
- sensitive-data disclosure and inference;
- audit evasion and repudiation;
- resource exhaustion, automation abuse, and economic denial of service;
- dependency compromise and supply-chain substitution;
- insecure recovery, backup, debug, or administrative paths.

Discard any category that does not produce an applicable actor, reachable path, violated objective, and material consequence.

## Threat path structure

Trace each threat as:

`actor capability -> reachable entry -> boundary crossing or authority abuse -> control interaction -> violated objective -> impact`

State the evidence supporting every link.
Separate prerequisites from the exploit mechanism and downstream amplification.

## Control analysis

Classify controls by what they actually do:

- prevention stops the path before impact;
- detection produces a trustworthy signal within a useful time;
- response contains or revokes the actor or mechanism;
- recovery restores service, data, access, and integrity;
- deterrence or governance changes incentives but does not technically block the path.

Identify the enforcement owner, protected boundary, configuration, failure mode, bypass surface, observability, and recovery behavior for each material control.
Do not treat encryption as authorization, authentication as authorization, validation as isolation, or logging as prevention.

## Multi-tenant systems

Trace tenant identity from authentication through request handling, asynchronous payloads, persistence, caches, indexes, exports, logs, and administrative tools.
Verify enforcement at the boundary that owns the protected resource.
Check whether retries, background work, shared mutable state, or user-controlled identifiers can replace or detach tenant context.

## Distributed and asynchronous systems

Inspect message authenticity, authorization context, replay, deduplication, ordering, poison work, retries, dead letters, cancellation, and irreversible effects.
Check whether a valid message can become unauthorized when delayed, replayed, or processed after privilege revocation.

## Operational and supply-chain paths

Inspect deployment authority, CI identities, artifact provenance, dependency substitution, secret exposure, emergency access, debug interfaces, backup restoration, and operator auditability.
Distinguish compromise of a dependency from ordinary dependency failure.

## Residual risk

Record the unresolved threat, affected objective, consequence, existing controls, remaining gap, owner, decision, verification signal, and review condition.
Reject permanent risk acceptance without scope, authority, and a revalidation trigger.

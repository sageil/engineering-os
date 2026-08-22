# Public API Contracts

Use this method when an eligible option creates or materially changes a contract consumed outside its release unit or versioned independently from its consumers.
Apply it to request-response APIs, asynchronous messages, events, and webhooks as applicable.

## Establish the contract context

Identify:

- current and intended consumers;
- contract owner and change authority;
- release independence and realistic version skew;
- current specification and observed de facto behavior;
- generated clients, schemas, gateways, caches, and intermediaries;
- data, trust, tenancy, and authorization boundaries; and
- compatibility and deprecation commitments.

Do not assume the documented contract is the complete consumed contract.
Inspect representative clients, tests, traffic evidence, and support history when they could reveal relied-on behavior.

## Build a contract ledger

For each operation or message, record the applicable obligations:

- purpose, actor, authority, and resource identity;
- input shape, validation, absence semantics, bounds, and defaults;
- output shape, presence semantics, ordering, freshness, and partial results;
- error categories, retry meaning, correlation, and safe disclosure;
- authentication and authorization decision points;
- idempotency, concurrency, replay, and duplicate handling;
- pagination, filtering, sorting, stable ordering, and cursor validity;
- caching, conditional requests, and invalidation;
- quotas, rate behavior, and overload response;
- event delivery, ordering, acknowledgement, and redelivery when applicable;
- latency, availability, durability, and consistency commitments;
- compatibility, versioning, deprecation, and removal; and
- verification and production observation.

Include only obligations that can change consumer behavior or contract safety.

## Analyze compatibility

Treat compatibility as observed consumer behavior under version skew, not only schema validity.
Check source, binary, wire, data, and behavioral compatibility as applicable.

An additive field, enum value, message type, optional property, or broader accepted input is not universally safe.
Establish how existing consumers handle unknown values, field presence, ordering, duplicates, defaults, and partial results.

For each change, state:

- which consumer versions can coexist;
- what old producers and consumers observe;
- what new producers and consumers observe;
- whether rollback restores the prior contract;
- how deprecation is communicated and measured; and
- the evidence required before removal.

## Define failure and retry semantics

Use stable error categories that let consumers distinguish invalid requests, denied authority, missing state, conflicts, dependency failure, throttling, and transient unavailability when those distinctions affect action.
Do not leak secrets, credentials, internal topology, or unnecessary personal data through errors or correlation data.

When retries can duplicate effects, define:

- idempotency scope and key ownership;
- request fingerprint rules;
- atomic claim or deduplication behavior;
- in-progress and completed responses;
- durable operation identity;
- retention and replay window; and
- reconciliation when outcome is uncertain.

Do not call an operation idempotent unless the complete effect and response contract support safe replay.

## Define collection behavior

For paginated or ordered results, define a deterministic stable order, tie-breaking behavior, cursor scope, cursor expiry, mutation behavior between pages, limits, and invalid-cursor behavior.
Do not expose internal storage offsets as a durable contract unless their stability is established.

## Compare eligible contracts

Test each eligible contract shape against the same consumer scenarios:

- current and mixed consumer versions;
- invalid, unauthorized, conflicting, and repeated requests;
- timeouts before and after durable effects;
- partial dependency failure;
- duplicate or reordered delivery;
- pagination during concurrent mutation;
- rollback and deprecation; and
- contract observation and support diagnosis.

Prefer the smallest contract that preserves required consumer outcomes and does not expose internal decisions without need.

## Verification obligations

Define contract, compatibility, and negative tests that can disprove the design.
Include representative old and new consumers when version skew is possible.
Specify which properties need runtime evidence rather than mocks or schema checks alone.

Use current primary standards and platform documentation for version-sensitive protocol claims.
Route a primary OAuth or OpenID Connect protocol security responsibility to `secure-oauth-oidc` through a new routing decision.
Use threat modeling when the user explicitly requests broader proactive attack-path analysis.

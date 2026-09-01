# Security Testing Method

Use this method to select proportionate security tests and establish findings without unnecessary harm.

## Coverage sources

Use the current applicable versions of primary standards and platform guidance.
Applicable sources can include:

- OWASP Web Security Testing Guide for web applications and services;
- OWASP Application Security Verification Standard for web control requirements;
- OWASP API Security guidance for API-specific authorization, resource, business-flow, inventory, and dependency risks;
- OWASP mobile application security testing guidance for mobile clients;
- OWASP GenAI and Agentic Security guidance for model, agent, retrieval, memory, and tool boundaries;
- protocol standards and official provider documentation; and
- accepted organization-specific security objectives and testing rules.

Record the source version when identifiers or requirements appear in findings.
Tailor coverage to actual assets, actors, entry points, trust transitions, and consequences.
Do not copy an entire taxonomy into the report as findings.

## Balanced evidence

Use complementary techniques according to the claim:

- source review establishes reachable code paths and enforcement placement;
- configuration review establishes declared controls and deployment intent;
- dependency analysis establishes component identity and advisory applicability;
- static analysis finds suspicious flows and patterns;
- dynamic analysis observes runtime responses and state changes;
- manual testing exercises authorization, business logic, sequencing, race, and multi-step state;
- runtime telemetry can establish attempts, decisions, effects, and cleanup; and
- controlled negative tests can prove rejection and isolation behavior.

No single technique establishes complete security coverage.
Use automated tools for breadth and manual reasoning for system-specific depth.

## High-value test lenses

Apply only lenses supported by the attack surface:

- identity, authentication, session, recovery, revocation, and credential lifecycle;
- object, function, property, tenant, and administrative authorization;
- input interpretation, injection, output handling, files, URLs, redirects, and server-side requests;
- secrets, personal data, logging, exports, backups, and error disclosure;
- resource consumption, rate behavior, sensitive business flows, concurrency, and abuse automation;
- configuration, inventory, debug interfaces, unsupported assets, and environment separation;
- dependency, build, artifact, deployment, and update trust;
- browser origin, content, storage, navigation, and client-side trust;
- mobile storage, inter-process communication, deep links, transport, platform permissions, and release configuration;
- asynchronous authenticity, authorization context, replay, ordering, duplicates, poison work, and revocation; and
- agentic model, prompt, retrieval, memory, tool authority, delegated identity, output, and cost boundaries.

## Authorization and business logic

Build an actor-action-resource matrix from actual roles, tenants, ownership, states, and transitions.
Test horizontal, vertical, cross-tenant, alternate-interface, delayed, replayed, and revoked-access cases when applicable.
Verify enforcement at the boundary that owns the protected resource or effect.

Do not call an object lookup vulnerable because an ownership condition is absent from one query until every applicable gateway, service, database, and policy safeguard has been inspected.

For sensitive business flows, model valid actions used in harmful sequence, volume, timing, or identity combinations.
Use bounded synthetic data and stop before material external or irreversible effect.

## Dependency findings

Establish exact component identity, version, build, deployment, reachability, vulnerable feature use, environmental preconditions, available mitigations, and advisory applicability.
A package name and version match can establish exposure to an advisory.
It does not by itself establish runtime reachability or exploitability.

## Agentic systems

Separate instructions from data across system, developer, user, retrieval, memory, tool, and model-output channels.
Test whether untrusted content can change authority, select tools, alter durable memory, access another tenant, disclose protected context, or reach an unsafe downstream interpreter.

Trace delegated identity and authorization through every tool call and asynchronous continuation.
Verify that model output is treated as untrusted input at code, query, shell, template, navigation, file, and external-effect boundaries.
Test tool argument validation, least privilege, effect confirmation where required by policy, iteration and cost bounds, cancellation, audit, rollback, and recovery.

Do not classify every prompt injection as the same severity.
Establish the authority gained, effect reached, data exposed, persistence, blast radius, and control evidence.

## Proof minimization

Use the smallest proof that establishes the violated objective:

1. Prefer direct source, configuration, or state evidence when it establishes reachability and consequence.
2. Use a controlled negative or cross-boundary request when runtime behavior is material.
3. Use a bounded exploit only when the claim cannot otherwise be established and the exact effect is authorized.
4. Stop after sufficient evidence exists.

Redact tokens and sensitive values while preserving the fact that proves the finding.
Store raw evidence only in an approved location with the required retention and access controls.

## False-positive challenge

For every candidate, test:

- whether the entry point is reachable in the assessed environment;
- whether the actor can satisfy the preconditions;
- whether another layer enforces the objective;
- whether the vulnerable feature is enabled and used;
- whether input reaches the suspected sink unchanged;
- whether the observed result violates an accepted objective;
- whether the effect persists or crosses the claimed boundary; and
- whether the result came from test instrumentation or an unrelated state.

Discard or downgrade the candidate when a load-bearing claim fails.

## Retest and closure

Retest through the same evidence boundary that established the finding.
Verify the original path no longer violates the objective and applicable adjacent behavior remains preserved.
Do not close a finding from a code change, configuration screenshot, or scanner result when the original claim required runtime evidence.

---
name: secure-oauth-oidc
description: >-
  Establish or assess the security invariants of a defined OAuth 2.0 or OpenID
  Connect deployment when the user explicitly requests protocol security design,
  audit, hardening, or migration. Use for authorization servers, OpenID Providers,
  clients, relying parties, resource servers, redirects, PKCE, issuer binding, token
  validation, refresh, DPoP, mTLS, or insecure-grant migration. Do not use for general
  threat modeling, unrelated authentication, active incidents, implementation, or a
  concrete observed failure that still needs causal isolation.
---

# Secure OAuth and OpenID Connect

## Contract

Treat OAuth and OpenID Connect security as end-to-end protocol invariants.
OAuth delegates access.
OpenID Connect adds authentication.
Never use an OAuth access token as an ID Token or infer login identity from OAuth alone.

Run read-only.
Do not implement protocol or cryptography.

Use one mode:

- `design`: define the applicable security profile and required protocol behavior;
- `assessment`: determine which applicable controls are satisfied, failed, or unknown;
- `migration`: define the secure target and the removal conditions for weaker flows.

Maintain one verdict:

- `design-ready`
- `controls-satisfied`
- `controls-failed`
- `migration-ready`
- `insufficient-evidence`

## Load the required references

Read [standards-and-controls.md](references/standards-and-controls.md) for every task.
It defines source precedence, currentness rules, and the stable RFC 9700 baseline.

Read [oidc-validation.md](references/oidc-validation.md) for ID Tokens, UserInfo, Discovery, multi-issuer login, account binding, or logout.

Read [attack-tests.md](references/attack-tests.md) for assessment, migration, negative-test design, or a request that includes attack analysis.

## 1. Establish the protocol profile

Identify:

- goal: delegated access, authentication, both, machine access, device authorization, or token exchange;
- parties: authorization server or OpenID Provider, client or relying party, resource server, user agent, user, and TLS intermediaries;
- client type and execution context, based on whether credentials can remain confidential;
- every enabled grant, response type, response mode, callback, refresh path, token exchange, logout path, and legacy path;
- issuer topology, discovery and registration model, resource servers, proxies, and trust boundaries;
- applicable standards, ecosystem profile, regulation, and exact versions;
- inspected code, configuration, metadata, libraries, tests, and runtime observations.

Mark every uninspected surface as unknown.
Do not let a registration label override actual client capability.

## 2. Build the transaction ledger

Trace each flow from initiation through callback, token use, refresh, revocation, and logout.

For each artifact, record producer, consumer, storage, transmission, validation, expiry, invalidation, and required binding:

| Artifact | Required binding or validation |
| --- | --- |
| Authorization request | Issuer, client, exact redirect, response mode, requested resource, and privilege. |
| `state` | High entropy, one use, and bound to the initiating user-agent session. |
| PKCE | Transaction-specific verifier, `S256` challenge, server-recorded challenge presence, and enforced verifier. |
| OIDC `nonce` | Transaction-specific and validated in the correct ID Token before token or session use. |
| Authorization response | Expected session, issuer, redirect endpoint, response mode, and success or error semantics. |
| Authorization code | Client, redirect, transaction, PKCE challenge, short lifetime, and single use. |
| Access token | Issuer, token type, audience, privilege, lifetime, and sender key when constrained. |
| Refresh token | Client instance, grant, scope, resource, replay family or sender key, expiry, and revocation. |
| ID Token | Expected issuer, relying-party audience, signature, algorithm, time, nonce, and required flow hashes. |

Missing or implicit bindings remain unknown or failed.

## 3. Apply the security baseline

Use the reference for exact source and requirement strength.
At minimum, establish these properties when applicable:

- redirect URIs use exact registered string matching, with only the native loopback-port exception;
- client and authorization-server paths contain no open redirector;
- authorization responses use protected transport;
- public authorization-code clients use PKCE, and all code clients use `S256` unless an evidenced profile permits otherwise;
- the token endpoint rejects downgrade, wrong verifier, reused code, wrong client, and wrong redirect binding;
- multi-issuer clients bind the selected issuer to the initiating transaction and validate response issuer before code exchange;
- access tokens are audience-restricted, least-privileged, secret in storage and telemetry, and rejected by the wrong resource server;
- refresh tokens for public clients use sender constraint or rotation with family reuse detection;
- resource-owner-password credentials grant is absent;
- implicit or other front-channel access-token issuance is absent unless every named leakage and injection risk has evidenced mitigation;
- security-relevant proxy headers are replaced by the trusted proxy and the internal hop is protected;
- validation fails before any session, account link, token use, protected request, or user-visible authenticated state.

Do not report a control as satisfied from metadata support, configuration intent, library defaults, or happy-path behavior alone.

## 4. Verify identity and authorization separately

For OIDC, validate the ID Token as a complete protocol object before creating a session.
Bind the local federated identity to `(iss, sub)`.
Do not use email, display name, username, or an unqualified `sub` as the durable identity key.

For protected resources, validate the access token for its issuer, type, audience, time, sender binding, scope, and requested action.
An ID Token does not authorize an API call.

## 5. Construct attack and failure evidence

For every failed or high-impact unknown control, state:

- attacker capability and precondition;
- protocol artifact or decision compromised;
- violated invariant;
- observable impact and blast radius;
- existing controls and their limits;
- smallest correction property;
- negative test or observation that closes the finding.

Use only authorized local, disposable, or dedicated test systems.
Never probe a third-party identity service or production account by implication.
Never expose tokens, codes, cookies, credentials, keys, or customer identity data in output.

## 6. Define migration completion

For migration away from an insecure or weaker path:

1. inventory every client, callback, grant, token, and dependent resource;
2. define the secure target profile and compatibility boundary;
3. prevent downgrade during coexistence;
4. time-box every weaker transition with an owner and removal condition;
5. define token, credential, key, and session invalidation after cutover;
6. require negative, replay, concurrency, provider, and conformance evidence as applicable;
7. define containment and recovery if rollout fails.

## 7. Apply the verdict gate

Set `design-ready` only in `design` mode when the protocol profile, flows, transaction bindings, applicable controls, trust boundaries, failure behavior, and verification obligations are defined, and no unresolved fact can materially change the design.
Set `controls-satisfied` only in `assessment` mode when every applicable control is supported by inspected evidence, no applicable control is failed, and no material control remains unknown.
Set `controls-failed` only in `assessment` mode when at least one applicable control has a supported failure.
Set `migration-ready` only in `migration` mode when the secure target, complete legacy inventory, downgrade prevention, invalidation behavior, owned transition obligations, removal conditions, negative evidence, containment, and recovery are established.
Set `insufficient-evidence` when a load-bearing fact is unknown and that unknown prevents the verdict required by the selected mode.
Do not use `insufficient-evidence` to hide a supported failed control.

## Output

Report:

1. scope, mode, parties, flows, issuers, resources, and applicable standards;
2. transaction ledger and trust boundaries;
3. mode-specific control status:
   - in `design` mode, report each target control as `required | prohibited | not-applicable` with its source, strength, and verification obligation;
   - in `assessment` mode, report each deployed control as `satisfied | failed | unknown | not-applicable` with its source, strength, and evidence;
   - in `migration` mode, report the current assessment state, target `required | prohibited | not-applicable` state, transition obligation, and removal evidence for each changed control;
4. attack paths and negative tests for failures and material unknowns;
5. migration obligations when applicable;
6. residual risks, owners, exceptions, and review dates;
7. `OAuth/OIDC verdict: design-ready | controls-satisfied | controls-failed | migration-ready | insufficient-evidence`.

## Boundaries

Use `threat-modeling` for a system-wide threat model whose principal scope is broader than OAuth or OIDC protocol correctness.
Use `adversarial-review` for general patch or merge-readiness review.
Use `causal-debugging` when a concrete failure still needs causal isolation.
Use `incident-control` while security harm is active or escalating.
Return an accepted design or migration target to ordinary authorized execution.

## Failure conditions

Fail when OAuth is treated as authentication, an access token is used as an ID Token, a signed JWT is accepted without full context validation, standards status comes from memory, PKCE support is confused with enforcement, sender binding is not enforced by the resource server, missing evidence becomes compliance, happy-path success becomes security proof, or secrets enter the report.

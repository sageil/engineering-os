---
name: security-testing
description: Perform an authorized security assessment of a defined system using source review, configuration analysis, scanners, or active probes and return verified findings.
---

# Security Testing

## Contract

Determine which security objectives can be violated in the authorized scope and report only findings supported by reproducible or directly verifiable evidence.
Balance automated breadth with manual analysis of authorization, business logic, state, and trust boundaries.

Maintain one verdict:

- `no-confirmed-findings`
- `confirmed-findings`
- `scope-incomplete`
- `blocked`
- `unsafe-to-proceed`

## 1. Establish scope, authority, and safety

Require an explicit request for a security test, security audit, vulnerability assessment, penetration test, scanner run, or exploit verification.

Identify:

- exact applications, services, repositories, hosts, identities, tenants, and environments in scope;
- explicit exclusions and protected third parties;
- assessment owner and finding recipient;
- allowed read-only and active techniques;
- credential and role boundaries;
- rate, concurrency, data-volume, and test-window limits;
- prohibited effects and stop conditions;
- evidence handling, sensitive-data retention, and disclosure rules;
- monitoring, escalation, cleanup, and recovery contacts; and
- applicable security objectives, standards, prior findings, and known risks.

Repository access authorizes read-only inspection of that repository.
It does not authorize scanning external systems, using credentials, creating accounts, modifying data, bypassing controls, causing load, or exploiting a vulnerability.

Return `scope-incomplete` when the target or expected assessment coverage is undefined.
Return `blocked` when a required target, artifact, credential, environment, or safe observation path is unavailable.
Return `unsafe-to-proceed` when the requested technique exceeds authority, lacks bounded stop conditions, or can cause uncontrolled harm.
Continue only with separately authorized safer work that can still produce an honest result.

## 2. Build the assessment model

Read [testing-method.md](references/testing-method.md).

Map the actual attack surface before selecting tests:

- entry points and exposed assets;
- identities, roles, tenants, sessions, and authorization decisions;
- sensitive data, secrets, irreversible effects, and trust transitions;
- inputs, parsers, interpreters, files, URLs, commands, queries, templates, and output sinks;
- APIs, browser clients, mobile clients, asynchronous consumers, webhooks, administration, and recovery paths;
- dependencies, build and deployment identities, artifacts, and configuration; and
- agent, model, retrieval, memory, tool, and output boundaries when applicable.

Use current primary standards and platform documentation to choose relevant test classes.
Treat standards as coverage aids rather than proof that a test applies or a control fails.

## 3. Plan bounded tests

For each security objective, define:

- applicable actor and starting access;
- target boundary or control;
- test preconditions and data;
- safe procedure and expected secure result;
- observation that indicates violation;
- maximum effect, stop condition, and cleanup; and
- evidence required to confirm or reject the candidate finding.

Select the least harmful technique that can establish the claim.
Use source and configuration review, dependency analysis, static analysis, controlled requests, dynamic scanning, browser or mobile interaction, and manual multi-step probes only where each adds decision-relevant evidence.
Do not treat scanner count or taxonomy coverage as assessment quality.

## 4. Execute within authority

Preserve a command and request log with target, time, identity, inputs, relevant outputs, and cleanup state.
Use isolated or disposable test data when possible.
Rate-limit active work to the approved envelope and stop when monitoring or system behavior shows unexpected effect.

Do not retrieve more sensitive data, create more durable effects, increase privilege, persist access, or widen scope after enough evidence exists to establish the finding.
Do not evade monitoring or destructive safeguards unless the exact technique and effect are authorized.
Do not use a production denial-of-service test to prove resource exhaustion.

## 5. Verify candidate findings

Classify every candidate:

- `confirmed`: reachability, violated objective, control failure, and consequence are established by direct evidence or a bounded reproduction;
- `supported-not-exploited`: source, configuration, or protocol evidence establishes the defect and reachable consequence without active exploitation;
- `unconfirmed`: a material premise or consequence remains unverified;
- `false-positive`: evidence establishes that a safeguard, unreachable path, or invalid premise closes the claim;
- `out-of-scope`: confirmation would exceed the authorized target or technique.

Seek disconfirming evidence before reporting a finding.
A scanner alert, dependency advisory, missing header, suspicious source pattern, or absent inline check is a lead rather than a confirmed vulnerability.
Do not require exploitation when direct evidence already establishes the violated security invariant.
Do not claim exploitability when only a control weakness or version match is established.

## 6. Calibrate findings

For each `confirmed` or `supported-not-exploited` finding, report:

- exact target and affected versions or environments;
- violated security objective;
- actor, preconditions, entry point, and action sequence;
- boundary crossed or authority abused;
- observed result and minimal evidence;
- affected assets, consequence, and blast radius;
- relevant safeguards and why they do not close the path;
- severity and confidence based on evidence;
- safe reproduction or verification procedure;
- correction property and closure evidence; and
- cleanup, disclosure, and retest status.

Do not use a fixed severity because a taxonomy category matched.
Do not include secrets, active credentials, unnecessary personal data, or destructive payloads in the report.

## 7. Apply the assessment gate

Set `no-confirmed-findings` only when planned applicable coverage completed, no supported finding remains, and limitations are explicit.
Set `confirmed-findings` when at least one `confirmed` or `supported-not-exploited` finding survives verification.
Set `scope-incomplete` when the requested coverage cannot be defined responsibly.
Set `blocked` when required evidence or access is unavailable after safe in-scope alternatives are exhausted.
Set `unsafe-to-proceed` when the remaining requested work cannot stay within authority or bounded harm.

Absence of confirmed findings is not proof that the system is secure.

## Output

- Scope, authority, environment, exclusions, and safety controls
- Attack-surface and security-objective map
- Planned and completed coverage
- Confirmed or supported findings, ordered by severity
- Rejected, unconfirmed, and out-of-scope candidates when decision-useful
- Tool and evidence limitations
- Cleanup, disclosure, and retest state
- `Security-testing verdict: no-confirmed-findings | confirmed-findings | scope-incomplete | blocked | unsafe-to-proceed`

## Boundaries

Do not replace proactive threat modeling.
Do not review only a defined patch for merge readiness.
Do not command an active incident.
Do not implement remediation unless separately requested after the assessment completes.
Do not issue a launch-readiness verdict.
Use `secure-oauth-oidc` when the principal responsibility is protocol-specific OAuth or OpenID Connect control assessment rather than broader security testing.

## Failure conditions

Fail when authority is inferred, scope expands silently, active tests lack stop conditions, a scanner alert becomes a finding without verification, absence of an inline check is treated as absence of enforcement, exploit proof causes unnecessary harm, taxonomy determines severity, sensitive evidence is disclosed, cleanup is omitted, or a partial assessment is reported as complete security assurance.

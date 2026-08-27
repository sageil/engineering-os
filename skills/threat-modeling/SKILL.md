---
name: threat-modeling
description: >-
  Build an evidence-based threat model for a defined system, feature, data flow, trust
  boundary, or proposed design when the user explicitly requests threat modeling,
  abuse-case analysis, attack-surface analysis, or proactive security design assessment.
  Identify assets, identities, attacker capabilities, trust transitions, credible threat
  paths, control evidence, and residual risk. Do not use for active security incidents,
  change-specific patch review, OAuth or OpenID Connect protocol-specific security
  assessment, vulnerability scanning/exploitation, generic architecture discussion,
  compliance-only checklists, or remediation implementation.
---

# Threat Modeling

## Contract

Model how credible actors could violate established security objectives and determine whether prevention, detection, response, and recovery controls reduce each material path to explicitly owned residual risk.

Do not manufacture threats from generic taxonomies or treat a named control as evidence that it works.
Do not actively test, scan, exploit, or modify without separate authority.

Maintain one verdict:
- `modeled`
- `input-incomplete`
- `research-required`
- `no-material-threat-surface`
- `unacceptable-risk`

## 1. Establish scope and authority

Require system/design scope, environment, protected assets/objectives, identities/tenants/roles, trust assumptions, sensitive data/irreversible effects, available evidence, and decision/risk owner.
Require separate authority for active probing only when the requested assessment needs it.

Return `input-incomplete` rather than inventing a system model.

When a load-bearing fact could change threat reachability or priority, return:
`Routing request: research-before-solution`

## 2. Model the actual system

Trace relevant entry points, identities, authorization decisions, data flows, storage, secrets, admin paths, dependencies, asynchronous work, logging, and recovery.
Mark every trust transition and enforcement owner.
Distinguish intended diagrams from inspected implementation and deployed configuration.

## 3. Define credible actors and capabilities

Identify only actors applicable to scope.
State starting access, knowledge, resources, and constraints.
Do not assume unlimited capability when a narrower realistic actor changes the decision.

## 4. Generate threat hypotheses cheaply

Read [threat-analysis.md](references/threat-analysis.md).

Generate only enough detail to test threat eligibility.

Classify each threat hypothesis:
- `credible`: applicable actor + reachable entry + plausible path + violated security objective + material consequence;
- `rejected`: one of those load-bearing elements is contradicted by evidence;
- `research-needed`: eligibility depends on a material unverified system or external fact.

Do not elaborate `rejected` threats.
Do not present `research-needed` threats as established risks; return to research.

This gate exists to prevent taxonomy-driven threat inflation.

## 5. Analyze credible threat paths

For each `credible` path, state:
- actor and preconditions;
- entry point and action sequence;
- boundary crossed/authority abused;
- objective violated;
- affected asset/blast radius;
- prevention/detection/response/recovery controls;
- evidence for each control;
- bypass paths;
- residual gap and falsifying evidence.

## 6. Challenge control claims

Inspect where authorization, validation, isolation, integrity, confidentiality, rate limits, audit, alerting, revocation, and recovery are actually enforced.
Check alternate interfaces, admin routes, asynchronous consumers, caches, replicas, retries, exports, backups, and failure modes.

Treat documentation as intended behavior, tests as encoded expectations, runtime evidence as observed behavior.

## 7. Prioritize without false precision

Rank credible threats using impact, reachability, required privilege, exposure, attacker effort, blast radius, detectability, recoverability, and control strength.
Use qualitative severity when numeric likelihood lacks evidence.

## 8. Resolve residual risk

For every material residual risk, name owner, affected objective, evidence/control gap, accepted response, verification signal, and review/expiry condition.
Do not call risk accepted without authorized decision owner.

Return correction direction, not remediation implementation.

## 9. Apply the threat-model gate

Set `modeled` only when:
- system/trust boundaries are evidence-backed;
- candidate threats were eligibility-screened;
- material attack surface is covered without generic inflation;
- control claims were inspected and bypasses considered;
- residual risks have explicit owners/decisions;
- remaining uncertainty cannot change principal threats or priority.

Set `unacceptable-risk` when a required objective remains credibly violable without adequate control or authorized acceptance.
Set `input-incomplete` when the system scope, protected objectives, identities, trust assumptions, evidence, or risk owner is missing and cannot be established by inspection.
Set `research-required` when an identifiable load-bearing fact could change threat reachability or priority and a separate investigation can resolve it.
Set `no-material-threat-surface` only when the scoped system and trust boundaries are established and no hypothesis passes the credible-threat eligibility gate.

## Output

- Scope, environment, authority, security objectives
- System/assets/identities/data/trust model
- Threat eligibility screen when rejected hypotheses are decision-useful
- Credible threat paths
- Control evidence and bypass analysis
- Residual risks, owners, decisions
- Evidence gaps and model-change conditions
- `Threat-model verdict: modeled | input-incomplete | research-required | no-material-threat-surface | unacceptable-risk`

## Boundaries

Do not actively scan/exploit without authority.
Do not replace adversarial review.
Use `secure-oauth-oidc` when OAuth or OpenID Connect protocol correctness is the principal security scope.
Do not command active incidents.
Do not turn compliance categories into unsupported threats.
Do not implement remediation.
Do not issue launch/readiness verdict.

## Failure conditions

Fail when taxonomy becomes threat list without eligibility screening, intended architecture is treated as observed enforcement, attacker capability is unlimited without reason, authentication/authorization are collapsed, control existence is confused with effectiveness, a `research-needed` path is ranked as credible, residual risk has no owner, or remediation begins without authority.

---
name: threat-modeling
description: Build an evidence-based threat model for a defined system, feature, data flow, trust boundary, or proposed design when the user explicitly requests threat modeling, abuse-case analysis, attack-surface analysis, or proactive security design assessment. Identify assets, identities, attacker capabilities, trust transitions, credible threat paths, control evidence, and residual risk. Do not use for active security incidents, change-specific patch review, vulnerability scanning or exploitation, generic architecture discussion, compliance-only checklists, or remediation implementation.
---

# Threat Modeling

## Contract

Model how credible actors could violate established security objectives and determine whether prevention, detection, response, and recovery controls reduce each material path to an explicitly owned residual risk.
Do not manufacture threats from generic taxonomies or treat a named control as evidence that it works.
Do not test, scan, exploit, or modify a system without separate authority.

Maintain one verdict:

- `modeled`: The material attack surface, credible threat paths, control evidence, and residual risks are decision-sufficient.
- `input-incomplete`: The system boundary, assets, identities, data flows, security objectives, or applicable environment are missing.
- `research-required`: A load-bearing system or external-contract fact is unresolved and could change the threat model.
- `no-material-threat-surface`: The scoped change creates no meaningful security boundary, asset, identity, or untrusted-input effect.
- `unacceptable-risk`: A credible threat violates a required security objective without adequate control or authorized risk acceptance.

## 1. Establish scope and authority

Require:

- the system, feature, data flow, or proposed design in scope;
- applicable environment and deployment boundary;
- protected assets and security objectives;
- identities, tenants, roles, and trust assumptions;
- sensitive data and irreversible effects;
- available implementation, configuration, and operational evidence;
- the decision and risk owner;
- explicit authority for any active probing beyond read-only inspection.

Return `input-incomplete` rather than inventing a system model.
When a load-bearing fact is researchable and could change the threat paths or their priority, return `research-required` with `Routing request: research-before-solution` for a new routing decision.

## 2. Model the actual system

Trace decision-relevant entry points, identities, authorization decisions, data flows, storage, secrets, administrative paths, external dependencies, asynchronous work, logging, and recovery paths.
Mark every trust transition and the component that owns enforcement.
Distinguish intended diagrams from inspected implementation and deployed configuration.

## 3. Define credible actors and capabilities

Identify only actors applicable to the scope, such as anonymous external users, authenticated users, cross-tenant users, privileged operators, compromised dependencies, malicious insiders, automated abuse, or supply-chain actors.
State each actor's starting access, knowledge, resources, and constraints.
Do not assume unlimited capability when a narrower realistic model changes the decision.

## 4. Construct threat paths

Read [threat-analysis.md](references/threat-analysis.md) for attack-surface prompts, control analysis, and common blind spots.

For each credible path, state:

- actor and required preconditions;
- entry point and action sequence;
- trust boundary crossed or authority abused;
- security objective violated;
- affected asset and blast radius;
- existing prevention, detection, response, and recovery controls;
- evidence for each control;
- residual gap and falsifying evidence.

Discard paths that lack a reachable entry, applicable actor, violated objective, or material consequence.

## 5. Challenge control claims

Inspect where authorization, validation, isolation, integrity, confidentiality, rate limits, audit, alerting, revocation, and recovery are actually enforced.
Check bypass paths, alternate interfaces, administrative routes, asynchronous consumers, caches, replicas, retries, exports, backups, and failure modes when applicable.
Treat documentation as intended behavior, tests as encoded expectations, and runtime evidence as observed behavior.
Do not count one control several times because multiple documents repeat it.

## 6. Prioritize without false precision

Rank material threats using impact, reachability, required privilege, exposure, attacker effort, blast radius, detectability, recoverability, and existing control strength.
Use qualitative severity when numeric likelihood lacks evidence.
Prioritize paths that combine high consequence with weak prevention, delayed detection, difficult recovery, or broad tenant and data impact.

## 7. Resolve residual risk

For every material residual risk, name the owner, affected objective, evidence gap or control gap, accepted response, verification signal, and review or expiry condition.
Do not call a risk accepted without an authorized decision owner.
Return a correction direction, not a remediation implementation.

## 8. Apply the threat-model gate

Set `modeled` only when:

- the scoped system and trust boundaries are evidence-backed;
- credible actors and paths cover the material attack surface without generic threat inflation;
- control claims were inspected and bypasses considered;
- material residual risks have explicit owners and decisions;
- remaining uncertainty cannot change the principal threats or their priority.

Set `unacceptable-risk` when a required security objective remains credibly violable and no adequate control or authorized risk acceptance exists.

## Output

- Scope, environment, authority, and security objectives
- System, asset, identity, data-flow, and trust-boundary model
- Credible actors and threat paths
- Control evidence and bypass analysis
- Prioritized residual risks, owners, and decisions
- Evidence gaps and conditions that change the model
- `Threat-model verdict: modeled | input-incomplete | research-required | no-material-threat-surface | unacceptable-risk`

## Boundaries

Do not perform active scanning, exploitation, credential use, or destructive testing without separate explicit authority.
Do not replace change-specific adversarial review.
Do not command an active security incident.
Do not turn compliance categories into unsupported threats.
Do not implement remediation.
Do not issue a system launch or operational-readiness verdict.

## Failure conditions

Fail the skill when a taxonomy becomes a threat list without reachability, intended architecture is treated as observed enforcement, attacker capability is unlimited without reason, authorization and authentication are collapsed, control existence is confused with control effectiveness, residual risk has no owner, or remediation begins without authority.

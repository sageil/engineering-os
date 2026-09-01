# Engineering OS Capability Map

The default route is no skill.
Skills are exceptional capabilities, not lifecycle stages and not wrappers around ordinary tool actions.

## Selection rule

Select zero or one working skill for the unresolved responsibility.
When an incident is active, retain `incident-control` as supervisory context and permit one bounded working skill to coexist without taking operational command.
Do not activate a skill merely because the task involves inspecting, editing, building, testing, verifying, packaging, running, or deploying through an established procedure.
Do not activate another working skill merely for a tool action or routine substep.
Require a new routing decision before a handoff.

## Automatic capabilities

| Skill | Activate only when | Do not activate for |
| --- | --- | --- |
| `research-before-solution` | Material decision uncertainty could change credible solutions or their ranking. | Concrete failure diagnosis, routine repository inspection, or implementation with a selected mechanism. |
| `causal-debugging` | An observed failure needs reproduction and causal discrimination. | Implementing a known correction or ordinary validation. |
| `incident-control` | Production harm, recovery, or incident monitoring is active. | Ordinary bugs, maintenance, or post-incident analysis after command is transferred. |
| `testing` | Test design, writing, updating, or assessment is the current unresolved responsibility, including test changes required by authorized implementation. | Running existing tests, reporting coverage, routine verification, general change review, acceptance review, or causal diagnosis. |

## Request-only capabilities

| Skill | Required user intent | Additional gate |
| --- | --- | --- |
| `execution-planning` | Request a transition plan. | A selected solution still has material transition hazards. |
| `adversarial-review` | Request independent review, audit, approval, or merge-readiness assessment of a defined change. | A diff, plan, migration, configuration, or other change artifact and its baseline are available. |
| `architecture-assessment` | Request an architecture audit, assessment, review, or fitness verdict. | A defined existing or proposed system boundary, intended outcomes, review horizon, owner, and architecture evidence are available or can be inspected. |
| `security-testing` | Request a security test, security audit, vulnerability assessment, penetration test, scanner run, or exploit verification. | Targets, environment, scope, authority, allowed techniques, safety limits, evidence handling, and assessment owner are defined or can be established. |
| `acceptance-review` | Request a criterion-by-criterion acceptance verdict. | One current authoritative requirement artifact and the implementation subject are available. |
| `story-splitting` | Request product or backlog decomposition into vertical slices. | The parent outcome and decision owner are known, and unresolved rules do not materially change the split. |
| `reduce-system-complexity` | Request a net-mechanism reduction target or verification. | One existing behavior path and its conserved outcomes are selected. |
| `requirements-hardening` | Request specification, acceptance-criteria hardening, example mapping, or gap closure. | An accountable decision owner and authoritative artifact are known or can be established. |
| `secure-oauth-oidc` | Request OAuth or OpenID Connect security design, protocol assessment, hardening, or migration analysis. | The protocol parties, flows, issuers, resources, and primary standards can be established from evidence. |
| `knowledge-promotion` | Request durable knowledge capture. | The learning is verified, reusable, and worth maintaining. |
| `technical-writing` | Request creation or review of technical documentation, an RFC, a README, a pull request description, or a commit message. | The intended reader, document mode, and authoritative technical material are known. |
| `frontend-design` | Request visual design and implementation of a new interface or substantial redesign. | The product, audience, interface job, conserved behavior, and visual authority are known or can be established. |
| `threat-modeling` | Request a threat model, abuse-case analysis, attack-surface analysis, or proactive security design assessment. | The security scope, assets, identities, trust boundaries, and decision owner are defined or can be established from evidence. |
| `operational-readiness` | Request an operational-readiness, production-readiness, launch, or go-no-go assessment. | A real launch boundary, required outcomes, operating environment, and decision authority exist. |

## Ordinary execution

Routine authorized production implementation uses no Engineering OS skill.
When implementation requires new or updated behavior tests, `testing` may activate for that test responsibility.
The base agent follows repository instructions, makes the scoped change, and performs proportional verification.
Building an image, starting a container, running existing checks, and executing an approved deployment procedure remain ordinary execution actions.

## Handoff envelope

A skill may return a routing request but may not activate the next skill itself.
During an active incident, the routing envelope also preserves incident state, command authority, operational controls, communication cadence, and the boundary of the selected working skill.
Pass only:

- the completed verdict;
- decision-relevant evidence and exact artifacts;
- the selected outcome or unresolved question;
- invariants and constraints;
- material uncertainty;
- authority and scope;
- the condition that invalidates the handoff.

Do not pass private reasoning or low-value process narration.

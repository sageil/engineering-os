# Orchestration

Engineering OS installs skills for agent discovery through `SKILL.md` descriptions.
The default working selection is no skill.
The agent selects a skill only when its activation description matches the current unresolved responsibility.
`incident-control` remains supervisory context while an incident is active.

## Agent selection contract

Each installed `SKILL.md` description is the discovery and activation boundary available to the agent.

The default `full` profile installs every packaged skill.
Use the optional `automatic`, `custom`, or `none` profile only when the environment requires a smaller discoverable set.

## Routing algorithm

1. Start with `none`.
2. Identify the single unresolved responsibility, not the current tool action or lifecycle phase.
3. Check whether an automatic capability has all of its positive conditions and none of its exclusions.
4. Select a request-only capability only when the user requested its distinctive output.
5. Select at most one working skill.
6. Keep that selection stable while performing ordinary substeps.
7. Return to `none` when the working responsibility is complete.
8. Require a new routing decision before every handoff.
9. Preserve incident supervision across working-skill changes until resolution or explicit command transfer.

## Automatic routing

Use `incident-control` when production harm is active or escalating.
Use `causal-debugging` when an observed failure needs controlled reproduction and causal discrimination.
Use `research-before-solution` when material decision uncertainty could change the available solutions or their ranking.
Use `testing` when designing, writing, updating, or assessing meaningful behavior tests becomes the current unresolved responsibility, including when authorized implementation requires test changes.
Running existing tests, reporting coverage, or performing routine verification does not activate it.
Public API contract design, observability design, and architecture opportunity discovery remain conditional methods inside `research-before-solution` rather than separate discoverable skills.
When more than one appears applicable, choose the skill that owns the immediate unresolved responsibility rather than stacking them.

## Request-only routing

Use `execution-planning` only for a requested plan when a selected solution still has material transition hazards.
Use `adversarial-review` only for requested independent review of a defined change artifact.
Use `architecture-assessment` only for a requested audit, assessment, review, or fitness verdict of a defined existing or proposed architecture.
Use `security-testing` only for a requested security test, security audit, vulnerability assessment, penetration test, scanner run, or exploit verification with defined scope and authority.
Use `acceptance-review` only for a requested criterion-by-criterion verdict against one authoritative acceptance contract.
Use `story-splitting` only for requested product or backlog decomposition into independently valuable child stories.
Use `reduce-system-complexity` only for a requested net-mechanism-reduction target or verification.
Use `requirements-hardening` only for requested requirement discovery, acceptance-criteria hardening, example mapping, or gap closure before implementation.
Use `secure-oauth-oidc` only for requested OAuth or OpenID Connect security design, protocol assessment, hardening, or insecure-flow migration analysis.
Use `knowledge-promotion` only for requested durable capture.
Use `technical-writing` only for requested creation or review of technical documentation, an RFC, a README, a pull request description, or a commit message.
Use `frontend-design` only for requested visual design and implementation when a new interface or substantial redesign requires open decisions about layout, typography, color, imagery, motion, or interface copy.
Use `threat-modeling` only for a requested proactive security analysis of a defined system, feature, data flow, trust boundary, or design.
Use `operational-readiness` only for a requested launch or sustained-operation assessment with a defined operating boundary.

## Ordinary execution route

Use no skill when the outcome, mechanism, authority, and affected path are sufficiently clear for routine execution.
The base agent performs implementation and proportional verification under repository instructions.

The following actions do not independently justify a skill:

- reading or editing files;
- building an application or image;
- running tests or checks;
- verifying a completion claim;
- starting or stopping local containers;
- packaging an artifact;
- executing an approved deployment or rollback procedure.

## Escalation examples

Building an existing container image uses no skill.
Deploying a stateless container through an approved reversible procedure uses no skill.
Designing a zero-downtime migration with mixed versions and unsafe intermediate states may use `execution-planning` when the user requests the plan.
Investigating why a container repeatedly crashes may use `causal-debugging`.
Responding to a container that is corrupting customer data now uses `incident-control`.
Rewriting a verified migration procedure for application operators uses `technical-writing` when the user explicitly requests the artifact.
Designing and implementing a new visual direction for a product page uses `frontend-design` when the user explicitly requests the design work.
Modeling how a proposed multi-tenant export path could cross tenant boundaries uses `threat-modeling` when explicitly requested.
Deciding whether a service is ready for production traffic uses `operational-readiness` when explicitly requested.
Proving every accepted criterion for a completed feature uses `acceptance-review` when explicitly requested.
Assessing whether an existing or proposed system architecture is fit for stated outcomes uses `architecture-assessment` when explicitly requested.
Performing an authorized security audit or active security assessment uses `security-testing` when explicitly requested.
Splitting an epic into independently valuable outcomes uses `story-splitting` when explicitly requested.
Establishing whether a selected path can remove total mechanism uses `reduce-system-complexity` when explicitly requested.
Turning a fuzzy feature request into explicit behavior rules and examples uses `requirements-hardening` when explicitly requested.
Assessing redirect, PKCE, issuer, token, refresh, and identity bindings for an authorization deployment uses `secure-oauth-oidc` when explicitly requested.
Designing regression coverage required by an authorized implementation uses `testing` when test work becomes the current unresolved responsibility.
Running an existing test command remains ordinary execution and does not activate `testing`.

## Handoffs

A skill may return `Routing request: <skill-name>` when another responsibility becomes unresolved.
That output asks the agent or host to make a new discovery and activation decision.
Reject a handoff when the prior verdict is incomplete, evidence is missing, authority is absent, or the target responsibility is not currently necessary.
During an incident, preserve the incident timeline, controls, command authority, communication cadence, integrity status, and working-skill boundary across every routing decision.

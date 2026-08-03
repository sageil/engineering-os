# Orchestration

Engineering OS uses context gating rather than asking a model to resist every visible skill.
The default working selection is no skill.
Expose zero or one working skill for the current unresolved responsibility.
Retain `incident-control` as supervisory context while an incident remains active, allowing one bounded working skill to coexist without operational authority.

## Provider-neutral routing contract

`routing.yaml` is the canonical activation policy.
It defines automatic and request-only capabilities without relying on provider metadata.
An agent host, launcher, or other orchestration layer should read that policy and expose only the selected working `SKILL.md` body, plus `incident-control` when its supervisory state remains active.

If the host cannot gate context dynamically, use the installer profiles to limit which skills are discoverable.
The default `automatic` profile exposes only the three narrowly automatic capabilities.
The `full` profile is intended for environments with an external router or disciplined explicit selection.

## Routing algorithm

1. Start with `none`.
2. Identify the single unresolved responsibility, not the current tool action or lifecycle phase.
3. Check whether an automatic capability has all of its positive conditions and none of its exclusions.
4. Check request-only capabilities only when the user requested their distinctive output.
5. Select at most one working skill.
6. Keep that selection stable while performing ordinary substeps.
7. Return to `none` when the working responsibility is complete.
8. Require a new routing decision before every handoff.
9. Preserve incident supervision across working-skill changes until resolution or explicit command transfer.

## Automatic routing

Use `incident-control` when production harm is active or escalating.
Use `causal-debugging` when an observed failure needs controlled reproduction and causal discrimination.
Use `research-before-solution` when material decision uncertainty could change the available solutions or their ranking.
When more than one appears applicable, choose the skill that owns the immediate unresolved responsibility rather than stacking them.

## Request-only routing

Use `execution-planning` only for a requested plan when a selected solution still has material transition hazards.
Use `adversarial-review` only for requested independent review of a defined change artifact.
Use `knowledge-promotion` only for requested durable capture.
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
Modeling how a proposed multi-tenant export path could cross tenant boundaries uses `threat-modeling` when explicitly requested.
Deciding whether a service is ready for production traffic uses `operational-readiness` when explicitly requested.

## Handoffs

A skill may return `Routing request: <skill-name>` when another responsibility becomes unresolved.
That output is a request for the orchestrator to reconsider context, not permission for automatic activation.
Reject a handoff when the prior verdict is incomplete, evidence is missing, authority is absent, or the target responsibility is not currently necessary.
During an incident, preserve the incident timeline, controls, command authority, communication cadence, integrity status, and working-skill boundary across every routing decision.

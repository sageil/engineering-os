# Engineering OS Capability Map

The default route is no skill.
Skills are exceptional capabilities, not lifecycle stages and not wrappers around ordinary tool actions.

## Selection rule

Select zero or one skill for the unresolved responsibility.
Do not activate a skill merely because the task involves inspecting, editing, building, testing, verifying, packaging, running, or deploying through an established procedure.
Do not activate another skill for a substep.
Require a new routing decision before a handoff.

## Automatic capabilities

| Skill | Activate only when | Do not activate for |
| --- | --- | --- |
| `research-before-solution` | Material uncertainty could change the credible options or their ranking. | Routine implementation with an explicit mechanism and verified owning path. |
| `causal-debugging` | An observed failure needs reproduction and causal discrimination. | Implementing a known correction or ordinary validation. |
| `incident-control` | Production harm is active or escalating. | Ordinary bugs, maintenance, or post-incident analysis. |

## Request-only capabilities

| Skill | Required user intent | Additional gate |
| --- | --- | --- |
| `architecture-evolution` | Request structural option analysis. | Relevant research is complete and the decision changes durable boundaries. |
| `execution-planning` | Request a transition plan. | A selected solution still has material transition hazards. |
| `adversarial-review` | Request independent review, audit, or readiness assessment. | A defined artifact and baseline are available. |
| `knowledge-promotion` | Request durable knowledge capture. | The learning is verified, reusable, and worth maintaining. |

## Ordinary execution

Routine authorized implementation uses no Engineering OS skill.
The base agent follows repository instructions, makes the scoped change, and performs proportional verification.
Building an image, starting a container, running checks, and executing an approved deployment procedure remain ordinary execution actions.

## Handoff envelope

A skill may return a routing request but may not activate the next skill itself.
Pass only:

- the completed verdict;
- decision-relevant evidence and exact artifacts;
- the selected outcome or unresolved question;
- invariants and constraints;
- material uncertainty;
- authority and scope;
- the condition that invalidates the handoff.

Do not pass private reasoning or low-value process narration.

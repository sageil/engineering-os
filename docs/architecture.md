# Architecture

Engineering OS separates universal baseline behavior, provider-neutral routing, and exceptional procedural capabilities.

## Baseline behavior

`global-agents.md` contains only invariants that should survive across ordinary engineering tasks.
It covers evidence honesty, authority, preservation of user work, proportional verification, completion honesty, and skill scarcity.

Routine implementation belongs to the base agent under repository instructions.
It is not an installable capability because loading a general implementation methodology for every change adds context without creating a distinct responsibility.

## Routing policy

`routing.yaml` is the canonical provider-neutral activation contract.
It defines:

- no skill as the default;
- no more than one active responsibility-owning skill;
- automatic and request-only capabilities;
- ordinary actions that do not trigger skills;
- no automatic handoffs.

The strongest enforcement is context gating outside the executing model.
An orchestrator should select zero or one capability and expose only that skill body.
When dynamic gating is unavailable, the installer limits discoverability through profiles.

## Portable skill packages

Each directory under `skills/` contains:

- `SKILL.md` with portable activation metadata and the core workflow;
- optional `references/` loaded only when specialized detail is needed.

The portable core contains no provider-specific agent metadata.
Provider adapters may exist outside the core, but no skill depends on them.

## Responsibility boundaries

| Skill | Activation | Produces | Does not own |
| --- | --- | --- | --- |
| `research-before-solution` | Automatic for material uncertainty | Research verdict and evidence-grounded options | Planning or implementation |
| `causal-debugging` | Automatic for observed failure needing causal isolation | Causal verdict and correction constraints | Correction selection |
| `incident-control` | Automatic for active production harm | Controlled incident state and verified recovery | Ordinary debugging after stabilization |
| `architecture-evolution` | Request-only structural analysis | Structural consequence analysis | Final selection or rollout |
| `execution-planning` | Request-only hazardous transition plan | Executable transition plan | Research or execution |
| `adversarial-review` | Request-only independent review | Supported findings and review verdict | Implementation |
| `knowledge-promotion` | Request-only durable capture | Durable artifact or no-store verdict | Automatic memory growth |

## Handoffs

A skill may emit a routing request but cannot activate the next capability itself.
The orchestrator returns to the default `none` state, evaluates the new responsibility, and then exposes zero or one skill.
This prevents lifecycle diagrams and nested methodology calls from becoming mandatory execution chains.

## Evaluation architecture

Structural validation proves package integrity, provider neutrality, routing invariants, and installer behavior.
Behavioral evaluation separately measures whether each capability improves outcomes enough to justify activation and whether routine tasks correctly select no skill.

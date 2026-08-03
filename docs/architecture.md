# Architecture

Engineering OS separates universal baseline behavior, provider-neutral routing, exceptional working capabilities, and persistent incident supervision.

## Baseline behavior

`global-agents.md` contains only invariants that should survive across ordinary engineering tasks.
It covers evidence honesty, authority, preservation of user work, proportional verification, completion honesty, and skill scarcity.

Routine implementation belongs to the base agent under repository instructions.
It is not an installable capability because loading a general implementation methodology for every change adds context without creating a distinct responsibility.

## Routing policy

`routing.yaml` is the canonical provider-neutral activation contract.
It defines:

- no working skill as the default;
- no more than one active working skill;
- persistent `incident-control` supervision while an incident remains active;
- automatic and request-only capabilities;
- ordinary actions that do not trigger skills;
- no automatic handoffs.

The strongest enforcement is context gating outside the executing model.
An orchestrator should select zero or one working capability and expose only that skill body.
During an active incident, it should also retain the `incident-control` body and current incident state as supervisory context.
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
| `research-before-solution` | Automatic for material decision uncertainty | Research verdict and evidence-grounded options, including structural analysis when needed | Failure diagnosis, planning, or implementation |
| `causal-debugging` | Automatic for observed failure needing causal isolation | Causal verdict and correction constraints | Correction selection |
| `incident-control` | Automatic for active production harm | Supervisory incident state, controlled operations, and verified recovery | The bounded investigation or planning output of a coexisting working skill |
| `execution-planning` | Request-only hazardous transition plan | Executable transition plan | Research or execution |
| `adversarial-review` | Request-only independent review | Supported findings and review verdict | Implementation |
| `knowledge-promotion` | Request-only durable capture | Durable artifact or no-store verdict | Automatic memory growth |
| `technical-communication` | Request-only substantial technical communication | Reader-centered artifact and communication verdict | Research, correctness review, durable placement, implementation, or file-format work |
| `threat-modeling` | Request-only proactive security analysis | Evidence-backed threat paths, control analysis, and residual-risk verdict | Active incident command, patch review, scanning, or remediation |
| `operational-readiness` | Request-only launch or sustained-operation assessment | Evidence-backed readiness findings and go-no-go verdict | Patch review, deployment execution, active incident command, or remediation |

## Handoffs

A skill may emit a routing request but cannot activate the next capability itself.
The orchestrator returns to the default `none` working state, evaluates the new responsibility, and then exposes zero or one working skill.
If an incident remains active, its supervisory context survives the working-skill transition until resolution or explicit command transfer.
This prevents lifecycle diagrams and nested methodology calls from becoming mandatory execution chains.

## Contract and evidence architecture

Structural validation proves package integrity, provider neutrality, routing invariants, and installer behavior.
Contract fixtures preserve intended activation, restraint, verdict, authority, and handoff behavior without pretending that synthetic comparisons prove capability value.
Field evidence may record outcomes, failures, overhead, and user decisions from representative use, but it is an input to judgment rather than a release formula.

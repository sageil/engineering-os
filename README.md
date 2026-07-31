# Engineering OS

![Abstract evidence-gated Engineering OS visual](assets/engineering-os-hero.png)

Engineering OS is a provider-neutral, evidence-gated capability suite for AI engineering agents.
It makes no skill the default, exposes specialized methods only when their distinctive responsibility is necessary, and requires claims to match available evidence.

Version 4.1.0 contains seven specialized skills.
Routine implementation and proportional verification are baseline agent behavior, not an installable skill.
The foundational capability remains `research-before-solution`, which blocks solution options until decision-relevant research is complete.

Engineering OS does not claim world-class status from prose alone.
Every capability must earn its activation cost through paired behavioral evaluation across models and agent hosts.

## Context-gated operating model

```text
default: no skill

automatic, maximum one:
  research-before-solution
  causal-debugging
  incident-control

request-only, maximum one:
  architecture-evolution
  execution-planning
  adversarial-review
  knowledge-promotion

ordinary execution:
  inspect -> edit -> build -> test -> verify -> package -> run -> deploy
  no skill activation unless the unresolved responsibility changes
```

![Engineering OS context-gated routing from no skill to one specialized capability](assets/engineering-os-routing.svg)

`routing.yaml` is the provider-neutral activation contract.
It defines no skill as the default, permits only one active responsibility-owning skill, and prohibits automatic handoffs.

## Included skills

| Skill | Activation | Sole responsibility |
| --- | --- | --- |
| [`research-before-solution`](skills/research-before-solution/SKILL.md) | Automatic when material decision uncertainty exists | Establish decision-sufficient truth, then present evidence-grounded options. |
| [`causal-debugging`](skills/causal-debugging/SKILL.md) | Automatic for an observed failure needing causal isolation | Establish the smallest defensible causal chain. |
| [`incident-control`](skills/incident-control/SKILL.md) | Automatic during active or escalating production harm | Control harm, preserve evidence, and verify recovery. |
| [`architecture-evolution`](skills/architecture-evolution/SKILL.md) | Request-only | Evaluate expensive-to-reverse structural options. |
| [`execution-planning`](skills/execution-planning/SKILL.md) | Request-only | Design a safe transition when material execution hazards remain. |
| [`adversarial-review`](skills/adversarial-review/SKILL.md) | Request-only | Independently challenge a defined change and report supported findings. |
| [`knowledge-promotion`](skills/knowledge-promotion/SKILL.md) | Request-only | Promote verified learning into the strongest appropriate durable artifact. |

## Evidence before solutions

![Research evidence passes through disciplined checkpoints before solution paths emerge](assets/research-before-solution.png)

The research gate treats model memory as a source of hypotheses rather than evidence.
It requires the owning path, material boundaries, competing explanations, contradictions, and remaining uncertainty to be understood before solution construction begins.

## Why ordinary work uses no skill

Building, testing, verifying, packaging, running containers, and executing an established deployment procedure are actions inside ordinary execution.
They are not separate engineering responsibilities and do not justify loading a methodology.

Universal behavior remains concise in `global-agents.md`:

- inspect before consequential claims or changes;
- preserve unrelated work;
- verify proportionally;
- never report checks that did not complete successfully;
- communicate evidence and limitations honestly.

## Quick start

Requirements:

- Bash 3.2 or newer;
- `sha256sum` or `shasum`;
- an agent host that discovers `SKILL.md` packages, or an orchestration layer that can inject selected skill content.

Install the default `automatic` profile, which exposes only three narrowly automatic skills:

```bash
./scripts/install.sh --agents keep
```

Install all seven skills only when the host performs context gating or users explicitly select capabilities:

```bash
./scripts/install.sh --profile full --agents keep
```

Install an exact subset:

```bash
./scripts/install.sh \
  --skills research-before-solution,adversarial-review \
  --agents keep
```

Install only the optional global policy and no skills:

```bash
./scripts/install.sh --profile none --agents replace
```

Preview operations without changing files:

```bash
./scripts/install.sh --profile automatic --agents replace --dry-run
```

Skills install to `~/.agents/skills` by default.
Use `--skills-target` for another host's discovery directory.
The optional policy installs to `~/.agents/AGENTS.md` only when explicitly selected.

## Provider neutrality

The portable core contains no provider-specific agent metadata.
Each skill contains only `SKILL.md` and directly related references.
Host-specific adapters may be developed separately, but they are not required by or embedded in the capability definitions.

When dynamic context gating is unavailable, installer profiles enforce scarcity by limiting which skills are discoverable.
The `full` profile deliberately trades that protection for availability and should be used only with disciplined routing.

## Update

Refresh an installation while preserving its recorded profile:

```bash
./scripts/update.sh --agents keep
```

Pass `--profile` or `--skills` to change the exposed capability set deliberately.
An installation created before profile state existed migrates to the `automatic` profile unless the update command selects another profile.
The update path reconciles removed managed skills safely and stops before changes when managed content has been modified.

## Version 4.1 changes

- The default route is now no skill.
- Only one responsibility-owning skill may be active.
- Automatic handoffs are prohibited.
- The default installer exposes only automatic capabilities.
- `architecture-evolution`, `execution-planning`, `adversarial-review`, and `knowledge-promotion` are request-only.
- `implement-and-prove` was removed because ordinary implementation and proportional verification are baseline behavior.
- Provider-specific agent metadata files were removed.
- Routing evaluations now include container, build, test, deployment, and other no-skill traps.

## Uninstall

```bash
./scripts/uninstall.sh
```

The uninstaller removes only unchanged managed skills.
It preserves modified skills and safely restores pre-existing content from backups.

## Validate the package

Run structural and portability validation:

```bash
./scripts/validate.sh
```

Run installer profile and lifecycle smoke checks:

```bash
./scripts/test.sh
```

These checks validate package behavior, not model improvement.
Behavioral quality requires the paired evaluations described in [Evaluation](docs/evaluation.md).

## Repository map

```text
skills/             Seven provider-neutral capability packages
routing.yaml        Canonical activation and context-gating contract
scripts/            Profile-aware install, update, uninstall, and validation
docs/               Architecture, orchestration, installation, and evaluation
evals/              Trigger, no-skill, handoff, restraint, and end-to-end cases
benchmark/          Paired benchmark design and release criteria
global-agents.md    Optional minimal universal policy
manifest.yaml       Version, capability inventory, and default exposure set
skills.md           Human-readable capability routing map
assets/             README graphics
```

## Contributing

Read [Contributing](docs/contributing.md) before changing a skill.
Do not add skill prose without a failing behavioral case that demonstrates why the base agent needs it.
Delete or demote a skill when it duplicates baseline behavior or does not justify its activation cost.

## License

Engineering OS is available under the [MIT License](LICENSE).

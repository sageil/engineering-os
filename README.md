# Engineering OS

![Abstract evidence-gated Engineering OS visual](assets/engineering-os-hero.png)

Engineering OS is a set of specialized skills for AI engineering agents.
It works with any agent provider.
Agents use no skill by default and activate one only when a task requires its method.
Each skill requires agents to support their claims with available evidence.

Version 4.9.0 includes 16 skills.
Agents handle routine implementation and verify changes according to risk without an installable skill.
The `research-before-solution` skill prevents an agent from proposing solutions until it has enough evidence to make the decision.

Each skill has one responsibility, clear activation rules, a defined method, an evidence standard, and a required output.
Contract fixtures define expected behavior at these boundaries.
Field evidence from real tasks can show how the skills behave outside contract fixtures.

## How agents select skills

```text
default: no skill

automatic working skills, maximum one:
  research-before-solution
  causal-debugging
  testing

automatic supervisory context during an active incident:
  incident-control

request-only working skills, maximum one:
  execution-planning
  adversarial-review
  acceptance-review
  story-splitting
  reduce-system-complexity
  requirements-hardening
  secure-oauth-oidc
  knowledge-promotion
  technical-writing
  frontend-design
  threat-modeling
  operational-readiness

ordinary execution:
  inspect -> edit -> build -> test -> verify -> package -> run -> deploy
  no skill activation unless the unresolved responsibility changes
```

![Engineering OS routing from no working skill to one bounded capability with persistent incident supervision](assets/engineering-os-routing.svg)

An agent can use at most one working skill at a time.
During an active incident, `incident-control` can remain active as supervisory context while one working skill handles a limited task.

An agent host discovers installed skills through each skill's `SKILL.md` description.
The description defines when the agent activates the skill.

## Included skills

| Skill | When used | Responsibility |
| --- | --- | --- |
| [`research-before-solution`](skills/research-before-solution/SKILL.md) | Automatic when missing facts could change a technical decision | Collect enough evidence to make the decision, assess structural effects when needed, and then present supported options. |
| [`causal-debugging`](skills/causal-debugging/SKILL.md) | Automatic when an observed failure needs causal analysis | Identify the smallest causal chain that the evidence supports. |
| [`incident-control`](skills/incident-control/SKILL.md) | Automatic supervisory context during an active production incident or recovery | Limit harm, keep one owner in control, supervise limited working skills, and verify recovery. |
| [`testing`](skills/testing/SKILL.md) | Automatic when test design, writing, updating, or assessment becomes the unresolved responsibility | Decide whether tests provide useful evidence of behavior and which tests to keep, improve, combine, replace, or remove. |
| [`execution-planning`](skills/execution-planning/SKILL.md) | Request-only | Plan a safe transition when execution has material risks. |
| [`adversarial-review`](skills/adversarial-review/SKILL.md) | Request-only | Independently challenge a defined change and report supported findings. |
| [`acceptance-review`](skills/acceptance-review/SKILL.md) | Request-only | Check each criterion to decide whether an implementation satisfies one authoritative contract. |
| [`story-splitting`](skills/story-splitting/SKILL.md) | Request-only | Split a broad outcome into small stories that each deliver independent value. |
| [`reduce-system-complexity`](skills/reduce-system-complexity/SKILL.md) | Request-only | Define or verify a net reduction in system mechanisms while preserving accepted behavior. |
| [`requirements-hardening`](skills/requirements-hardening/SKILL.md) | Request-only | Turn product intent or an existing requirement into explicit, testable behavior without making decisions for the requirement owner. |
| [`secure-oauth-oidc`](skills/secure-oauth-oidc/SKILL.md) | Request-only | Design or assess end-to-end OAuth and OpenID Connect security invariants against current primary standards. |
| [`knowledge-promotion`](skills/knowledge-promotion/SKILL.md) | Request-only | Record verified learning in the most suitable durable artifact. |
| [`technical-writing`](skills/technical-writing/SKILL.md) | Request-only | Apply Diátaxis, Google developer style, Simplified Technical English, and Global English to technical documents. |
| [`frontend-design`](skills/frontend-design/SKILL.md) | Request-only | Design and implement a subject-specific visual direction while preserving product behavior and existing design constraints. |
| [`threat-modeling`](skills/threat-modeling/SKILL.md) | Request-only | Identify credible attack paths, verify controls, and record the owners of remaining risks in a defined security scope. |
| [`operational-readiness`](skills/operational-readiness/SKILL.md) | Request-only | Decide whether a system or release can operate, degrade, and recover with named owners. |

## Evidence before solutions

![Research evidence passes through disciplined checkpoints before solution paths emerge](assets/research-before-solution.png)

The research gate treats model memory as a source of hypotheses, not evidence.
Before an agent proposes a solution, it must inspect the owning path and relevant boundaries.
It must also test competing explanations, resolve material contradictions, and state any remaining uncertainty.

## Why ordinary work uses no skill

Agents do not need a skill to build, run existing tests, verify, package, run containers, or use an established deployment procedure.
These tasks use the agent's baseline behavior.

Universal behavior remains concise in `global-agents.md`:

- Inspect before consequential claims or changes.
- Preserve unrelated work.
- Match verification scope to the change risk.
- Never report checks that did not complete successfully.
- Communicate evidence and limitations honestly.

## Quick start

Requirements:

- Bash 3.2 or newer
- `sha256sum` or `shasum`
- An agent host that discovers `SKILL.md` packages

Install all 16 skills.
This is the default profile:

```bash
./scripts/install.sh --agents keep
```

Install only the four skills that can activate automatically.
Use this profile when the agent host must discover fewer skills:

```bash
./scripts/install.sh --profile automatic --agents keep
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
The same selection installs every packaged `lang/**` file under `~/.agents/lang/` so the policy can load only the language defaults needed for the current task.

## Provider neutrality

The portable core does not contain metadata for a specific agent provider.
Each skill contains only `SKILL.md` and directly related references.
You can develop host-specific adapters separately.
The skill definitions do not require or contain these adapters.

The default `full` profile installs every skill so that agents can discover each skill from its description.
Use the `automatic`, `custom`, or `none` profile when the agent host must discover fewer skills.

## Install or update

Refresh an installation while preserving its recorded profile:

```bash
./scripts/install.sh --agents keep
```

Pass `--profile` or `--skills` to change the installed skill set.
The manifest defines the valid skill names.
The installer rejects unknown skill names before it changes the target directory.
During an update, the installer removes managed skills that are no longer in the selected profile.
If managed content has changed, the installer stops before it makes changes.
Use `--replace-modified` to back up changed managed skills and replace them with the packaged versions.

## Version 4.9 changes

- Version 4.9.0 adds the `testing` skill for test design and test-suite quality decisions.
- Version 4.9.0 adds the request-only `frontend-design` skill for substantial visual design and implementation work.
- The `testing` skill includes examples for behavior, test-data factories, weak coverage metrics, mutation testing, test scope, and test organization.
- The universal policy now requires tests to prove behavior through the public interface at the layer named by the claim.
- New installations include all 16 skills.
- The `automatic` profile contains four skills.

## Uninstall

```bash
./scripts/uninstall.sh
```

The uninstaller removes only unchanged managed skills.
It preserves modified skills and restores pre-existing content from backups.

## Validate the package

Run structural and portability validation:

```bash
./scripts/validate.sh
```

Run installer profile and lifecycle smoke checks:

```bash
./scripts/test.sh
```

These checks validate package structure, routing, contract coverage, and installer behavior.
See [Evaluation](docs/evaluation.md) for contract-fixture and field-evidence guidance.

## Repository map

```text
skills/             Sixteen provider-neutral capability packages
routing.yaml        Maintainer-only routing inventory and validation fixture
scripts/            Profile-aware install, update, uninstall, and validation
lang/               Language defaults loaded only when the policy routes to them
docs/               Architecture, orchestration, installation, and evaluation
evals/              Trigger, no-skill, handoff, restraint, and end-to-end contract fixtures
benchmark/          Optional field-observation dimensions and scenarios
global-agents.md    Optional minimal universal policy and language router
manifest.yaml       Version, capability inventory, and default exposure set
skills.md           Human-readable capability routing map
assets/             README graphics
```

## Contributing

Read [Contributing](docs/contributing.md) before changing a skill.
A skill must own a useful responsibility that baseline behavior, the global policy, and existing skills do not own.
When you change activation, restraint, verdict, authority, or handoff behavior, update the matching contract fixtures.

## License

Engineering OS is available under the [MIT License](LICENSE).
See [Third-party notices](THIRD_PARTY_NOTICES.md) for adapted material and its license terms.

<p align="center">
  <img src="assets/hero-banner.png" alt="Engineering OS — teaching AI agents how experienced engineers think" width="100%">
</p>

<h1 align="center">Engineering OS</h1>

<p align="center"><strong>Teaching AI agents how experienced engineers think.</strong></p>

<p align="center">
Engineering OS is an open engineering methodology that turns AI coding agents from code generators into evidence-driven engineering collaborators.
</p>

<p align="center">
  <a href="#getting-started">Get Started</a> ·
  <a href="#the-method">The Method</a> ·
  <a href="#capabilities">Capabilities</a> ·
  <a href="#architecture">Architecture</a> ·
  <a href="#roadmap">Roadmap</a>
</p>

---

## AI can write code.

That is not the hard part.

The hard part is engineering.

Coding agents often start before they understand the system, treat assumptions as facts, commit to the first plausible solution, and declare success after shallow verification. With standalone skills, you are still largely at the mercy of the model: whether it investigates, compares alternatives, challenges itself, or remembers what matters can vary from one task to the next.

Engineering OS makes those behaviours part of a repeatable engineering process.

<p align="center">
  <img src="assets/problem-comparison.png" alt="Traditional AI compared with Engineering OS" width="100%">
</p>

---

## The method

Engineering OS gives agents a shared methodology instead of a loose collection of prompts.

Every task moves through the same disciplined lifecycle:

**Investigate → Decide → Plan → Build → Verify → Communicate → Learn**

The sequence is adaptive, not bureaucratic. Small, obvious work stays small. Ambiguous or consequential work receives deeper investigation, planning, and verification.

<p align="center">
  <img src="assets/engineering-lifecycle-and-system.png" alt="Engineering OS lifecycle, judgment kernel, capabilities, and workflow" width="100%">
</p>

---

## One philosophy. Every capability.

Every capability inherits the same Engineering Judgment Kernel:

- Reality over intuition.
- Evidence over assumptions.
- Truth over consistency.
- Judgment over speed.
- Reversibility over cleverness.
- Systems over components.
- Humans over optimization.
- Learning over remembering.

The kernel keeps the capabilities consistent even when different models or harnesses perform the work.

---

## Capabilities

Engineering OS is made of independent, composable capabilities.

| Capability | Governing question |
|---|---|
| Engineering Investigation | What is actually true? |
| Engineering Decision | What is the strongest practical choice? |
| Engineering Economics | Is the change worth its lifetime cost? |
| Plan Gate | What is the safest execution strategy? |
| Engineering Quality | What should be built, and how well? |
| Debugging | Where exactly is the defect? |
| Testing | What evidence proves the behaviour? |
| Refactoring | How can the system improve without changing behaviour? |
| Architecture Review | Will this remain a healthy system? |
| Systems Thinking | What second-order effects follow? |
| Incident Response | What is the safest next action under pressure? |
| Change Management | How does this reach production safely? |
| Engineering Communication | How do we transfer the correct mental model? |
| Adversarial Code Review | Can the change be shown to be unsafe? |
| Engineering Memory | What knowledge should survive? |
| Learning & Knowledge Capture | What should permanently improve after this work? |

---

## From prompting to engineering

Prompt engineering tells a model what to do.

Skill engineering teaches a model a task.

Engineering OS gives the model a coherent engineering methodology—shared principles, decision gates, evidence standards, verification habits, and learning loops.

That produces more consistent outcomes across models because the process no longer depends entirely on whatever reasoning pattern the model happens to use in the moment.

---

## Architecture

Engineering OS is layered like an operating system:

1. **Engineering Work** — bugs, features, migrations, incidents, refactors, research.
2. **Capabilities** — focused engineering disciplines that compose as needed.
3. **Engineering Judgment Kernel** — shared principles and reasoning models.
4. **Models & Tooling** — LLMs, search, linters, runtimes, observability.
5. **Runtime Services** — memory, context, evaluations, profiles, and telemetry.

<p align="center">
  <img src="assets/architecture-decision-benchmark.png" alt="Engineering OS architecture, decision engine, and benchmark preview" width="100%">
</p>

---

## Engineering compounds

Engineering OS does not stop when the code works.

The result of each task can become stronger system knowledge:

**Observation → Investigation → Decision → Implementation → Review → Documentation → Automation → Institutional Memory**

The best lessons move into their strongest home: code, tests, CI, documentation, runbooks, decision records, or memory. The system improves instead of repeating the same mistakes.

---

## A production bug, two outcomes

### Without Engineering OS

1. Guess the cache is broken.
2. Rewrite the cache.
3. Run shallow tests.
4. Discover production still fails.
5. Start over.

### With Engineering OS

1. Establish the observed behaviour.
2. Generate credible competing hypotheses.
3. Inspect repository and runtime evidence.
4. Disprove incorrect explanations.
5. Choose the smallest justified correction.
6. Verify the fix adversarially.
7. Capture the reusable lesson in the right artifact.

The difference is not more ceremony. It is less rework and better decisions.

---

## Getting started

```bash
git clone https://github.com/sageil/engineering-os.git
cd engineering-os
./scripts/install.sh --profile balanced
```

Profiles let teams choose how strongly Engineering OS shapes agent behaviour:

- **Lightweight** — essential investigation, quality, and review.
- **Balanced** — the complete recommended methodology.
- **Strict** — stronger gates for consequential engineering work.

---

## Model and tool agnostic

Engineering OS is designed to work across agents and harnesses that support durable instructions or discoverable skills. The methodology does not depend on one model, framework, language, or repository type.

The capabilities remain independently discoverable, while a small global bootstrap policy ensures the most important behaviours—evidence before edits, alternatives before commitment, and honest verification—are always present.

---

## Visual system

The included visual assets establish a shared language for the lifecycle, capabilities, kernel, architecture, and future benchmark.

<p align="center">
  <img src="assets/brand-system-dark.png" alt="Engineering OS visual identity and design system" width="100%">
</p>

A light design-system reference is also included at [`assets/brand-system-light.png`](assets/brand-system-light.png).


## Contributing

Engineering OS is open by design.

Contributions should improve engineering judgment, not merely add more instructions. New capabilities must have a clear responsibility, inherit the shared kernel, avoid duplicating existing capabilities, and include evaluations that demonstrate real behavioural value.

---

## License

MIT

---

<p align="center">
  <strong>Engineering OS does not try to make AI write more code.</strong><br>
  It teaches AI agents how experienced engineers think.
</p>

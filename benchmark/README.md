# Engineering OS Benchmark

The benchmark measures marginal skill utility, not the persuasiveness of skill prose.

## Experimental unit

Each task pins:

- repository commit or immutable artifact;
- requirements and acceptance criteria;
- environment and dependencies;
- model and reasoning configuration;
- agent scaffold and tool permissions;
- baseline context;
- candidate skill set;
- deterministic verifier when possible.

Run the same task in baseline and candidate conditions.
Change only skill availability.
Repeat nondeterministic conditions and preserve every raw trajectory and output.

## Conditions

- `baseline`: Global product instructions and repository instructions without Engineering OS skills.
- `global-policy`: Baseline plus `global-agents.md` only.
- `single-skill`: Global policy plus the one candidate skill.
- `automatic-profile`: Global policy plus only the manifest automatic skills.
- `context-gated-suite`: Global policy plus only the skill selected for the current responsibility.
- `full-discovery-suite`: Global policy plus all manifest skills, included as an overactivation stress condition.
- `smaller-suite`: Global policy plus the smallest plausible competing skill set.

The smaller-suite condition tests whether composition earns its additional context and routing complexity.
The full-discovery condition tests whether exposing every capability causes waste relative to context gating.

## Scoring

Use deterministic acceptance checks for code and operational tasks.
Use blinded calibrated reviewers for evidence quality, option usefulness, communication, and other irreducibly judgment-based outcomes.
Measure safety constraints separately from average quality.

Report each model and scaffold independently.
Report confidence intervals or run-to-run dispersion.
Do not hide negative deltas in an aggregate score.

## Release decisions

Predeclare a primary outcome, safety constraints, and overhead budget for each skill.
Keep a skill installable only when it provides a reproducible improvement, meaningful efficiency gain, or prevention of a high-consequence baseline failure.
Demote conditional methods to references when separate activation adds no value.
Move universal invariants to global policy when retrieval is unreliable.
Delete guidance that adds cost without useful behavioral change.

## Result status

This repository includes benchmark design and evaluation cases, not completed comparative results.
Do not describe version 4.1.0 as world-class until those results exist and satisfy the release criteria.

# Findings and Severity

## Finding validity gate

Report a finding only when every applicable statement is true:
- the reviewed change introduces, exposes, or materially worsens it;
- the triggering condition is reachable under the applicable contract;
- the violated invariant or requirement is established;
- existing safeguards do not prevent the outcome;
- the consequence is observable and material enough to act on;
- evidence supports confidence and severity.

Discard the finding when a load-bearing statement fails.
Use `insufficient-evidence` when an important statement cannot be verified.

## Severity

Use impact, likelihood, blast radius, detectability, recoverability, and urgency.

- **Critical:** credible immediate catastrophic security, irreversible widespread data loss, severe safety impact, or comparable release-blocking harm.
- **High:** credible major correctness, security, integrity, availability, or compatibility failure requiring correction before release.
- **Medium:** credible bounded defect or operational problem that should be corrected but may not block in every release context.
- **Low:** small supported issue with limited consequence and straightforward containment.

Do not inflate severity because a subsystem is important.
Do not lower severity because correction is difficult.

## Confidence

- **High:** direct reproduction, decisive test, static guarantee, or converging verified evidence.
- **Moderate:** path and consequence are well supported but one environmental/runtime condition remains unexecuted.
- **Low:** do not report as an established finding.

Convert low-confidence concerns into limitations, questions, or research.

## Blocking decision

Block when expected harm, irreversibility, security/data impact, compatibility commitment, or recovery difficulty outweighs delay cost.
Do not automatically block every valid issue.

## Correction direction

Recommend the smallest **property change** that restores the invariant.
Do not prescribe an architecture when multiple solutions could satisfy that property.
Separate the defect from optional improvement.

# Findings and Severity

## Finding validity gate

Report a finding only when every applicable statement is true:

- The reviewed change introduces, exposes, or materially worsens it.
- The triggering condition is reachable under the applicable contract.
- The violated invariant or requirement is established.
- Existing safeguards do not prevent the outcome.
- The consequence is observable and material enough to act on.
- Evidence supports the confidence and severity.

Discard the finding when a load-bearing statement fails.
Use `insufficient-evidence` when the statement is important but cannot be verified.

## Severity

Use severity based on impact, likelihood, blast radius, detectability, recoverability, and urgency.

- **Critical:** Credible immediate risk of catastrophic security breach, irreversible widespread data loss, severe safety impact, or comparable harm that must block release.
- **High:** Credible major correctness, security, data integrity, availability, or compatibility failure affecting important users or operations and requiring correction before release.
- **Medium:** Credible bounded defect or operational problem that should be corrected but may not justify blocking under all release conditions.
- **Low:** Small supported issue with limited consequence and straightforward containment.

Do not inflate severity because a subsystem is important.
Do not lower severity because the correction is difficult.

## Confidence

- **High:** Direct reproduction, decisive test, static guarantee, or converging verified evidence establishes the finding.
- **Moderate:** The path and consequence are well supported, but one environmental or runtime condition remains unexecuted.
- **Low:** Do not report as an established finding.

Convert low-confidence concerns into questions, limitations, or further research rather than findings.

## Blocking decision

Block when expected harm, irreversibility, security or data impact, compatibility commitment, or recovery difficulty outweighs the cost of delay.
Do not automatically block every valid issue.
State the condition under which a medium finding becomes blocking when context matters.

## Correction direction

Recommend the smallest direction that restores the invariant.
Avoid prescribing architecture without researching alternatives.
Separate the defect from optional improvement.

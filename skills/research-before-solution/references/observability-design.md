# Observability Design

Use this method when an eligible option defines or materially changes telemetry, service indicators or objectives, alert policy, sampling, cardinality, or telemetry privacy and cost.
Design for decisions and action, not for signal volume.

## Start with questions and outcomes

Identify the user and operator questions that telemetry must answer.
Map them to critical journeys and to healthy, degraded, failed, and recovered outcomes.

Examples of decision-relevant questions include:

- Which user outcome is failing or slow?
- Which tenant, region, dependency, version, or operation is affected?
- Is work delayed, duplicated, rejected, stale, or lost?
- Did recovery restore the semantic outcome?
- Which control can contain the problem?

Do not select signal types or a telemetry stack before the required questions and actions are clear.

## Build a signal contract ledger

For each required observation, record:

- the question or invariant it supports;
- producer and owning execution path;
- event or measurement semantics;
- dimensions and expected cardinality;
- correlation and context-propagation requirements;
- sensitive-data classification and redaction;
- sampling, aggregation, and loss tolerance;
- retention and query horizon;
- expected volume and cost owner;
- consuming dashboard, alert, investigation, SLI, audit, or reconciliation;
- operator action and owner; and
- verification that can show the signal is accurate and available.

Prefer one semantically complete structured event when it reduces fragile reconstruction across many disconnected lines.
Do not make wide events universal when metrics, traces, audit records, or domain reconciliation provide the clearer contract.

## Control cardinality, privacy, and cost

Use bounded dimensions for metrics.
Place high-cardinality identifiers only in approved signals and stores where their diagnostic value, access, retention, and cost are explicit.

Do not record secrets, credentials, tokens, or unnecessary personal data.
Treat payload capture as a separate authorized data decision.

Set budgets for telemetry volume, cardinality, retention, and query cost when they can affect system viability.
Sampling and aggregation must preserve the questions, service indicators, and rare failure evidence they are expected to support.

## Define service indicators and objectives

Define the population of valid events and the good-event condition for each indicator.
Use journey outcomes, correctness, freshness, durability, and latency distributions where applicable.
Do not use process uptime as a substitute for a user or operator outcome.

For each objective, state:

- indicator formula and data source;
- included and excluded traffic;
- threshold and measurement window;
- sampling or loss assumptions;
- error-budget owner and action; and
- invalidation conditions for the measurement.

## Design actionable alerts

Alert on urgent, actionable symptoms or exhausted risk budgets when possible.
Each alert must identify the affected outcome, owner, threshold or condition, expected action, escalation path, runbook, and known blind spots.

Use multi-window or burn-rate policies when they fit the service objective and current tooling.
Do not require one alert technique for every system.
Avoid alerts that only restate an internal cause without showing operational consequence.

## Account for telemetry failure

Define how the system detects and handles lost context, dropped telemetry, delayed export, collector failure, backend unavailability, clock skew, and invalid measurement.
Telemetry loss must not silently improve an SLI or hide a release-blocking outcome.
State which local or independent evidence remains available when the telemetry path fails.

## Compare eligible designs

Compare designs against the same failure and investigation scenarios.
Include signal accuracy, loss behavior, cardinality, privacy, cost, owner action, version skew, and backend portability where they are material.

Treat vendor, collector, instrumentation, and storage choices as implementation facts that require current primary evidence when they can change feasibility or ranking.
Do not embed one telemetry vendor or library as a universal design.

## Verification obligations

Define focused checks that can disprove the design:

- known requests produce the expected correlated signals;
- failures and recovery produce distinct observable outcomes;
- dimensions remain within bounds;
- sensitive data is absent or correctly controlled;
- sampling and loss do not invalidate indicators;
- alerts reach the named owner and lead to a bounded action; and
- telemetry-path failure is itself observable.

Configuration presence or a dashboard screenshot alone does not prove the signal contract.

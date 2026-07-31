# Experimental Method

## Prefer discriminating experiments

Choose an experiment by how many credible explanations it can separate, not by how much data it produces.
State the prediction before running the experiment.
Record a control and the factor being changed.
Reject post-hoc stories that were not predicted unless a new experiment tests them.

## Isolate boundaries

Trace the failure across input, validation, transformation, persistence, concurrency, external dependency, and presentation boundaries.
Use binary search to locate the first boundary where actual state diverges from expected state.
Verify the boundary's input and output rather than assuming ownership from filenames or service names.

## Handle intermittent failures

Record frequency, timing, load, ordering, resource pressure, cache state, retries, clocks, and shared mutable state.
Use repeated trials with controlled seeds or schedules when possible.
Compare distributions rather than isolated samples.
Do not call a failure resolved because it did not recur in a small uncontrolled sample.

## Handle concurrency

Model actors, shared state, synchronization, ordering constraints, and permitted interleavings.
Seek a deterministic schedule or reduced reproducer.
Instrument ordering carefully because logging and breakpoints can hide or create races.
Distinguish data races, logical races, deadlocks, starvation, duplication, and lost work.

## Handle performance anomalies

Define the constrained resource and baseline before optimizing.
Measure latency distributions, throughput, saturation, allocation, I/O, and dependency time as applicable.
Separate warmup, cache effects, workload differences, and observer overhead.
Do not infer the bottleneck from aggregate CPU or wall-clock time alone.

## Use counterfactual evidence

Strong causal support usually combines:

- failure with the suspected mechanism present;
- success when the mechanism is removed or controlled;
- failure again when the mechanism is restored;
- preservation of adjacent behavior.

Use the strongest safe approximation when exact reversal is impossible.
State the remaining causal uncertainty.

## Protect evidence

Keep raw timestamps, inputs, traces, and commands separate from interpretation.
Avoid destructive cleanup until evidence is preserved.
Remove temporary instrumentation after the investigation, or document its deliberate retention and cost.

# Performance Investigation

Use this method when the observed failure is latency, throughput, resource consumption, queue delay, memory growth, startup time, frame instability, or another performance anomaly.

## Define the performance failure

State the affected outcome, workload, environment, version, time window, metric definition, expected range, observed distribution, and consequence.
Distinguish regression, saturation, leak, tail-latency, burst, capacity, cold-start, and measurement failures.

Do not compare results from materially different workloads, data shapes, hardware, configuration, cache state, warmup, regions, or instrumentation without bounding the difference.

## Preserve a comparable workload

Capture request or operation mix, concurrency, payload and data size, arrival pattern, test duration, warmup, cache state, dependencies, background work, and rate controls.
Use the smallest representative workload that preserves the anomaly.

Record whether the workload is open-loop or closed-loop.
Account for coordinated omission when a load generator waits for slow responses before sending more work.

## Decompose the observation

Measure only relevant signals:

- end-to-end latency distribution and timeout rate;
- throughput and completed useful work;
- CPU, run queue, throttling, and scheduler delay;
- allocation, retained memory, collection pauses, and memory pressure;
- disk, filesystem, network, connection-pool, and database waits;
- dependency and queue time;
- lock, contention, retry, duplicate, and backpressure behavior;
- client rendering, main-thread work, frame time, and asset transfer; and
- telemetry overhead and dropped observations.

Separate service time, queue time, network time, dependency time, and client time when the evidence permits.
Do not infer a bottleneck from aggregate CPU, averages, one profile, or temporal correlation alone.

## Form causal models

For each candidate bottleneck, state the resource or mechanism, predicted saturation signal, predicted workload sensitivity, expected control result, and falsifying observation.

Useful discriminating changes can include one bounded variation in concurrency, payload size, data volume, cache state, dependency latency, feature path, allocation rate, query shape, or resource limit.
Change one explanatory factor at a time when practical.

## Memory growth

Distinguish expected retained state, cache growth, fragmentation, delayed collection, unbounded queueing, and unreachable-object retention.
Compare retained ownership after equivalent work and quiescence.
Do not call increasing resident memory a leak without evidence that unintended state remains reachable or cannot be reclaimed as designed.

## Database and queue delay

For database work, preserve the exact query shape, parameters, data distribution, plan, statistics, indexes, lock state, connection wait, and transaction context.
For queued work, measure arrival rate, service rate, age, retries, poison work, concurrency, and drain behavior.
Queue depth alone cannot distinguish a short healthy burst from sustained overload.

## Establish cause

Require a controlled or strongly discriminating comparison that changes the predicted outcome while preserving adjacent behavior.
Repeat enough trials to distinguish the effect from ordinary variation.
Report confidence intervals or distributions when they materially affect the conclusion.

After the causal gate passes, state performance correction constraints and the benchmark, load, profile, or runtime observation that must disprove a regression.
Do not select caching, batching, concurrency, indexing, compression, memoization, sharding, or another correction before the cause is established.

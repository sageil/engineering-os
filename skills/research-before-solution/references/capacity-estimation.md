# Capacity Estimation

Use this method when workload, latency, data growth, availability, resource limits, or operating cost can eliminate or materially reorder solution options.
Estimate only the quantities that can change the decision.

## Establish the input contract

Record each input with source, unit, time window, environment, confidence, and decision effect.
Separate:

- measured current values;
- accepted target values;
- reported values;
- derived values;
- explicit assumptions; and
- unknown values.

Do not replace a missing requirement with an industry default when the value can change the architecture.
Use ranges and named scenarios when uncertainty is material.

## Model workload shape

Describe the workload in terms that match the system:

- actors, tenants, devices, or producers;
- normal and peak request, event, or job rates;
- read and write mix;
- concurrency and connection duration;
- payload and transfer volume;
- burst duration and recurrence;
- queue arrival, service, age, and drain rates;
- stored-data growth, retention, replication, and backup volume; and
- hot working set and locality.

An average does not establish peak capacity.
A peak rate without duration does not establish backlog, storage, or recovery demand.

## Derive transparent quantities

Show the formula, units, assumptions, and range for each derived result.
Applicable relationships can include:

- rate from actions divided by time;
- concurrency from arrival rate multiplied by service time;
- transfer demand from rate multiplied by payload size;
- stored-data growth from write volume, record size, retention, and copies;
- queue growth from arrival rate minus service rate over burst duration;
- drain time from backlog divided by spare service rate;
- working set from active records and their resident size; and
- connection demand from concurrent actors and connections per actor.

Round results to the precision supported by the inputs.
Keep binary and decimal units explicit.
Do not import generic peak factors, latency constants, or component ceilings as local facts.

## Allocate budgets

When latency is material, allocate the end-to-end objective across local work, network hops, dependencies, queues, retries, and response processing.
Account for fan-out, tail latency, queue delay, timeout budgets, and retry amplification.
Do not add independent percentile values as if they describe one observed end-to-end percentile without a justified model.

When availability or recovery is material, identify serial dependencies, correlated failure domains, redundancy assumptions, recovery objectives, and allowed degraded outcomes.
Do not multiply nominal service objectives without checking shared dependencies and actual request paths.

## Compare demand with evidence-backed limits

For each eligible option, identify:

- limiting resources;
- applicable measured or documented limits;
- safe operating range and required headroom;
- saturation and overload behavior;
- backpressure or shedding behavior;
- scaling unit and scaling delay;
- failure mode when the limit is crossed; and
- observation that reveals approach to the limit.

Use benchmarks only when hardware, software, configuration, data shape, workload, and concurrency are sufficiently comparable.
Treat vendor maximums as boundary claims, not sustainable production capacity.

Identify the first constraint reached in each material scenario.
Do not add a cache, queue, replica, partition, shard, or region until an evidenced constraint requires its obligation.

## Include operating cost when it changes viability

Model the material cost drivers over the stated horizon:

- compute and baseline capacity;
- storage, replication, backup, and retention;
- data transfer and egress;
- managed-service or license commitments;
- redundancy and disaster-recovery capacity;
- observability and security processing; and
- operator ownership and support burden.

Use current applicable pricing evidence for external cost claims.
State cost ranges and sensitivity to the assumptions that dominate them.
Do not make initial development effort the primary architecture criterion.

## Test sensitivity

Vary the few assumptions that can change eligibility or ranking.
Name the threshold where an option becomes non-viable or another mechanism becomes necessary.
Do not vary every input when only one or two shape the decision.

## Output contribution

Add to the research record:

- input table with classifications and sources;
- workload scenarios and time windows;
- transparent calculations with units and ranges;
- limiting resources and evidence-backed ceilings;
- latency, availability, recovery, and cost budgets when material;
- sensitivity thresholds;
- facts that eliminate or reorder options; and
- verification signals and invalidation conditions.

Capacity estimates are decision evidence, not a guarantee.
Define the production measurements or tests that can disprove them.

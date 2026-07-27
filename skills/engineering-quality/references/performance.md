# Performance Review Reference

Load only when latency, throughput, memory, CPU, storage, cost, or scale is material.

Start with a requirement or measurement. Avoid optimization by intuition alone unless there is an obvious unbounded-resource defect.

Review:

- algorithmic complexity and realistic input sizes
- database round trips, N+1 behaviour, indexes, and query plans
- network calls, serialization, batching, and payload size
- blocking work on latency-sensitive paths
- memory retention, streaming, buffering, and unbounded collections
- concurrency limits and contention
- caching correctness, invalidation, and stampede risk
- benchmark representativeness and variance
- cold start versus steady state
- performance changes that reduce clarity or safety

Report the workload, environment, measurement method, and uncertainty. Do not generalize a microbenchmark beyond what it measured.

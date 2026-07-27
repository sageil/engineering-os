# API and Compatibility Review Reference

Load for public APIs, SDKs, schemas, events, command interfaces, or shared internal contracts.

Review:

- source, binary, behavioural, and data compatibility as applicable
- request and response validation
- error shape and status semantics
- idempotency and safe retry behaviour
- pagination, limits, filtering, and ordering guarantees
- timeouts and cancellation
- versioning and deprecation policy
- additive versus breaking changes
- tolerant readers and strict writers where appropriate
- mixed-version deployment and rollback
- migration guidance and sunset observability
- exposure of internal implementation details

A syntactically additive change can still be behaviourally breaking. Verify real clients and consumers when possible.

# API Compatibility Reference

Load when request/response schemas, public methods, events, command formats, or shared contracts change.

Check:

- field removal, rename, type, nullability, default, and semantic changes
- error-code and status changes
- pagination, ordering, retry, and idempotency semantics
- old/new client interoperability
- rollout sequencing and deprecation windows
- unknown-field tolerance and version negotiation

Compatibility is behavioural, not merely syntactic.

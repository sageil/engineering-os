# Go language defaults

Apply these defaults when working in Go unless repository-local instructions or clearly established project conventions specify otherwise.

## Data shape and boundaries

- Validate untrusted input at package or service boundaries.
- Decode boundary data into typed structs before it reaches domain logic.
- Do not pass `map[string]any`, `map[string]interface{}`, `any`, `interface{}`, or raw JSON through production code after decoding unless the domain truly requires arbitrary data.
- Keep type assertions, reflection, and raw map indexing inside boundary readers or narrowly scoped adapters.
- Use pointers, `sql.Null*`, custom nullable types, or `omitempty` only when absence is real boundary or domain semantics.
- Do not use nil pointers, empty strings, zero numbers, or zero time values as hidden substitutes for required data.
- If a value is required after validation, represent it as required in the normalized struct and return an error when missing.
- Constructors and setup functions should validate required dependencies once and return concrete initialized structs.
- Prefer small named decoder, normalizer, or constructor functions over repeated nil checks across call sites.

## Errors and resources

- Add useful operation or boundary context when propagating an error, and preserve the cause with `%w` when callers must inspect it.
- Use `errors.Is` and `errors.As` for error identity and type checks.
- Do not branch on error strings.
- Log or return an error at the layer that owns the response or recovery action.
- Avoid repeated logging at every call layer.
- Keep resource acquisition and cleanup close together with `defer` when the function lifetime matches the resource lifetime.
- Handle a cleanup error when it can change correctness or the reported outcome.

## Concurrency and cancellation

- Pass `context.Context` explicitly for request-scoped cancellation and deadlines.
- Do not store a request context in a long-lived struct or replace it with `context.Background()` to evade cancellation.
- Give every goroutine a lifecycle owner, a bounded start condition, and an exit path.
- Bound fan-out according to the limiting resource, such as a connection pool, external quota, memory budget, or CPU capacity.
- Use channels for communication and ownership transfer when they clarify the protocol.
- Use a mutex or another synchronization primitive when it expresses simple shared-state ownership more clearly.
- Make the sender that owns a channel responsible for closing it.
- Do not close a receive-only channel or close a channel only to signal one task when cancellation already owns that responsibility.

## Verification

- Format touched Go files with the repository's configured formatter.
- Run focused package tests for changed behavior.
- Run the race detector on affected tests when concurrency or shared state changes.
- Run the repository's configured static checks when the changed path can affect them.
- Before finalizing Go changes, scan touched files for repeated nil checks, raw map access, scattered type assertions, ignored errors, unowned goroutines, unbounded fan-out, and optional fields required for normal production behavior.

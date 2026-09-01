# Python language defaults

Apply these defaults when working in Python unless repository-local instructions or clearly established project conventions specify otherwise.

## Data shape and boundaries

- Treat type hints as documentation and static-analysis input, not runtime validation.
- Validate untrusted data at boundaries before it enters core application logic.
- Prefer dataclasses, typed models, `TypedDict`, or project-standard validation models over unstructured `dict[str, Any]` in application code.
- Keep `Any`, raw dictionaries, `getattr`, `hasattr`, repeated `.get(...)` defaults, and ad hoc type checks inside boundary readers or adapters.
- Do not pass partially validated dictionaries through multiple layers.
- If production behavior requires a value, make it required in the normalized model and fail during parsing when missing.
- Use `Optional[...]` or `T | None` only when `None` is meaningful domain data.
- Do not use `None`, empty strings, empty collections, or sentinel defaults to hide missing required values.
- Prefer small named `parse_*`, `read_*`, `decode_*`, or `normalize_*` functions over local defensive checks at every call site.
- Validate dependencies and configuration once at startup or construction, then pass concrete initialized objects through the system.

## Language and resource lifetime

- Use `field(default_factory=...)` or an equivalent project-standard factory for mutable dataclass defaults.
- Prefer immutable dataclasses or value objects when the modeled contract must not change after construction.
- Prefer `pathlib.Path` for new path manipulation when it fits the project style.
- Use timezone-aware datetimes for persisted, exchanged, or user-visible instants, and make timezone conversion explicit at the boundary.
- Keep import-time work minimal.
- Do not start services, read volatile runtime state, or perform external I/O as an incidental import side effect.
- Use context managers or `try` and `finally` so files, locks, transactions, and other resources are released on every exit path.

## Exceptions and asynchronous work

- Catch the narrowest exception that the current boundary can handle correctly.
- Preserve the original cause when raising a new exception with material context.
- Do not use a broad exception handler to convert an unknown failure into success.
- Log an exception at the layer that owns the response, retry, or terminal action instead of at every propagation layer.
- Keep blocking database, network, filesystem, and subprocess calls out of event-loop code.
- When a blocking library is required, isolate it once at an explicit adapter boundary and preserve cancellation and resource limits.
- Give every background task a lifecycle owner, stop condition, cleanup path, and observation of terminal failure.
- Propagate `asyncio.CancelledError` after cleanup unless the protocol explicitly owns cancellation suppression.
- Use structured concurrency when the supported Python version and sibling-task failure semantics make it applicable.
- Bound asynchronous fan-out according to the limiting dependency or resource.

## Security-sensitive boundaries

- Pass subprocess arguments as a sequence and keep `shell=False` unless the shell is the explicit, fully controlled subject.
- Parameterize database queries instead of composing SQL from untrusted values.
- Resolve and validate an untrusted path against its approved root before filesystem access.
- Do not deserialize untrusted data with `pickle` or evaluate it as Python code.
- Keep secrets out of source, fixtures, logs, errors, and generated artifacts.

## Verification

- Run the repository's configured formatter, linter, and type checker only where the changed path requires them.
- Run focused tests for changed behavior and affected exception, timeout, cancellation, and cleanup paths.
- Before finalizing Python changes, scan touched files for repeated `.get(...)` chains, broad `Any`, scattered `isinstance` checks, broad exception handlers, blocking calls in async code, orphan tasks, and optional fields required for normal production behavior.

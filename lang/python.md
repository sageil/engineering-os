# Python data shape and boundary rules

Apply these defaults when working in Python unless repository-local instructions or clearly established project conventions specify otherwise.

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
- Before finalizing Python changes, scan touched files for repeated `.get(...)` chains, broad `Any`, scattered `isinstance` checks, and optional fields required for normal production behavior.

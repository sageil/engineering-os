# Rust data shape and boundary rules

Apply these defaults when working in Rust unless repository-local instructions or clearly established project conventions specify otherwise.

- Validate untrusted input at boundaries before it reaches domain logic.
- Deserialize or convert boundary data into typed structs and enums before passing it through application code.
- Prefer domain types, newtypes, and enums that make invalid states unrepresentable.
- Do not pass `serde_json::Value`, `HashMap<String, Value>`, `Box<dyn Any>`, or loosely typed maps through production code after boundary decoding unless the domain truly requires arbitrary data.
- Keep dynamic JSON access, downcasting, stringly typed dispatch, and ad hoc key lookups inside boundary adapters or serializers.
- Use `Option<T>` only when absence is meaningful domain data or part of an external DTO contract.
- If production behavior requires a value, represent it as `T` after validation and return an error when missing.
- Do not use empty strings, zero numbers, empty collections, or default values to hide missing required data.
- Prefer `Result<T, E>` with clear error types over panics for boundary validation and recoverable failures.
- Constructors and configuration loaders should validate required dependencies once and return concrete initialized structs.
- Prefer named `parse_*`, `decode_*`, `try_from`, `new`, or `normalize_*` functions over repeated local validation at call sites.
- Before finalizing Rust changes, scan touched files for repeated `Option` unwrapping, scattered `serde_json::Value` access, stringly typed state, unnecessary `unwrap` or `expect`, and optional fields required for normal production behavior.

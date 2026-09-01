# Go data shape and boundary rules

Apply these defaults when working in Go unless repository-local instructions or clearly established project conventions specify otherwise.

- Validate untrusted input at package or service boundaries.
- Decode boundary data into typed structs before it reaches domain logic.
- Do not pass `map[string]any`, `map[string]interface{}`, `any`, `interface{}`, or raw JSON through production code after decoding unless the domain truly requires arbitrary data.
- Keep type assertions, reflection, and raw map indexing inside boundary readers or narrowly scoped adapters.
- Use pointers, `sql.Null*`, custom nullable types, or `omitempty` only when absence is real boundary or domain semantics.
- Do not use nil pointers, empty strings, zero numbers, or zero time values as hidden substitutes for required data.
- If a value is required after validation, represent it as required in the normalized struct and return an error when missing.
- Constructors and setup functions should validate required dependencies once and return concrete initialized structs.
- Prefer small named decoder, normalizer, or constructor functions over repeated nil checks across call sites.
- Before finalizing Go changes, scan touched files for repeated nil checks, raw map access, scattered type assertions, and optional fields required for normal production behavior.

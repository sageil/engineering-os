# TypeScript data shape and boundary rules

Apply these defaults when working in TypeScript unless repository-local instructions or clearly established project conventions specify otherwise.

- Avoid large inline conditional-spread object literals.
- Avoid replacing them with long repeated `if (x !== undefined) target.x = x` blocks.
- Do not copy optional fields one by one through production code unless constructing a narrow external DTO where absence is part of the contract.
- If more than two optional fields are being copied, prefer a boundary decoder, normalized typed object, or named DTO builder.
- Validate untrusted data exactly once at the boundary.
- Boundaries include HTTP request bodies, database rows, external provider responses, JSON parsing, workflow or activity payloads and results, environment variables, CLI input, and filesystem metadata.
- Name boundary readers clearly, such as `read*`, `parse*`, `decode*`, or `normalize*`.
- After validation, pass concrete typed objects through the system and avoid repeating the same defensive checks downstream.
- Prefer typed API, workflow, activity, and persistence contracts over `Record<string, unknown>` in internal application code.
- Optional properties are only for genuinely optional domain data.
- If production behavior requires a value, make it required after normalization and fail at the boundary when missing.
- Do not make properties optional merely to simplify construction.
- With `exactOptionalPropertyTypes`, prefer normalized objects or small named builders near the boundary when omission is semantically distinct from present `undefined`.
- Before finalizing TypeScript changes, scan touched files for repeated conditional-spread construction, repeated undefined-copy blocks, downstream type checks against already typed data, new unstructured payloads, and optional fields required for normal production behavior.

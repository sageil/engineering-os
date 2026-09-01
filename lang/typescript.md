# TypeScript language defaults

Apply these defaults when working in TypeScript unless repository-local instructions or clearly established project conventions specify otherwise.

## Data shape and boundaries

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

## Type modeling

- Keep the repository's strict compiler checks enabled.
- Do not weaken compiler options to make one change compile.
- Use `unknown` for values whose type is not established, including caught values, and narrow or decode them before use.
- Use discriminated unions for closed state variants and make switches exhaustive when every variant requires behavior.
- Prefer literal unions or `as const` objects over runtime enums when only a closed set of values is required.
- Use explicit types for exported and cross-boundary contracts while allowing clear local values to remain inferred.
- Use `readonly` for contracts that must not be mutated after construction.
- Avoid type assertions and non-null assertions when narrowing or a better data model can prove the invariant.
- Use a narrow, documented assertion only when the invariant is established locally and cannot be represented cleanly.

## Control flow and asynchronous work

- Avoid nested callbacks and inline object construction inside `map`, `flatMap`, `reduce`, or chained array methods when the logic has branching, validation, or multiple derived fields.
- Prefer explicit loops, local variables, and named intermediate values for multi-step transformations.
- Run independent asynchronous work in parallel only when ordering, resource limits, cancellation, and partial failure are defined.
- Do not use `Promise.all` for unbounded input or for operations that must stop after the first durable effect fails.

## Security-sensitive boundaries

- Use parameterized database APIs instead of composing queries from untrusted values.
- Pass a static executable and a separate argument array to process APIs instead of interpolating a shell command.
- Validate untrusted URLs, redirects, and filesystem paths against the authority and root that own the operation.
- Treat generated HTML, script, query, template, and command fragments as executable sinks that need the matching encoder or safe API.
- Keep secrets out of source, fixtures, logs, errors, and generated artifacts.

## Verification

- Prefer a narrow `@ts-expect-error` with a reason over `@ts-ignore` when a verified external type mismatch cannot be represented another way.
- Run the repository's configured formatter, linter, type checker, and focused tests in proportion to the change.
- Before finalizing TypeScript changes, scan touched files for repeated conditional-spread construction, repeated undefined-copy blocks, downstream type checks against typed data, new `any` or unstructured payloads, unsafe assertions, unbounded promise fan-out, and optional fields required for normal production behavior.

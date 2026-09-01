# .NET C# data shape and boundary rules

Apply these defaults when working in C# unless repository-local instructions or clearly established project conventions specify otherwise.

- Enable and respect nullable reference types in modern C# projects.
- Validate untrusted input at boundaries before it reaches domain or application services.
- Use typed request, response, domain, and persistence models instead of `dynamic`, `object`, `ExpandoObject`, `JObject`, or `Dictionary<string, object?>` in application code.
- Keep dynamic access, reflection, and loose dictionary reads inside boundary adapters or serializers.
- Use `required`, constructors, init-only properties, value objects, or validation attributes where they match the project style.
- If production behavior requires a value, represent it as non-null after validation and fail at the boundary when missing.
- Use nullable properties only when null is meaningful domain data or required by an external DTO contract.
- Do not suppress nullability warnings with `!` unless the invariant is proven locally and cannot be represented cleanly in the type system.
- Validate options and required dependencies once during startup or construction, then inject concrete initialized services and option objects.
- Prefer named mapper, decoder, validator, or factory functions over repeated null checks across handlers and services.
- Before finalizing C# changes, scan touched files for repeated null guards, `dynamic`, loose object dictionaries, null-forgiving operators, and nullable properties required for normal production behavior.

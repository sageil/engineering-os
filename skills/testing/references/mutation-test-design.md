# Mutation-Aware Test Design

Read this reference when realistic code mutations can reveal whether assertions protect the selected behavior.

Use these operators to design counterexamples and to interpret survivors.
Do not claim that a test killed a mutant unless the mutation was applied and the test failed for the expected reason.

## Quick scan

| Production construct | Challenge |
| --- | --- |
| Arithmetic | Change the operator and avoid identity-only inputs |
| Comparison | Move the boundary and test both sides plus equality |
| Equality | Exercise equal and not-equal values |
| Boolean logic | Use mixed truth values that distinguish `&&` from `||` |
| Returned value | Change the result variant, value, or collection contents |
| Side effect | Remove, delay, duplicate, or reorder the effect when those changes are observable |
| String or collection operation | Remove filtering, trimming, sorting, casing, or contents |
| Optional value | Remove safe handling of `null` or `undefined` when the contract promises it |
| Error mapping | Return the wrong public error, status, or retry classification |
| Authorization | Remove identity, role, tenant, or scope filtering |

## Numeric boundaries

For a meaningful threshold, test just below, exactly at, and just above the boundary when all three values have defined behavior.

Bad:

```typescript
it("uses bulk processing for large orders", () => {
  expect(selectProcessingPath(buildItems(150))).toBe("bulk");
});
```

This case does not distinguish `items.length >= 100` from `items.length > 100`.

Good:

```typescript
it.each([
  { count: 99, expected: "standard" },
  { count: 100, expected: "bulk" },
  { count: 101, expected: "bulk" },
])("selects $expected processing for $count items", ({ count, expected }) => {
  expect(selectProcessingPath(buildItems(count))).toBe(expected);
});
```

If the exact boundary is not authoritative, ask for the smallest owner decision instead of encoding the current comparison as product intent.

## Arithmetic and identity values

Choose inputs that distinguish the intended operation from plausible alternatives.

Bad:

```typescript
it("calculates the total", () => {
  expect(addFee(50, 0)).toBe(50);
  expect(scaleWeight(10, 1)).toBe(10);
});
```

Adding or subtracting zero and multiplying or dividing by one can produce the same result.

Good:

```typescript
it("adds the fee to the subtotal", () => {
  expect(addFee(50, 7)).toBe(57);
});

it("scales the weight by the package count", () => {
  expect(scaleWeight(10, 3)).toBe(30);
});
```

Also choose values that reveal rounding, truncation, sign, overflow, or unit-conversion behavior when those risks apply.

## Boolean combinations

All-true and all-false cases often do not distinguish `&&` from `||`.

Bad:

```typescript
it("grants access", () => {
  expect(canAccess({ isAdmin: true, isOwner: true })).toBe(true);
});
```

Good:

```typescript
it.each([
  { isAdmin: true, isOwner: false, expected: true },
  { isAdmin: false, isOwner: true, expected: true },
  { isAdmin: false, isOwner: false, expected: false },
])("returns $expected for the access combination", (scenario) => {
  expect(canAccess(scenario)).toBe(scenario.expected);
});
```

Do not infer the missing combination when the contract does not define it.

## Equality and result variants

Assert enough of the public result to detect a wrong branch or wrong result kind.

Bad:

```typescript
it("rejects an existing member", async () => {
  const result = await inviteMember(existingMember);

  expect(result.ok).toBe(false);
});
```

This can remain green when the implementation returns the wrong rejection reason.

Good:

```typescript
it("rejects an invitation for an existing member", async () => {
  const result = await inviteMember(existingMember);

  expect(result).toEqual({
    code: "already-member",
    kind: "rejected",
  });
});
```

Prefer a complete stable result value when the public contract is a discriminated result.
Avoid asserting unstable diagnostic fields that are not part of the contract.

## Collections, strings, and ordering

Use examples where filtering, casing, trimming, sorting, and non-empty contents affect the observable result.

Bad:

```typescript
it("returns active members", () => {
  const members = [buildMember({ active: true })];

  expect(listActiveMembers(members)).toHaveLength(1);
});
```

Removing the filter still returns one member.

Good:

```typescript
it("returns active members and excludes inactive members", () => {
  const active = buildMember({ active: true, id: "active" });
  const inactive = buildMember({ active: false, id: "inactive" });

  expect(listActiveMembers([inactive, active])).toEqual([active]);
});
```

Assert order only when order is accepted behavior.
Otherwise compare contents without coupling the test to an internal ordering choice.

## Optional and missing values

Test missing values when safe absence handling is part of the contract.

Bad:

```typescript
it("shows the display name", () => {
  expect(getDisplayName({ profile: { name: "Ada" } })).toBe("Ada");
});
```

This does not detect removal of optional handling.

Good:

```typescript
it.each([
  { user: { profile: { name: "Ada" } }, expected: "Ada" },
  { user: {}, expected: "Anonymous" },
])("returns $expected for the profile state", ({ user, expected }) => {
  expect(getDisplayName(user)).toBe(expected);
});
```

Do not add `null` or `undefined` cases when the validated boundary makes those states impossible.

## Side effects and ordering

An empty-body mutation survives when a test only asserts that the operation does not throw.

Bad:

```typescript
it("processes the order", async () => {
  await processOrder(order);

  expect(true).toBe(true);
});
```

Good:

```typescript
it("persists the confirmed order before publishing it", async () => {
  const result = await processOrder(order);

  expect(result).toEqual({ kind: "confirmed", orderId: order.id });
  expect(await orderRepository.read(order.id)).toMatchObject({ status: "confirmed" });
  expect(publishedEvents()).toContainEqual({ kind: "order-confirmed", orderId: order.id });
});
```

The example proves result, persistence, and publication.
It does not prove persistence happens before publication unless the test also observes that ordering through a declared contract or a failure experiment.

When ordering matters, design an observable case where the wrong order changes the public result, durability, or recovery behavior.
Do not spy on internal call order only because the implementation currently uses two helpers.

## Authorization and error mapping

Security and multi-tenant filters need positive and negative examples with distinct identities or scopes.

Bad:

```typescript
it("lists projects", async () => {
  expect(await listProjects(owner)).toHaveLength(1);
});
```

The case can stay green when the tenant filter is removed and only one project exists.

Good:

```typescript
it("does not return projects from another tenant", async () => {
  const ownProject = await createProject({ tenantId: "tenant-a" });
  await createProject({ tenantId: "tenant-b" });

  const result = await listProjects({ tenantId: "tenant-a" });

  expect(result).toEqual([ownProject]);
});
```

For error mapping, use inputs that cause each material downstream failure and assert the public status, code, retryability, or message contract.

## Equivalent mutants

An equivalent mutant has no observable difference from the original behavior.
It cannot be killed by a useful test.

Potential examples include dead paths, operations with identity constants, or branches with identical observable outcomes.

Do not classify a survivor as equivalent only because no current test kills it.
Explain why no valid input through the public interface can produce a different observable outcome.

If many equivalent mutants expose redundant branches or identity operations, record a production simplification opportunity without turning the testing assessment into implementation work.

## Decision checklist

Before reporting a mutation gap, confirm:

- the mutation changes accepted observable behavior;
- the selected public interface can reach that behavior;
- the input distinguishes the original from the mutation;
- the assertion observes the changed result or side effect;
- the mutation is not type-invalid, unreachable, or behaviorally equivalent; and
- an executed mutation claim names the exact mutation, test command, expected test, and observed failure.

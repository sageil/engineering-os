# Behavior Testing Examples

Read only the sections selected by `SKILL.md` for the current work.

Use the examples to reason about the evidence boundary.
Do not copy names, values, or structures when the subject has a different public contract.

## Contents

- Public behavior versus implementation structure
- Reaching validation through behavior
- HTTP evidence versus browser evidence
- Observable callbacks versus internal collaborator spies
- Mutation-aware boundary questions
- Extraction and test organization
- Test factories and isolated state
- Coverage theater
- Relevant execution scope

## Public behavior versus implementation structure

The following tests prove how the implementation is organized rather than what the public operation does.

```typescript
it("calls validateAmount", () => {
  const spy = vi.spyOn(validator, "validateAmount");

  processPayment(payment);

  expect(spy).toHaveBeenCalled();
});

it("validates the CVV through a private method", () => {
  const result = validator._validateCVV("123");

  expect(result).toBe(true);
});

it("sets the internal validation flag", () => {
  processPayment(payment);

  expect(processor.isValidated).toBe(true);
});
```

An implementation can inline the validation, replace the validator, or remove the flag without changing payment behavior.
Those tests would fail after a behavior-preserving refactor.

Test the public result instead.

```typescript
it("rejects a negative payment amount", () => {
  const payment = getMockPayment({
    amountMinorUnits: -100,
    currency: "GBP",
  });

  const result = processPayment(payment);

  expect(result).toEqual({
    error: expect.stringContaining("Amount must be positive"),
    success: false,
  });
});

it("rejects an invalid CVV", () => {
  const payment = getMockPayment({ cvv: "12" });

  const result = processPayment(payment);

  expect(result).toEqual({
    error: expect.stringContaining("Invalid CVV"),
    success: false,
  });
});

it("processes a valid payment", () => {
  const payment = getMockPayment({
    amountMinorUnits: 10_000,
    currency: "GBP",
    cvv: "123",
  });

  const result = processPayment(payment);

  expect(result).toEqual({
    data: { transactionId: expect.any(String) },
    success: true,
  });
});
```

For a discriminated result, prefer asserting the complete result value.
This gives stronger mutation resistance and avoids relying on a separate boolean assertion to narrow the result type.

## Reaching validation through behavior

Reach validation branches through the operation whose behavior they protect.

```typescript
describe("processPayment", () => {
  it("rejects a negative amount", () => {
    const payment = getMockPayment({ amountMinorUnits: -100 });

    const result = processPayment(payment);

    expect(result).toEqual({
      error: expect.stringContaining("Amount must be positive"),
      success: false,
    });
  });

  it("rejects an amount above the accepted limit", () => {
    const payment = getMockPayment({ amountMinorUnits: 1_500_000 });

    const result = processPayment(payment);

    expect(result).toEqual({
      error: expect.stringContaining("Amount exceeds limit"),
      success: false,
    });
  });

  it("rejects an invalid CVV", () => {
    const payment = getMockPayment({ cvv: "12" });

    const result = processPayment(payment);

    expect(result).toEqual({
      error: expect.stringContaining("Invalid CVV"),
      success: false,
    });
  });

  it("accepts a valid payment", () => {
    const payment = getMockPayment();

    const result = processPayment(payment);

    expect(result).toMatchObject({ success: true });
  });
});
```

When coverage drops, ask which accepted behavior is not protected.
Do not create a direct validator test only to execute its branches when the validator is private implementation of a public operation.

## HTTP evidence versus browser evidence

This test proves an HTTP contract.

```typescript
it("creates a workspace through the HTTP API", async () => {
  const response = await server.inject({
    method: "POST",
    payload: { name: "Research" },
    url: "/api/workspaces",
  });

  expect(response.statusCode).toBe(201);
  expect(response.json()).toMatchObject({ name: "Research" });
});
```

It does not prove that a user can create a workspace through the browser.
It bypasses the control, form handler, browser security policy, cookies, redirects, loading state, error state, and rendering.

A browser claim requires a browser-initiated action and visible result.

```typescript
it("lets an administrator create and open a workspace", async ({ page }) => {
  await page.goto("/settings/workspaces");
  await page.getByRole("button", { name: "Create workspace" }).click();
  await page.getByLabel("Workspace name").fill("Research");
  await page.getByRole("button", { name: "Create" }).click();

  await expect(page.getByRole("heading", { name: "Research" })).toBeVisible();
  await expect(page).toHaveURL(/workspace=/);
});
```

Keep both tests when both the HTTP contract and browser journey are accepted behaviors with independent failure modes.
Name each test according to the narrowest evidence it actually proves.

## Observable callbacks versus internal collaborator spies

A mock-call assertion can prove behavior when the caller supplies the callback as part of the public contract.

```typescript
it("delivers each accepted message to the subscriber", () => {
  const onMessage = vi.fn();
  const subscription = subscribe(onMessage);

  subscription.publish({ id: "message-1", text: "Ready" });

  expect(onMessage).toHaveBeenCalledOnce();
  expect(onMessage).toHaveBeenCalledWith({
    id: "message-1",
    text: "Ready",
  });
});
```

The callback is supplied through the public interface, so its invocation and payload are observable outputs.

The following assertion proves only an internal choice.

```typescript
it("processes a payment", () => {
  const process = vi.spyOn(internalProcessor, "process");

  handlePayment(payment);

  expect(process).toHaveBeenCalledWith(payment);
});
```

Replace it with an assertion against the public result or accepted side effect.

```typescript
it("returns the completed transaction", async () => {
  const result = await handlePayment(getMockPayment());

  expect(result).toEqual({
    data: { transactionId: expect.any(String) },
    success: true,
  });
});
```

## Mutation-aware boundary questions

When a condition contains a meaningful boundary, test the boundary or obtain a product decision.

```typescript
function selectProcessingPath(items: readonly Item[]): "bulk" | "standard" {
  return items.length >= 100 ? "bulk" : "standard";
}
```

A test with 150 items does not distinguish `>= 100` from `> 100`.
Ask the decision owner when the exact boundary is not established.

```markdown
The bulk path uses `items.length >= 100`, but current tests cover only `150`.
Should exactly `100` items use the bulk path?

- Yes: protect `100` as the first bulk value.
- No: change and protect the rule as `items.length > 100`.
- Unspecified: record that the exact boundary is not guaranteed and do not invent a test expectation.
```

When the behavior is established, protect both sides of the boundary.

```typescript
it.each([
  { count: 99, expected: "standard" },
  { count: 100, expected: "bulk" },
])("selects $expected processing for $count items", ({ count, expected }) => {
  const items = Array.from({ length: count }, buildItem);

  expect(selectProcessingPath(items)).toBe(expected);
});
```

Use the same challenge for equality, boolean logic, ordering, optional values, arithmetic, string operations, and meaningful side effects.

## Extraction and test organization

Do not extract a single-use helper only to create a matching unit test.

This organization mirrors implementation instead of stable behavior.

```text
src/
  payment-validator.ts
  payment-processor.ts
  payment-formatter.ts
test/
  payment-validator.test.ts
  payment-processor.test.ts
  payment-formatter.test.ts
```

Prefer a behavior-oriented test when `processPayment` owns the public contract.

```text
src/
  payment-validator.ts
  payment-processor.ts
  payment-formatter.ts
test/
  process-payment.test.ts
```

The following extracted helper has one caller and no distinct public responsibility.

```typescript
export function prepareParticipantData(items: readonly Item[]) {
  return {
    available: items.filter((item) => !item.isClaimedByCurrentUser),
    yourClaims: items.filter((item) => {
      return item.isClaimed && item.isClaimedByCurrentUser;
    }),
  };
}
```

A direct helper test couples the suite to that extraction.

```typescript
it("filters claims", () => {
  expect(prepareParticipantData(items)).toEqual(expected);
});
```

Keep the filtering in its owning operation when it has no separate coherent contract, and test the owner.

```typescript
export async function loadParticipantView(
  database: Database,
  eventId: EventId,
  userId: UserId,
) {
  const items = await getItems(database, eventId, userId);
  const yourClaims = items.filter((item) => {
    return item.isClaimed && item.isClaimedByCurrentUser;
  });
  const available = items.filter((item) => !item.isClaimedByCurrentUser);

  return { available, yourClaims };
}

it("separates the participant's claims from available items", async () => {
  const result = await loadParticipantView(database, eventId, userId);

  expect(result.yourClaims).toHaveLength(1);
  expect(result.available).toHaveLength(2);
});
```

Extraction is justified when it creates a coherent reusable meaning, improves ownership, or creates a necessary dependency seam.
A file and its test can have a one-to-one relationship when that file is itself the public unit under test.

## Test factories and isolated state

Use a factory when repeated or nested data becomes clearer behind a named builder.
Keep one-off values inline.

Return complete valid data by default and make intentional invalidity explicit.

```typescript
function getMockUser(overrides: Partial<User> = {}): User {
  return UserSchema.parse({
    createdAt: new Date("2024-01-01"),
    email: "test@example.com",
    id: "user-123",
    isActive: true,
    name: "Test User",
    role: "user",
    ...overrides,
  });
}

it("creates a user with a custom email", () => {
  const user = getMockUser({ email: "custom@example.com" });

  const result = createUser(user);

  expect(result).toMatchObject({ success: true });
});
```

Reuse the production schema when it already owns the boundary contract.
Do not redefine that schema in the test.

For a narrow override surface, constrain the fields that a caller can change.

```typescript
type UserIdentityOverrides = Partial<Pick<User, "email" | "name">>;

function getMockUser(overrides: UserIdentityOverrides = {}): User {
  return UserSchema.parse({
    email: "test@example.com",
    id: "user-123",
    name: "Test User",
    role: "user",
    ...overrides,
  });
}
```

Compose factories for nested values.

```typescript
function getMockItem(overrides: Partial<Item> = {}): Item {
  return ItemSchema.parse({
    id: "item-1",
    name: "Test Item",
    weightGrams: 100,
    ...overrides,
  });
}

function getMockOrder(overrides: Partial<Order> = {}): Order {
  return OrderSchema.parse({
    customer: getMockCustomer(),
    id: "order-1",
    items: [getMockItem()],
    payment: getMockPayment(),
    ...overrides,
  });
}

it("calculates the total item weight", () => {
  const order = getMockOrder({
    items: [
      getMockItem({ weightGrams: 100 }),
      getMockItem({ id: "item-2", weightGrams: 200 }),
    ],
  });

  expect(calculateTotalWeightGrams(order)).toBe(300);
});
```

Do not share one mutable object across tests.

```typescript
const sharedUser: User = {
  email: "test@example.com",
  id: "user-123",
  name: "Test User",
  role: "user",
};

it("changes the user's name", () => {
  sharedUser.name = "Modified User";
});

it("starts with the default name", () => {
  expect(sharedUser.name).toBe("Test User");
});
```

Create fresh state for every case.

```typescript
it("changes the user's name", () => {
  const user = getMockUser({ name: "Modified User" });

  expect(user.name).toBe("Modified User");
});

it("starts with the default name", () => {
  const user = getMockUser();

  expect(user.name).toBe("Test User");
});
```

Do not hide missing required data behind an incomplete object cast.

```typescript
function getMockUser(): User {
  return {
    id: "user-123",
  } as User;
}
```

Build complete valid values and override only the fields relevant to the scenario.

## Coverage theater

### Mocking the function under test

This can report coverage while proving nothing about the real implementation.

```typescript
it("calls the validator", () => {
  const validate = vi.spyOn(validator, "validate");

  validator.validate(payment);

  expect(validate).toHaveBeenCalled();
});
```

Call the real public operation and assert its observable result.

```typescript
it("rejects an invalid payment", () => {
  const payment = getMockPayment({ amountMinorUnits: -100 });

  const result = validate(payment);

  expect(result).toEqual({
    error: expect.stringContaining("Amount must be positive"),
    success: false,
  });
});
```

### Checking only that an internal function ran

This test does not establish the payment outcome.

```typescript
it("processes the payment", () => {
  const process = vi.spyOn(internalProcessor, "process");

  handlePayment(payment);

  expect(process).toHaveBeenCalledWith(payment);
});
```

Assert the transaction result or accepted durable side effect.

```typescript
it("returns the transaction identifier", async () => {
  const result = await handlePayment(getMockPayment());

  expect(result).toEqual({
    data: { transactionId: expect.any(String) },
    success: true,
  });
});
```

### Testing trivial storage behavior

This test proves a setter and getter repeat a value.

```typescript
it("sets the retry limit", () => {
  worker.setRetryLimit(3);

  expect(worker.getRetryLimit()).toBe(3);
});
```

Test the behavior controlled by the retry limit.

```typescript
it("stops after three failed attempts", async () => {
  const operation = vi.fn().mockRejectedValue(new Error("Unavailable"));
  const worker = createWorker({ retryLimit: 3 });

  const result = await worker.run(operation);

  expect(result).toEqual({ kind: "failed", attempts: 3 });
});
```

### Executing lines without protecting branches

This happy-path test executes validation but does not protect rejection rules.

```typescript
it("validates a payment", () => {
  const result = validate(getMockPayment());

  expect(result).toMatchObject({ success: true });
});
```

Protect the accepted positive and negative behaviors.

```typescript
describe("validate", () => {
  it.each([
    {
      expectedError: "Amount must be positive",
      payment: getMockPayment({ amountMinorUnits: -100 }),
    },
    {
      expectedError: "Amount exceeds limit",
      payment: getMockPayment({ amountMinorUnits: 1_500_000 }),
    },
    {
      expectedError: "Invalid CVV",
      payment: getMockPayment({ cvv: "12" }),
    },
  ])("rejects invalid payment data", ({ expectedError, payment }) => {
    expect(validate(payment)).toEqual({
      error: expect.stringContaining(expectedError),
      success: false,
    });
  });

  it("accepts valid payment data", () => {
    expect(validate(getMockPayment())).toMatchObject({ success: true });
  });
});
```

## Relevant execution scope

Use the repository's tested watch or affected command when it exists.
Inspect the installed runner help and repository scripts before selecting flags.

Use an exact test name or file to prove a failing case or debug it.
After the correction, run the complete affected scope, including known consumers.
Do not claim success from a selector that executed zero expected tests.

Representative commands follow.

| Runner | Failing-case or debug selector | Affected verification direction |
| --- | --- | --- |
| Vitest | `vitest run test/payment.test.ts -t "rejects a negative amount"` | Repository watch command, verified changed-base selection, or `vitest related` with a mechanically complete source-file list |
| Jest | `jest --runTestsByPath test/payment.test.ts -t "rejects a negative amount"` | Repository watch command, `--onlyChanged`, `--changedSince`, or `--findRelatedTests` with complete changed sources |
| pytest | `pytest test_payment.py::test_rejects_negative_amount` | Repository affected task or the complete owning package plus known consumers |
| Playwright Test | `playwright test workspace.spec.ts --grep "creates a workspace"` | Repository journey project or verified changed-project selection |
| Go, Rust, or JVM | Exact package, class, or test selector | Repository affected task or dependency-derived package and transitive consumer set |

Do not leave a watcher or its child processes running after the work is complete.
Run the repository's required non-watch final gate when the change scope or policy requires it.

## Final decision checklist

Before accepting a test design or audit verdict, confirm:

- The test proves behavior through the public interface at the layer named by its claim.
- The test does not use a lower layer as evidence for a higher-layer claim.
- The function under test is not mocked.
- The test does not depend on private methods or replaceable internal state.
- Interaction assertions prove a caller-visible or boundary contract.
- Fixtures are fresh, valid by default, and explicit when invalid.
- Production schemas are reused when they own the boundary contract.
- Positive, negative, boundary, failure, and side-effect cases are proportionate to the behavior.
- A realistic behavior mutation would make the relevant test fail.
- A behavior-preserving internal refactor would keep the test valid.
- Test organization follows stable behavior rather than implementation files by reflex.
- Focused execution proves the failing case, and final execution covers the complete affected scope.
- Every claimed verification ran at least one expected test and completed successfully.

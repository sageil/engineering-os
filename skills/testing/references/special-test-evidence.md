# Special Test Evidence

Read this reference when ordinary input-action-outcome examples are not enough because the suite contains characterization baselines, snapshots, asynchronous polling, nondeterminism, browser components, or user journeys.

## Contents

- Characterization and golden-master tests
- Snapshots and approval baselines
- Asynchronous outcomes
- Retry helpers
- Time, randomness, and shared state
- Component and browser evidence
- Direct transport in browser suites

## Characterization and golden-master tests

A characterization test records actual current behavior so that a later change is visible.
It is compatibility evidence, not proof that the behavior is correct or accepted.

Bad:

```typescript
it("calculates the correct legacy bonus", () => {
  expect(calculateBonus(-5, "premium", 3)).toBe(-0.75);
});
```

The name upgrades an observed result into a correctness claim without an authoritative rule.

Good:

```typescript
/**
 * This characterization test records current behavior before the scoring refactor.
 * The negative result is suspicious and needs an owner decision before it changes.
 */
it("characterizes a negative bonus for negative activity", () => {
  expect(calculateBonus(-5, "premium", 3)).toBe(-0.75);
});
```

Use a clear name or file suffix so readers can distinguish observed behavior from accepted behavior.
Scope characterization evidence to the path that will change and the nearby callers whose compatibility can be affected.

Treat characterization tests as scaffolding by default.
Replace them with accepted behavior tests as the contract becomes known, but do not delete unique compatibility evidence before its replacement or an explicit compatibility decision exists.

When an observed result looks wrong:

- record the exact observation;
- label the behavior as suspicious;
- identify deployed consumers or stored data that can rely on it;
- obtain the accepted behavior from an owner or authoritative artifact; and
- replace the observation with a regression test only after the decision is established.

## Snapshots and approval baselines

A snapshot can efficiently detect broad output changes.
It does not explain which parts of the output are intentional or important.

Bad:

```typescript
it("renders the account page correctly", () => {
  expect(renderAccountPage(account)).toMatchSnapshot();
});
```

The claim is broader than the evidence, and a large baseline can be accepted without understanding the change.

Good for temporary characterization:

```typescript
it("characterizes the current invoice document before formatter replacement", () => {
  const invoice = renderInvoice(getStableInvoiceScenario());

  expect(invoice).toMatchFileSnapshot("invoice-before-formatter-change.txt");
});
```

Good for a stable contract:

```typescript
it("includes the invoice number, total, and payment deadline", () => {
  const invoice = renderInvoice(getInvoiceScenario());

  expect(invoice).toContain("Invoice INV-123");
  expect(invoice).toContain("Total: $125.00");
  expect(invoice).toContain("Pay by 2026-09-01");
});
```

Prefer focused assertions when a small stable contract is known.
Use a snapshot or approval baseline when the whole complex output is the change-detection subject and human review of updates is real.

Before accepting a snapshot update, inspect the rendered or serialized difference.
Do not accept a new baseline only because the test runner offers an update command.

Control dates, random identifiers, ordering, locale, and unstable metadata before creating a baseline.

## Asynchronous outcomes

An async test must wait for the action and observe its settled public outcome.

Bad:

```typescript
it("rejects an unavailable provider", () => {
  importWorkspaceFromProvider(request);

  expect(errorEvents()).toContainEqual({ code: "provider-unavailable" });
});
```

The assertion can run before the promise settles, and a later rejection can escape the test.

Good:

```typescript
it("reports an unavailable provider", async () => {
  const result = await importWorkspaceFromProvider(request);

  expect(result).toEqual({
    code: "provider-unavailable",
    kind: "failed",
    retryable: true,
  });
});
```

For a promised rejection, await the rejection assertion.

```typescript
it("rejects malformed provider data", async () => {
  await expect(importWorkspaceFromProvider(malformedRequest)).rejects.toThrow(
    "Invalid provider response",
  );
});
```

Test both resolved and rejected paths when both are accepted behavior.
For cancellation, streams, or events, assert the caller-visible terminal state and any required emitted values.

## Retry helpers

A retry helper can execute its callback more than once.
Keep the action under test outside the callback and retry only the observation.

Bad:

```typescript
await waitFor(() => {
  fireEvent.click(submitButton);
  expect(onSubmit).toHaveBeenCalledOnce();
});
```

The callback can submit the form more than once.

Good:

```typescript
await user.click(submitButton);

await waitFor(() => {
  expect(onSubmit).toHaveBeenCalledOnce();
});
```

Prefer the harness's auto-retrying observable assertion or a built-in asynchronous query when it directly expresses the outcome.
Do not put a built-in waiting query inside another retry helper.

Bad:

```typescript
await waitFor(() => screen.findByRole("status", { name: "Saved" }));
```

Good:

```typescript
await screen.findByRole("status", { name: "Saved" });
```

Arbitrary sleeps test elapsed time, not readiness.

Bad:

```typescript
await page.waitForTimeout(2_000);
expect(await page.getByText("Saved").isVisible()).toBe(true);
```

Good:

```typescript
await expect(page.getByRole("status", { name: "Saved" })).toBeVisible();
```

Use an evidence-based timeout only to bound a real wait.
Do not add retries or sleeps to hide an unowned lifecycle race.

## Time, randomness, and shared state

Make changing inputs explicit and restore any global control in guaranteed cleanup.

Bad:

```typescript
const account = buildAccount({ id: crypto.randomUUID() });

it("updates the account", async () => {
  await updateAccount(account);
});
```

The suite-level object is shared, the identifier changes across runs, and there is no observable assertion or cleanup.

Good:

```typescript
it("updates the account display name", async () => {
  const account = await accountFixture.create({ displayName: "Before" });

  try {
    const result = await updateAccount(account.id, { displayName: "After" });

    expect(result).toMatchObject({ displayName: "After" });
  } finally {
    await accountFixture.remove(account.id);
  }
});
```

Use unique data for parallel persistent tests and make cleanup idempotent.
Do not let one test depend on state created by another test.

For time, pass an explicit clock or timestamp when the public design supports it.
If the test must control a global clock, restore it in `finally` or verified test lifecycle cleanup.

For random behavior, inject a deterministic generator or assert stable public properties.
Do not replace randomness with one fixed case when the accepted claim concerns a distribution or broad input space.

## Component and browser evidence

Choose the lightest harness that honestly proves the claim.

| Claim | Required evidence |
| --- | --- |
| Pure formatting or domain rule | Direct operation result |
| Component contract | Rendered output, accessible state, public properties, and public events |
| Browser behavior | Real browser rendering, focus, events, lifecycle, or browser API behavior |
| User journey | Accessible user actions and user-visible outcomes in the served application |

Bad:

```typescript
it("opens the settings dialog", () => {
  const component = new SettingsComponent();

  component.setState({ open: true });

  expect(component.state.open).toBe(true);
});
```

Good:

```typescript
it("opens the settings dialog from the settings control", async () => {
  renderSettings();

  await user.click(screen.getByRole("button", { name: "Settings" }));

  expect(screen.getByRole("dialog", { name: "Settings" })).toBeVisible();
});
```

Prefer accessible role and name queries when they represent how a user or assistive technology finds the control.
Use a test identifier only when no stable user-facing query exists.

Do not require a real browser for pure logic that a smaller public interface proves honestly.
Do require a real browser when the claim depends on rendering, focus, browser security policy, cookies, redirects, or browser APIs.

## Direct transport in browser suites

A direct HTTP client is valid when the HTTP contract, fixture setup, readiness probe, diagnostic, or server-side post-condition is the stated subject.
It is not browser or user-journey evidence.

Bad:

```typescript
it("lets a user create a workspace", async ({ page }) => {
  const response = await page.request.post("/api/workspaces", {
    data: { name: "Research" },
  });

  expect(response.status()).toBe(201);
});
```

Good:

```typescript
it("lets a user create and open a workspace", async ({ page }) => {
  await page.goto("/settings/workspaces");
  await page.getByRole("button", { name: "Create workspace" }).click();
  await page.getByLabel("Workspace name").fill("Research");
  await page.getByRole("button", { name: "Create" }).click();

  await expect(page.getByRole("heading", { name: "Research" })).toBeVisible();
});
```

When network behavior is part of the claim, attach the observer before the action, let the browser initiate the request, and assert the stable visible result.

```typescript
const created = page.waitForResponse((response) => {
  const url = new URL(response.url());

  return response.request().method() === "POST" && url.pathname === "/api/workspaces";
});

await page.getByRole("button", { name: "Create" }).click();
expect((await created).status()).toBe(201);
await expect(page.getByRole("heading", { name: "Research" })).toBeVisible();
```

Setup evidence cannot be borrowed by the journey.
If a fixture creates pre-existing state through an API or datastore, state where the browser claim begins and prove that later action through the browser.

## Decision checklist

Before accepting special-case evidence, confirm:

- characterization observations are not presented as correctness authority;
- suspicious behavior has a named compatibility or owner decision gap;
- snapshot updates were inspected and nondeterministic fields are controlled;
- promises, rejections, cancellations, and streams are awaited to a public outcome;
- retry callbacks contain observations, not repeatable actions;
- sleeps and retries do not replace a real readiness signal;
- time, randomness, shared state, and cleanup are controlled where material;
- component tests use rendered accessible behavior rather than internal state; and
- browser journeys are initiated by the browser or user and end in a user-visible result.

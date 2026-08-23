# Test Quality Properties

Read this reference for a test-quality audit or when a recommendation depends on suite health rather than one behavior claim.

Use the properties as separate evidence lenses.
Do not combine them into a numeric score.

## Contents

- Rating method
- Understandable
- Maintainable
- Repeatable
- Atomic
- Necessary
- Granular
- Fast
- Test-first history
- Quality audit checklist

## Rating method

Rate each applicable property as `strong`, `mixed`, `weak`, or `unknown`.

Use `unknown` when the required evidence is not available.
Do not convert missing evidence into a negative rating.

| Property | Evidence to inspect |
| --- | --- |
| Understandable | Names, arrange-action-assert flow, domain language, and failure messages |
| Maintainable | Public-boundary coupling, fixture ownership, duplication, and refactor resistance |
| Repeatable | Time, randomness, concurrency, network access, persistent state, order, and cleanup |
| Atomic | Shared prerequisites, test ordering, failure isolation, and coherent behavior scope |
| Necessary | Distinct behavior, invariant, boundary, failure mode, or diagnostic value |
| Granular | One coherent outcome and a failure that identifies the broken rule |
| Fast | Measured duration in the feedback loop where the test belongs |
| Test-first history | Captured failing run, development trace, or relevant repository history |

## Understandable

A reader must be able to identify the scenario, action, and expected result without reconstructing private implementation.

Bad:

```typescript
it("works", async () => {
  const result = await run(getMockData());

  expect(result.ok).toBe(true);
});
```

The name does not identify the behavior, and the assertion does not identify the promised result.

Good:

```typescript
it("returns the created workspace after a valid request", async () => {
  const request = getCreateWorkspaceRequest({ name: "Research" });

  const result = await createWorkspace(request);

  expect(result).toEqual({
    kind: "created",
    workspace: expect.objectContaining({ name: "Research" }),
  });
});
```

Keep setup, action, and outcome easy to distinguish.
Do not require ritual comments when the structure and names already make the behavior clear.

## Maintainable

A behavior-preserving refactor must not require unrelated test rewrites.

Bad:

```typescript
it("creates a workspace", async () => {
  const validate = vi.spyOn(internalValidator, "validate");
  const insert = vi.spyOn(internalStore, "insert");

  await createWorkspace(request);

  expect(validate).toHaveBeenCalledBefore(insert);
});
```

This test fixes internal collaborator choice and ordering even when neither is part of the public contract.

Good:

```typescript
it("makes a created workspace available to its owner", async () => {
  const created = await createWorkspace(request);

  const visible = await listWorkspaces(request.ownerId);

  expect(visible).toContainEqual(created.workspace);
});
```

Shared helpers improve maintainability only when they expose a coherent scenario concept.
Do not hide the important behavior behind a generic helper that performs the action and assertion.

## Repeatable

A repeatable test controls inputs that can vary and cleans the state it owns.

Bad:

```typescript
it("expires an invitation after one hour", () => {
  const invitation = createInvitation();

  expect(isExpired(invitation, new Date())).toBe(false);
});
```

The wall clock can cross a boundary while the test runs.

Good:

```typescript
it("keeps an invitation active before its expiry time", () => {
  const createdAt = new Date("2026-01-01T10:00:00Z");
  const checkedAt = new Date("2026-01-01T10:59:59Z");
  const invitation = createInvitation({ createdAt });

  expect(isExpired(invitation, checkedAt)).toBe(false);
});
```

Also inspect random identifiers, locale, time zone, parallel workers, external services, shared files, shared databases, cookies, and process environment.
One passing run does not prove repeatability.

## Atomic

Atomic means that a test can run alone and that its failure identifies one coherent behavior.
It does not mean one assertion per test.

Bad:

```typescript
it("shows the workspace created by the previous test", async ({ page }) => {
  await page.goto("/workspaces");

  await expect(page.getByText("Research")).toBeVisible();
});
```

The test depends on execution order and hidden shared state.

Good:

```typescript
it("creates and displays a workspace", async ({ page, workspaceFixture }) => {
  const name = workspaceFixture.uniqueName();

  await page.goto("/workspaces");
  await page.getByRole("button", { name: "Create workspace" }).click();
  await page.getByLabel("Workspace name").fill(name);
  await page.getByRole("button", { name: "Create" }).click();

  await expect(page.getByRole("heading", { name })).toBeVisible();
});
```

Several assertions can remain together when they describe one result, such as a rejection status and its public error code.

## Necessary

A necessary test contributes behavior evidence that would be lost if the test disappeared.

Bad reasoning:

```markdown
Keep all five cases because each case executes the normalization function.
```

Good reasoning:

```markdown
The mixed-case inputs all prove the same ASCII lowercase rule and can become one parameterized case.
Keep the empty-input rejection separate because it protects a different failure behavior.
```

Do not use file count, line count, coverage contribution, or historical age as a necessity rule.

## Granular

A granular test protects one coherent behavior at a boundary that gives useful failure information.

Bad:

```typescript
it("handles workspace administration", async () => {
  await createWorkspace();
  await renameWorkspace();
  await inviteMember();
  await revokeMember();
  await archiveWorkspace();
});
```

The failure does not identify which independent rule broke, and later actions can hide the first defect.

Good:

```typescript
it("prevents a revoked member from opening the workspace", async () => {
  const scenario = await getWorkspaceWithRevokedMember();

  const result = await openWorkspace(scenario.member, scenario.workspaceId);

  expect(result).toEqual({ kind: "forbidden" });
});
```

Do not split one coherent result into many tests only to enforce one assertion per test.

## Fast

Judge speed against the feedback loop where the test belongs.
A user-journey test can be slower than a domain test and still be appropriate.

Bad conclusion:

```markdown
This test looks small, so its speed is strong.
```

Good conclusion:

```markdown
Speed is unknown because no timing evidence was supplied.
Measure the owning suite and the focused case before recommending a different layer or harness.
```

Do not weaken the evidence boundary only to make a test faster.
Use measured cost after test value is established.

## Test-first history

The final test and production tree cannot prove that the test failed before the behavior was implemented.

Bad conclusion:

```markdown
The test is well written, so test-first history is strong.
```

Good conclusion:

```markdown
Test-first history is unknown because the final tree contains no chronology evidence.
A captured failing run or relevant development trace would establish it.
```

Do not reshape history or manufacture a failing assertion to create test-first theater.

## Quality audit checklist

Before reporting a property rating, confirm:

- the rating names exact tests and evidence;
- unknown timing or chronology stays unknown;
- repeatability considers inputs and cleanup, not one successful run;
- atomicity does not become a one-assertion rule;
- necessity is based on distinct behavior evidence;
- granularity follows coherent outcomes rather than implementation size;
- maintainability is challenged with a behavior-preserving refactor; and
- speed recommendations preserve the evidence boundary required by the claim.

The property set is informed by Dave Farley's [Properties of Good Tests](https://www.linkedin.com/pulse/tdd-properties-good-tests-dave-farley-iexge/).
The evidence rules, ratings, and examples in this reference are adapted for this skill's behavior-evidence responsibility.

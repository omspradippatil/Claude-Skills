---
name: testing-qa
description: >-
  Activate this skill for unit tests, TDD, Playwright E2E tests, Jest/Vitest setups,
  test strategy design, or stabilizing flaky test suites. Use when writing reliable tests,
  mocking boundaries, or setting up automated regression verification.
---

# Testing & Quality Assurance Engineering

> **Scope**: Pragmatic testing strategies covering Test-Driven Development (TDD), unit and integration testing with Vitest/Jest, end-to-end (E2E) automation with Playwright, test doubles, visual regression, and flaky test mitigation.

---

## When to Activate

- Writing new unit, integration, or E2E tests
- Designing test suites and coverage strategies for features or bugfixes
- Setting up or configuring Vitest, Jest, or Playwright
- Debugging flaky, slow, or intermittent test failures
- Mocking external services, network APIs, or database connections
- Creating realistic fixtures and test factories
- Establishing verification gates before release

---

## 1. Test Pyramid & Testing Philosophy

### The Pragmatic Testing Philosophy
- **Test behavior, not implementation details**: Refactoring internal variable names or private helper functions should never break tests if observable behavior remains unchanged.
- **Speed matters**: Keep unit and integration test suites sub-second or single-digit seconds to preserve fast developer feedback loops.
- **Avoid 100% coverage vanity metrics**: Focus high coverage on critical business logic, edge conditions, permissions, and financial/data mutation paths.

### Testing Layers
1. **Unit Tests (Vitest/Jest)**: Fast, deterministic, in-memory tests for pure functions, state transitions, validation schemas, and domain models.
2. **Integration Tests**: Verify interactions across module boundaries (e.g., API route handler + database repository using an ephemeral test DB).
3. **End-to-End Tests (Playwright)**: Verify critical user journeys (signup, checkout, authentication, core workflows) against a running application.

---

## 2. Test-Driven Development (TDD) Workflow

Follow the strict **Red-Green-Refactor** cycle:
1. **Red**: Write a minimal test specifying the intended behavior. Run it and verify that it fails for the expected reason.
2. **Green**: Write the simplest possible implementation that makes the test pass. Do not write premature optimizations or unneeded features.
3. **Refactor**: Clean up the code, eliminate duplication, improve naming and structure, while ensuring the test suite remains green.

---

## 3. Unit & Integration Testing Patterns (Vitest / Jest)

### Arrange-Act-Assert (AAA) Pattern
Structure every test case clearly:
```typescript
it('calculates total with tiered volume discount', () => {
  // Arrange
  const pricingTier = { threshold: 10, discountPercent: 15 };
  const cartItems = [{ id: 'item-1', price: 100, quantity: 12 }];

  // Act
  const result = calculateCartTotal(cartItems, pricingTier);

  // Assert
  expect(result.subtotal).toBe(1200);
  expect(result.discount).toBe(180);
  expect(result.total).toBe(1020);
});
```

### Effective Test Doubles
- **Spies / Mocks**: Use `vi.fn()` or `jest.fn()` sparingly to verify boundaries (e.g., email notification service called with correct recipient).
- **Network Boundaries**: Use MSW (Mock Service Worker) for intercepting API requests at the network layer rather than patching `globalThis.fetch`.
- **Database Boundaries**: Prefer testing against a real ephemeral database (Docker or SQLite in-memory) over mocking SQL queries.

---

## 4. End-to-End Testing with Playwright

### Resilient Selectors
Never select elements by volatile CSS classes or unstable DOM hierarchies. Prioritize user-facing, accessible attributes:

```typescript
// ❌ Flaky & Brittle
await page.locator('div.container > form > div:nth-child(2) > button').click();

// ✅ Resilient & Accessible (User-Centric)
await page.getByRole('button', { name: /sign in/i }).click();
await page.getByLabel('Email address').fill('user@example.com');
await page.getByTestId('checkout-summary').toBeVisible();
```

### Page Object Model (POM)
For complex user journeys, encapsulate page interactions in reusable Page Objects:
```typescript
export class LoginPage {
  constructor(private readonly page: Page) {}

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, pass: string) {
    await this.page.getByLabel('Email address').fill(email);
    await this.page.getByLabel('Password').fill(pass);
    await this.page.getByRole('button', { name: /log in/i }).click();
    await this.page.waitForURL('/dashboard');
  }
}
```

### Visual Regression Testing
Use Playwright's built-in snapshot comparisons for UI stability:
```typescript
await expect(page).toHaveScreenshot('landing-hero.png', {
  maxDiffPixelRatio: 0.02,
  animations: 'disabled',
});
```

---

## 5. Eliminating Flaky Tests

### Root Causes & Remediation
1. **Arbitrary Sleep (`sleep(1000)`)**: Never use hardcoded sleeps. Always wait for specific DOM state, network response, or condition:
   ```typescript
   // ❌ Bad
   await page.waitForTimeout(2000);
   // ✅ Good
   await page.waitForResponse(resp => resp.url().includes('/api/cart') && resp.status() === 200);
   ```
2. **Shared State Between Tests**: Ensure every test runs in an isolated context. Reset database state and mock calls before each test (`beforeEach`).
3. **Time & Timezones**: Freeze system time using `vi.useFakeTimers()` or specify fixed UTC timezones in test runners.
4. **Order Dependency**: Shuffle test execution order (`--shuffle` in Vitest/Jest) to catch hidden state leakage.

---

## 6. Verification Release Gate Checklist

Before declaring any feature or bugfix complete:
- [ ] New behavior has corresponding unit or integration tests.
- [ ] Edge cases (empty arrays, null/undefined, extreme numbers, unauthorized users) are covered.
- [ ] All tests run locally and pass cleanly without skips or warnings.
- [ ] Flaky test assertions and hardcoded timeouts have been eliminated.
- [ ] CI pipeline runs the complete test suite in an isolated environment.

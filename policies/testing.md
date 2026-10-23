# Testing and Verification Policy

This policy applies to all tasks that involve writing code, modifying existing code, or verifying that a system works correctly. Load this file for any task categorized as **Testing / QA** or when any other task reaches its completion gate.

---

## 1. Core Principles

### Run Tests and Require Fresh Evidence
- All relevant tests must be run *after the final code mutation* before declaring any code change complete.
- "I believe it should work" is not a substitute for running tests. Earlier passing tests are stale and do not prove the final state.
- If tests cannot be run in the current environment, explicitly state this limitation. Do not claim success without evidence.

### Verify Acceptance Criteria Relevant to the Task
- Verify the specific requirements and edge cases of the current task directly.
- Passing unrelated test suites is not proof that the active change meets its acceptance criteria.
- Target tests to the blast radius of the change, expanding to regression tests before completion.

### Report Failures and Evidence Honestly
- **Never fabricate test results.** If tests fail, report the failure accurately with output excerpts.
- Distinguish clearly between **executed tests** (with actual command and output) and **suggested manual tests** for the user.
- Do not claim tests pass when they have not been run.
- Do not suppress or hide failing tests by commenting them out, skipping them without justification, or modifying test assertions to match broken behavior.
- If a test is flaky and not caused by the current change, document it clearly rather than silently skipping it.

### Fix the Code, Not the Tests
- When a test fails after a code change, the default assumption is that the code is broken, not the test.
- Only modify a test when: the test itself has a bug; the tested behavior has intentionally changed and the test needs to be updated to match the new spec (document this clearly in the commit/PR).

---

## 2. Test Categories

### Unit Tests
**Scope**: Individual functions, classes, or modules in isolation.

- Test one behavior per test case. Keep tests small and focused.
- Mock external dependencies (databases, APIs, file systems) — unit tests must not make real network calls.
- Aim for fast execution (milliseconds per test). Slow unit tests indicate a design problem.
- Cover: happy path, edge cases, error conditions, boundary values.
- Naming: `describe("functionName")` → `it("should return X when given Y")`.

**Frameworks**: Jest (JavaScript/TypeScript), Vitest, pytest, unittest (Python), JUnit (Java), Go testing package.

### Integration Tests
**Scope**: Interactions between multiple components, services, or layers (e.g., API routes + database, service + repository).

- Use test databases or in-memory equivalents (SQLite for SQL, Firestore Emulator, Supabase local).
- Test real data flows: write to DB → read from DB → verify output.
- Clean up test data after each test run (use transactions, truncation, or isolated test schemas).
- Cover: component integration points, external service interactions, middleware chains.

### End-to-End (E2E) Tests — Playwright
**Scope**: Full user journeys through the application UI in a real browser.

- Use [Playwright](https://playwright.dev) for E2E tests.
- Test critical user journeys: registration, login, core feature use, checkout, data submission.
- Use page object models to keep tests maintainable.
- Do not test implementation details in E2E — test user-visible behavior.
- Run against a staging environment that mirrors production, not a local dev server, for CI checks.
- Avoid brittle selectors: prefer `getByRole`, `getByLabel`, `getByText` over CSS selectors or XPath.

```typescript
// Prefer role-based selectors
await page.getByRole('button', { name: 'Submit' }).click();
await expect(page.getByRole('alert')).toHaveText('Form submitted successfully');
```

### Security Tests
- Run `npm audit` / `pip-audit` / `bundler-audit` and fail if critical/high vulnerabilities are unresolved.
- Run SAST (Static Application Security Testing) tools: ESLint security plugin, Bandit (Python), Semgrep.
- Verify authentication is enforced: test that protected routes return `401` / `403` without valid credentials.
- Test for common injection vulnerabilities in integration tests when adding new query endpoints.
- See `policies/security.md` for the full security release gate checklist.

### SEO Validation
- Verify canonical tags, meta titles, meta descriptions, and Open Graph tags are correct after any change.
- Run a sitemap validity check: all URLs must return `200 OK`.
- Use Lighthouse or PageSpeed Insights to check Core Web Vitals after performance-relevant changes.
- See `policies/seo.md` for the full SEO validation checklist.

### Accessibility Tests
- Run `axe-core` or Playwright's built-in accessibility snapshot tests as part of CI.
- Perform keyboard navigation testing for any new interactive component.
- Verify color contrast ratios for new UI elements.
- See `policies/frontend.md` for the full accessibility checklist.

---

## 3. Test Coverage

- Maintain meaningful test coverage — coverage percentage is a proxy, not the goal.
- Prioritize covering: critical business logic, security-relevant code paths, complex conditional logic.
- 100% coverage with trivially passing tests is worthless. Untested critical paths are high-risk.
- Do not write tests purely to inflate coverage numbers.
- When coverage drops due to added code: add tests for the new code before considering the task complete.

---

## 4. Continuous Integration

- All tests must pass in CI before a pull request can be merged.
- CI pipelines should run: linting, type checking, unit tests, integration tests, and (optionally) E2E tests.
- Failed CI must be investigated and fixed — do not re-run CI repeatedly hoping for a different result without fixing the underlying issue.
- Flaky tests must be fixed or isolated (quarantined, tracked in an issue). Silently ignoring flaky tests is not acceptable.

Example CI pipeline order:
1. Install dependencies
2. Type checking (`tsc --noEmit`)
3. Linting (`eslint .`)
4. Unit tests (`jest` / `vitest`)
5. Integration tests
6. E2E tests (on staging deploy)
7. Security audit (`npm audit`)
8. Accessibility check

---

## 5. Source-Code Checks vs. Live Production Verification

**Distinguish clearly between:**

- **Source-code checks**: Static analysis, unit tests, and integration tests run against local code. These verify the code is internally consistent and logically correct but cannot guarantee production behavior.
- **Live production verification**: Checks run against the deployed production environment — real HTTP requests, real database, real user traffic patterns.

When reporting on test results:
- State which environment the tests ran against.
- Do not claim a production issue is resolved based solely on local tests.
- For live verification, use real URLs and record the actual HTTP status codes, response times, and observable behavior.

Example correct reporting:
> "Unit tests pass locally. Integration tests pass against the local Supabase emulator. I have not verified this against the production environment — please run a smoke test after deployment."

Example incorrect reporting:
> "All tests pass. ✅" (when tests were only run locally and the issue was a production configuration problem)

---

## 6. Release Gates

A release is only ready when **all** of the following are verified:

- [ ] **Code review**: Changes have been reviewed (or self-reviewed carefully for solo projects)
- [ ] **Tests passing**: All unit, integration, and relevant E2E tests pass in CI
- [ ] **No regressions**: Existing tests have not been broken by the change
- [ ] **Security check**: `npm audit` / equivalent passes; security policy checklist reviewed
- [ ] **Accessibility check**: No new a11y violations introduced; keyboard navigation tested for new UI
- [ ] **Performance check**: No significant regression in Core Web Vitals or API response times
- [ ] **Documentation updated**: README, API docs, or inline comments updated if behavior changed
- [ ] **Environment variables**: New required env vars are documented; no secrets in source
- [ ] **Migration safety**: Database migrations are tested and reversible; backups confirmed before running on production
- [ ] **Smoke test plan**: A set of manual or automated checks to run immediately after deployment is defined

---

## 7. Writing Good Tests

A good test is:

- **Fast**: Completes in milliseconds (unit) or seconds (integration). E2E can take longer but should be parallelized.
- **Isolated**: Does not depend on the state left by other tests. Order of execution does not matter.
- **Deterministic**: Always produces the same result given the same code. No random failures.
- **Readable**: The test name clearly describes what is being tested and what the expected outcome is.
- **Minimal**: Tests only what is necessary. Does not assert on irrelevant details.
- **Maintained**: Tests are updated when the system intentionally changes. They are not abandoned when they start failing.

A bad test is one that:
- Passes when the code is broken (false positive)
- Fails for reasons unrelated to the code under test (flaky)
- Is so implementation-coupled that refactoring requires rewriting all tests
- Is commented out because "it's annoying"

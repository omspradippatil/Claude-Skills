# Security Policy

This policy applies to **all** tasks that involve authentication, authorization, secrets, user input, data storage, access control, or network communication. Load this file whenever the task category is **Security** or when any other task touches these domains.

---

## 1. Secrets and Credentials

**Never hard-code secrets, credentials, or API keys.**

- All secrets must be stored in environment variables or a secrets manager (e.g., Vault, AWS Secrets Manager, Doppler, `.env` files excluded from version control).
- `.env` files must be listed in `.gitignore`. Verify this before committing any new project.
- Never log secrets, tokens, or passwords — even at debug level.
- Rotate any secret that has been accidentally committed or exposed. Treat it as compromised immediately.
- Do not pass secrets as URL query parameters; they appear in server logs and browser history.
- Use short-lived tokens where possible (JWT expiry, OAuth refresh flows).
- For Supabase/Firebase: never expose `service_role` keys or admin SDK credentials in client-side code. Client-side code must only use the public `anon` key with appropriate Row Level Security enforced.

---

## 2. Input Validation

**Validate all input at the server side. Client-side validation is UX only — never security.**

- Validate type, length, format, and range for every field.
- Reject unexpected fields (allowlist approach, not blocklist).
- Use schema validation libraries (Zod, Joi, Pydantic, Yup) rather than ad-hoc checks.
- Validate file uploads: check MIME type server-side (not just extension), enforce size limits, scan for malware in high-risk contexts.
- Never pass unsanitized user input to shell commands (`exec`, `spawn`, `subprocess`). Use parameterized APIs instead.

---

## 3. SQL and NoSQL Injection Prevention

- **Always use parameterized queries or prepared statements.** Never construct SQL strings by concatenating user input.
- ORM query builders are acceptable but verify that raw query escape hatches (`raw()`, `query()`) are never used with user-supplied data.
- For NoSQL (MongoDB, Firestore): validate that query operators (`$where`, `$gt`, etc.) cannot be injected via user-supplied JSON keys.
- Use least-privilege database users — the application user should not have `DROP`, `ALTER`, or `TRUNCATE` privileges in production.

```sql
-- WRONG
SELECT * FROM users WHERE email = '${userInput}';

-- CORRECT
SELECT * FROM users WHERE email = $1;  -- with parameterized value
```

---

## 4. XSS Prevention

- **Encode all output** before inserting user-supplied data into HTML, JavaScript, CSS, or URL contexts.
- Never use `innerHTML`, `dangerouslySetInnerHTML`, `document.write`, or `eval()` with untrusted data.
- Use framework-provided escaping mechanisms (React JSX auto-escapes; Angular's template binding). Only bypass these when absolutely necessary and with explicit sanitization.
- Implement a strict **Content Security Policy (CSP)** header:
  - Avoid `unsafe-inline` and `unsafe-eval`.
  - Prefer nonce-based or hash-based CSP for inline scripts that are unavoidable.
- Sanitize rich-text HTML input with an allowlist-based library (DOMPurify) rather than a blocklist.

---

## 5. CSRF Protection

- Use CSRF tokens for all state-changing form submissions in traditional server-rendered apps.
- For SPA + API setups, use the `SameSite=Strict` or `SameSite=Lax` cookie attribute to mitigate CSRF.
- Verify the `Origin` or `Referer` header server-side for sensitive endpoints when appropriate.
- Do not use `GET` requests for state-changing operations.

---

## 6. Authentication and Authorization

- **Verify authentication and authorization server-side on every protected operation.** Never rely solely on client-side checks.
- Implement proper session management: invalidate sessions on logout; use secure, random session IDs.
- Use established auth libraries and platforms (NextAuth, Passport, Supabase Auth, Firebase Auth, Auth0) rather than rolling custom auth.
- Enforce multi-factor authentication (MFA) for admin and privileged operations.
- Apply the **principle of least privilege**: users and services should only have the permissions they need.
- Implement account lockout or rate limiting after repeated failed login attempts.

### Supabase-Specific
- Enable Row Level Security (RLS) on every table that stores user data. Verify with `SELECT * FROM pg_tables WHERE rowsecurity = false` in the SQL editor.
- Never disable RLS for convenience. If a table should be public, write an explicit permissive policy.
- Use `auth.uid()` in RLS policies — never trust a `user_id` column that comes from the client without server-side verification.

### Firebase-Specific
- Write Firestore Security Rules that enforce authentication and document-level ownership.
- Test rules with the Firebase Emulator Suite before deploying.
- Never use `allow read, write: if true` in production rules.

---

## 7. CORS Configuration

- Configure CORS narrowly: allowlist only the specific origins that need access.
- Never use wildcard `*` as the allowed origin for authenticated endpoints.
- Do not reflect the `Origin` header without validating it against a known allowlist.
- Set appropriate `Access-Control-Allow-Methods` and `Access-Control-Allow-Headers` — do not allow all methods and headers.

---

## 8. Rate Limiting and Resource Protection

- Apply rate limiting to all public-facing endpoints, especially authentication, registration, and password reset.
- Apply stricter limits to expensive operations (AI inference, file processing, bulk exports).
- Use exponential backoff and jitter for retry logic in clients.
- Set timeouts on all outbound HTTP requests — never allow indefinitely hanging connections.
- Limit upload size, request body size, and query result size.
- Protect against ReDoS (Regular Expression Denial of Service) by auditing complex regexes.

---

## 9. HTTPS and Security Headers

All production deployments must use HTTPS. Additionally, apply the following HTTP security headers:

| Header | Required Value |
|---|---|
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains; preload` |
| `Content-Security-Policy` | Strict allowlist; no `unsafe-inline`, no `unsafe-eval` |
| `X-Content-Type-Options` | `nosniff` |
| `X-Frame-Options` | `DENY` or `SAMEORIGIN` |
| `Referrer-Policy` | `strict-origin-when-cross-origin` |
| `Permissions-Policy` | Restrict camera, microphone, geolocation as appropriate |

---

## 10. Secure Cookie Attributes

All session and auth cookies must have:
- `Secure` — cookie only sent over HTTPS
- `HttpOnly` — inaccessible to JavaScript
- `SameSite=Strict` or `SameSite=Lax` — CSRF mitigation
- Appropriate `Path` and `Domain` to scope cookie access

---

## 11. Dependency Auditing

- Run `npm audit`, `pip-audit`, `bundler-audit`, or the equivalent before releasing changes that modify dependencies.
- Address all critical and high severity vulnerabilities before shipping.
- Prefer dependencies that are actively maintained, widely used, and have clear security policies.
- Pin dependency versions in lockfiles and commit lockfiles to version control.
- Periodically review and remove unused dependencies.

---

## 12. Error Handling

- Never expose stack traces, internal paths, database schemas, or implementation details in error responses sent to clients.
- Log detailed errors server-side only, with appropriate access controls on logs.
- Return generic error messages to clients: `"An error occurred"` — not `"SQL syntax error near 'users'"`.
- Handle all promise rejections and async errors; unhandled rejections can crash Node.js processes.

---

## Release Gate Security Checklist

Before shipping any change that touches security-relevant code, verify:

- [ ] **Auth**: Every protected endpoint verifies authentication and authorization server-side
- [ ] **Input validation**: All user input is validated server-side with a schema
- [ ] **Injection**: No raw SQL string concatenation; all queries parameterized
- [ ] **XSS**: No `innerHTML`/`dangerouslySetInnerHTML` with untrusted data; CSP header present
- [ ] **Secrets**: No credentials in source code, logs, or client bundles; `.env` in `.gitignore`
- [ ] **Dependency vulns**: `npm audit` / equivalent run and passing (no critical/high unresolved)
- [ ] **Security headers**: HSTS, CSP, `X-Content-Type-Options`, `X-Frame-Options` configured
- [ ] **Access control**: RLS enabled on all Supabase tables; Firebase rules deployed and tested
- [ ] **Error handling**: No internal details leaked in error responses
- [ ] **Static analysis**: Linter and security-focused rules (ESLint security plugin, Bandit, etc.) passing

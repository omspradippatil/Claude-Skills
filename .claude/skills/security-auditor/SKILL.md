---
name: security-auditor
description: >-
  Activate this skill to perform OWASP security audits, penetration testing, threat modeling,
  or securing endpoints. Use when reviewing authentication/authorization flows, checking for
  injection vulnerabilities, auditing dependencies, or preparing a security release gate.
---

# Security Auditor Skill

> **Scope**: All security work must be authorized. Never run intrusive or destructive tests against production systems without explicit written approval. This skill covers code review, static analysis, configuration audits, and controlled testing only.

---

## When to Activate

- Security reviews before shipping new features or APIs
- Threat modeling for new architectures
- Auditing auth/authz implementations (JWT, OAuth, session management)
- Checking for secrets exposure in code or config
- Reviewing database Row Level Security (RLS) policies
- Hardening HTTP headers, CORS, and cookies
- Dependency vulnerability scanning
- Preparing a security release gate checklist

---

## Audit Process (Step-by-Step)

### Step 1 — Map Trust Boundaries & Attack Surface
- Identify all entry points: HTTP endpoints, WebSocket connections, background jobs, webhooks, file uploads, public SDKs.
- Draw or describe the trust boundary diagram: what crosses from untrusted (internet) to trusted (server/database).
- Note which roles exist and what they can access.
- Mark third-party integrations and their privilege level.

### Step 2 — Check OWASP Top 10 Risks
Work through each risk category in order (see reference list below). For each: identify whether the surface exists, note mitigations in place, flag gaps.

### Step 3 — Review Authentication & Authorization
- **AuthN**: How are users identified? Password hashing (bcrypt/argon2, not MD5/SHA1), MFA availability, session fixation prevention, account lockout/rate limiting on login.
- **AuthZ**: Is every route/resolver/action gated by a permission check? Check for IDOR (Insecure Direct Object Reference) — can user A access user B's resources by changing an ID?
- JWT: algorithm pinned (never `alg: none`), expiry set, refresh token rotation, storage (httpOnly cookie preferred over localStorage).
- OAuth/OIDC: state parameter validated, redirect_uri allowlisted, PKCE used for SPAs/mobile.

### Step 4 — Input Validation & Sanitization
- All external input validated at the boundary (not just the UI).
- Use allow-lists, not block-lists for input schemas.
- SQL: parameterized queries or ORM — never string-interpolated SQL.
- HTML output: context-aware escaping (XSS prevention). Check `dangerouslySetInnerHTML`, `innerHTML`, `v-html`.
- File uploads: MIME type validation server-side, not just extension; virus scanning for user files; store outside webroot.
- Path traversal: normalize paths, reject `../` sequences.

### Step 5 — Scan for Secret Exposure
- Search codebase for hardcoded secrets: API keys, DB credentials, private keys, tokens.
  ```bash
  grep -rE "(api_key|secret|password|token|private_key)\s*=\s*['\"][^'\"]{8,}" --include="*.{js,ts,py,env,yaml,json}" .
  ```
- Check `.env.example` vs `.env` — `.env` must be in `.gitignore`.
- Review git history for accidentally committed secrets: `git log -p | grep -i secret`.
- Verify environment variable injection in CI/CD (not in logs, not in Docker layer).
- Check Dockerfile and docker-compose for `ENV` or `ARG` leaking secrets into image layers.

### Step 6 — Audit Dependencies
- Run dependency vulnerability scan:
  - Node.js: `npm audit --audit-level=high` or `pnpm audit`
  - Python: `pip-audit` or `safety check`
  - Go: `govulncheck ./...`
  - Rust: `cargo audit`
- Review `package.json` / `pyproject.toml` for pinned vs range versions.
- Check for abandoned packages (last publish date, GitHub archive status).
- Verify supply chain: are dependencies from trusted registries? Check for typosquatting in recently added packages.
- Flag any dependency with a known Critical or High CVE for immediate remediation.

### Step 7 — Check Security Headers & Cookies
Required HTTP response headers:
```
Content-Security-Policy: default-src 'self'; script-src 'self'; ...
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
X-Content-Type-Options: nosniff
X-Frame-Options: DENY  (or SAMEORIGIN if framing is needed)
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```
Cookie flags:
- Session/auth cookies: `HttpOnly; Secure; SameSite=Strict` (or `Lax` for OAuth flows).
- No sensitive data in cookie values.
- Check cookie expiry — sessions should expire.

### Step 8 — Verify Database Row Level Security (RLS)
**Supabase RLS checklist:**
- RLS enabled on every table that holds user data: `SELECT relname, relrowsecurity FROM pg_class WHERE relkind = 'r';`
- Default deny policy exists (no rows returned without explicit policy).
- `auth.uid()` used in policies (not a column the client can spoof).
- Service role key used only server-side — never exposed to the client.
- Policies reviewed for privilege escalation (can a non-admin user update `role` column?).
- Storage bucket policies checked alongside table policies.

**Firebase/Firestore RLS:**
- Security Rules deployed and not in test mode (`allow read, write: if true` → immediate fail).
- Rules validate `request.auth != null` before any write.
- Rules validate `request.resource.data` shape (type, size, required fields).
- Rules do not allow client to set `uid` fields (use `request.auth.uid`).
- Storage rules restrict by content type and file size.

### Step 9 — Test API Access Control
- Attempt to access resources as an unauthenticated user — expect 401.
- Attempt to access another user's resources as an authenticated user — expect 403.
- Attempt to access admin endpoints as a regular user — expect 403.
- Test HTTP method override (`X-HTTP-Method-Override`).
- Test mass assignment: send extra fields in POST/PUT body — ensure they are ignored.
- Check GraphQL introspection disabled in production.
- Verify rate limiting on sensitive endpoints (login, password reset, OTP verify).

### Step 10 — Review Error Handling & Information Disclosure
- Error responses must not leak stack traces, file paths, SQL queries, or internal IDs to clients.
- Production error pages should be generic ("Something went wrong") — detailed errors logged server-side only.
- Debug/verbose logging disabled in production builds.
- Internal IP addresses or service names not exposed in response headers.
- Version headers (`X-Powered-By`, `Server`) removed or genericized.

---

## OWASP Top 10 (2021) Reference

| # | Category | Key Question |
|---|----------|-------------|
| A01 | **Broken Access Control** | Can users access resources/actions they shouldn't? |
| A02 | **Cryptographic Failures** | Is sensitive data encrypted in transit and at rest? Weak algorithms in use? |
| A03 | **Injection** | Is untrusted data sent to interpreters (SQL, shell, LDAP, XML)? |
| A04 | **Insecure Design** | Are security requirements defined? Threat modeling done? |
| A05 | **Security Misconfiguration** | Default creds, unnecessary features enabled, verbose errors in prod? |
| A06 | **Vulnerable & Outdated Components** | Unpatched libraries with known CVEs? |
| A07 | **Identification & Authentication Failures** | Weak passwords allowed? Sessions not invalidated on logout? |
| A08 | **Software & Data Integrity Failures** | Unverified CI/CD pipelines? Unsigned packages? Deserialization issues? |
| A09 | **Security Logging & Monitoring Failures** | Are security events logged? Are alerts configured? |
| A10 | **Server-Side Request Forgery (SSRF)** | Can an attacker make the server fetch arbitrary URLs? |

---

## Supabase-Specific Checks
- [ ] `SUPABASE_SERVICE_ROLE_KEY` never in client-side code or `.env` files committed to git
- [ ] `anon` key permissions minimized — confirm what anon users can actually do
- [ ] Auth email templates customized (no Supabase branding leaks in forgot-password flow)
- [ ] Auth redirect URLs allowlisted (no open redirect via OAuth)
- [ ] Realtime channels authenticated (not open to any connected socket)
- [ ] Edge Functions validate `Authorization` header before processing
- [ ] Database functions (`security definer`) reviewed — they bypass RLS

## Firebase-Specific Checks
- [ ] Firebase config object (apiKey etc.) treated as public — security enforced by Rules, not by hiding config
- [ ] App Check enabled for production to prevent API abuse
- [ ] Cloud Functions validate Firebase ID tokens server-side
- [ ] Admin SDK credential files (`serviceAccount.json`) never committed
- [ ] Firestore indexes reviewed — no accidental full-collection exposure
- [ ] Firebase Hosting headers configured (CSP, HSTS)

---

## Security Release Gate Checklist

### Must Pass (Blocking)
- [ ] **No critical/high CVEs** in dependency audit
- [ ] **No hardcoded secrets** in codebase or git history
- [ ] **RLS enabled and tested** on all user-data tables
- [ ] **Auth tokens expire** and refresh token rotation implemented
- [ ] **All inputs validated** server-side on every mutation endpoint
- [ ] **Parameterized queries only** — no dynamic SQL string construction
- [ ] **HTTPS enforced** — HSTS header present
- [ ] **CORS policy explicit** — no wildcard `*` on credentialed requests
- [ ] **Error messages generic** in production — no stack traces to clients
- [ ] **Admin/privileged endpoints** protected by role check, not just authentication

### Should Pass (High Priority)
- [ ] CSP header configured
- [ ] Cookie flags: `HttpOnly`, `Secure`, `SameSite` set
- [ ] Rate limiting on login, registration, password reset, OTP
- [ ] Security event logging in place (failed logins, permission denials)
- [ ] Dependency lock files committed and verified in CI
- [ ] GraphQL introspection disabled in production

### Nice to Have
- [ ] Penetration test scheduled (authorized, scoped)
- [ ] Bug bounty or responsible disclosure policy published
- [ ] Security.txt file at `/.well-known/security.txt`
- [ ] Subresource Integrity (SRI) on third-party scripts

---

## Output Format

When completing a security audit, produce a report with:
1. **Executive Summary** — overall risk level (Critical / High / Medium / Low / Informational)
2. **Findings Table** — each finding with: ID, Category, Severity, Description, Evidence (code snippet or config), Recommendation
3. **Remediation Priority** — ordered list from highest to lowest severity
4. **Release Gate Result** — PASS / FAIL with blocking items called out

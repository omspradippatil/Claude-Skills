---
name: api-architecture
description: >-
  Activate this skill when designing REST or GraphQL APIs, Node.js or Python backends,
  microservices, authentication middleware, or caching layers. Use when defining API contracts,
  reviewing endpoint security, or designing data validation and error schemas.
---

# API Architecture Skill

---

## When to Activate

- Designing new REST or GraphQL APIs from scratch
- Reviewing or refactoring existing API structure
- Auth/authz middleware design (JWT, OAuth, API keys, sessions)
- Input validation and error response schemas
- Rate limiting and throttling strategy
- API versioning decisions
- Microservice communication patterns
- OpenAPI/Swagger spec generation
- Logging, tracing, and observability setup

---

## Design Process (Step-by-Step)

### Step 1 — Define the API Contract
Before writing any code, define the contract:
- Who are the consumers? (web frontend, mobile app, third-party, internal services)
- What resource model does the API expose?
- What actions are needed? Map to HTTP methods (REST) or operations (GraphQL).
- Start with an OpenAPI spec or GraphQL schema — code follows the contract, not vice versa.

**API-first benefits:** Enables parallel frontend/backend development, auto-generates client SDKs, serves as living documentation.

### Step 2 — Auth & AuthZ Design
**Authentication options:**
- **JWT (Bearer token)**: Stateless, scalable. Use for SPAs, mobile apps. Require short expiry (15min access, 7d refresh). Algorithm must be pinned (`RS256` for asymmetric, `HS256` with secure secret minimum 256-bit).
- **Session cookies**: Stateful, server-managed. Good for SSR apps. Require `HttpOnly; Secure; SameSite=Strict`.
- **API keys**: For server-to-server. Hash stored server-side (never plaintext), prefix-based routing (`sk_live_...`), rotatable.
- **OAuth 2.0 / OIDC**: For delegated access. Use PKCE for all public clients.

**Authorization patterns:**
- RBAC (Role-Based Access Control): roles → permissions → resources. Simple to understand and audit.
- ABAC (Attribute-Based Access Control): evaluate policies based on resource/user/environment attributes. More flexible, more complex.
- Ownership check: always verify `resource.userId === requestingUser.id` before returning or modifying.
- Fail closed: if the auth check fails or is ambiguous, deny access.

### Step 3 — Input Validation & Error Schema
**Validation rules:**
- Validate at the API boundary — don't trust any input.
- Use a schema validation library: Zod (TypeScript), Pydantic (Python), Joi (Node.js), express-validator.
- Validate: types, ranges, lengths, formats (email, URL, UUID), presence of required fields.
- Sanitize: strip unexpected fields (mass assignment prevention), normalize strings.

**Standard error response schema** (use consistently across all endpoints):
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "email",
        "message": "Must be a valid email address"
      }
    ],
    "requestId": "req_abc123",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

**HTTP status codes to use:**
| Code | When to use |
|------|-------------|
| 200 OK | Successful GET, PUT, PATCH |
| 201 Created | Successful POST that creates a resource |
| 204 No Content | Successful DELETE or action with no body |
| 400 Bad Request | Invalid input, validation failure |
| 401 Unauthorized | Not authenticated |
| 403 Forbidden | Authenticated but not authorized |
| 404 Not Found | Resource does not exist |
| 409 Conflict | Duplicate resource, state conflict |
| 422 Unprocessable Entity | Semantically invalid (valid format, invalid business logic) |
| 429 Too Many Requests | Rate limit exceeded |
| 500 Internal Server Error | Unexpected server error |
| 503 Service Unavailable | Downstream dependency failure |

### Step 4 — Rate Limiting
- Apply at the API gateway or middleware level — not per-endpoint unless specific needs.
- Strategies:
  - **Fixed window**: Simple, but susceptible to burst at window boundary.
  - **Sliding window**: More accurate, prevents boundary bursts. Preferred.
  - **Token bucket**: Allows controlled bursting, good for APIs that need flexibility.
- Limits by: IP (unauthenticated), user ID (authenticated), API key.
- Return `429 Too Many Requests` with headers:
  ```
  Retry-After: 60
  X-RateLimit-Limit: 100
  X-RateLimit-Remaining: 0
  X-RateLimit-Reset: 1705312200
  ```
- Back rate limits with Redis or an in-memory store — not a database.

### Step 5 — Data Model Design
- Follow single responsibility: each endpoint manages one resource type.
- Separate your API resource model from your database model — use a DTO (Data Transfer Object) layer.
- Never expose internal database IDs directly if they're sequential integers — use UUIDs or nanoid.
- Soft delete preferred for user-facing data (add `deleted_at` column) — allows recovery and audit trails.
- Timestamps: all resources should have `created_at`, `updated_at`.

### Step 6 — API Versioning
Strategies (pick one and be consistent):
- **URL versioning**: `/api/v1/users` — Most explicit, easiest to route. Recommended for public APIs.
- **Header versioning**: `Accept: application/vnd.api+json;version=1` — Cleaner URLs, harder to test in browser.
- **Query param**: `/api/users?version=1` — Simple but can conflict with other params.

Rules:
- Never make breaking changes to an existing version.
- Deprecation policy: announce → deprecation header → sunset date → removal.
- Add `Deprecation` and `Sunset` response headers for deprecated endpoints.
- Support at least N-1 versions at any time.

### Step 7 — Logging & Observability
**What to log on every request:**
```json
{
  "requestId": "req_abc123",
  "method": "POST",
  "path": "/api/v1/orders",
  "statusCode": 201,
  "durationMs": 45,
  "userId": "usr_xyz",
  "userAgent": "Mozilla/5.0...",
  "ip": "203.0.113.1"
}
```

**What NOT to log:**
- Passwords, tokens, API keys, card numbers, SSNs — mask or omit.
- Full request bodies (may contain PII) — log field names only, not values for sensitive fields.

**Structured logging:** Use JSON logs (not printf-style). Tools: Winston, Pino (Node.js), structlog (Python).

**Distributed tracing:** Add `X-Request-ID` or `X-Trace-ID` headers. Pass through all service calls. Log the trace ID at every hop.

**Metrics to instrument:**
- Request rate, error rate, latency (p50/p95/p99) — the RED method.
- Saturation (queue depth, connection pool usage).
- Business metrics (orders created, payments processed).

### Step 8 — Testing Strategy
- **Unit tests**: Test validation logic, business rules, transformation functions in isolation.
- **Integration tests**: Test the full request-response cycle including database interactions. Use a test database, not mocks.
- **Contract tests**: If you have multiple consumers, use Pact or similar to verify both sides honor the contract.
- **Load tests**: Before launch, test at expected peak + 3× spike with k6, Artillery, or Locust.
- Test all error paths — not just happy paths.

---

## REST Best Practices

### Resource Naming
```
GET    /api/v1/articles          → List articles
POST   /api/v1/articles          → Create article
GET    /api/v1/articles/:id      → Get one article
PATCH  /api/v1/articles/:id      → Update article (partial)
PUT    /api/v1/articles/:id      → Replace article (full)
DELETE /api/v1/articles/:id      → Delete article

GET    /api/v1/articles/:id/comments  → Nested resource
```
- Use nouns, not verbs: `/articles` not `/getArticles`.
- Use plural nouns: `/users` not `/user`.
- Kebab-case for multi-word: `/blog-posts` not `/blogPosts`.

### Pagination
Always paginate list endpoints. Use cursor-based pagination for large/real-time datasets:
```json
{
  "data": [...],
  "pagination": {
    "cursor": "eyJpZCI6MTAwfQ==",
    "hasMore": true,
    "total": 1542
  }
}
```
Offset pagination for simple use cases:
```json
{
  "data": [...],
  "pagination": {
    "page": 2,
    "perPage": 25,
    "total": 1542,
    "totalPages": 62
  }
}
```

### Filtering & Sorting
```
GET /api/v1/articles?status=published&author=user_123
GET /api/v1/articles?sort=created_at&order=desc
GET /api/v1/articles?fields=id,title,created_at   (sparse fieldsets)
```

---

## GraphQL Considerations

### N+1 Problem
- Every list resolver that fetches related data will trigger N additional queries.
- Solution: use DataLoader to batch and cache per-request.
```js
const userLoader = new DataLoader(async (ids) => {
  const users = await db.users.findMany({ where: { id: { in: ids } } });
  return ids.map(id => users.find(u => u.id === id));
});
```

### Query Depth & Complexity Limits
- Malicious or accidental queries can deeply nest (user → posts → comments → author → posts...).
- Use `graphql-depth-limit` (max depth 5–7) and `graphql-query-complexity`.
- Set a timeout on query execution.

### Production Hardening
- Disable introspection in production (or restrict to authenticated users).
- Use persisted queries (allowlist of known query hashes) for maximum security.
- Rate limit by query complexity points, not just request count.
- Implement field-level authorization in resolvers, not just at the top level.

---

## Security Checklist

- [ ] All inputs validated with a schema validator before processing
- [ ] No SQL string interpolation — parameterized queries or ORM only
- [ ] CORS policy explicit: `origin` allowlist, not `*` for credentialed requests
- [ ] JWT: algorithm pinned, expiry set, refresh token rotation implemented
- [ ] Sensitive fields (password, token) stripped from response objects
- [ ] Rate limiting on all public endpoints
- [ ] Error messages don't leak internal details (stack traces, SQL, file paths)
- [ ] API keys hashed in database, never stored plaintext
- [ ] Auth check on every protected route — no security by obscurity
- [ ] Mass assignment prevented — explicit allowlist of accepted fields

---

## OpenAPI Spec Template

```yaml
openapi: 3.1.0
info:
  title: My API
  version: 1.0.0
  description: API description
servers:
  - url: https://api.example.com/v1
    description: Production
  - url: https://staging-api.example.com/v1
    description: Staging

security:
  - BearerAuth: []

components:
  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  schemas:
    Error:
      type: object
      required: [error]
      properties:
        error:
          type: object
          required: [code, message]
          properties:
            code: { type: string }
            message: { type: string }
            requestId: { type: string }

paths:
  /articles:
    get:
      summary: List articles
      parameters:
        - in: query
          name: cursor
          schema: { type: string }
        - in: query
          name: limit
          schema: { type: integer, minimum: 1, maximum: 100, default: 25 }
      responses:
        '200':
          description: Success
        '401':
          description: Unauthorized
          content:
            application/json:
              schema: { $ref: '#/components/schemas/Error' }
```

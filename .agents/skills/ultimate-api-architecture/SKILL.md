---
name: ultimate-api-architecture
description: Master heuristics for designing scalable APIs, Microservices, and Middleware.
---

# Ultimate API Architecture

### 1. RESTful Standards
- Use semantic HTTP methods (GET for reads, POST for creation, PUT/PATCH for updates, DELETE).
- Version your API routes aggressively (e.g., `/api/v1/users`).
- Standardize error responses into a predictable JSON shape: `{ "error": true, "code": "VALIDATION_FAILED", "message": "..." }`.

### 2. Authentication & Authorization
- Use HTTP-only, secure cookies for JWTs where possible to prevent XSS exfiltration.
- If using bearer tokens, implement strict short-lived access tokens and longer-lived, rotatable refresh tokens.
- Apply rate-limiting globally (e.g., 100 req/min) and strictly on sensitive endpoints like `/login`.

### 3. Performance & Caching
- Implement Redis caching for expensive, read-heavy queries.
- Return pagination metadata (cursor, total_pages, next_page) for list endpoints instead of massive arrays.

---
name: cloudflare-expert
description: >-
  Activate this skill for Cloudflare Workers, Edge functions, D1 databases, R2 storage, or Wrangler deployments.
---

# Cloudflare Expert Skill

## Cloudflare Workers

### Handler Patterns

```typescript
// Module syntax (recommended)
export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);

    // Route by pathname
    if (url.pathname.startsWith('/api/')) {
      return handleApi(request, env, ctx);
    }

    return new Response('Not Found', { status: 404 });
  },

  // Scheduled trigger
  async scheduled(event: ScheduledEvent, env: Env, ctx: ExecutionContext) {
    ctx.waitUntil(runCleanup(env));
  },
};

// TypeScript bindings interface
interface Env {
  DB: D1Database;
  BUCKET: R2Bucket;
  KV: KVNamespace;
  API_SECRET: string; // secret set via wrangler secret
}
```

### Request/Response Manipulation
```typescript
// Clone and modify request headers
const modifiedRequest = new Request(request, {
  headers: { ...Object.fromEntries(request.headers), 'X-Custom': 'value' },
});

// Stream large responses
async function handleStream(request: Request): Promise<Response> {
  const { readable, writable } = new TransformStream();
  // pipe upstream to writable
  return new Response(readable, {
    headers: { 'Content-Type': 'text/event-stream', 'Cache-Control': 'no-cache' },
  });
}

// CORS response helper
function corsResponse(body: string, status = 200): Response {
  return new Response(body, {
    status,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Content-Type': 'application/json',
    },
  });
}
```

### Environment Bindings
Defined in `wrangler.toml`:
```toml
name = "my-worker"
main = "src/index.ts"
compatibility_date = "2024-01-01"

[[d1_databases]]
binding = "DB"
database_name = "my-db"
database_id = "xxxx-xxxx"

[[r2_buckets]]
binding = "BUCKET"
bucket_name = "my-bucket"

[[kv_namespaces]]
binding = "KV"
id = "xxxx"
```

---

## D1 — Edge SQL Database

### Query Patterns
```typescript
// Prepared statement (prevents SQL injection)
const stmt = env.DB.prepare('SELECT * FROM users WHERE id = ?').bind(userId);
const user = await stmt.first<User>();

// Batch queries (single round trip)
const results = await env.DB.batch([
  env.DB.prepare('INSERT INTO posts (title, author_id) VALUES (?, ?)').bind(title, authorId),
  env.DB.prepare('UPDATE users SET post_count = post_count + 1 WHERE id = ?').bind(authorId),
]);

// All results
const { results: posts } = await env.DB.prepare('SELECT * FROM posts ORDER BY created_at DESC LIMIT ?').bind(50).all<Post>();
```

### Migrations
```bash
# Create migration
wrangler d1 migrations create my-db add-users-table

# Apply locally
wrangler d1 migrations apply my-db --local

# Apply to production
wrangler d1 migrations apply my-db --remote
```

```sql
-- migrations/0001_add_users_table.sql
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  created_at INTEGER NOT NULL DEFAULT (unixepoch())
);
CREATE INDEX idx_users_email ON users(email);
```

### SQLite Compatibility Notes
- D1 uses SQLite under the hood — use SQLite types: `TEXT`, `INTEGER`, `REAL`, `BLOB`
- No `RETURNING` clause support in older compatibility dates — query after insert
- Timestamps: store as `INTEGER` (Unix epoch) or `TEXT` (ISO 8601)
- No full-text search (FTS) in D1 currently

---

## R2 — Object Storage

### Operations
```typescript
// Upload
await env.BUCKET.put('uploads/image.jpg', request.body, {
  httpMetadata: { contentType: 'image/jpeg' },
  customMetadata: { userId: '123' },
});

// Download
const object = await env.BUCKET.get('uploads/image.jpg');
if (!object) return new Response('Not Found', { status: 404 });

return new Response(object.body, {
  headers: {
    'Content-Type': object.httpMetadata?.contentType ?? 'application/octet-stream',
    'Cache-Control': 'public, max-age=31536000, immutable',
    'ETag': object.etag,
  },
});

// Delete
await env.BUCKET.delete('uploads/image.jpg');

// List
const listed = await env.BUCKET.list({ prefix: 'uploads/', limit: 100 });
```

### Pre-signed URLs
Use the R2 public bucket URL or generate via a Worker that verifies auth before returning an object — R2 does not have native pre-signed URLs like S3. Use time-limited signed tokens in your Worker instead.

### CORS Configuration
Configure in R2 Dashboard or via API:
```json
[
  {
    "AllowedOrigins": ["https://your-app.com"],
    "AllowedMethods": ["GET", "PUT"],
    "AllowedHeaders": ["*"],
    "MaxAgeSeconds": 3000
  }
]
```

---

## KV — Key-Value Store

### Patterns
```typescript
// Write with TTL (seconds)
await env.KV.put('session:abc123', JSON.stringify(sessionData), {
  expirationTtl: 3600, // 1 hour
});

// Read with type helper
const raw = await env.KV.get('session:abc123');
const session = raw ? (JSON.parse(raw) as Session) : null;

// Read with metadata
const { value, metadata } = await env.KV.getWithMetadata<Meta>('key');

// List keys with prefix
const { keys } = await env.KV.list({ prefix: 'session:' });
```

### Eventual Consistency
- KV is **eventually consistent** — writes may take up to 60s to propagate globally
- **Not suitable** for counters, leaderboards, or highly consistent transactional data — use D1 for that
- Reads are always from the closest edge — great for config, feature flags, cached HTML

---

## Wrangler CLI

### Local Development
```bash
# Start local dev server (uses local miniflare)
wrangler dev

# Dev against production bindings (caution!)
wrangler dev --remote

# Tail production logs
wrangler tail
```

### Secrets
```bash
# Set a secret (prompts for value, never stored in wrangler.toml)
wrangler secret put STRIPE_SECRET_KEY

# List secrets
wrangler secret list

# Delete a secret
wrangler secret delete STRIPE_SECRET_KEY
```

### Environments
```toml
# wrangler.toml
[env.staging]
name = "my-worker-staging"
vars = { ENVIRONMENT = "staging" }

[env.production]
name = "my-worker-prod"
vars = { ENVIRONMENT = "production" }
```

```bash
wrangler deploy --env production
wrangler secret put API_KEY --env production
```

---

## Edge Caching

### Cache-Control Headers
```typescript
// Cache static assets for 1 year with immutable
return new Response(asset, {
  headers: { 'Cache-Control': 'public, max-age=31536000, immutable' },
});

// Cache API responses for 60s, allow stale for 10s
return new Response(data, {
  headers: { 'Cache-Control': 'public, s-maxage=60, stale-while-revalidate=10' },
});
```

### Cache API (Programmatic)
```typescript
const cache = caches.default;

async function fetch(request: Request, env: Env, ctx: ExecutionContext) {
  // Check cache first
  const cached = await cache.match(request);
  if (cached) return cached;

  // Fetch and store
  const response = await fetch(request.url);
  ctx.waitUntil(cache.put(request, response.clone()));
  return response;
}
```

### Cache Purging
```bash
# Purge by tag (requires Enterprise) or by URL via API
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/purge_cache" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -d '{"files": ["https://example.com/static/main.js"]}'
```

---

## Security Best Practices

- **Never** put secrets in `wrangler.toml` — use `wrangler secret put` instead
- Validate `Authorization` headers or use Cloudflare Access for admin endpoints
- Set `Access-Control-Allow-Origin` explicitly — avoid wildcard `*` for credentialed requests
- Use `crypto.subtle` (available in Workers) for HMAC verification of webhooks:
```typescript
async function verifySignature(body: string, signature: string, secret: string): Promise<boolean> {
  const key = await crypto.subtle.importKey(
    'raw', new TextEncoder().encode(secret), { name: 'HMAC', hash: 'SHA-256' }, false, ['verify']
  );
  const sig = hexToUint8Array(signature);
  return crypto.subtle.verify('HMAC', key, sig, new TextEncoder().encode(body));
}
```

---

## Performance Best Practices

- **Minimize CPU time**: Workers have a 50ms CPU limit on free tier (50ms–30s on paid)
- Use `ctx.waitUntil()` for non-blocking background work (logging, cache writes)
- **Stream large responses** using `TransformStream` rather than buffering
- Co-locate D1 databases and Workers in the same region to minimize latency
- Cache expensive D1 queries in KV with appropriate TTLs
- Use `Promise.all()` for parallel fetch/D1 calls that don't depend on each other

---
name: postgres-ecosystem
description: >-
  Activate this skill for PostgreSQL, Supabase, Neon databases, complex SQL queries,
  migrations, or Row Level Security (RLS). Use when designing schemas, tuning queries,
  writing safe migrations, or enforcing multi-tenant isolation.
---

# PostgreSQL & Modern Cloud Database Ecosystem

> **Scope**: Covers PostgreSQL core principles, Supabase architecture & RLS security, Neon branching & serverless workflows, query optimization, indexing strategies, and zero-downtime database migrations.

---

## When to Activate

- Designing relational database schemas and constraints
- Implementing or auditing Row Level Security (RLS) policies
- Supabase integrations (Auth, Storage, Edge Functions, Realtime)
- Neon database branching for CI/CD and pull request environments
- Writing safe, reversible SQL migrations
- Optimizing slow queries with `EXPLAIN (ANALYZE, BUFFERS)`
- Establishing indexing strategies (B-Tree, GIN, BRIN, Partial, Expression)
- Connection pooling and scaling (PgBouncer, Supavisor)

---

## 1. Schema Design Principles

### Strict Constraints & Integrity
- Always use `NOT NULL` unless a column is genuinely optional.
- Explicitly define foreign key constraints with sensible `ON DELETE` behavior (`CASCADE`, `RESTRICT`, or `SET NULL`).
- Use UUIDv7 or `BIGINT GENERATED ALWAYS AS IDENTITY` for primary keys. UUIDv7 provides time-sortable random keys that reduce B-tree index fragmentation.
- Use native types: `timestamptz` for all timestamps, `text` over arbitrary `varchar(255)`, `jsonb` over `json`.
- Enforce business invariants using `CHECK` constraints (e.g., `CHECK (price >= 0)`, `CHECK (end_date >= start_date)`).

### Normalization vs Pragmatic Denormalization
- Default to 3NF (Third Normal Form) for transactional integrity.
- Use `jsonb` only for semi-structured data, dynamic user attributes, or audit logs.
- When querying inside `jsonb`, create GIN indexes (`CREATE INDEX ON table USING gin (data jsonb_path_ops);`) or expression indexes on specific keys.

---

## 2. Row Level Security (RLS) & Multi-Tenant Isolation

### Universal RLS Rules
1. **Always enable RLS explicitly**:
   ```sql
   ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
   ALTER TABLE organizations FORCE ROW LEVEL SECURITY; -- Forces RLS on table owners/superusers if supported
   ```
2. **Deny by default**: In PostgreSQL, enabling RLS without policies denies all operations except for superusers.
3. **Separate policies per action**: Do not use `FOR ALL` for combined read/write logic. Write distinct policies for `SELECT`, `INSERT`, `UPDATE`, and `DELETE`.

### Supabase RLS Patterns
```sql
-- Pattern: Multi-tenant tenant_id matching authenticated user
CREATE POLICY "Users can view members of their organization"
ON org_members FOR SELECT
TO authenticated
USING (
  org_id IN (
    SELECT om.org_id FROM org_members om WHERE om.user_id = auth.uid()
  )
);

-- Pattern: Ownership-based mutations
CREATE POLICY "Users can update their own profile"
ON profiles FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());
```

### Critical RLS Traps to Avoid
- **Never expose `service_role` or postgres admin keys in client bundles.** Only public `anon` keys belong in the client.
- **Recursive policies**: If policy on table `A` queries table `A`, it causes infinite recursion. Use helper security-definer functions or JWT metadata claims where appropriate.
- **Index RLS filter columns**: Columns evaluated in `USING` clauses (such as `user_id`, `org_id`, `tenant_id`) MUST have indexes, otherwise every single row lookup triggers a sequential table scan.

---

## 3. Safe, Zero-Downtime Migrations

### The Golden Rules of Production Migrations
1. **Never perform destructive schema changes in a single deployment.**
2. **Always write reversible migrations** with a verified rollback script.
3. **Avoid table locks on large tables:**
   - Add columns with default values without lock in modern Postgres (`ALTER TABLE t ADD COLUMN c text DEFAULT 'x'` is instant in Postgres 11+).
   - Create indexes concurrently: `CREATE INDEX CONCURRENTLY idx_orders_customer ON orders (customer_id);`
   - Never add a `NOT NULL` constraint to an existing column without a `CHECK ... NOT VALID` followed by `VALIDATE CONSTRAINT`.

### Expand and Contract Migration Lifecycle
When renaming or restructuring a column:
1. **Phase 1 (Expand)**: Add the new column alongside the old. Dual-write to both old and new columns in the application code.
2. **Phase 2 (Backfill)**: Backfill historical data in small batched transactions to prevent replication lag and transaction lockouts.
3. **Phase 3 (Switch)**: Switch application reads to the new column.
4. **Phase 4 (Contract)**: Drop old column and stop writing to it after safe monitoring period.

---

## 4. Query Optimization & Indexing

### Diagnosis with EXPLAIN
Always examine execution plans using:
```sql
EXPLAIN (ANALYZE, BUFFERS, VERBOSE, COSTS)
SELECT * FROM orders WHERE status = 'pending' AND created_at > NOW() - INTERVAL '7 days';
```
Look for:
- **Seq Scan on large tables**: Indicates missing or non-selective index.
- **Rows Removed by Filter**: A high number indicates the index didn't filter early enough.
- **Buffers: shared read**: Indicates data was read from disk rather than OS/Postgres shared buffer cache.

### Strategic Index Types
- **B-Tree**: Default for equality (`=`), range (`<`, `<=`, `>`, `>=`), and `BETWEEN` queries.
- **Partial Index**: Great for filtering sub-states:
  ```sql
  CREATE INDEX idx_unprocessed_jobs ON jobs (priority DESC, created_at ASC) WHERE status = 'pending';
  ```
- **Composite Index Column Order**: Put equality columns first, followed by range/sorting columns (Left-to-Right prefix rule).
- **GIN Index**: For arrays, full-text search (`tsvector`), and `jsonb`.

---

## 5. Cloud Platforms: Supabase & Neon Workflows

### Neon Database Branching
- Use Neon branches in CI pipelines to provision an instant, copy-on-write database clone per Pull Request.
- Run database migrations against the PR branch, run integration and E2E tests, and terminate the branch automatically upon PR merge or closure.
- Never run manual experimental queries against production compute; spin up a point-in-time branch to safely test queries on production-scale data.

### Supabase Edge & Storage
- Validate all file uploads with explicit Storage bucket security policies.
- Ensure Edge Functions verify authorization headers and validate JWTs before executing business logic.
- Run scheduled maintenance (`VACUUM ANALYZE`) on heavily churned tables to control table bloat.

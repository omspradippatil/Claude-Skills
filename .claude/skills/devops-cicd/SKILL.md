---
name: devops-cicd
description: >-
  Activate this skill for tasks involving GitHub Actions, Docker, CI/CD pipelines,
  containerization, infrastructure-as-code, or deployment automation workflows.
---

# DevOps & CI/CD Pipelines

> **Scope**: Best practices for continuous integration, continuous delivery, Docker containerization, GitHub Actions workflows, secret management, artifact caching, and zero-downtime deployment strategies.

---

## When to Activate

- Writing or reviewing GitHub Actions workflows (`.github/workflows/*.yml`)
- Creating or optimizing Dockerfiles and multi-stage container builds
- Designing continuous delivery pipelines (staging, preview, production)
- Setting up automated testing, linting, and security gates in CI
- Configuring caching to minimize CI build times
- Managing environments, secrets, and deployment approvals
- Diagnosing failing CI builds, container crashes, or deployment timeouts

---

## 1. GitHub Actions Architecture & Best Practices

### Workflow Structure
- Use deterministic action versions with pinned SHA digests or major semantic tags (e.g., `actions/checkout@v4`).
- Organize workflows by concern:
  - `pr-validation.yml`: Fast checks (lint, typecheck, unit tests) triggered on `pull_request`.
  - `integration.yml`: Slower integration/E2E test runs triggered on PR or specific labels.
  - `release.yml`: Build artifacts, publish packages, or deploy upon tag push or merge to `main`.

### Concurrency & Redundant Run Cancellation
Cancel in-progress runs when new commits are pushed to the same branch:
```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: ${{ github.ref != 'refs/heads/main' }}
```

### Principle of Least Privilege Permissions
Always define minimal job-level permissions rather than default write-all:
```yaml
permissions:
  contents: read
  pull-requests: write # only if posting PR comments
  id-token: write      # only for OIDC authentication to AWS/GCP
```

### High-Speed Dependency Caching
- Cache package manager stores (`~/.pnpm-store`, `~/.npm`, `~/.cache/pip`, `~/.cargo`) using built-in setup actions (`setup-node` with `cache: 'pnpm'`).
- Cache build outputs across steps where appropriate.

---

## 2. Production Docker Engineering

### Multi-Stage Build Pattern
Always separate build-time dependencies from production runtime containers to minimize image size and attack surface:

```dockerfile
# ── Stage 1: Build ─────────────────────────────────────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app
RUN apk add --no-cache libc6-compat
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

# ── Stage 2: Production Runtime ───────────────────────────────────────────────
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nodejs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nodejs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nodejs:nodejs /app/.next/static ./.next/static

USER nodejs
EXPOSE 3000
ENV PORT=3000
CMD ["node", "server.js"]
```

### Docker Security Essentials
1. **Never run containers as root**: Create and switch to a non-privileged user (`USER nodejs` or `USER appuser`).
2. **Never bake secrets or `.env` files into Docker images**: Pass secrets at runtime via environment variables or secret managers (K8s secrets, AWS Secrets Manager, Doppler).
3. **Use `.dockerignore`**: Exclude `node_modules`, `.git`, `.env*`, test coverage, logs, and build artifacts from the build context.
4. **Scan images for CVEs**: Use Trivy, Grype, or GitHub Container Scanning in CI.

---

## 3. Secret Management & Environment Promotion

### CI/CD Secrets Isolation
- Never print environment variables or secrets in shell steps (`set -x` or `echo "$SECRET"`).
- Mask dynamic tokens with `::add-mask::<value>` in GitHub Actions.
- Use GitHub Environments for staging and production with mandatory reviewers and deployment protection rules.
- Use OpenID Connect (OIDC) rather than long-lived cloud access keys whenever deploying to AWS, GCP, or Azure.

---

## 4. Release Strategies & Verification Gates

### Deployment Patterns
- **Blue-Green Deployments**: Maintain two identical environments. Route traffic to the new version once verified; instant rollback by routing traffic back.
- **Canary Releases**: Route a small percentage of user traffic (e.g., 5%) to the new release, monitor error rates and latency, then gradually increase to 100%.
- **Rollback Readiness**: Every release must have an automated or documented one-command rollback mechanism.

### Pre-Deployment Verification Checklist
- [ ] All unit, integration, and security checks pass in CI.
- [ ] Docker image scans report zero critical/high unmitigated vulnerabilities.
- [ ] Database migrations are backwards-compatible (expand before contract).
- [ ] Healthcheck endpoints (`/healthz` or `/api/health`) are responding before routing traffic.
- [ ] Sentry / observability tags match the deployed release version.

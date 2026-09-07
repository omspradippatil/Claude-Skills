---
name: ultimate-devops-cicd
description: Master heuristics for Infrastructure, Docker, GitHub Actions, and CI/CD Pipelines.
---

# Ultimate DevOps & CI/CD

This skill enforces strict DevOps guidelines to prevent build failures, missing secrets, and flaky deployments.

### 1. Docker Best Practices
- Use multi-stage builds to minimize image sizes (e.g., compile in `node:builder`, run in `node:alpine`).
- Never run containers as `root`. Always create a dedicated non-root user.
- Cache dependencies efficiently by copying package manifests before the rest of the source code.

### 2. GitHub Actions
- Pin actions to specific commit SHAs rather than `@v2` tags to prevent supply-chain attacks.
- Use aggressive caching actions (`actions/cache`) for `node_modules`, `cargo`, or pip dependencies.
- Separate environments logically (e.g., `build`, `test`, `deploy`) and use matrix builds for cross-browser testing.

### 3. CI/CD Principles
- Always fail fast. Run fast linters/formatters before expensive E2E tests.
- Infrastructure as Code (IaC): Prefer declarative configuration over manual clicking in dashboards.

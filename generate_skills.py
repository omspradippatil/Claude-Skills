import os
import re
import json

base_dir = "/Users/om/Desktop/Projects/Claude-Skills"
skills_dir = os.path.join(base_dir, ".agents/skills")

new_skills = [
    {
        "name": "ultimate-devops-cicd",
        "cat": "backend",
        "title": "Ultimate DevOps & CI/CD",
        "desc": "GitHub Actions, Docker containerization, deployment workflows, and robust CI/CD pipelines.",
        "prompt": "Create a robust GitHub Actions pipeline that builds, tests, and deploys this Dockerized Node app.",
        "markdown": """---
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
"""
    },
    {
        "name": "ultimate-api-architecture",
        "cat": "backend",
        "title": "Ultimate API Architecture",
        "desc": "REST, GraphQL, microservices, robust error handling, caching, and rate limiting.",
        "prompt": "Design a scalable REST API using Node.js with Redis caching and JWT authentication.",
        "markdown": """---
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
"""
    },
    {
        "name": "ultimate-mobile-engineering",
        "cat": "mobile",
        "title": "Ultimate Mobile Engineering",
        "desc": "React Native, Flutter, Swift, native bridges, offline-first architectures, and mobile UX.",
        "prompt": "Refactor this React Native FlatList to use FlashList for 60fps scrolling performance.",
        "markdown": """---
name: ultimate-mobile-engineering
description: Master heuristics for Mobile App Development, React Native, and Flutter.
---

# Ultimate Mobile Engineering

### 1. Performance over Everything
- Mobile devices are resource-constrained. Never use `map` to render large lists; always use optimized virtualized lists (e.g., `FlashList` in React Native, `ListView.builder` in Flutter).
- Avoid blocking the JS/UI thread. Offload heavy computations to web workers, native modules, or isolates.

### 2. Offline-First Architecture
- Design apps to work offline by default. Cache aggressive reads locally (e.g., WatermelonDB, SQLite, Hive).
- Use optimistic UI updates. When a user "likes" a post, update the UI instantly before the server confirms.

### 3. Native Fluidity
- Respect platform guidelines (Human Interface Guidelines for iOS, Material Design for Android).
- Ensure tap targets are at least 44x44 points.
- Manage memory proactively (e.g., caching images locally rather than constantly refetching).
"""
    },
    {
        "name": "ultimate-state-management",
        "cat": "web",
        "title": "Ultimate State Management",
        "desc": "React Query, SWR, Zustand, Redux, and minimizing complex prop-drilling.",
        "prompt": "Implement React Query to cache this data fetch and add a Zustand store for UI state.",
        "markdown": """---
name: ultimate-state-management
description: Heuristics for complex frontend state, server caching, and avoiding spaghetti data flows.
---

# Ultimate State Management

### 1. Server State vs. Client State
- Do not put API responses in global state (Redux/Zustand). Use server-state caching libraries (React Query, SWR, RTK Query) to handle loading, caching, re-fetching, and background updates.
- Reserve global client state (Zustand, Pinia) exclusively for UI layout toggles, themes, or multi-step form data.

### 2. Colocation
- Keep state as close to where it is used as possible. Do not lift state globally if only two sibling components need it.

### 3. State Machines for Complexity
- For highly complex logic (e.g., checkout flows, media players), use finite state machines (like XState) rather than scattering `isLoading`, `isError`, and `isSuccess` booleans across your component.
"""
    },
    {
        "name": "ultimate-git-collaboration",
        "cat": "memory",
        "title": "Ultimate Git Collaboration",
        "desc": "Safe branching, atomic commits, conventional commits, and handling merge conflicts.",
        "prompt": "Review my git status and create a conventional commit message for the recent refactoring.",
        "markdown": """---
name: ultimate-git-collaboration
description: Heuristics for atomic commits, branching, and AI Git workflow safety.
---

# Ultimate Git Collaboration

### 1. Safe AI Refactoring
- Never perform massive, sweeping changes on the `main` branch. Always checkout a new feature branch (e.g., `git checkout -b refactor/auth`).
- Make atomic, granular commits. Do not bundle a CSS fix and a database migration into the same commit.

### 2. Conventional Commits
- Use semantic commit prefixes: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`.
- Include context (e.g., `fix(auth): prevent token undefined crash`).

### 3. Conflict Resolution
- When stuck in a rebase or merge conflict, explicitly list the conflicting files, explain the diverging paths, and ask the user how they want to resolve business logic discrepancies.
"""
    },
    {
        "name": "ultimate-persistent-memory",
        "cat": "memory",
        "title": "Ultimate Persistent Memory",
        "desc": "Proactive context ledgers, recording architectural decisions, and tracking past mistakes.",
        "prompt": "Update our MEMORY.md file to reflect the new decision to use Redis for caching.",
        "markdown": """---
name: ultimate-persistent-memory
description: Enforces the maintenance of a persistent project ledger to preserve context across sessions.
---

# Ultimate Persistent Memory

### 1. The Context Ledger
- When working on this project, assume there is a `MEMORY.md`, `LESSONS.md`, or `ARCHITECTURE.md` file in the root. 
- You MUST read this file at the start of a session to understand the stack, prior mistakes, and user preferences.

### 2. Active Learning
- If the user corrects your code, or if you encounter a persistent bug, DO NOT just move on. Ask the user if you should append the lesson to the memory file to prevent future regressions.

### 3. Architectural Logging
- Whenever a major library is added or a folder structure is decided upon, document the "why" in the memory file.
"""
    },
    {
        "name": "ultimate-engineering-discipline",
        "cat": "memory",
        "title": "Ultimate Engineering Discipline",
        "desc": "Zero silent deletions, Karpathy/Caveman style, surgical patching, and strict anti-bloat.",
        "prompt": "Refactor this file but follow strict surgical patching: DO NOT delete any existing comments.",
        "markdown": """---
name: ultimate-engineering-discipline
description: Strict behavioral rules to prevent AI Slop, over-engineering, and silent regressions.
---

# Ultimate Engineering Discipline

### 1. ZERO Silent Deletions
- NEVER remove, modify, or truncate existing comments, imports, or business logic unless explicitly told to. 
- If a refactor requires deleting code, you MUST highlight exactly what you are deleting and briefly explain why before proceeding.

### 2. Karpathy & Caveman Minimalism
- Prioritize the absolute fewest lines of code possible. 
- Do not write clever abstractions, unnecessary wrappers, or complex generic types when simple, procedural code suffices. YAGNI (You Aren't Gonna Need It).

### 3. Explain the "Why"
- Before outputting a huge block of code, write 2 sentences explaining your architectural choice. Explicitly state if there is an easier, simpler alternative.

### 4. Surgical Patching
- Output only the specific lines or functions that need changing. Do not rewrite a 500-line file just to fix a typo.
"""
    }
]

# 1. Create the skill files
for skill in new_skills:
    folder_path = os.path.join(skills_dir, skill["name"])
    os.makedirs(folder_path, exist_ok=True)
    with open(os.path.join(folder_path, "SKILL.md"), "w") as f:
        f.write(skill["markdown"])

# 2. Add the missing 14 existing skills + the 7 new ones to the skillsData array for index.html
all_skills = [
    { "name": 'ultimate-frontend-design', "cat": 'ui', "title": 'Ultimate Frontend Design', "desc": 'A mega-catalog of UI aesthetics, true glassmorphism, Brutalism, and typography hierarchies.', "prompt": 'Redesign this dashboard using the "Dark Glass Clean Layout" aesthetic.' },
    { "name": 'ultimate-security-auditor', "cat": 'arch', "title": 'Ultimate Security Auditor', "desc": 'Unified OWASP reviews, LLM risk assessments, API hardening, and mobile security checks.', "prompt": 'Perform a comprehensive security audit on these API endpoints using the OWASP guidelines.' },
    { "name": 'ultimate-cloudflare-expert', "cat": 'backend', "title": 'Ultimate Cloudflare Expert', "desc": 'Edge Workers, D1 SQL, R2, durable objects, and local Wrangler sandbox mastery.', "prompt": 'Architect a serverless KV store and Edge Worker caching strategy.' },
    { "name": 'ultimate-testing-qa', "cat": 'web', "title": 'Ultimate Testing QA', "desc": 'Playwright, E2E stabilization, CI auto-fix workflows, and surgical patching heuristics.', "prompt": 'Generate robust Playwright UI regression tests for this checkout flow with auto-retry fixtures.' },
    { "name": 'ultimate-llm-optimization', "cat": 'memory', "title": 'Ultimate LLM Optimization', "desc": 'Caveman heuristics, Karpathy rules, minimal abstractions, and token-saving strategies.', "prompt": 'Refactor this module. Remove all abstraction bloat and follow the Caveman strict guidelines.' },
    { "name": 'ultimate-web-animation', "cat": 'ui', "title": 'Ultimate Web Animation', "desc": 'GSAP, cinematic scroll-scrubbing, physics-based springs, and WebGL transitions.', "prompt": 'Implement a smooth scroll-triggered stagger animation for these bento grid cards.' },
    { "name": 'ultimate-seo-marketing', "cat": 'seo', "title": 'Ultimate SEO & Marketing', "desc": 'Technical SEO engine, GSC prioritization, pricing page layouts, and JSON-LD structured schemas.', "prompt": 'Run a technical SEO audit on this landing page and generate JSON-LD schema.' },
    { "name": 'ultimate-firebase-expert', "cat": 'backend', "title": 'Ultimate Firebase Expert', "desc": 'Firestore architecture, RLS security rules, Auth, and Serverless Cloud Functions.', "prompt": 'Design a Firestore document schema with strict collection group security rules.' },
    { "name": 'ultimate-3d-visuals', "cat": 'ui', "title": 'Ultimate 3D Visuals', "desc": 'Three.js, WebGL shaders, glTF optimization, and performant 3D model rendering on the web.', "prompt": 'Setup a basic Three.js scene with a rotating cube and optimized lighting.' },
    { "name": 'ultimate-assets-media', "cat": 'ui', "title": 'Ultimate Assets & Media', "desc": 'Next-gen image formats (WebP/AVIF), lazy loading strategies, and variable font optimizations.', "prompt": 'Implement an optimal image loading strategy using HTML picture tags and WebP.' },
    { "name": 'ultimate-postgres-ecosystem', "cat": 'backend', "title": 'Ultimate Postgres Ecosystem', "desc": 'Supabase, Neon serverless, RLS policies, indexing, and complex SQL migrations.', "prompt": 'Write a strict Row Level Security policy for the users table in Postgres.' },
    { "name": 'ultimate-ux-research', "cat": 'ui', "title": 'Ultimate UX Research', "desc": 'User discovery protocols, usability heuristics, cognitive load reduction, and UX writing.', "prompt": 'Analyze this checkout flow and identify cognitive load bottlenecks based on UX heuristics.' },
    { "name": 'ultimate-web-gamedev', "cat": 'web', "title": 'Ultimate Web GameDev', "desc": 'HTML5 Canvas, game loops, physics engines (Matter.js), and rendering optimizations.', "prompt": 'Create a robust 60fps requestAnimationFrame game loop with delta time calculations.' }
]

# Append the 7 new skills
for s in new_skills:
    all_skills.append({
        "name": s["name"],
        "cat": s["cat"],
        "title": s["title"],
        "desc": s["desc"],
        "prompt": s["prompt"]
    })

# Format the skillsData JS string
js_str = "    const skillsData = [\n"
for s in all_skills:
    js_str += f"      {{ name: '{s['name']}', cat: '{s['cat']}', title: '{s['title']}', desc: '{s['desc']}', prompt: '{s['prompt']}' }},\n"
js_str = js_str.rstrip(",\n") + "\n    ];"

# Update index.html
with open(os.path.join(base_dir, "index.html"), "r") as f:
    html = f.read()

html = re.sub(r'    const skillsData = \[.*?\];', js_str, html, flags=re.DOTALL)
# Update text in index.html to 21+
html = html.replace('14+ Ultimate Master Skills', '21+ Ultimate Master Skills')

with open(os.path.join(base_dir, "index.html"), "w") as f:
    f.write(html)

# Update README.md
with open(os.path.join(base_dir, "README.md"), "r") as f:
    readme = f.read()

readme = readme.replace('14+ Ultimate Skills', '21+ Ultimate Skills')
readme = readme.replace('14+ Ultimate Domain Skills', '21+ Ultimate Domain Skills')
readme = readme.replace('14 Ultimate Domain Skills', '21 Ultimate Domain Skills')

with open(os.path.join(base_dir, "README.md"), "w") as f:
    f.write(readme)
    
# Update install.sh
with open(os.path.join(base_dir, "install.sh"), "r") as f:
    install = f.read()

install = install.replace('14 ULTIMATE DOMAIN SKILLS', '21 ULTIMATE DOMAIN SKILLS')

with open(os.path.join(base_dir, "install.sh"), "w") as f:
    f.write(install)


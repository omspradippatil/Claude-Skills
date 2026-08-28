# ⚡ AI Coding Agent Skills & Tooling Suite

A curated, conflict-free, multi-platform installer for elite AI coding agent skills across **macOS, Linux, and Windows**.

Equip your AI coding agent (**Claude Code, Antigravity, Cursor, Codex, Windsurf, OpenCode**) with design heuristics, architecture visualization, mobile & web development rules, deep agentic SEO, backend architectures, workflow automation, and persistent cross-session memory.

---

## 🚀 One-Liner Quick Install (MAS / Terminal Activation Style)

Open your terminal or command prompt inside your project and run:

### 🍏 macOS & 🐧 Linux (Terminal)
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.sh)"
```
*(Or `curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.sh | bash`)*

### 🪟 Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.ps1 | iex
```

### 🪟 Windows (Command Prompt / CMD)
```cmd
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.ps1 | iex"
```

---

## 🗑️ One-Liner Quick Uninstall

To completely remove all installed skills, global packages, and cloned repositories in one command:

### 🍏 macOS & 🐧 Linux
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/uninstall.sh)"
```

### 🪟 Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/uninstall.ps1 | iex
```

---

## 🧠 What "Loading" Means in Skill (`SKILL.md`) Files

In modern AI agent systems (such as Claude Code, Antigravity, Cursor, and Codex), skills are **not** loaded by dumping thousands of lines into the context window at start. Instead, they operate on a **Progressive Disclosure & Lifecycle Loading System**:

```
┌──────────────────────────────────────────────────────────────┐
│ 1. Registration Phase (Indexing Frontmatter)                 │
│    Agent reads only the `name` and `description` YAML header │
│    (~20-50 tokens per skill) at agent startup.              │
└──────────────────────────────┬───────────────────────────────┘
                               │ User sends prompt matching trigger
                               ▼
┌──────────────────────────────────────────────────────────────┐
│ 2. Progressive Disclosure (On-Demand Loading)                │
│    Agent reads full `SKILL.md` workflows, guidelines, and    │
│    rule sets into active working context ONLY when required. │
└──────────────────────────────┬───────────────────────────────┘
                               │ Agent plans execution
                               ▼
┌──────────────────────────────────────────────────────────────┐
│ 3. Script & Evidence Collection Execution                    │
│    Agent invokes local Python/Node scripts or CLI tools      │
│    (e.g., SEO crawlers, Playwright headless, Archify).       │
└──────────────────────────────┬───────────────────────────────┘
                               │ Session ends / resumes
                               ▼
┌──────────────────────────────────────────────────────────────┐
│ 4. Cross-Session Memory Synthesis (Claude-Mem)               │
│    Agent actions and architectural decisions are compressed  │
│    and re-injected automatically into future conversations.  │
└──────────────────────────────────────────────────────────────┘
```

1. **Lightweight Indexing**: When an agent starts, it reads only the skill metadata (title, trigger conditions, domain). Your context window stays clean and fast.
2. **Context Activation**: When your prompt matches a skill (e.g., *"Design a high-contrast dark mode card"* or *"Audit our technical SEO schema"*), the agent loads that skill's exact rules, constraints, and decision trees.
3. **Tool Execution**: Skills with helper scripts (like `Archify`, `Playwright`, `Agentic SEO`, `UI Pro Max`) are executed locally without third-party API dependencies.
4. **Non-Conflicting Precedence**: Skills are partitioned into non-overlapping domains. UI design rules never conflict with database migrations or SEO indexing.

---

## 📦 Modular Skill Suites, Tasks & Activation Prompts

### 🎨 1. Core UI/UX, Design Systems & Taste (Primary Focus)
*Enforces human-like visual balance, clean typography, whitespace discipline, and eliminates generic "AI boilerplate" aesthetics.*

| Skill / Tool | What It Does & What Loading Means | Example Activation Prompt |
| :--- | :--- | :--- |
| **UI/UX Pro Max CLI** (`uipro-cli`) | Generates design guidelines, UI heuristics, color palettes, accessibility checks, and layout hierarchies. | `"uipro init --ai antigravity: Generate a design token system and color palette for a fintech dashboard."` |
| **Taste Skill** (`Leonxlnx/taste-skill`) | Strips generic AI styling; enforces whitespace discipline, high contrast, typography hierarchy, and authentic layout rhythm. | `"Redesign this settings view. Apply high taste, clean typography hierarchy, and remove generic AI borders/shadows."` |
| **Accessible Motion** (`mthines/agent-skills`) | Injects physics-based springs, easing curves, micro-interactions, gesture response, and hardware-accelerated 60fps animations. | `"Add spring physics transitions and micro-interactions to the modal open and accordion drawer."` |

---

### 🏛️ 2. Architecture & System Visualization
*Turns codebases and architectures into verifiable interactive HTML/SVG system maps.*

| Skill / Tool | What It Does & What Loading Means | Example Activation Prompt |
| :--- | :--- | :--- |
| **Archify System Mapper** (`tt-a1i/archify`) | Deterministically compiles codebase topology, workflows, sequence diagrams, and lifecycle charts into interactive, verifiable HTML/SVG diagrams. | `"Use archify to map this repository's runtime architecture and data flow as an interactive HTML diagram."` |

---

### 📱 3. Mobile App Development (Flutter / Dart / Native)
*Mobile-first architecture, widget trees, state management, and mobile security.*

| Skill / Tool | What It Does & What Loading Means | Example Activation Prompt |
| :--- | :--- | :--- |
| **Dart Skills CLI** (`dart pub global activate skills`) | Scans `pubspec.yaml` and registers official, package-specific instructions directly into your agent for your dependencies. | `"Inspect pubspec.yaml and generate Riverpod 2.0 state management with code-generation annotations."` |
| **Flutter Claude Skills** (`Harishwarrior/flutter-claude-skills`) | Context rules for widget rebuild optimization, Riverpod/BLoC patterns, native platform bridges, and platform conventions. | `"Optimize this ListView widget tree to prevent unnecessary rebuilds using const constructors and selector hooks."` |
| **Fastlane Skills** (`fastlane/agent-skills`) | Automates screenshot generation, keystore signing, metadata packaging, build numbering, and Play Store / TestFlight releases. | `"Create a Fastlane lane for automating TestFlight beta builds with dynamic build numbering and changelog generation."` |
| **OWASP Mobile Security** (`OWASP/secure-agent-playbook`) | Audits mobile source code for hardcoded secrets, insecure IPC, weak local encryption, and broken mobile API endpoints. | `"Audit this Flutter application against OWASP MASVS for hardcoded keys and insecure biometric storage."` |

---

### 🌐 4. Web Frontend, DOM & Browser Automation
*Web-specific UI/UX, DOM interactions, responsive layouts, and E2E browser testing.*

| Skill / Tool | What It Does & What Loading Means | Example Activation Prompt |
| :--- | :--- | :--- |
| **Frontend Agent Skills** (`hueyexe/frontend-agent-skills`) | Web-specific accessibility (WCAG AA/AAA), semantic HTML, responsive CSS grid/flexbox layouts, and UX copy formatting. | `"Refactor this navbar and hero section to be fully accessible with semantic ARIA landmarks and responsive CSS grid."` |
| **Web Design Collection** (`MengTo/Skills`) | Specialized CSS keyframes, layout transitions, scroll-driven effects, and Framer Motion patterns for modern websites. | `"Create a smooth scroll-driven card expansion effect using Framer Motion and Tailwind CSS."` |
| **TestDino Playwright Skill** (`testdino-hq/playwright-skill`) | AI-powered Playwright best practices, test generator, fixture optimizer, and flaky test auto-healing. | `"Write an end-to-end Playwright test suite for user authentication with fixtures and auto-retry for flaky network calls."` |
| **Playwright Browser CLI** (`@playwright/cli`) | Headless browser automation for UI visual regression checks, synthetic user workflows, and automated screenshots. | `"Run a visual regression test comparing the desktop and mobile checkout layouts."` |
| **Firecrawl CLI** (`firecrawl-cli`) | Crawls, cleans, and converts web pages into LLM-ready clean markdown for real-time web scraping and doc ingestion. | `"Crawl the official Supabase SSR documentation and summarize the auth cookie handling pattern."` |

---

### 🔍 5. Agentic SEO & Search Optimization
*LLM-first SEO analysis, structured data schemas, and Core Web Vitals optimization.*

| Skill / Tool | What It Does & What Loading Means | Example Activation Prompt |
| :--- | :--- | :--- |
| **Agentic SEO Skill Suite** (`Bhanunamikaze/Agentic-SEO-Skill`) | 16 sub-skills, 10 specialist agents, and 89 evidence collector scripts for technical SEO, schema audits, indexing, and LLM-search citation (AEO). | `"Run a full technical SEO audit on this landing page and generate JSON-LD schema for SoftwareApplication."` |
| **Ashley SEO & Indexing Agent** (`ashleytheash/seo-agent-skill`) | Audits technical on-page SEO, OpenGraph data, JSON-LD structured schemas, `robots.txt`, dynamic sitemaps, and Core Web Vitals. | `"Check our OpenGraph meta tags, canonical URLs, and sitemap configuration for Google indexing readiness."` |

---

### 🔥 6. Backend, Databases & Cloud Edge
*Relational databases, auth policies, serverless edge workers, and realtime data.*

| Skill / Tool | What It Does & What Loading Means | Example Activation Prompt |
| :--- | :--- | :--- |
| **Supabase Agent Skills** (`supabase/agent-skills`) | PostgreSQL architecture, Row Level Security (RLS) policies, Edge Functions (Deno), realtime subscriptions, and Auth triggers. | `"Design a PostgreSQL schema for a multi-tenant SaaS with strict Row Level Security (RLS) policies."` |
| **Firebase Agent Skills** (`firebase/agent-skills`) | Firestore document design, Firebase Cloud Messaging (FCM) push notifications, security rules, and serverless Cloud Functions. | `"Write Firestore security rules that only allow team members with role 'admin' to mutate billing records."` |
| **Neon Database Skills** (`neondatabase/agent-skills`) | Serverless Postgres, database branching for PRs, index tuning, connection pooling, and low-latency SQL optimization. | `"Configure database branching for CI/CD pull requests and optimize our indexing strategy on the orders table."` |
| **Cloudflare Ecosystem** (`cloudflare/skills`) | Workers, D1 SQL, R2 object storage, KV key-value stores, rate limiting, and edge API caching configurations. | `"Write a Cloudflare Worker with D1 SQL binding and edge cache headers for geo-distributed API responses."` |

---

### 🐳 7. DevOps, Local Infrastructure & Integrations
*Containerization, CI/CD automation, API contracts, and external orchestration.*

| Skill / Tool | What It Does & What Loading Means | Example Activation Prompt |
| :--- | :--- | :--- |
| **Docker Skills** (`docker/agent-skills`) | Multi-stage Dockerfile generation, docker-compose orchestration, local database mock services, and container hardening. | `"Create a multi-stage production Dockerfile for a Next.js / Flutter web app with non-root security user."` |
| **Composio Integration** (`composiohq/skills`) | Connects agent directly to GitHub Actions, repository issues, pull requests, Gmail alerts, and external workflow automations. | `"Set up a GitHub Action that triggers automated code review on every pull request using Composio."` |
| **Postman / OpenAPI Skills** (`postman/agent-skills`) | Ingests Swagger/OpenAPI specifications, generates strongly typed data models (Dart/TS), and automates endpoint contract testing. | `"Ingest openapi.yaml and generate strongly typed TypeScript API clients with Zod validation schemas."` |

---

### 🔄 8. Intelligent Workflows & Cross-Platform Plugins
*Stack-agnostic, question-driven workflows and the comprehensive 388+ Claude Code skills library.*

| Skill / Tool | What It Does & What Loading Means | Example Activation Prompt |
| :--- | :--- | :--- |
| **Antigravity Workflows** (`harikrishna8121999/antigravity-workflows`) | Question-driven workflows that auto-detect your project stack, ask clarifying architectural questions, and execute step-by-step. | `"Run antigravity workflow to implement a responsive authentication flow tailored to my tech stack."` |
| **Claude Skills Universal Library** (`alirezarezvani/claude-skills`) | 388+ production-ready Claude Code skills & plugins across 20 domains (Engineering, Security, C-Level, PR reviews, CI/CD). | `"Activate senior-architect skill: Review this codebase and propose a decoupled service layer."` |

---

### 🧠 9. Code Quality, Security & Persistent Memory
*Pragmatic architecture, cross-session memory preservation, exception monitoring, and up-to-date framework docs.*

| Skill / Tool | What It Does & What Loading Means | Example Activation Prompt |
| :--- | :--- | :--- |
| **Claude-Mem Persistent Memory** (`thedotmack/claude-mem`) | Automatically captures what the agent does during sessions, compresses it with AI, and injects relevant context back into future sessions. | *Automatic / Transparent* — `"What architectural decisions did we make yesterday regarding user permissions?"` |
| **Andrej Karpathy Philosophy** (`multica-ai/andrej-karpathy-skills`) | Prioritizes clarity, minimal abstractions, readability, clean foundational code, and strict engineering discipline. | `"Refactor this utility module following Karpathy principles: simple loops, zero over-engineering, maximum clarity."` |
| **Caveman & Ponytail** (`JuliusBrussee/caveman`, `DietrichGebert/ponytail`) | Eliminates framework bloat, prevents premature abstraction, enforces simple directory architectures, and refuses micro-abstractions. | `"Audit our directory structure and remove redundant wrapper abstractions."` |
| **Sentry for AI** (`getsentry/sentry-for-ai`) | Automated root-cause analysis for production exceptions, stack trace parsing, and regression pinpointing. | `"Analyze this production Sentry stack trace and identify the null-pointer regression."` |
| **CTX7 Documentation Indexer** (`ctx7`) | Indexes and injects the latest framework/library documentation directly into the agent context, eliminating hallucinations from outdated APIs. | `"ctx7 index react-router@v7: Show the exact route loader configuration for nested layouts."` |

---

## 🎯 Conflict-Free Synchronization Architecture

All skills have been structured into distinct, complementary layers:
- **Design & UI**: `uipro-cli` + `taste-skill` + `agent-skills motion` operate exclusively on visual rendering, CSS, and layout tokens.
- **System Mapping**: `archify` operates exclusively on system diagrams and architecture exports.
- **Platform Separation**: Mobile rules (`flutter-claude-skills`, `fastlane`) only trigger on Flutter/Dart files; Web rules (`playwright-skill`, `frontend-agent-skills`) trigger on DOM/Web code.
- **Memory & Continuity**: `claude-mem` operates at the session layer, preserving your progress without modifying source code.

Everything installs cleanly in seconds and operates in complete synchronization!

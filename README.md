# ⚡ AI Coding Agent Skills & Tooling Suite

A curated, automated installer for world-class AI coding agent skills across **macOS, Linux, and Windows**.

Equip your AI coding agent (Claude Code, Antigravity, Cursor, etc.) with elite architectural guidelines, taste-enforced UI/UX, mobile rules, backend architectures, DevOps pipelines, and persistent memory.

---

## 🚀 One-Liner Quick Install (MAS / Windows Activation Style)

Open your terminal or command prompt inside your project and run:

### 🍏 macOS & 🐧 Linux (Terminal)
```bash
curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.sh | bash
```

### 🪟 Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.ps1 | iex
```

### 🪟 Windows (Command Prompt / CMD)
```cmd
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.ps1 | iex"
```

---

## 🎯 Interactive Setup Modes

When executed, the installer will automatically detect your environment, check prerequisites (`Node.js`, `npm`, `git`, `dart`), and prompt you:

```text
Are you installing skills for an application or a web app?

  1) 📱 Mobile Application   (Flutter / Dart / Native + UI/UX + Backend + DevOps + Quality)
  2) 🌐 Web Application      (Frontend + DOM + SEO + Playwright + Backend + DevOps + Quality)
  3) 🚀 All-in-One Full Suite (Install ALL Mobile, Web, UI/UX, Cloud, DevOps & Quality skills)
  4) 🎯 Custom Selection      (Choose specific skill categories to install)
```

---

## 📦 Detailed Skills Breakdown & Descriptions

### 🎨 1. Core UI/UX, Design Systems & Taste (Primary Focus)
| Skill / Tool | Purpose & Usage | Command |
| :--- | :--- | :--- |
| **UI/UX Pro Max CLI** | Generates design guidelines, UI heuristics, color palettes, accessibility checks, and layout hierarchies. | `npm install -g uipro-cli` |
| **Taste Skill** | Enforces human-like visual balance, clean typography, whitespace discipline, and eliminates generic AI aesthetics. | `npx skills@latest add Leonxlnx/taste-skill -g` |
| **Accessible Motion** | Physics-based springs, easing curves, micro-interactions, gesture response, and hardware-accelerated animations. | `npx skills@latest add mthines/agent-skills -g` |

---

### 📱 2. Mobile App Development (Flutter / Dart / Native)
| Skill / Tool | Purpose & Usage | Command |
| :--- | :--- | :--- |
| **Dart Skills CLI** | Scans `pubspec.yaml` and registers official, package-specific instructions directly into your agent. | `dart pub global activate skills` |
| **Flutter Claude Skills** | Context rules for widget rebuild optimization, Riverpod/BLoC patterns, native bridges, and platform conventions. | Cloned into `~/.claude/skills/flutter-skills` |
| **Fastlane Skills** | Automates screenshot generation, keystore signing, metadata packaging, build numbering, and Play Store / TestFlight releases. | `npx skills@latest add fastlane/agent-skills -g` |
| **OWASP Mobile Security** | Audits mobile source code for hardcoded secrets, insecure IPC, weak local encryption, and broken mobile API endpoints. | `npx skills@latest add OWASP/secure-agent-playbook -g` |

---

### 🌐 3. Web Frontend, DOM & Browser Automation
| Skill / Tool | Purpose & Usage | Command |
| :--- | :--- | :--- |
| **Frontend Agent Skills** | Web-specific accessibility (WCAG), semantic HTML, responsive CSS grid/flexbox layouts, and UX copy formatting. | `npx skills@latest add hueyexe/frontend-agent-skills -g` |
| **Web Interaction Skills**| Specialized CSS keyframes, layout transitions, scroll-driven effects, and Framer Motion patterns for modern websites. | `npx skills@latest add MengTo/Skills -g` |
| **SEO & Indexing Agent** | Audits technical on-page SEO, OpenGraph data, JSON-LD structured schemas, robots.txt, sitemaps, and Core Web Vitals. | `npx skills@latest add ashleytheash/seo-agent-skill -g` |
| **Playwright Automation**| Headless browser automation for UI visual regression checks, synthetic user workflows, E2E testing, and screenshots. | `npm install -g @playwright/cli@latest` + `playwright-cli install --skills` |
| **Firecrawl CLI** | Crawls, cleans, and converts web pages into LLM-ready clean markdown for real-time web scraping and doc ingestion. | `npm install -g firecrawl-cli` |

---

### 🔥 4. Backend, Databases & Cloud Edge
| Skill / Tool | Purpose & Usage | Command |
| :--- | :--- | :--- |
| **Supabase Agent Skills**| PostgreSQL architecture, Row Level Security (RLS) policies, Edge Functions (Deno), realtime subscriptions, and Auth triggers. | `npx skills@latest add supabase/agent-skills -g` |
| **Firebase Agent Skills**| Firestore document design, Firebase Cloud Messaging (FCM) push notifications, security rules, and Cloud Functions. | `npx skills@latest add firebase/agent-skills -g` |
| **Neon Database Skills** | Serverless Postgres, database branching for PRs, index tuning, connection pooling, and low-latency SQL query optimization. | `npx skills@latest add neondatabase/agent-skills -g` |
| **Cloudflare Ecosystem** | Workers, D1 SQL, R2 object storage, KV key-value stores, rate limiting, and edge API caching configurations. | `npx skills@latest add https://github.com/cloudflare/skills -g` |

---

### 🐳 5. DevOps, Local Infrastructure & Integrations
| Skill / Tool | Purpose & Usage | Command |
| :--- | :--- | :--- |
| **Docker Skills** | Multi-stage Dockerfile generation, docker-compose orchestration, local database mock services, and container hardening. | `npx skills@latest add docker/agent-skills -g` |
| **Composio Integration** | Connects agent directly to GitHub Actions, repository issues, pull requests, Gmail alerts, and external workflow automations. | `npx skills@latest add composiohq/skills -g` |
| **Postman / OpenAPI** | Ingests Swagger/OpenAPI specifications, generates strongly typed data models (Dart/TS), and automates endpoint contract testing. | `npx skills@latest add postman/agent-skills -g` |

---

### 🧠 6. Code Quality, Observability & Persistent Memory
| Skill / Tool | Purpose & Usage | Command |
| :--- | :--- | :--- |
| **Andrej Karpathy Philosophy** | Prioritizes clarity, minimal abstractions, readability, clean foundational code, and strict engineering discipline. | `npx skills@latest add multica-ai/andrej-karpathy-skills -g` |
| **Caveman** | Eliminates framework bloat, prevents over-engineering, enforces simple directory architectures, and refuses micro-abstractions. | `npx skills@latest add JuliusBrussee/caveman -g` |
| **Ponytail** | Clean code patterns and refusal of unnecessary micro-abstractions. | `npx skills@latest add https://github.com/DietrichGebert/ponytail/tree/main/skills -g` |
| **MemoryPlugin** | Provides cross-session long-term memory so the agent retains project context, design preferences, and architectural decisions. | `npx skills@latest add memoryplugin/agent-skills -g` |
| **Sentry for AI** | Automated root-cause analysis for production exceptions, stack trace parsing, and regression pinpointing. | `npx skills@latest add getsentry/sentry-for-ai -g` |
| **CTX7 Documentation Indexer** | Indexes and injects the latest framework/library documentation directly into the agent context, eliminating hallucinations. | `npm install -g ctx7` |

---

## 💡 Pro Tips

- **Initialize Design Tokens**: In any UI project folder, run:
  ```bash
  uipro init --ai antigravity
  ```
- **Local Execution**: You can also clone this repository and run the scripts locally:
  - macOS/Linux: `./install.sh`
  - Windows: `.\install.ps1` or double-click `install.bat`

<#
==============================================================================
 🚀 AI Agent Skills Installer & Manager (Windows PowerShell)
 Repository: https://github.com/omspradippatil/Claude-Skills
==============================================================================
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Write-Banner {
    Write-Host ""
    Write-Host "╔═════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                ⚡ AI CODING SKILLS & AGENT SUITE ⚡                    ║" -ForegroundColor Cyan
    Write-Host "║         High-Performance Skills & Tooling for AI Coding Agents          ║" -ForegroundColor Cyan
    Write-Host "╚═════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-HeaderSection([string]$title) {
    Write-Host ""
    Write-Host "==============================================================================" -ForegroundColor Magenta
    Write-Host " $title" -ForegroundColor Magenta
    Write-Host "==============================================================================" -ForegroundColor Magenta
}

function Run-Step([string]$title, [string]$description, [string]$command) {
    Write-Host ""
    Write-Host "▶ $title" -ForegroundColor Cyan
    Write-Host "  Purpose: $description" -ForegroundColor DarkGray
    Write-Host "  Command: $command" -ForegroundColor Yellow
    
    try {
        Invoke-Expression $command
        if ($LASTEXITCODE -eq 0 -or $? -eq $true) {
            Write-Host "  ✔ Completed successfully!" -ForegroundColor Green
        } else {
            Write-Host "  ✖ Warning: Process completed with non-zero exit code ($LASTEXITCODE). Continuing..." -ForegroundColor DarkYellow
        }
    } catch {
        Write-Host "  ✖ Error executing: $_" -ForegroundColor Red
    }
}

function Check-Prerequisites {
    Write-Host "🔍 Checking system prerequisites..." -ForegroundColor Blue
    
    if (Get-Command node -ErrorAction SilentlyContinue) {
        $nodeVer = node -v
        Write-Host "  ✔ Node.js: $nodeVer" -ForegroundColor Green
    } else {
        Write-Host "  ✖ Node.js is not installed! Please install Node.js (https://nodejs.org) to use npx & npm skills." -ForegroundColor Red
    }

    if (Get-Command npm -ErrorAction SilentlyContinue) {
        $npmVer = npm -v
        Write-Host "  ✔ npm: $npmVer" -ForegroundColor Green
    } else {
        Write-Host "  ✖ npm is not installed!" -ForegroundColor Red
    }

    if (Get-Command git -ErrorAction SilentlyContinue) {
        $gitVer = git --version
        Write-Host "  ✔ Git: $gitVer" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Git is not installed! Some repository skills may fail." -ForegroundColor Yellow
    }
    Write-Host ""
}

# ==============================================================================
# INSTALLATION FUNCTIONS
# ==============================================================================

function Install-CoreUiUx {
    Write-HeaderSection "🎨 1. CORE UI/UX, DESIGN SYSTEMS & TASTE"
    
    Run-Step "UI/UX Pro Max CLI" `
        "Generates design guidelines, UI heuristics, color palettes, accessibility checks, and layout hierarchies." `
        "npm install -g uipro-cli"

    Run-Step "Taste Skill" `
        "Enforces human-like visual balance, clean typography, whitespace discipline, and eliminates generic AI aesthetics." `
        "npx --yes skills@latest add Leonxlnx/taste-skill -g -y"

    Run-Step "Accessible & Performant Motion" `
        "Provides context for physics-based springs, easing curves, micro-interactions, gesture response, and 60fps animations." `
        "npx --yes skills@latest add mthines/agent-skills -g -y"
}

function Install-MobileSkills {
    Write-HeaderSection "📱 2. MOBILE APP DEVELOPMENT (FLUTTER / DART / NATIVE)"

    if (Get-Command dart -ErrorAction SilentlyContinue) {
        Run-Step "Dart Skills CLI" `
            "Scans pubspec.yaml and registers official, package-specific instructions directly into your agent." `
            "dart pub global activate skills"
    } else {
        Write-Host "⚠ Dart SDK not found. Skipping 'dart pub global activate skills'. (Install Flutter/Dart if developing mobile apps)." -ForegroundColor Yellow
    }

    $flutterSkillsDir = Join-Path $HOME ".claude\skills\flutter-skills"
    $claudeSkillsDir = Join-Path $HOME ".claude\skills"
    if (!(Test-Path $claudeSkillsDir)) {
        New-Item -ItemType Directory -Force -Path $claudeSkillsDir | Out-Null
    }

    if (Test-Path $flutterSkillsDir) {
        Run-Step "Community Flutter Claude Skills (Update)" `
            "Context rules for widget rebuild optimization, Riverpod/BLoC patterns, native bridges, and platform conventions." `
            "git -C `"$flutterSkillsDir`" pull"
    } else {
        Run-Step "Community Flutter Claude Skills (Clone)" `
            "Context rules for widget rebuild optimization, Riverpod/BLoC patterns, native bridges, and platform conventions." `
            "git clone https://github.com/Harishwarrior/flutter-claude-skills.git `"$flutterSkillsDir`""
    }

    Run-Step "Fastlane Skills" `
        "Automates screenshot generation, keystore signing, metadata packaging, build numbering, and Play Store / TestFlight releases." `
        "npx --yes skills@latest add fastlane/agent-skills -g -y"

    Run-Step "OWASP Mobile & API Security Playbook" `
        "Audits mobile source code for hardcoded secrets, insecure IPC, weak local encryption, and broken mobile API endpoints." `
        "npx --yes skills@latest add OWASP/secure-agent-playbook -g -y"
}

function Install-WebSkills {
    Write-HeaderSection "🌐 3. WEB FRONTEND, DOM & BROWSER AUTOMATION"

    Run-Step "Frontend Agent Skills" `
        "Web-specific accessibility (WCAG), semantic HTML, responsive CSS grid/flexbox layouts, and UX copy formatting." `
        "npx --yes skills@latest add hueyexe/frontend-agent-skills -g -y"

    Run-Step "Web Design & Interaction Collection" `
        "Specialized CSS keyframes, layout transitions, scroll-driven effects, and Framer Motion patterns for modern websites." `
        "npx --yes skills@latest add MengTo/Skills -g -y"

    Run-Step "SEO & Indexing Agent" `
        "Audits technical on-page SEO, OpenGraph data, JSON-LD structured schemas, robots.txt, sitemaps, and Core Web Vitals." `
        "npx --yes skills@latest add ashleytheash/seo-agent-skill -g -y"

    Run-Step "Playwright Browser Automation" `
        "Headless browser automation for UI visual regression checks, synthetic user workflows, E2E testing, and screenshots." `
        "npm install -g @playwright/cli@latest; playwright-cli install --skills"

    Run-Step "Firecrawl CLI" `
        "Crawls, cleans, and converts web pages into LLM-ready clean markdown for real-time web scraping and doc ingestion." `
        "npm install -g firecrawl-cli"
}

function Install-BackendSkills {
    Write-HeaderSection "🔥 4. BACKEND, DATABASES & CLOUD EDGE"

    Run-Step "Supabase Agent Skills" `
        "PostgreSQL architecture, Row Level Security (RLS) policies, Edge Functions (Deno), realtime subscriptions, and Auth triggers." `
        "npx --yes skills@latest add supabase/agent-skills -g -y"

    Run-Step "Firebase Agent Skills" `
        "Firestore document design, Firebase Cloud Messaging (FCM) push notifications, security rules, and serverless Cloud Functions." `
        "npx --yes skills@latest add firebase/agent-skills -g -y"

    Run-Step "Neon Database Skills" `
        "Serverless Postgres, database branching for PRs, index tuning, connection pooling, and low-latency SQL optimization." `
        "npx --yes skills@latest add neondatabase/agent-skills -g -y"

    Run-Step "Cloudflare Ecosystem" `
        "Workers, D1 SQL, R2 object storage, KV key-value stores, rate limiting, and edge API caching configurations." `
        "npx --yes skills@latest add https://github.com/cloudflare/skills -g -y"
}

function Install-DevOpsSkills {
    Write-HeaderSection "🐳 5. DEVOPS, LOCAL INFRASTRUCTURE & INTEGRATIONS"

    Run-Step "Docker Skills" `
        "Multi-stage Dockerfile generation, docker-compose orchestration, local database mock services, and container hardening." `
        "npx --yes skills@latest add docker/agent-skills -g -y"

    Run-Step "Composio Integration" `
        "Connects agent directly to GitHub Actions, repository issues, pull requests, Gmail alerts, and external workflow automations." `
        "npx --yes skills@latest add composiohq/skills -g -y"

    Run-Step "Postman / OpenAPI Skills" `
        "Ingests Swagger/OpenAPI specifications, generates strongly typed data models (Dart/TS), and automates endpoint contract testing." `
        "npx --yes skills@latest add postman/agent-skills -g -y"
}

function Install-CodeQualitySkills {
    Write-HeaderSection "🧠 6. CODE QUALITY, OBSERVABILITY & PERSISTENT MEMORY"

    Run-Step "Andrej Karpathy Engineering Philosophy" `
        "Prioritizes clarity, minimal abstractions, readability, clean foundational code, and strict engineering discipline." `
        "npx --yes skills@latest add multica-ai/andrej-karpathy-skills -g -y"

    Run-Step "Caveman (Anti-Overengineering)" `
        "Eliminates framework bloat, prevents over-engineering, enforces simple directory architectures, and refuses micro-abstractions." `
        "npx --yes skills@latest add JuliusBrussee/caveman -g -y"

    Run-Step "Ponytail Skills" `
        "Enforces clean software design patterns, eliminating bloated libraries and preserving codebase simplicity." `
        "npx --yes skills@latest add https://github.com/DietrichGebert/ponytail/tree/main/skills -g -y"

    Run-Step "MemoryPlugin (Cross-Session Persistence)" `
        "Provides cross-session long-term memory so the agent retains project context, design preferences, and architectural decisions." `
        "npx --yes skills@latest add memoryplugin/agent-skills -g -y"

    Run-Step "Sentry for AI" `
        "Automated root-cause analysis for production exceptions, stack trace parsing, and regression pinpointing." `
        "npx --yes skills@latest add getsentry/sentry-for-ai -g -y"

    Run-Step "CTX7 Documentation Indexer" `
        "Indexes and injects the latest framework/library documentation directly into the agent context, eliminating hallucinations." `
        "npm install -g ctx7"
}

# ==============================================================================
# UNINSTALLATION FUNCTIONS
# ==============================================================================

function Uninstall-CoreUiUx {
    Write-HeaderSection "🗑️  REMOVING CORE UI/UX & TASTE SKILLS"
    Run-Step "Uninstall UI/UX Pro Max CLI" "Removes global uipro-cli" "npm uninstall -g uipro-cli"
    Run-Step "Remove Taste Skill" "Removes taste skill" "npx --yes skills@latest remove -g -y taste-skill"
    Run-Step "Remove Motion Skills" "Removes motion skills" "npx --yes skills@latest remove -g -y agent-skills"
}

function Uninstall-MobileSkills {
    Write-HeaderSection "🗑️  REMOVING MOBILE APP SKILLS"
    if (Get-Command dart -ErrorAction SilentlyContinue) {
        Run-Step "Deactivate Dart Skills CLI" "Removes global dart skills" "dart pub global deactivate skills"
    }
    $flutterSkillsDir = Join-Path $HOME ".claude\skills\flutter-skills"
    if (Test-Path $flutterSkillsDir) {
        Run-Step "Remove Flutter Skills Folder" "Deletes cloned flutter-skills folder" "Remove-Item -Recurse -Force `"$flutterSkillsDir`""
    }
    Run-Step "Remove Fastlane Skills" "Removes fastlane agent skills" "npx --yes skills@latest remove -g -y fastlane"
    Run-Step "Remove OWASP Security Playbook" "Removes mobile security playbook" "npx --yes skills@latest remove -g -y secure-agent-playbook"
}

function Uninstall-WebSkills {
    Write-HeaderSection "🗑️  REMOVING WEB & BROWSER SKILLS"
    Run-Step "Uninstall Playwright CLI & Firecrawl" "Removes global web CLIs" "npm uninstall -g @playwright/cli firecrawl-cli"
    Run-Step "Remove Frontend Agent Skills" "Removes frontend skills" "npx --yes skills@latest remove -g -y frontend-agent-skills"
    Run-Step "Remove Web Design Collection" "Removes web animation skills" "npx --yes skills@latest remove -g -y Skills"
    Run-Step "Remove SEO Agent" "Removes SEO agent skills" "npx --yes skills@latest remove -g -y seo-agent-skill"
}

function Uninstall-BackendSkills {
    Write-HeaderSection "🗑️  REMOVING BACKEND & CLOUD SKILLS"
    Run-Step "Remove Supabase Skills" "Removes Supabase skills" "npx --yes skills@latest remove -g -y supabase"
    Run-Step "Remove Firebase Skills" "Removes Firebase skills" "npx --yes skills@latest remove -g -y firebase"
    Run-Step "Remove Neon Skills" "Removes Neon database skills" "npx --yes skills@latest remove -g -y neondatabase"
    Run-Step "Remove Cloudflare Skills" "Removes Cloudflare skills" "npx --yes skills@latest remove -g -y cloudflare"
}

function Uninstall-DevOpsSkills {
    Write-HeaderSection "🗑️  REMOVING DEVOPS & INTEGRATION SKILLS"
    Run-Step "Remove Docker Skills" "Removes Docker skills" "npx --yes skills@latest remove -g -y docker"
    Run-Step "Remove Composio Skills" "Removes Composio skills" "npx --yes skills@latest remove -g -y composio"
    Run-Step "Remove Postman Skills" "Removes Postman OpenAPI skills" "npx --yes skills@latest remove -g -y postman"
}

function Uninstall-CodeQualitySkills {
    Write-HeaderSection "🗑️  REMOVING CODE QUALITY & MEMORY SKILLS"
    Run-Step "Uninstall CTX7 Indexer" "Removes global ctx7 CLI" "npm uninstall -g ctx7"
    Run-Step "Remove Andrej Karpathy Skills" "Removes Karpathy engineering rules" "npx --yes skills@latest remove -g -y andrej-karpathy-skills"
    Run-Step "Remove Caveman Skills" "Removes anti-bloat rules" "npx --yes skills@latest remove -g -y caveman"
    Run-Step "Remove Ponytail Skills" "Removes ponytail rules" "npx --yes skills@latest remove -g -y ponytail"
    Run-Step "Remove MemoryPlugin" "Removes cross-session memory skills" "npx --yes skills@latest remove -g -y memoryplugin"
    Run-Step "Remove Sentry for AI" "Removes Sentry AI skills" "npx --yes skills@latest remove -g -y sentry-for-ai"
}

function Uninstall-AllSkills {
    Write-HeaderSection "🗑️  REMOVING ALL INSTALLED SKILLS & GLOBAL PACKAGES"
    
    Write-Host "Uninstalling all global skills CLI registry entries..." -ForegroundColor Yellow
    npx --yes skills@latest remove --all -g -y 2>$null

    Write-Host "Uninstalling global npm packages..." -ForegroundColor Yellow
    npm uninstall -g uipro-cli @playwright/cli firecrawl-cli ctx7 2>$null

    if (Get-Command dart -ErrorAction SilentlyContinue) {
        Write-Host "Deactivating global Dart skills..." -ForegroundColor Yellow
        dart pub global deactivate skills 2>$null
    }

    $flutterSkillsDir = Join-Path $HOME ".claude\skills\flutter-skills"
    if (Test-Path $flutterSkillsDir) {
        Write-Host "Removing cloned Claude skills directory..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force $flutterSkillsDir 2>$null
    }

    Write-Host ""
    Write-Host "═════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host " 🗑️  ALL SKILLS & TOOLS HAVE BEEN UNINSTALLED SUCCESSFULLY!              " -ForegroundColor Green
    Write-Host "═════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
}

# Main Script Entry Point
function Main {
    Write-Banner
    Check-Prerequisites

    Write-Host "Select an action or project configuration:" -ForegroundColor White
    Write-Host ""
    Write-Host "  1) 📱 Install: Mobile Application   (Flutter / Dart / Native + UI/UX + Backend + DevOps + Quality)" -ForegroundColor Cyan
    Write-Host "  2) 🌐 Install: Web Application      (Frontend + DOM + SEO + Playwright + Backend + DevOps + Quality)" -ForegroundColor Cyan
    Write-Host "  3) 🚀 Install: All-in-One Full Suite (Install ALL Mobile, Web, UI/UX, Cloud, DevOps & Quality skills)" -ForegroundColor Cyan
    Write-Host "  4) 🎯 Install: Custom Selection      (Choose specific skill categories to install)" -ForegroundColor Cyan
    Write-Host "  5) 🗑️  Delete / Uninstall Skills      (Remove installed skills, CLIs, and configs)" -ForegroundColor Red
    Write-Host ""
    
    $choice = Read-Host "Select an option [1-5] (default: 3)"
    if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "3" }

    switch ($choice) {
        "1" {
            Write-Host "`n🚀 Starting Mobile Application Skills Installation..." -ForegroundColor Green
            Install-CoreUiUx
            Install-MobileSkills
            Install-BackendSkills
            Install-DevOpsSkills
            Install-CodeQualitySkills
        }
        "2" {
            Write-Host "`n🚀 Starting Web Application Skills Installation..." -ForegroundColor Green
            Install-CoreUiUx
            Install-WebSkills
            Install-BackendSkills
            Install-DevOpsSkills
            Install-CodeQualitySkills
        }
        "3" {
            Write-Host "`n🚀 Starting Complete All-in-One Skills Installation..." -ForegroundColor Green
            Install-CoreUiUx
            Install-MobileSkills
            Install-WebSkills
            Install-BackendSkills
            Install-DevOpsSkills
            Install-CodeQualitySkills
        }
        "4" {
            Write-Host "`nSelect categories to install:" -ForegroundColor White

            $c1 = Read-Host "Install 🎨 Core UI/UX & Taste skills? [Y/n]"
            if ($c1 -notmatch "^[Nn]") { Install-CoreUiUx }

            $c2 = Read-Host "Install 📱 Mobile App (Flutter/Dart) skills? [Y/n]"
            if ($c2 -notmatch "^[Nn]") { Install-MobileSkills }

            $c3 = Read-Host "Install 🌐 Web Frontend & Browser skills? [Y/n]"
            if ($c3 -notmatch "^[Nn]") { Install-WebSkills }

            $c4 = Read-Host "Install 🔥 Backend & Cloud Edge skills? [Y/n]"
            if ($c4 -notmatch "^[Nn]") { Install-BackendSkills }

            $c5 = Read-Host "Install 🐳 DevOps & Integrations skills? [Y/n]"
            if ($c5 -notmatch "^[Nn]") { Install-DevOpsSkills }

            $c6 = Read-Host "Install 🧠 Code Quality & Memory skills? [Y/n]"
            if ($c6 -notmatch "^[Nn]") { Install-CodeQualitySkills }
        }
        "5" {
            Write-Host "`n🗑️  Uninstall Options:" -ForegroundColor Red
            Write-Host "  1) Delete ALL installed skills and global packages"
            Write-Host "  2) Delete specific skill categories"
            Write-Host ""
            $unChoice = Read-Host "Select uninstall option [1-2] (default: 1)"
            if ([string]::IsNullOrWhiteSpace($unChoice)) { $unChoice = "1" }

            if ($unChoice -eq "2") {
                $u1 = Read-Host "Remove 🎨 Core UI/UX skills? [y/N]"
                if ($u1 -match "^[Yy]") { Uninstall-CoreUiUx }

                $u2 = Read-Host "Remove 📱 Mobile App skills? [y/N]"
                if ($u2 -match "^[Yy]") { Uninstall-MobileSkills }

                $u3 = Read-Host "Remove 🌐 Web Frontend & Browser skills? [y/N]"
                if ($u3 -match "^[Yy]") { Uninstall-WebSkills }

                $u4 = Read-Host "Remove 🔥 Backend & Cloud Edge skills? [y/N]"
                if ($u4 -match "^[Yy]") { Uninstall-BackendSkills }

                $u5 = Read-Host "Remove 🐳 DevOps & Integrations skills? [y/N]"
                if ($u5 -match "^[Yy]") { Uninstall-DevOpsSkills }

                $u6 = Read-Host "Remove 🧠 Code Quality & Memory skills? [y/N]"
                if ($u6 -match "^[Yy]") { Uninstall-CodeQualitySkills }
            } else {
                Uninstall-AllSkills
            }
            return
        }
        Default {
            Write-Host "`nInvalid option. Defaulting to Complete All-in-One installation." -ForegroundColor Yellow
            Install-CoreUiUx
            Install-MobileSkills
            Install-WebSkills
            Install-BackendSkills
            Install-DevOpsSkills
            Install-CodeQualitySkills
        }
    }

    Write-Host ""
    Write-Host "═════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host " 🎉 ALL SKILLS HAVE BEEN CONFIGURED & INSTALLED SUCCESSFULLY! 🎉           " -ForegroundColor Green
    Write-Host "═════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "💡 Quick Tip: To initialize project-level design tokens in any UI project, run: uipro init --ai antigravity" -ForegroundColor Cyan
    Write-Host ""
}

Main

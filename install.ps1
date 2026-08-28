<#
==============================================================================
 🚀 AI Agent Skills Installer & Manager (Windows PowerShell)
 Repository: https://github.com/omspradippatil/Claude-Skills
==============================================================================
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
param(
    [switch]$Uninstall,
    [switch]$Global,
    [switch]$Project
)

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

# Scope Settings
$global:ScopeFlag = "-g"
$global:ScopeNpm = "-g"
$global:ScopeDesc = "Global (~/.agents & system-wide)"
$global:SkillsDir = Join-Path $HOME ".claude\skills"

function Set-Scope([string]$choice) {
    if ($choice -eq "2") {
        $global:ScopeFlag = ""
        $global:ScopeNpm = ""
        $global:ScopeDesc = "Project Directory ($((Get-Location).Path))"
        $global:SkillsDir = Join-Path (Get-Location).Path ".claude\skills"
        $agentDir = Join-Path (Get-Location).Path ".agent\skills"
        if (!(Test-Path $global:SkillsDir)) { New-Item -ItemType Directory -Force -Path $global:SkillsDir | Out-Null }
        if (!(Test-Path $agentDir)) { New-Item -ItemType Directory -Force -Path $agentDir | Out-Null }
    } else {
        $global:ScopeFlag = "-g"
        $global:ScopeNpm = "-g"
        $global:ScopeDesc = "Global (~/.agents & system-wide)"
        $global:SkillsDir = Join-Path $HOME ".claude\skills"
        if (!(Test-Path $global:SkillsDir)) { New-Item -ItemType Directory -Force -Path $global:SkillsDir | Out-Null }
    }
}

# ==============================================================================
# INSTALLATION FUNCTIONS (ALL SKILLS AUTO-CONFIRMED VIA --all -y)
# ==============================================================================

function Install-CoreUiUx {
    Write-HeaderSection "🎨 1. CORE UI/UX, DESIGN SYSTEMS & TASTE"
    
    if ($global:ScopeNpm -eq "-g") {
        Run-Step "UI/UX Pro Max CLI" "Generates design guidelines, UI heuristics, and layout hierarchies." "npm install -g uipro-cli"
    } else {
        Run-Step "UI/UX Pro Max CLI" "Generates design guidelines, UI heuristics, and layout hierarchies." "npm install --save-dev uipro-cli"
    }

    Run-Step "Taste Skill" `
        "Enforces human-like visual balance, clean typography, whitespace discipline, and eliminates generic AI aesthetics." `
        "npx --yes skills@latest add Leonxlnx/taste-skill $global:ScopeFlag --all -y"

    Run-Step "Accessible & Performant Motion" `
        "Provides context for physics-based springs, easing curves, micro-interactions, gesture response, and 60fps animations." `
        "npx --yes skills@latest add mthines/agent-skills $global:ScopeFlag --all -y"
}

function Install-ArchitectureSkills {
    Write-HeaderSection "🏛️ 2. ARCHITECTURE & SYSTEM VISUALIZATION"

    Run-Step "Archify System Mapper" `
        "Compiles codebase topology and workflows into beautiful, verifiable interactive HTML/SVG diagrams with motion." `
        "npx --yes skills@latest add tt-a1i/archify $global:ScopeFlag --all -y"
}

function Install-MobileSkills {
    Write-HeaderSection "📱 3. MOBILE APP DEVELOPMENT (FLUTTER / DART / NATIVE)"

    if (Get-Command dart -ErrorAction SilentlyContinue) {
        Run-Step "Dart Skills CLI" `
            "Scans pubspec.yaml and registers official, package-specific instructions directly into your agent." `
            "dart pub global activate skills"
    } else {
        Write-Host "⚠ Dart SDK not found. Skipping 'dart pub global activate skills'. (Install Flutter/Dart if developing mobile apps)." -ForegroundColor Yellow
    }

    $flutterSkillsDir = Join-Path $global:SkillsDir "flutter-skills"
    if (Test-Path $flutterSkillsDir) {
        Run-Step "Community Flutter Claude Skills (Update)" `
            "Context rules for widget rebuild optimization, Riverpod/BLoC patterns, native bridges, and platform conventions." `
            "git -C `"$flutterSkillsDir`" pull"
    } else {
        Run-Step "Community Flutter Claude Skills (Clone)" `
            "Context rules for widget rebuild optimization, Riverpod/BLoC patterns, native bridges, and platform conventions." `
            "git clone https://github.com/Harishwarrior/flutter-claude-skills.git `"$flutterSkillsDir`""
    }

    Run-Step "OWASP Mobile & API Security Playbook" `
        "Audits mobile source code for hardcoded secrets, insecure IPC, weak local encryption, and broken mobile API endpoints." `
        "npx --yes skills@latest add OWASP/secure-agent-playbook $global:ScopeFlag --all -y"
}

function Install-WebSkills {
    Write-HeaderSection "🌐 4. WEB FRONTEND, DOM & BROWSER AUTOMATION"

    Run-Step "Frontend Agent Skills" `
        "Web-specific accessibility (WCAG), semantic HTML, responsive CSS grid/flexbox layouts, and UX copy formatting." `
        "npx --yes skills@latest add hueyexe/frontend-agent-skills $global:ScopeFlag --all -y"

    Run-Step "Web Design & Interaction Collection" `
        "Specialized CSS keyframes, layout transitions, scroll-driven effects, and Framer Motion patterns for modern websites." `
        "npx --yes skills@latest add MengTo/Skills $global:ScopeFlag --all -y"

    Run-Step "TestDino Playwright Skill" `
        "AI-powered Playwright testing toolkit: best practices, test generators, fixture optimizations, and flaky test healing." `
        "npx --yes skills@latest add testdino-hq/playwright-skill $global:ScopeFlag --all -y"

    if ($global:ScopeNpm -eq "-g") {
        Run-Step "Playwright Browser Automation CLI" "Headless browser automation for UI regression checks." "npm install -g @playwright/cli@latest; playwright-cli install --skills"
        Run-Step "Firecrawl CLI" "Crawls and converts web pages into clean markdown." "npm install -g firecrawl-cli"
    } else {
        Run-Step "Playwright Browser Automation CLI" "Headless browser automation for UI regression checks." "npm install --save-dev @playwright/cli@latest"
        Run-Step "Firecrawl CLI" "Crawls and converts web pages into clean markdown." "npm install --save-dev firecrawl-cli"
    }
}

function Install-SeoSkills {
    Write-HeaderSection "🔍 5. AGENTIC SEO & SEARCH OPTIMIZATION"

    $seoSkillsDir = Join-Path $global:SkillsDir "seo"
    if (Test-Path $seoSkillsDir) {
        Run-Step "Agentic SEO Skill Suite (Update)" `
            "LLM-first SEO analysis engine: 16 sub-skills, 10 specialist agents, and 89 utility scripts for deep audits and schemas." `
            "git -C `"$seoSkillsDir`" pull"
    } else {
        Run-Step "Agentic SEO Skill Suite (Clone)" `
            "LLM-first SEO analysis engine: 16 sub-skills, 10 specialist agents, and 89 utility scripts for deep audits and schemas." `
            "git clone https://github.com/Bhanunamikaze/Agentic-SEO-Skill.git `"$seoSkillsDir`""
    }

    Run-Step "Ashley SEO & Indexing Agent" `
        "Audits technical on-page SEO, OpenGraph data, JSON-LD structured schemas, robots.txt, sitemaps, and Core Web Vitals." `
        "npx --yes skills@latest add ashleytheash/seo-agent-skill $global:ScopeFlag --all -y"
}

function Install-BackendSkills {
    Write-HeaderSection "🔥 6. BACKEND, DATABASES & CLOUD EDGE"

    Run-Step "Supabase Agent Skills" `
        "PostgreSQL architecture, Row Level Security (RLS) policies, Edge Functions (Deno), realtime subscriptions, and Auth triggers." `
        "npx --yes skills@latest add supabase/agent-skills $global:ScopeFlag --all -y"

    Run-Step "Firebase Agent Skills" `
        "Firestore document design, Firebase Cloud Messaging (FCM) push notifications, security rules, and serverless Cloud Functions." `
        "npx --yes skills@latest add firebase/agent-skills $global:ScopeFlag --all -y"

    Run-Step "Neon Database Skills" `
        "Serverless Postgres, database branching for PRs, index tuning, connection pooling, and low-latency SQL optimization." `
        "npx --yes skills@latest add neondatabase/agent-skills $global:ScopeFlag --all -y"

    Run-Step "Cloudflare Ecosystem" `
        "Workers, D1 SQL, R2 object storage, KV key-value stores, rate limiting, and edge API caching configurations." `
        "npx --yes skills@latest add https://github.com/cloudflare/skills $global:ScopeFlag --all -y"
}

function Install-DevOpsSkills {
    Write-HeaderSection "🐳 7. DEVOPS, LOCAL INFRASTRUCTURE & INTEGRATIONS"

    Run-Step "Docker Skills" `
        "Multi-stage Dockerfile generation, docker-compose orchestration, local database mock services, and container hardening." `
        "npx --yes skills@latest add docker/agent-skills $global:ScopeFlag --all -y"

    Run-Step "Composio Integration" `
        "Connects agent directly to GitHub Actions, repository issues, pull requests, Gmail alerts, and external workflow automations." `
        "npx --yes skills@latest add composiohq/skills $global:ScopeFlag --all -y"

    Run-Step "Postman / OpenAPI Skills" `
        "Ingests Swagger/OpenAPI specifications, generates strongly typed data models (Dart/TS), and automates endpoint contract testing." `
        "npx --yes skills@latest add postman/agent-skills $global:ScopeFlag --all -y"
}

function Install-WorkflowsAndPlugins {
    Write-HeaderSection "🔄 8. INTELLIGENT WORKFLOWS & CROSS-AGENT PLUGINS"

    if ($global:ScopeNpm -eq "-g") {
        Run-Step "Antigravity Workflows CLI" "Stack-agnostic, question-driven workflows." "npm install -g antigravity-workflows"
    } else {
        Run-Step "Antigravity Workflows CLI" "Stack-agnostic, question-driven workflows." "npm install --save-dev antigravity-workflows"
    }

    $claudeSkillsLibDir = Join-Path $global:SkillsDir "claude-skills"
    if (Test-Path $claudeSkillsLibDir) {
        Run-Step "Claude Skills Universal Library (Update)" `
            "Comprehensive suite of 388+ engineering, architecture, C-level advisory, security, and productivity skills." `
            "git -C `"$claudeSkillsLibDir`" pull"
    } else {
        Run-Step "Claude Skills Universal Library (Clone)" `
            "Comprehensive suite of 388+ engineering, architecture, C-level advisory, security, and productivity skills." `
            "git clone https://github.com/alirezarezvani/claude-skills.git `"$claudeSkillsLibDir`""
    }
}

function Install-CodeQualitySkills {
    Write-HeaderSection "🧠 9. CODE QUALITY, SECURITY & PERSISTENT MEMORY"

    Run-Step "Claude-Mem Persistent Session Context" `
        "Preserves context across sessions by capturing tool actions and injecting semantic summaries into future chats." `
        "npx --yes claude-mem install 2>$null; npx --yes skills@latest add thedotmack/claude-mem $global:ScopeFlag --all -y"

    Run-Step "Andrej Karpathy Engineering Philosophy" `
        "Prioritizes clarity, minimal abstractions, readability, clean foundational code, and strict engineering discipline." `
        "npx --yes skills@latest add multica-ai/andrej-karpathy-skills $global:ScopeFlag --all -y"

    Run-Step "Caveman (Anti-Overengineering)" `
        "Eliminates framework bloat, prevents over-engineering, enforces simple directory architectures, and refuses micro-abstractions." `
        "npx --yes skills@latest add JuliusBrussee/caveman $global:ScopeFlag --all -y"

    Run-Step "Ponytail Skills" `
        "Enforces clean software design patterns, eliminating bloated libraries and preserving codebase simplicity." `
        "npx --yes skills@latest add https://github.com/DietrichGebert/ponytail/tree/main/skills $global:ScopeFlag --all -y"

    Run-Step "MemoryPlugin (Cross-Session Persistence)" `
        "Provides cross-session long-term memory so the agent retains project context, design preferences, and architectural decisions." `
        "npx --yes skills@latest add memoryplugin/agent-skills $global:ScopeFlag --all -y"

    Run-Step "Sentry for AI" `
        "Automated root-cause analysis for production exceptions, stack trace parsing, and regression pinpointing." `
        "npx --yes skills@latest add getsentry/sentry-for-ai $global:ScopeFlag --all -y"

    if ($global:ScopeNpm -eq "-g") {
        Run-Step "CTX7 Documentation Indexer" "Indexes and injects the latest framework docs." "npm install -g ctx7"
    } else {
        Run-Step "CTX7 Documentation Indexer" "Indexes and injects the latest framework docs." "npm install --save-dev ctx7"
    }
}

# ==============================================================================
# UNINSTALLATION FUNCTIONS
# ==============================================================================

function Uninstall-AllSkills {
    Write-HeaderSection "🗑️  REMOVING ALL INSTALLED SKILLS & GLOBAL PACKAGES"
    
    Write-Host "Uninstalling all global skills CLI registry entries..." -ForegroundColor Yellow
    npx --yes skills@latest remove --all -g -y 2>$null
    npx --yes skills@latest remove --all -y 2>$null

    Write-Host "Uninstalling global npm packages..." -ForegroundColor Yellow
    npm uninstall -g uipro-cli @playwright/cli firecrawl-cli ctx7 antigravity-workflows 2>$null

    if (Get-Command dart -ErrorAction SilentlyContinue) {
        Write-Host "Deactivating global Dart skills..." -ForegroundColor Yellow
        dart pub global deactivate skills 2>$null
    }

    Write-Host "Removing cloned Claude skills directories..." -ForegroundColor Yellow
    $dirs = @(
        "$HOME\.claude\skills\flutter-skills",
        "$HOME\.claude\skills\seo",
        "$HOME\.claude\skills\claude-skills",
        ".claude\skills",
        ".agent\skills"
    )
    foreach ($d in $dirs) {
        if (Test-Path $d) { Remove-Item -Recurse -Force $d 2>$null }
    }

    Write-Host ""
    Write-Host "═════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host " 🗑️  ALL SKILLS & TOOLS HAVE BEEN UNINSTALLED SUCCESSFULLY!              " -ForegroundColor Green
    Write-Host "═════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
}

# Main Script Entry Point
function Main {
    if ($Uninstall) {
        Uninstall-AllSkills
        return
    }

    Write-Banner
    Check-Prerequisites

    # STEP 1: Choose Installation Scope
    Write-Host "Where would you like to install the skills?" -ForegroundColor White
    Write-Host ""
    Write-Host "  1) 🌍 Global            (Recommended: Available across all projects in ~/.agents & system-wide)" -ForegroundColor Cyan
    Write-Host "  2) 📁 Current Project   (Install only in this project folder: $((Get-Location).Path))" -ForegroundColor Cyan
    Write-Host ""
    
    $scopeChoice = Read-Host "Select install scope [1-2] (default: 1)"
    if ([string]::IsNullOrWhiteSpace($scopeChoice)) { $scopeChoice = "1" }
    Set-Scope $scopeChoice

    # STEP 2: Choose Skill Configuration Suite
    Write-Host ""
    Write-Host "Which skills configuration would you like to install into [$global:ScopeDesc]?" -ForegroundColor White
    Write-Host ""
    Write-Host "  1) 🚀 All-in-One Full Suite (Install ALL 9 Categories & 400+ Skills without conflicts)" -ForegroundColor Cyan
    Write-Host "  2) 📱 Mobile Application   (UI/UX + Archify + Flutter/Dart + SEO + Cloud + DevOps + Memory)" -ForegroundColor Cyan
    Write-Host "  3) 🌐 Web Application      (UI/UX + Archify + Frontend/Playwright + SEO + Cloud + DevOps + Memory)" -ForegroundColor Cyan
    Write-Host "  4) 🎯 Custom Selection     (Choose specific skill categories to install)" -ForegroundColor Cyan
    Write-Host "  5) 🗑️  Delete / Uninstall   (Remove installed skills and configurations)" -ForegroundColor Red
    Write-Host ""

    $suiteChoice = Read-Host "Select skill suite [1-5] (default: 1)"
    if ([string]::IsNullOrWhiteSpace($suiteChoice)) { $suiteChoice = "1" }

    switch ($suiteChoice) {
        "1" {
            Write-Host "`n🚀 Starting All-in-One Skills Installation into $global:ScopeDesc..." -ForegroundColor Green
            Install-CoreUiUx
            Install-ArchitectureSkills
            Install-MobileSkills
            Install-WebSkills
            Install-SeoSkills
            Install-BackendSkills
            Install-DevOpsSkills
            Install-WorkflowsAndPlugins
            Install-CodeQualitySkills
        }
        "2" {
            Write-Host "`n🚀 Starting Mobile Application Skills Installation into $global:ScopeDesc..." -ForegroundColor Green
            Install-CoreUiUx
            Install-ArchitectureSkills
            Install-MobileSkills
            Install-SeoSkills
            Install-BackendSkills
            Install-DevOpsSkills
            Install-WorkflowsAndPlugins
            Install-CodeQualitySkills
        }
        "3" {
            Write-Host "`n🚀 Starting Web Application Skills Installation into $global:ScopeDesc..." -ForegroundColor Green
            Install-CoreUiUx
            Install-ArchitectureSkills
            Install-WebSkills
            Install-SeoSkills
            Install-BackendSkills
            Install-DevOpsSkills
            Install-WorkflowsAndPlugins
            Install-CodeQualitySkills
        }
        "4" {
            Write-Host "`nSelect categories to install into $global:ScopeDesc:" -ForegroundColor White

            $c1 = Read-Host "Install 🎨 Core UI/UX & Taste skills? [Y/n]"
            if ($c1 -notmatch "^[Nn]") { Install-CoreUiUx }

            $cArch = Read-Host "Install 🏛️ Architecture & System Visualizer (Archify)? [Y/n]"
            if ($cArch -notmatch "^[Nn]") { Install-ArchitectureSkills }

            $c2 = Read-Host "Install 📱 Mobile App (Flutter/Dart) skills? [Y/n]"
            if ($c2 -notmatch "^[Nn]") { Install-MobileSkills }

            $c3 = Read-Host "Install 🌐 Web Frontend & Browser (Playwright) skills? [Y/n]"
            if ($c3 -notmatch "^[Nn]") { Install-WebSkills }

            $cSeo = Read-Host "Install 🔍 Agentic SEO & Indexing skills? [Y/n]"
            if ($cSeo -notmatch "^[Nn]") { Install-SeoSkills }

            $c4 = Read-Host "Install 🔥 Backend & Cloud Edge skills? [Y/n]"
            if ($c4 -notmatch "^[Nn]") { Install-BackendSkills }

            $c5 = Read-Host "Install 🐳 DevOps & Integrations skills? [Y/n]"
            if ($c5 -notmatch "^[Nn]") { Install-DevOpsSkills }

            $cWf = Read-Host "Install 🔄 Intelligent Workflows & Claude Skills Suite? [Y/n]"
            if ($cWf -notmatch "^[Nn]") { Install-WorkflowsAndPlugins }

            $c6 = Read-Host "Install 🧠 Code Quality, Claude-Mem & Sentry skills? [Y/n]"
            if ($c6 -notmatch "^[Nn]") { Install-CodeQualitySkills }
        }
        "5" {
            Uninstall-AllSkills
            return
        }
        Default {
            Write-Host "`nDefaulting to Complete All-in-One installation into $global:ScopeDesc..." -ForegroundColor Yellow
            Install-CoreUiUx
            Install-ArchitectureSkills
            Install-MobileSkills
            Install-WebSkills
            Install-SeoSkills
            Install-BackendSkills
            Install-DevOpsSkills
            Install-WorkflowsAndPlugins
            Install-CodeQualitySkills
        }
    }

    Write-Host ""
    Write-Host "═════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host " 🎉 ALL SKILLS HAVE BEEN INSTALLED & CONFIGURED IN [$global:ScopeDesc]! 🎉" -ForegroundColor Green
    Write-Host "═════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "💡 Quick Tip: To initialize project-level design tokens in any UI project, run: uipro init --ai antigravity" -ForegroundColor Cyan
    Write-Host ""
}

Main

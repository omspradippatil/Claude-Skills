# ==============================================================================
# AI Agent Skills Installer — Cross-Platform Engineering System (Windows)
# Repository: https://github.com/omspradippatil/Claude-Skills
#
# Usage:
#   irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.ps1 | iex
#   .\install.ps1 [-Global] [-Project] [-Force] [-Uninstall]
# ==============================================================================

param(
    [switch]$Global,
    [switch]$Project,
    [switch]$Force,
    [switch]$Uninstall,
    [switch]$Help
)

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/omspradippatil/Claude-Skills.git"
$TmpDir  = Join-Path $env:TEMP "claude-skills-install-$PID"

$KnownSkills = @(
    "security-auditor","seo-marketing","frontend-design","api-architecture",
    "postgres-ecosystem","firebase-expert","cloudflare-expert","devops-cicd",
    "testing-qa","mobile-engineering","llm-optimization","state-management",
    "web-animation","assets-media","3d-visuals","web-gamedev",
    "git-collaboration","sentry-expert","ux-research"
)

function Write-Header { param($msg) Write-Host "`n== $msg ==" -ForegroundColor Cyan }
function Write-OK     { param($msg) Write-Host "  ✔ $msg" -ForegroundColor Green }
function Write-Warn   { param($msg) Write-Host "  ⚠ $msg" -ForegroundColor Yellow }
function Write-Err    { param($msg) Write-Host "  ✖ $msg" -ForegroundColor Red }

function Check-Prerequisites {
    Write-Header "Checking Prerequisites"

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Err "git not found. Install git for Windows (https://git-scm.com) and retry."
        exit 1
    }
    Write-OK "git $(git --version)"

    if (Get-Command node -ErrorAction SilentlyContinue) {
        Write-OK "node $(node -v)"
    } else {
        Write-Warn "Node.js not found — npm-based tools will be unavailable."
    }
}

function Fetch-Repo {
    if (Test-Path $TmpDir) { return }
    Write-Host "  Fetching repository…" -ForegroundColor DarkCyan
    git clone --depth 1 --quiet $RepoUrl $TmpDir
    if (-not $?) { Write-Err "Clone failed."; exit 1 }
    Write-OK "Repository fetched"
}

function Install-SkillsTo {
    param($Src, $Dst, $Label)

    if (-not (Test-Path $Src)) {
        Write-Warn "Skills source not found at $Src — skipping $Label"
        return
    }

    New-Item -ItemType Directory -Path $Dst -Force | Out-Null
    $count = 0; $skipped = 0

    Get-ChildItem -Path $Src -Directory | ForEach-Object {
        $target = Join-Path $Dst $_.Name
        if ((Test-Path $target) -and (-not $Force)) {
            $skipped++
            return
        }
        Copy-Item -Path $_.FullName -Destination $target -Recurse -Force
        $count++
    }

    if ($count -gt 0)   { Write-OK "Installed $count skill(s) to $Label" }
    if ($skipped -gt 0) { Write-Host "  ℹ $skipped skill(s) already existed (use -Force to overwrite)" -ForegroundColor DarkGray }
}

function Install-EntryPoint {
    param($SrcFile, $DstFile, $Label)
    $src = Join-Path $TmpDir $SrcFile
    if (-not (Test-Path $src)) { return }

    if ((Test-Path $DstFile) -and (-not $Force)) {
        $answer = Read-Host "$DstFile already exists. Overwrite? [y/N]"
        if ($answer -notmatch '^[Yy]') { Write-Host "  Skipped $Label" -ForegroundColor DarkGray; return }
    }

    Copy-Item -Path $src -Destination $DstFile -Force
    Write-OK "Installed $Label → $DstFile"
}

function Install-Global {
    Write-Header "Global Installation"
    Fetch-Repo

    $claudeSkills = Join-Path $env:USERPROFILE ".claude\skills"
    $geminiSkills = Join-Path $env:USERPROFILE ".gemini\config\skills"
    $geminiRules  = Join-Path $env:USERPROFILE ".gemini\config\rules"

    $agentSkillsSrc = Join-Path $TmpDir ".agents\skills"
    Install-SkillsTo $agentSkillsSrc $claudeSkills "~\.claude\skills"
    Install-SkillsTo $agentSkillsSrc $geminiSkills "~\.gemini\config\skills"

    $rulesSrc = Join-Path $TmpDir ".agents\rules"
    if (Test-Path $rulesSrc) {
        New-Item -ItemType Directory -Path $geminiRules -Force | Out-Null
        Copy-Item "$rulesSrc\*" $geminiRules -Recurse -Force
        Write-OK "Installed rules to ~\.gemini\config\rules"
    }

    if (Get-Command npm -ErrorAction SilentlyContinue) {
        Write-Header "Optional npm Packages"
        foreach ($pkg in @("firecrawl-cli","ctx7","antigravity-workflows")) {
            Write-Host "  Installing $pkg…" -ForegroundColor DarkCyan
            npm install -g $pkg --quiet 2>$null
            if ($?) { Write-OK "$pkg installed" } else { Write-Warn "$pkg install failed (skipping)" }
        }
    }
}

function Install-Project {
    $projectDir = (Get-Location).Path
    Write-Header "Project Installation into $projectDir"
    Fetch-Repo

    $agentSkillsSrc = Join-Path $TmpDir ".agents\skills"
    Install-SkillsTo $agentSkillsSrc (Join-Path $projectDir ".agents\skills") ".agents\skills"
    Install-SkillsTo $agentSkillsSrc (Join-Path $projectDir ".claude\skills") ".claude\skills"

    foreach ($f in @("CLAUDE.md","AGENTS.md","GEMINI.md")) {
        Install-EntryPoint $f (Join-Path $projectDir $f) $f
    }

    $cursorSrc = Join-Path $TmpDir ".cursor\rules"
    if (Test-Path $cursorSrc) {
        $cursorDst = Join-Path $projectDir ".cursor\rules"
        New-Item -ItemType Directory -Path $cursorDst -Force | Out-Null
        Copy-Item "$cursorSrc\*" $cursorDst -Recurse -Force
        Write-OK "Installed .cursor\rules"
    }

    $answer = Read-Host "`nAdd skills directories to .gitignore? [Y/n]"
    if ($answer -notmatch '^[Nn]') {
        $gitignore = Join-Path $projectDir ".gitignore"
        if (-not (Test-Path $gitignore)) { "" | Set-Content $gitignore }
        $content = Get-Content $gitignore -Raw
        if ($content -notmatch [regex]::Escape(".claude/skills")) { ".claude/skills" | Add-Content $gitignore }
        if ($content -notmatch [regex]::Escape(".agents/skills")) { ".agents/skills" | Add-Content $gitignore }
        Write-OK "Updated .gitignore"
    }
}

function Uninstall-Global {
    Write-Header "Uninstalling Global Skills"
    Write-Warn "This will remove all skills installed by this repository."
    $answer = Read-Host "Are you sure? [y/N]"
    if ($answer -notmatch '^[Yy]') { Write-Host "  Aborted."; return }

    $removed = 0
    foreach ($skill in $KnownSkills) {
        foreach ($base in @("$env:USERPROFILE\.claude\skills","$env:USERPROFILE\.gemini\config\skills")) {
            $dir = Join-Path $base $skill
            if (Test-Path $dir) {
                Remove-Item $dir -Recurse -Force
                Write-OK "Removed $dir"
                $removed++
            }
        }
    }

    if (Get-Command npm -ErrorAction SilentlyContinue) {
        npm uninstall -g firecrawl-cli ctx7 antigravity-workflows 2>$null
    }

    Write-Host "`n  Removed $removed skill directories."
}

# ── Main ──────────────────────────────────────────────────────────────────────
try {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║        ⚡ Claude Skills — Cross-Platform Engineering System      ║" -ForegroundColor Cyan
    Write-Host "║           Claude Code · Antigravity · Cursor · Codex            ║" -ForegroundColor Cyan
    Write-Host "╚══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    if ($Help) {
        Get-Help $MyInvocation.InvocationName
        exit 0
    }

    Check-Prerequisites

    if ($Uninstall) { Uninstall-Global }
    elseif ($Project) { Install-Project }
    elseif ($Global) { Install-Global }
    else {
        Write-Host "Installation scope:" -ForegroundColor White
        Write-Host "  1) Global  — User profile skills directories" -ForegroundColor Cyan
        Write-Host "  2) Project — Current directory" -ForegroundColor Cyan
        Write-Host "  3) Uninstall" -ForegroundColor Red
        Write-Host ""
        $choice = Read-Host "Select [1-3] (default: 1)"
        switch ($choice) {
            "2" { Install-Project }
            "3" { Uninstall-Global }
            default { Install-Global }
        }
    }

    Write-Host ""
    Write-Host "══════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "  ✅  Done! Run scripts/validate.sh to verify the installation.      " -ForegroundColor Green
    Write-Host "══════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
}
finally {
    if (Test-Path $TmpDir) { Remove-Item $TmpDir -Recurse -Force -ErrorAction SilentlyContinue }
}

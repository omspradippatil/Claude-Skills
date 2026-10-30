# ==============================================================================
# Claude-Skills: Cross-Platform AI Agent Skills Installer (Windows PowerShell)
# Repository: https://github.com/omspradippatil/Claude-Skills
#
# Usage:
#   .\install.ps1 [OPTIONS]
#   .\install.ps1 (interactive terminal mode)
#   irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.ps1 | iex
# ==============================================================================

[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [Alias("Target", "t")]
    [string]$Scope = "",

    [Alias("p")]
    [string]$Platform = "",

    [Alias("s")]
    [string[]]$Skills = @(),

    [Alias("a", "full")]
    [switch]$All,

    [Alias("m")]
    [switch]$Minimal,

    [Alias("f")]
    [switch]$Force,

    [Alias("u", "Uninstall")]
    [switch]$DoUninstall,

    [Alias("y")]
    [switch]$NonInteractive,

    [Alias("h", "?")]
    [switch]$Help
)

$ErrorActionPreference = "Stop"

if ($Help) {
    Write-Host @"
Usage: .\install.ps1 [OPTIONS]

Options:
  -Scope, -Target, -t   Target scope: 'project' or 'global' (default: project)
  -Platform, -p         Target platform: 'claude', 'antigravity', 'cursor', or 'agents' (default: agents)
  -Skills, -s           Comma-separated list of skills to install
  -All, -a, -full       Install all available domain skills
  -Minimal, -m          Minimal install (router and policies only, no specialist skills)
  -Force, -f            Overwrite existing files without prompting
  -DoUninstall, -u      Uninstall previously installed skills from target
  -NonInteractive, -y   Run non-interactively using defaults
  -Help, -h             Show this help message

Interactive:
  Run without options in a console to launch the interactive setup menu:
    .\install.ps1
    install.bat
    irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.ps1 | iex
"@
    exit 0
}

# ── Validate Explicit Arguments ───────────────────────────────────────────────
if (-not [string]::IsNullOrWhiteSpace($Scope)) {
    $ScopeLower = $Scope.ToLowerInvariant().Trim()
    if ($ScopeLower -ne "project" -and $ScopeLower -ne "global") {
        throw "-Scope/-Target must be 'project' or 'global'."
    }
    $Scope = $ScopeLower
}

if (-not [string]::IsNullOrWhiteSpace($Platform)) {
    $PlatformLower = $Platform.ToLowerInvariant().Trim()
    if (@("agents", "claude", "cursor", "antigravity") -notcontains $PlatformLower) {
        throw "-Platform must be 'agents', 'claude', 'cursor', or 'antigravity'."
    }
    $Platform = $PlatformLower
}

# ── Locate Repository Source ──────────────────────────────────────────────────
$Repo = $null
$TempRepo = $null

# 1. Check if running from a script file inside a repository
if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) {
    $CandidateLock = Join-Path $PSScriptRoot "skills-lock.json"
    $CandidatePolicies = Join-Path $PSScriptRoot "policies"
    $CandidateSkills = Join-Path $PSScriptRoot ".agents/skills"
    if ((Test-Path -LiteralPath $CandidateLock) -and (Test-Path -LiteralPath $CandidatePolicies) -and (Test-Path -LiteralPath $CandidateSkills)) {
        $Repo = (Resolve-Path -LiteralPath $PSScriptRoot).Path
    }
}

# 2. Check if current working directory is the repository
if ([string]::IsNullOrWhiteSpace($Repo)) {
    $CurLock = Join-Path (Get-Location).Path "skills-lock.json"
    $CurPolicies = Join-Path (Get-Location).Path "policies"
    $CurSkills = Join-Path (Get-Location).Path ".agents/skills"
    if ((Test-Path -LiteralPath $CurLock) -and (Test-Path -LiteralPath $CurPolicies) -and (Test-Path -LiteralPath $CurSkills)) {
        $Repo = (Get-Location).Path
    }
}

# 3. Remote execution fallback: clone into temporary folder
if ([string]::IsNullOrWhiteSpace($Repo)) {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "git is required to fetch installer source when running outside a local clone."
    }
    $TempRepo = Join-Path $env:TEMP ("claude-skills-" + [guid]::NewGuid().ToString("N"))
    Write-Host "Fetching installer source from git repository..." -ForegroundColor Cyan
    $GitRepo = if ($env:CLAUDE_SKILLS_REPO) { $env:CLAUDE_SKILLS_REPO } else { "https://github.com/omspradippatil/Claude-Skills.git" }
    $GitRef = $env:CLAUDE_SKILLS_REF
    if (-not [string]::IsNullOrWhiteSpace($GitRef)) {
        & git clone --depth 1 --branch $GitRef $GitRepo $TempRepo 2>$null
        if ($LASTEXITCODE -ne 0) { & git clone --depth 1 $GitRepo $TempRepo }
    } else {
        & git clone --depth 1 $GitRepo $TempRepo
    }
    if ($LASTEXITCODE -ne 0 -or (-not (Test-Path -LiteralPath (Join-Path $TempRepo "skills-lock.json")))) {
        throw "Failed to fetch repository from git ($GitRepo)."
    }
    $Repo = $TempRepo
}

try {
    # ── Discover Available Skills ─────────────────────────────────────────────
    $AvailableSkills = @()
    $AgentsSkillsDir = Join-Path $Repo ".agents/skills"
    if (Test-Path -LiteralPath $AgentsSkillsDir) {
        $AvailableSkills = @(Get-ChildItem -LiteralPath $AgentsSkillsDir -Directory | Where-Object {
            Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md")
        } | Sort-Object Name | Select-Object -ExpandProperty Name)
    }

    $RecommendedSkills = @("ui-ux-pro-max", "api-architecture", "testing-qa", "security-auditor", "devops-cicd", "state-management")

    # ── Parse Skills Parameter ────────────────────────────────────────────────
    $ParsedSkills = [System.Collections.Generic.List[string]]::new()
    foreach ($item in $Skills) {
        if (-not [string]::IsNullOrWhiteSpace($item)) {
            foreach ($sub in $item.Split(',')) {
                $trimmed = $sub.Trim()
                if (-not [string]::IsNullOrWhiteSpace($trimmed)) {
                    $ParsedSkills.Add($trimmed)
                }
            }
        }
    }

    # ── Interactive Mode Detection ────────────────────────────────────────────
    $IsExplicit = $false
    if ($All -or $Minimal -or $DoUninstall -or $Force -or $NonInteractive -or ($ParsedSkills.Count -gt 0) -or (-not [string]::IsNullOrWhiteSpace($Scope)) -or (-not [string]::IsNullOrWhiteSpace($Platform))) {
        $IsExplicit = $true
    }

    $HasConsole = $false
    try {
        if ([Environment]::UserInteractive -and -not [Console]::IsInputRedirected) {
            $HasConsole = $true
        }
    } catch {
        $HasConsole = $false
    }

    function Ask-User([string]$PromptText, [string]$DefaultValue = "") {
        Write-Host -NoNewline $PromptText
        $ans = Read-Host
        if ([string]::IsNullOrWhiteSpace($ans)) {
            return $DefaultValue
        }
        return $ans.Trim()
    }

    # ── Interactive Menu ──────────────────────────────────────────────────────
    if (-not $IsExplicit -and $HasConsole) {
        Write-Host ""
        Write-Host "╔═════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
        Write-Host "║        ⚡ Claude-Skills — Cross-Platform AI Agent Suite                 ║" -ForegroundColor Cyan
        Write-Host "║           Claude Code · Antigravity · Cursor · Codex                    ║" -ForegroundColor Cyan
        Write-Host "╚═════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
        Write-Host ""

        # Step 1: Target Scope
        if ([string]::IsNullOrWhiteSpace($Scope)) {
            Write-Host "Where would you like to install?" -ForegroundColor White
            Write-Host "  1) 📁 Current Project ($((Get-Location).Path))" -ForegroundColor Cyan
            Write-Host "  2) 🌍 Global          ($env:USERPROFILE)" -ForegroundColor Cyan
            Write-Host ""
            $targetChoice = Ask-User "Select target [1-2] (default: 1): " "1"
            if ($targetChoice -eq "2" -or $targetChoice.ToLower() -eq "global") {
                $Scope = "global"
            } else {
                $Scope = "project"
            }
            Write-Host ""
        }

        # Step 2: Target Platform
        if ([string]::IsNullOrWhiteSpace($Platform)) {
            Write-Host "Which AI platform / agent are you configuring?" -ForegroundColor White
            Write-Host "  1) 🤖 Claude Code       (.claude/skills)" -ForegroundColor Cyan
            Write-Host "  2) ⚡ Antigravity / AGY (.gemini/config/skills or .agents/skills)" -ForegroundColor Cyan
            Write-Host "  3) 🖱️  Cursor            (.cursor/skills)" -ForegroundColor Cyan
            Write-Host "  4) 🧠 Codex / Agents    (.agents/skills)" -ForegroundColor Cyan
            Write-Host ""
            $platformChoice = Ask-User "Select platform [1-4] (default: 1): " "1"
            switch ($platformChoice.ToLower()) {
                "2" { $Platform = "antigravity" }
                "antigravity" { $Platform = "antigravity" }
                "3" { $Platform = "cursor" }
                "cursor" { $Platform = "cursor" }
                "4" { $Platform = "agents" }
                "agents" { $Platform = "agents" }
                "codex" { $Platform = "agents" }
                default { $Platform = "claude" }
            }
            Write-Host ""
        }

        # Step 3: What all to install
        Write-Host "What all would you like to install?" -ForegroundColor White
        Write-Host "  1) 🚀 All Skills        (Install all $($AvailableSkills.Count) domain skills)" -ForegroundColor Cyan
        Write-Host "  2) ⭐ Recommended Pack  (ui-ux-pro-max, api-architecture, testing-qa, security-auditor, devops-cicd, state-management)" -ForegroundColor Cyan
        Write-Host "  3) 🎯 Custom Selection  (Choose specific skills from catalog)" -ForegroundColor Cyan
        Write-Host "  4) 📄 Minimal           (Policies and task router only — no specialist skills)" -ForegroundColor Cyan
        Write-Host "  5) 🗑️  Uninstall         (Remove installed skills and clean up)" -ForegroundColor Red
        Write-Host ""
        $suiteChoice = Ask-User "Select option [1-5] (default: 1): " "1"
        switch ($suiteChoice) {
            "1" {
                $All = $true
                $ParsedSkills.Clear()
            }
            "2" {
                $ParsedSkills.Clear()
                foreach ($sk in $RecommendedSkills) { $ParsedSkills.Add($sk) }
            }
            "3" {
                Write-Host ""
                Write-Host "Available Domain Skills ($($AvailableSkills.Count)):" -ForegroundColor White
                for ($i = 0; $i -lt $AvailableSkills.Count; $i++) {
                    $num = $i + 1
                    $sk = $AvailableSkills[$i]
                    Write-Host ("  [{0,2}] {1,-24}" -f $num, $sk) -NoNewline -ForegroundColor Cyan
                    if (($num % 3) -eq 0) { Write-Host "" }
                }
                if (($AvailableSkills.Count % 3) -ne 0) { Write-Host "" }
                Write-Host ""
                $customInput = Ask-User "Enter skill numbers or names (comma-separated, e.g. 1,5,12): " ""
                $ParsedSkills.Clear()
                foreach ($part in $customInput.Split(",")) {
                    $clean = $part.Trim()
                    if ($clean -match '^\d+$') {
                        $idx = [int]$clean - 1
                        if ($idx -ge 0 -and $idx -lt $AvailableSkills.Count) {
                            $ParsedSkills.Add($AvailableSkills[$idx])
                        }
                    } elseif (-not [string]::IsNullOrWhiteSpace($clean)) {
                        $ParsedSkills.Add($clean)
                    }
                }
            }
            "4" {
                $Minimal = $true
                $ParsedSkills.Clear()
            }
            "5" {
                $DoUninstall = $true
            }
            default {
                $All = $true
                $ParsedSkills.Clear()
            }
        }
    }

    # ── Default Fallbacks ─────────────────────────────────────────────────────
    if ([string]::IsNullOrWhiteSpace($Scope)) { $Scope = "project" }
    if ([string]::IsNullOrWhiteSpace($Platform)) { $Platform = "agents" }

    if ($All) {
        $ParsedSkills.Clear()
        foreach ($sk in $AvailableSkills) { $ParsedSkills.Add($sk) }
    } elseif ($Minimal) {
        $ParsedSkills.Clear()
    }
    $SelectedSkills = $ParsedSkills.ToArray()

    # ── Handle Uninstallation ─────────────────────────────────────────────────
    if ($DoUninstall) {
        $UninstallScript = Join-Path $Repo "uninstall.ps1"
        if (Test-Path -LiteralPath $UninstallScript) {
            $DestDir = if ($Scope -eq "global") { $env:USERPROFILE } else { (Get-Location).Path }
            & $UninstallScript -Target $DestDir
            exit $LASTEXITCODE
        } else {
            throw "uninstall.ps1 not found in $Repo"
        }
    }

    # ── Validate Selected Skills ──────────────────────────────────────────────
    foreach ($Name in $SelectedSkills) {
        if ($Name -notmatch "^[a-z0-9]+(-[a-z0-9]+)*$") {
            throw "Invalid skill name: $Name"
        }
        $Candidate = Join-Path (Join-Path $Repo ".agents/skills") $Name
        if (-not (Test-Path -LiteralPath (Join-Path $Candidate "SKILL.md"))) {
            throw "Unknown or incomplete skill: $Name"
        }
    }

    # ── Platform Skill Folder Setup ───────────────────────────────────────────
    $Target = if ($Scope -eq "global") { $env:USERPROFILE } else { (Get-Location).Path }
    $SkillRoot = switch ($Platform) {
        "claude" { ".claude/skills" }
        "cursor" { ".cursor/skills" }
        "antigravity" { if ($Scope -eq "global") { ".gemini/config/skills" } else { ".agents/skills" } }
        default { ".agents/skills" }
    }

    $Manifest = Join-Path $Target ".claude-skills-install.windows.manifest"
    if (-not (Test-Path -LiteralPath $Target)) {
        New-Item -ItemType Directory -Force -Path $Target | Out-Null
    }

    # ── Existing Installation Detection ───────────────────────────────────────
    $ExistingDetected = $false
    if (Test-Path -LiteralPath $Manifest) {
        $ExistingDetected = $true
    } else {
        foreach ($check in @("CLAUDE.md", "AGENTS.md", "GEMINI.md", ".cursor/rules/always-on.mdc", ".cursor", "policies/core.md", "policies", $SkillRoot)) {
            if (Test-Path -LiteralPath (Join-Path $Target $check)) {
                $ExistingDetected = $true
                break
            }
        }
    }

    if ($ExistingDetected -and -not $Force) {
        if (-not $IsExplicit -and $HasConsole) {
            Write-Host ""
            Write-Host "Existing configuration detected in $Target." -ForegroundColor Yellow
            $ow = Ask-User "Override existing configuration and use force for all files? [Y/n]: " "y"
            if ($ow -match '^[Yy]$' -or [string]::IsNullOrWhiteSpace($ow)) {
                $Force = $true
                Write-Host "✔ Force override enabled." -ForegroundColor Green
            } else {
                Write-Host "Installation cancelled." -ForegroundColor Red
                exit 1
            }
        } else {
            throw "Refusing to overwrite existing installation in $Target without -Force."
        }
    }

    # ── Copy Managed Files ────────────────────────────────────────────────────
    $Entries = [System.Collections.Generic.List[string]]::new()

    function Copy-ManagedFile([string]$Source, [string]$Relative) {
        $NormalizedRel = $Relative.Replace("\", "/").TrimStart('/')
        $Destination = Join-Path $Target ($NormalizedRel.Replace("/", [IO.Path]::DirectorySeparatorChar))
        $DestDir = Split-Path -Parent $Destination
        if (-not (Test-Path -LiteralPath $DestDir)) {
            New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
        }

        $SourceResolved = (Resolve-Path -LiteralPath $Source).Path
        $DestExists = Test-Path -LiteralPath $Destination
        $DestResolved = if ($DestExists) { (Resolve-Path -LiteralPath $Destination).Path } else { $Destination }

        if ($DestExists -and -not $Force -and ($SourceResolved -ne $DestResolved)) {
            throw "Refusing to overwrite existing file: $Destination (use -Force after review)."
        }

        if ($SourceResolved -ne $DestResolved) {
            Copy-Item -LiteralPath $SourceResolved -Destination $Destination -Force
        }

        $Hash = (Get-FileHash -LiteralPath $Destination -Algorithm SHA256).Hash.ToLowerInvariant()
        $Entries.Add($NormalizedRel + "|" + $Hash)
    }

    # Base router, platform rules, and policies
    foreach ($Name in @("CLAUDE.md", "AGENTS.md", "GEMINI.md", "skills-lock.json", "scripts/route-task.py")) {
        $FilePath = Join-Path $Repo $Name
        if (Test-Path -LiteralPath $FilePath) {
            Copy-ManagedFile $FilePath $Name
        }
    }

    $CursorRule = Join-Path $Repo ".cursor/rules/always-on.mdc"
    if (Test-Path -LiteralPath $CursorRule) {
        Copy-ManagedFile $CursorRule ".cursor/rules/always-on.mdc"
    }

    $PoliciesDir = Join-Path $Repo "policies"
    if (Test-Path -LiteralPath $PoliciesDir) {
        Get-ChildItem -LiteralPath $PoliciesDir -Filter "*.md" -File | ForEach-Object {
            Copy-ManagedFile $_.FullName ("policies/" + $_.Name)
        }
    }

    # Specialist skills
    foreach ($Name in $SelectedSkills) {
        $SourceSkill = Join-Path (Join-Path $Repo ".agents/skills") $Name
        $ResolvedSkillDir = (Resolve-Path -LiteralPath $SourceSkill).Path
        Get-ChildItem -LiteralPath $ResolvedSkillDir -File -Recurse | ForEach-Object {
            $RelInsideSkill = $_.FullName.Substring($ResolvedSkillDir.Length).TrimStart('\', '/').Replace('\', '/')
            Copy-ManagedFile $_.FullName ($SkillRoot + "/" + $Name + "/" + $RelInsideSkill)
        }
    }

    $Entries | Set-Content -LiteralPath $Manifest -Encoding utf8

    Write-Host ""
    Write-Host "══════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "  ✅ Installation complete!" -ForegroundColor Green
    Write-Host "══════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "  Destination:      $Target" -ForegroundColor White
    Write-Host "  Platform:         $Platform ($SkillRoot)" -ForegroundColor White
    if ($SelectedSkills.Count -gt 0) {
        Write-Host "  Installed skills: $($SelectedSkills -join ', ')" -ForegroundColor White
    } else {
        Write-Host "  Installed skills: None (minimal router and policies only)" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "  Verify routing:   python scripts/route-task.py --task `"your task`"" -ForegroundColor Cyan
    Write-Host "  To uninstall:     .\uninstall.ps1 -Target `"$Target`"" -ForegroundColor Yellow
    Write-Host ""
}
finally {
    if ($TempRepo -and (Test-Path -LiteralPath $TempRepo)) {
        Remove-Item -LiteralPath $TempRepo -Recurse -Force -ErrorAction SilentlyContinue
    }
}

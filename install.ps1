param(
    [ValidateSet("project","global")][string]$Scope = "project",
    [ValidateSet("agents","claude","cursor","antigravity")][string]$Platform = "agents",
    [string[]]$Skills = @(),
    [switch]$All,
    [switch]$Minimal,
    [switch]$Force,
    [switch]$Help
)
$ErrorActionPreference = "Stop"
if ($Help) {
    Write-Output "Usage: .\install.ps1 [-Scope project|global] [-Platform agents|claude|cursor|antigravity] [-Skills skill1,skill2] [-All] [-Minimal] [-Force]"
    exit 0
}

$Repo = $PSScriptRoot
$TempRepo = $null
if (-not (Test-Path (Join-Path $Repo "skills-lock.json"))) {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "Git is required when installing from outside a local clone." }
    $TempRepo = Join-Path $env:TEMP ("claude-skills-" + [guid]::NewGuid().ToString("N"))
    & git clone --depth 1 https://github.com/omspradippatil/Claude-Skills.git $TempRepo
    if ($LASTEXITCODE -ne 0) { throw "Repository clone failed with exit code $LASTEXITCODE." }
    $Repo = $TempRepo
}

try {
    if ($Scope -eq "global") { $Target = $env:USERPROFILE }
    else { $Target = (Get-Location).Path }
    $Manifest = Join-Path $Target ".claude-skills-install.windows.manifest"
    if ((Test-Path $Manifest) -and (-not $Force)) { throw "Install manifest already exists at $Manifest. Uninstall first or use -Force." }
    $SkillRoot = switch ($Platform) {
        "claude" { ".claude/skills" }
        "cursor" { ".cursor/skills" }
        "antigravity" { if ($Scope -eq "global") { ".gemini/config/skills" } else { ".agents/skills" } }
        default { ".agents/skills" }
    }

    if ($All) {
        $Skills = @(Get-ChildItem (Join-Path $Repo ".agents/skills") -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") } | Select-Object -ExpandProperty Name)
    }

    foreach ($Name in $Skills) {
        if ($Name -notmatch "^[a-z0-9]+(-[a-z0-9]+)*$") { throw "Invalid skill name: $Name" }
        $Candidate = Join-Path (Join-Path $Repo ".agents/skills") $Name
        if (-not (Test-Path (Join-Path $Candidate "SKILL.md"))) { throw "Unknown or incomplete skill: $Name" }
    }
    $Entries = [System.Collections.Generic.List[string]]::new()

    function Copy-ManagedFile([string]$Source, [string]$Relative) {
        $Destination = Join-Path $Target ($Relative.Replace("/", [IO.Path]::DirectorySeparatorChar))
        if ((Test-Path $Destination) -and (-not $Force)) { throw "Refusing to overwrite existing file: $Destination (use -Force after review)." }
        New-Item -ItemType Directory -Force -Path (Split-Path $Destination) | Out-Null
        Copy-Item -LiteralPath $Source -Destination $Destination -Force
        $Hash = (Get-FileHash -LiteralPath $Destination -Algorithm SHA256).Hash.ToLowerInvariant()
        $Entries.Add($Relative + "|" + $Hash)
    }

    foreach ($Name in @("CLAUDE.md","AGENTS.md","GEMINI.md","skills-lock.json","scripts/route-task.py")) {
        Copy-ManagedFile (Join-Path $Repo $Name) $Name
    }
    Copy-ManagedFile (Join-Path $Repo ".cursor/rules/always-on.mdc") ".cursor/rules/always-on.mdc"
    Get-ChildItem (Join-Path $Repo "policies") -Filter "*.md" -File | ForEach-Object {
        Copy-ManagedFile $_.FullName ("policies/" + $_.Name)
    }

    foreach ($Name in $Skills) {
        $SourceSkill = Join-Path (Join-Path $Repo ".agents/skills") $Name
        if (-not (Test-Path (Join-Path $SourceSkill "SKILL.md"))) { throw "Unknown or incomplete skill: $Name" }
        Get-ChildItem $SourceSkill -File -Recurse | ForEach-Object {
            $RelativePath = $_.FullName.Substring($SourceSkill.Length).TrimStart([char[]]@([char]92,[char]47))
            Copy-ManagedFile $_.FullName ($SkillRoot + "/" + $Name + "/" + $RelativePath.Replace([IO.Path]::DirectorySeparatorChar, "/"))
        }
    }
    $Entries | Set-Content -LiteralPath $Manifest -Encoding utf8
    Write-Output "Installed minimal router and policies to $Target."
    if ($Skills.Count -gt 0) { Write-Output "Installed selected skills: $($Skills -join ', ')" }
    else { Write-Output "No specialist skills selected. Add them with -Skills skill1,skill2." }
    Write-Output "No third-party tools were installed. Uninstall with .\uninstall.ps1 -Target '$Target'."
}
finally {
    if ($TempRepo -and (Test-Path $TempRepo)) { Remove-Item $TempRepo -Recurse -Force }
}

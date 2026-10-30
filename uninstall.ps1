# ==============================================================================
# Claude-Skills: Windows Uninstaller (PowerShell)
# Repository: https://github.com/omspradippatil/Claude-Skills
#
# Usage:
#   .\uninstall.ps1 [-Target DIRECTORY] [-All]
#   uninstall.bat [-Target DIRECTORY]
#   irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/uninstall.ps1 | iex
# ==============================================================================

[CmdletBinding()]
param(
    [Parameter(Position=0)]
    [Alias("t")]
    [string]$Target = "",

    [Alias("a")]
    [switch]$All,

    [Alias("h", "?")]
    [switch]$Help
)

$ErrorActionPreference = "Stop"

if ($Help) {
    Write-Host @"
Usage: .\uninstall.ps1 [-Target DIRECTORY] [-All]

Options:
  -Target, -t   Directory to uninstall from (default: current project or user profile)
  -All, -a      All-in-one uninstall: removes from both current directory and user profile
  -Help, -h     Show this help message
"@
    exit 0
}

function Uninstall-Path([string]$Dir) {
    if (-not (Test-Path -LiteralPath $Dir)) {
        Write-Host "Target directory not found: $Dir; skipping." -ForegroundColor Yellow
        return
    }
    $Dir = (Resolve-Path -LiteralPath $Dir).Path

    $Manifest = Join-Path $Dir ".claude-skills-install.windows.manifest"
    if (-not (Test-Path -LiteralPath $Manifest)) {
        $PosixManifest = Join-Path $Dir ".claude-skills-install.manifest"
        if (Test-Path -LiteralPath $PosixManifest) {
            $Manifest = $PosixManifest
        } else {
            Write-Host "No install manifest found in $Dir; skipping." -ForegroundColor Yellow
            return
        }
    }

    Write-Host "Uninstalling from: $Dir" -ForegroundColor Cyan
    $Removed = 0
    $Kept = 0
    foreach ($Line in Get-Content -LiteralPath $Manifest) {
        if ([string]::IsNullOrWhiteSpace($Line)) { continue }
        $Parts = if ($Line.Contains("|")) { $Line.Split("|", 2) } else { $Line.Split("`t", 2) }
        if ($Parts.Count -ne 2) { throw "Invalid install manifest entry; stopping safely." }
        $Relative = $Parts[0].Trim()
        $ExpectedHash = $Parts[1].Trim().ToLowerInvariant()
        $Normalized = $Relative.Replace("\", "/")
        if ([IO.Path]::IsPathRooted($Relative) -or $Normalized.Split("/") -contains "..") {
            throw "Unsafe path in manifest; stopping safely: $Relative"
        }
        $Path = Join-Path $Dir ($Normalized.Replace("/", [IO.Path]::DirectorySeparatorChar))
        if ((Test-Path -LiteralPath $Path -PathType Leaf)) {
            $ActualHash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
            if ($ActualHash -eq $ExpectedHash) {
                Remove-Item -LiteralPath $Path -Force
                $Removed++
            } else {
                Write-Host "Kept changed file: $Path" -ForegroundColor Yellow
                $Kept++
            }
        } else {
            $Kept++
        }
    }
    Remove-Item -LiteralPath $Manifest -Force

    # Clean up empty parent directories left behind
    foreach ($folder in @(".claude/skills", ".agents/skills", ".cursor/skills", ".gemini/config/skills", "policies", ".cursor/rules", ".cursor", "scripts")) {
        $folderPath = Join-Path $Dir ($folder.Replace('/', [IO.Path]::DirectorySeparatorChar))
        if (Test-Path -LiteralPath $folderPath) {
            Get-ChildItem -LiteralPath $folderPath -Directory -Recurse -ErrorAction SilentlyContinue | Sort-Object -Property FullName -Descending | ForEach-Object {
                if (@(Get-ChildItem -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue).Count -eq 0) {
                    Remove-Item -LiteralPath $_.FullName -Force -ErrorAction SilentlyContinue
                }
            }
            if (@(Get-ChildItem -LiteralPath $folderPath -Force -ErrorAction SilentlyContinue).Count -eq 0) {
                Remove-Item -LiteralPath $folderPath -Force -ErrorAction SilentlyContinue
            }
        }
    }

    Write-Host "✔ Removed $Removed unchanged installed files from $Dir; kept $Kept changed or missing files." -ForegroundColor Green
}

if ($All) {
    Write-Host "== Running All-in-One Uninstall ==" -ForegroundColor Cyan
    $Found = $false
    $LocalDirs = @((Get-Location).Path)
    if ($env:USERPROFILE -and ((Get-Location).Path -ne $env:USERPROFILE)) {
        $LocalDirs += $env:USERPROFILE
    }
    foreach ($d in $LocalDirs) {
        $m1 = Join-Path $d ".claude-skills-install.windows.manifest"
        $m2 = Join-Path $d ".claude-skills-install.manifest"
        if ((Test-Path -LiteralPath $m1) -or (Test-Path -LiteralPath $m2)) {
            Uninstall-Path $d
            $Found = $true
        }
    }
    if (-not $Found) {
        Write-Host "No install manifests found in current project or user profile." -ForegroundColor Yellow
    } else {
        Write-Host "All-in-one uninstall complete!" -ForegroundColor Green
    }
    exit 0
}

if ([string]::IsNullOrWhiteSpace($Target)) {
    $LocalProject = (Get-Location).Path
    $mLocal1 = Join-Path $LocalProject ".claude-skills-install.windows.manifest"
    $mLocal2 = Join-Path $LocalProject ".claude-skills-install.manifest"
    $GlobalProfile = $env:USERPROFILE
    $mGlobal1 = if ($GlobalProfile) { Join-Path $GlobalProfile ".claude-skills-install.windows.manifest" } else { "" }
    $mGlobal2 = if ($GlobalProfile) { Join-Path $GlobalProfile ".claude-skills-install.manifest" } else { "" }

    if ((Test-Path -LiteralPath $mLocal1) -or (Test-Path -LiteralPath $mLocal2)) {
        $Target = $LocalProject
    } elseif ($GlobalProfile -and ((Test-Path -LiteralPath $mGlobal1) -or (Test-Path -LiteralPath $mGlobal2))) {
        $Target = $GlobalProfile
    } else {
        throw "No install manifest found in current directory or user profile. Specify -Target DIRECTORY or use -All."
    }
}

Uninstall-Path $Target

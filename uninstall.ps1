param(
    [string]$Target = "",
    [switch]$All,
    [switch]$Help
)
$ErrorActionPreference = "Stop"

if ($Help) {
    Write-Output "Usage: .\uninstall.ps1 [-Target DIRECTORY] [-All]"
    Write-Output "Removes only unchanged files listed by installation manifest(s)."
    Write-Output "  -Target   Specify directory to uninstall"
    Write-Output "  -All      All-in-one uninstall: removes from both current directory and user profile"
    exit 0
}

function Uninstall-Path([string]$Dir) {
    $Dir = (Resolve-Path -LiteralPath $Dir).Path
    $Manifest = Join-Path $Dir ".claude-skills-install.windows.manifest"
    if (-not (Test-Path $Manifest)) {
        Write-Output "No install manifest found at $Manifest; skipping."
        return
    }

    Write-Output "Uninstalling from: $Dir"
    $Removed = 0
    $Kept = 0
    foreach ($Line in Get-Content -LiteralPath $Manifest) {
        if ([string]::IsNullOrWhiteSpace($Line)) { continue }
        $Parts = $Line.Split("|", 2)
        if ($Parts.Count -ne 2) { throw "Invalid install manifest entry; stopping safely." }
        $Relative = $Parts[0]
        $Normalized = $Relative.Replace("\", "/")
        if ([IO.Path]::IsPathRooted($Relative) -or $Normalized.Split("/") -contains "..") { throw "Unsafe path in manifest; stopping safely." }
        $Path = Join-Path $Dir ($Normalized.Replace("/", [IO.Path]::DirectorySeparatorChar))
        if ((Test-Path -LiteralPath $Path -PathType Leaf) -and ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash -eq $Parts[1])) {
            Remove-Item -LiteralPath $Path
            $Removed++
        } else {
            Write-Output "Kept changed or missing file: $Path"
            $Kept++
        }
    }
    Remove-Item -LiteralPath $Manifest
    Write-Output "Removed $Removed unchanged installed files from $Dir; kept $Kept changed or missing files."
}

if ($All) {
    Write-Output "== Running All-in-One Uninstall =="
    $Found = $false
    $LocalManifest = Join-Path (Get-Location).Path ".claude-skills-install.windows.manifest"
    $GlobalManifest = Join-Path $env:USERPROFILE ".claude-skills-install.windows.manifest"
    if (Test-Path $LocalManifest) {
        Uninstall-Path (Get-Location).Path
        $Found = $true
    }
    if ((Test-Path $GlobalManifest) -and ((Get-Location).Path -ne $env:USERPROFILE)) {
        Uninstall-Path $env:USERPROFILE
        $Found = $true
    }
    if (-not $Found) {
        Write-Output "No install manifests found in current project or user profile."
    } else {
        Write-Output "All-in-one uninstall complete!"
    }
    exit 0
}

if ([string]::IsNullOrWhiteSpace($Target)) {
    $LocalManifest = Join-Path (Get-Location).Path ".claude-skills-install.windows.manifest"
    $GlobalManifest = Join-Path $env:USERPROFILE ".claude-skills-install.windows.manifest"
    if (Test-Path $LocalManifest) {
        $Target = (Get-Location).Path
    } elseif (Test-Path $GlobalManifest) {
        $Target = $env:USERPROFILE
    } else {
        throw "No install manifest found in current directory or user profile. Specify -Target DIRECTORY or use -All."
    }
}

Uninstall-Path $Target

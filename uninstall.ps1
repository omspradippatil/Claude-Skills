param(
    [string]$Target = "",
    [switch]$Help
)
$ErrorActionPreference = "Stop"

if ($Help) {
    Write-Output "Usage: .\uninstall.ps1 [-Target DIRECTORY]"
    Write-Output "Removes only unchanged files listed by this installation's manifest."
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
        throw "No install manifest found in current directory or user profile. Specify -Target DIRECTORY."
    }
} else {
    $Target = (Resolve-Path -LiteralPath $Target).Path
}

$Manifest = Join-Path $Target ".claude-skills-install.windows.manifest"
if (-not (Test-Path $Manifest)) { throw "No install manifest at $Manifest; nothing was removed." }
$Removed = 0
$Kept = 0
foreach ($Line in Get-Content -LiteralPath $Manifest) {
    if ([string]::IsNullOrWhiteSpace($Line)) { continue }
    $Parts = $Line.Split("|", 2)
    if ($Parts.Count -ne 2) { throw "Invalid install manifest entry; stopping safely." }
    $Relative = $Parts[0]
    $Normalized = $Relative.Replace("\", "/")
    if ([IO.Path]::IsPathRooted($Relative) -or $Normalized.Split("/") -contains "..") { throw "Unsafe path in manifest; stopping safely." }
    $Path = Join-Path $Target ($Normalized.Replace("/", [IO.Path]::DirectorySeparatorChar))
    if ((Test-Path -LiteralPath $Path -PathType Leaf) -and ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash -eq $Parts[1])) {
        Remove-Item -LiteralPath $Path
        $Removed++
    } else {
        Write-Output "Kept changed or missing file: $Path"
        $Kept++
    }
}
Remove-Item -LiteralPath $Manifest
Write-Output "Removed $Removed unchanged installed files; kept $Kept changed or missing files."

param([Parameter(Mandatory=$true)][string]$Target)
$ErrorActionPreference = "Stop"
$Target = (Resolve-Path -LiteralPath $Target).Path
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

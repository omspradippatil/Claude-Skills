<#
==============================================================================
 🗑️ AI Agent Skills Uninstaller (Windows PowerShell)
 Repository: https://github.com/omspradippatil/Claude-Skills
==============================================================================
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "╔═════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║                  🗑️  AI CODING SKILLS UNINSTALLER                      ║" -ForegroundColor Red
Write-Host "╚═════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Red
Write-Host ""

Write-Host "Uninstalling all global skills CLI entries..." -ForegroundColor Yellow
npx --yes skills@latest remove --all -g -y 2>$null

Write-Host "Uninstalling global npm packages (uipro-cli, @playwright/cli, firecrawl-cli, ctx7)..." -ForegroundColor Yellow
npm uninstall -g uipro-cli @playwright/cli firecrawl-cli ctx7 2>$null

if (Get-Command dart -ErrorAction SilentlyContinue) {
    Write-Host "Deactivating global Dart skills CLI..." -ForegroundColor Yellow
    dart pub global deactivate skills 2>$null
}

$flutterSkillsDir = Join-Path $HOME ".claude\skills\flutter-skills"
if (Test-Path $flutterSkillsDir) {
    Write-Host "Removing cloned Flutter Claude skills directory..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $flutterSkillsDir 2>$null
}

Write-Host ""
Write-Host "✔ All AI skills and global tools have been removed successfully!" -ForegroundColor Green
Write-Host ""

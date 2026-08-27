@echo off
TITLE AI Agent Skills Installer
CLS

echo ==============================================================================
echo  Launching AI Agent Skills Installer...
echo ==============================================================================
echo.

IF EXIST "%~dp0install.ps1" (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
) ELSE (
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.ps1 | iex"
)

PAUSE

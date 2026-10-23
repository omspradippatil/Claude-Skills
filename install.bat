@echo off
REM PowerShell installer wrapper. Usage: install.bat -Scope project -Platform agents
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
exit /b %ERRORLEVEL%

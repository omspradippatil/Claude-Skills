@echo off
REM PowerShell uninstaller wrapper. Usage: uninstall.bat [-Target DIRECTORY]
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0uninstall.ps1" %*
exit /b %ERRORLEVEL%

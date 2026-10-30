@echo off
setlocal
REM ==============================================================================
REM Claude-Skills: Windows Command Prompt Wrapper for install.ps1
REM Usage: install.bat [-Scope project|global] [-Platform agents|claude|cursor|antigravity]
REM ==============================================================================

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
set "EXIT_CODE=%ERRORLEVEL%"

if not "%EXIT_CODE%"=="0" (
    echo.
    echo [ERROR] Installation failed with exit code %EXIT_CODE%.
    if /i "%cmdcmdline:~0,6%"=="cmd /c" pause
)
exit /b %EXIT_CODE%

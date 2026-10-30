@echo off
setlocal
REM ==============================================================================
REM Claude-Skills: Windows Command Prompt Wrapper for uninstall.ps1
REM Usage: uninstall.bat [-Target DIRECTORY] [-All]
REM ==============================================================================

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0uninstall.ps1" %*
set "EXIT_CODE=%ERRORLEVEL%"

if not "%EXIT_CODE%"=="0" (
    echo.
    echo [ERROR] Uninstallation failed with exit code %EXIT_CODE%.
    if /i "%cmdcmdline:~0,6%"=="cmd /c" pause
)
exit /b %EXIT_CODE%

@echo off
REM AI Agent Skills Installer — Windows CMD wrapper
REM Usage: install.bat [global|project|uninstall]
powershell.exe -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*

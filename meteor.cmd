@echo off
set "oldcd=%cd%"
if "%~1"=="--changelog" (
	echo meteorRename Changelog
	echo.
	echo v1.1
	echo - Added --at flag
	echo - Fixed Set-Location in GUI
	echo.
	echo v1.2
	echo - Added "Change to Uppercase" button
	echo - Added --changelog flag
	echo - Added --help flag and help page
	echo.
	echo v1.2.1
	echo - Fixed "Add Suffix"
	echo - Added better error messages
	echo - Improved meteor.cmd
	echo - Changed console window startup message
	exit /b 0
) else if "%~1"=="--help" (
	echo meteorRename Help
	echo.
	echo Usage: meteor [flag]
	echo Options: --at ^<path^>    Opens meteorRename in a specified directory
	echo          --help         Displays this help message
	echo          --changelog    Displays a changelog
	exit /b 0
) else if "%~1"=="--at" (
	set "workpath=%~2"
) else (
	set "workpath=%oldcd%"
)
cd /d "%~dp0"
if not exist meteor_gui.ps1 (
	echo File not found "meteor_gui.ps1"!
	cd /d "%oldcd%"
	pause >nul
	exit /b 1
)
if not exist meteor_actions.ps1 (
	echo File not found "meteor_actions.ps1"!
	cd /d "%oldcd%"
	pause >nul
	exit /b 1
)
cd /d "%oldcd%"
cd /d "%workpath%"
if %errorlevel% gtr 0 (
	echo Invalid directory!
	cd /d "%oldcd%"
	pause >nul
	exit /b 1
) else (
	set "workpath=%cd%"
)
start "meteorRename" powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0meteor_gui.ps1" -StartIn "%workpath%"
cd /d "%oldcd%"
exit /b 0

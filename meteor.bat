@echo off
set "oldcd=%cd%"
if "%~1"=="--version" (
	echo meteorRename version 1.1
	echo Developed by Josh Abedelmassieh
	exit /b
) else if "%~1"=="--at" (
	set "workpath=%~2"
) else (
	set "workpath=%oldcd%"
)
cd %~dp0
if not exist meteor_gui.ps1 (
	cls
	echo File not found "meteor_gui.ps1"!
	pause >nul
	exit /b
)
if not exist meteor_actions.ps1 (
	cls
	echo File not found "meteor_actions.ps1"!
	pause >nul
	exit /b
)
cd %workpath%
if %errorlevel% gtr 0 (
	cls
	echo Invalid directory!
	pause >nul
	exit /b
) else (
	set "workpath=%cd%"
)
cd %~dp0
start "meteorRename" powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0meteor_gui.ps1" -StartIn "%workpath%"
cd %oldcd%
exit /b
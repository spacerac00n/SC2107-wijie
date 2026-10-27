@echo off
cls
SET "AG_IDE_SYSTEM_TARGET=%USERPROFILE%\.gemini\antigravity-ide"
SET "AG_OLD_SYSTEM_TARGET=%USERPROFILE%\.gemini\antigravity"

echo ========================================================
echo   SHARED LAB PC PURGE (ANTIGRAVITY IDE CLEAN SLATE)
echo ========================================================
echo.
echo WARNING: This will forcefully wipe all cached data, workspace histories,
echo and recent item registries from this user account.
echo.
pause
echo.

:: 1. Shred global recent file logs, workspace manager histories, and window states
echo [1/3] Purging shared user folder caches and Workspace Manager history...
if exist "%APPDATA%\Code\User\globalStorage" rmdir /S /Q "%APPDATA%\Code\User\globalStorage"
if exist "%APPDATA%\Code\User\workspaceStorage" rmdir /S /Q "%APPDATA%\Code\User\workspaceStorage"
if exist "%APPDATA%\Antigravity\User\globalStorage" rmdir /S /Q "%APPDATA%\Antigravity\User\globalStorage"
if exist "%APPDATA%\Antigravity\User\workspaceStorage" rmdir /S /Q "%APPDATA%\Antigravity\User\workspaceStorage"
if exist "%APPDATA%\Antigravity IDE\User\globalStorage" rmdir /S /Q "%APPDATA%\Antigravity IDE\User\globalStorage"
if exist "%APPDATA%\Antigravity IDE\User\workspaceStorage" rmdir /S /Q "%APPDATA%\Antigravity IDE\User\workspaceStorage"

:: 2. Wipe localized runtime agent contexts and active AI threads from previous users
echo [2/3] Scrubbing active model runtime context paths...
if exist "%AG_IDE_SYSTEM_TARGET%" rmdir /S /Q "%AG_IDE_SYSTEM_TARGET%"
if exist "%AG_OLD_SYSTEM_TARGET%" rmdir /S /Q "%AG_OLD_SYSTEM_TARGET%"

:: 3. Wipe background telemetry and extension state configurations
echo [3/3] Clearing residual editor interface traces...
if exist "%USERPROFILE%\.antigravity" rmdir /S /Q "%USERPROFILE%\.antigravity"

echo.
echo ========================================================
echo SUCCESS: Shared PC Traces Cleared!
echo ========================================================
echo The Antigravity IDE will now launch as if it were opened
echo for the very first time. No ghost links or histories remain.
echo ========================================================
pause
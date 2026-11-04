@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"

set "COMMIT_MESSAGE=%~1"
if not defined COMMIT_MESSAGE set "COMMIT_MESSAGE=Update China Fictional Maglev Set"

echo Repo: China Fictional Maglev Set
echo Commit: %COMMIT_MESSAGE%
echo.

echo [1/3] Building GRF from checked-in sprites...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1" -SkipSprites
if errorlevel 1 goto failure

echo [2/3] Staging and committing source changes...
git add -A
if errorlevel 1 goto failure

git diff --cached --quiet
if errorlevel 1 goto commit
echo No staged changes to commit.
goto push_loop

:commit
git commit -m "%COMMIT_MESSAGE%"
if errorlevel 1 goto failure

:push_loop
echo [3/3] Pushing main to GitHub...
git push -u origin main
if not errorlevel 1 goto success

echo.
echo Push failed with exit code %errorlevel%.
echo Check the proxy at 127.0.0.1:7890, VPN, DNS and GitHub access.
echo Retrying in 20 seconds. Press Ctrl+C to stop.
timeout /t 20 /nobreak >nul
goto push_loop

:success
echo.
echo Upload completed.
pause
endlocal
exit /b 0

:failure
echo.
echo Build or commit failed. Nothing was pushed.
pause
endlocal
exit /b 1

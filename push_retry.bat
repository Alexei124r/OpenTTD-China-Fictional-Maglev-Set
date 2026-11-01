@echo off
setlocal
cd /d "%~dp0"

echo Repo: China Fictional Maglev Set
echo Remote: %~n0 will keep retrying until the push succeeds.
echo If github.com:443 is blocked, configure a VPN/proxy or fix the DNS
echo resolution before running this script. Press Ctrl+C to stop.
echo.

:push_loop
git push -u origin main
if not errorlevel 1 goto success

echo.
echo Push failed with exit code %errorlevel%. Retrying in 20 seconds...
timeout /t 20 /nobreak >nul
goto push_loop

:success
echo.
echo Push succeeded.
pause
endlocal

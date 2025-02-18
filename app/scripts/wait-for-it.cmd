@echo off
setlocal enabledelayedexpansion

:: Default values
set "WAITFORIT_TIMEOUT=30"
set "WAITFORIT_STRICT=0"
set "WAITFORIT_QUIET=0"

:: Parse host:port
for /f "tokens=1,2 delims=:" %%a in ("%~1") do (
    set WAITFORIT_HOST=%%a
    set WAITFORIT_PORT=%%b
)

:: Check if host is provided
if "%WAITFORIT_HOST%"=="" (
    echo Error: You need to provide a host and port to test.
    exit /b 1
)

echo Waiting for %WAITFORIT_HOST%:%WAITFORIT_PORT% with a timeout of %WAITFORIT_TIMEOUT% seconds...

set /a "counter=0"

:waitloop
:: Check if the port is open using netstat
netstat -an | findstr ":8082" >nul
if !errorlevel! == 0 (
    echo Port %WAITFORIT_PORT% is open on %WAITFORIT_HOST%.
    exit /b 0
)

:: Try to ping the database
ping -n 1 %WAITFORIT_HOST% >nul 2>&1
if %errorlevel%==0 (
    echo %WAITFORIT_HOST%:%WAITFORIT_PORT% is available.
    exit /b 0
)

:: Increment counter and check timeout
set /a counter+=1
if %counter% geq %WAITFORIT_TIMEOUT% (
    echo Timeout occurred after %WAITFORIT_TIMEOUT% seconds waiting for %WAITFORIT_HOST%:%WAITFORIT_PORT%.
    exit /b 1
)

:: Wait for 1 second by pinging localhost
ping -n 2 127.0.0.1 >nul
goto waitloop
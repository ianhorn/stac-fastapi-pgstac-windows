@echo off
setlocal enabledelayedexpansion

:: Default values
set "WAITFORIT_TIMEOUT=15"
set "WAITFORIT_STRICT=0"
set "WAITFORIT_QUIET=0"

:: Parse arguments
:parseargs
if "%~1"=="" goto :done
if "%~1"=="--help" goto :usage

:: Parse host:port
for /f "tokens=1,2 delims=:" %%a in ("%~1") do (
    set WAITFORIT_HOST=%%a
    set WAITFORIT_PORT=%%b
)
shift

:: Parse timeout
if "%~1"=="-t" (
    set WAITFORIT_TIMEOUT=%2
    shift
    shift
)

:: Parse quiet
if "%~1"=="-q" (
    set WAITFORIT_QUIET=1
    shift
)

:: Parse strict
if "%~1"=="-s" (
    set WAITFORIT_STRICT=1
    shift
)

goto :parseargs

:done
if "%WAITFORIT_HOST%"=="" (
    echo Error: You need to provide a host and port to test.
    goto :usage
)

:: Wait for the TCP connection
echo Waiting for %WAITFORIT_HOST%:%WAITFORIT_PORT% with a timeout of %WAITFORIT_TIMEOUT% seconds

set /a "counter=0"
:waitloop
:: Check if the host and port are available using netstat
netstat -an | find ":%WAITFORIT_PORT% " | find "LISTENING" >nul
if not errorlevel 1 (
    echo %WAITFORIT_HOST%:%WAITFORIT_PORT% is available.
    goto :success
)

:: Increment counter and check timeout
set /a counter+=1
if !counter! geq %WAITFORIT_TIMEOUT% (
    echo Timeout occurred after %WAITFORIT_TIMEOUT% seconds waiting for %WAITFORIT_HOST%:%WAITFORIT_PORT%.
    if "%WAITFORIT_STRICT%"=="1" (
        exit /b 1
    )
    goto :failure
)

:: Wait for 1 second before retrying
timeout /t 1 >nul
goto :waitloop

:success
exit /b 0

:failure
exit /b 1

:usage
echo Usage:
echo wait-for-it.cmd host:port [-t timeout] [-s] [-q] [-- command args]
echo -t TIMEOUT  Timeout in seconds (default 15)
echo -q          Quiet mode, no output
echo -s          Strict mode, exit with error if connection fails
exit /b 1
@echo off

REM Drive C exists, so now we have temporary storage for redirected I/O
REM once we setup the temp directories.

set OLDTMP=%TEMP%
set TEMP=%FTEMP%
set TMP=%FTEMP%

if not exist %TEMP%\NUL mkdir "%TEMP%
if not exist %TEMP%\NUL goto AbortBatch

set FPIPES=NO
echo. | set /p FPIPES=
if "%FPIPES%" == "NO" goto AbortBatch
echo y| set /p FPIPES=
if not "%FPIPES%" == "y" goto AbortBatch
CD | set /p FINSP=

verrlvl 0
goto Done

:AbortBatch
set FERROR="no support for 'set /p' or I/O redirection."
call FDIFAIL.BAT ERROR_SHELL
verrlvl 1

:Done
set FPIPES=

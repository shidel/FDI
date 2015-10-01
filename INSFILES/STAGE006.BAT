@echo off

REM Drive C exists, so now we have temporary storage for redirected I/O
REM once we setup the temp directories.

set FTEMPO=%TEMP%
set FTMPO=%TMP%
set TEMP=%FTEMP%
set TMP=%FTEMP%

if not exist %TEMP%\NUL mkdir "%TEMP%
if not exist %TEMP%\NUL goto AbortBatch

CD | set /p FINSP=

verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done
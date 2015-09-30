@echo off

REM Drive C exists, so now we have temporary storage for redirected I/O
REM once we setup the temp directories.

set FDI_TEMPO=%TEMP%
set FDI_TMPO=%TMP%
set TEMP=%FDI_TEMP%
set TMP=%FDI_TEMP%

if not exist %TEMP%\NUL mkdir "%TEMP%
if not exist %TEMP%\NUL goto AbortBatch

CD | set /p FDI_INSP=

verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done
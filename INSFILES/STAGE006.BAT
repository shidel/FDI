@echo off

REM Drive C exists, so now we have temporary storage for redirected I/O
REM once we setup the temp directories.

set FTEMPO=%TEMP%
set FTMPO=%TMP%
set TEMP=%FTEMP%
set TMP=%FTEMP%

if not exist %TEMP%\NUL mkdir "%TEMP%
if not exist %TEMP%\NUL goto AbortBatch

REM Test if SET /P is available. It does not function under DOSBox, PC-DOS,
REM MS-DOS and under the FreeDOS 4DOS shell. The standard FreeDOS shell and
REM later versions of Windows DOS support it. We cannot install without it!

set FPIPES=NO
echo. | set /p FPIPES=
if "%FPIPES%" == "NO" goto AbortBatch
echo YES| set /p FPIPES=
if not "%FPIPES%" == "y" goto AbortBatch
CD | set /p FINSP=

verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done
set FPIPES=

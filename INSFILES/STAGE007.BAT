@echo off

REM Prompt user for all questions needed for install.

call FDIWIND.BAT 5
vecho "Gathering some information to prepare for installation." /n
vdelay %FDEL%

REM Locate installer packages media.
set _MI=0

REM For some reason, DOS sometimes fails to do this correctly on the first try.
:MediaLoop
if "%_MI%" == "27" goto MissingMedia
vmath %_MI% + 1 | set /p _MT=
if "%_MT%" == "" goto MediaLoop
set _MI=%_MT%

vmath %_MI% + 64 | set /p _MA=
vstr /c %_MA% | set /p _MA=
call FDIMEDIA.BAT %_MA%

if not "%FMEDIA%" == "" goto MediaFound
goto MediaLoop

:MissingMedia
set FERROR="Unable to locate installation packages."
call FDFAIL.BAT "Unable to locate installation packages."
goto AbortBatch

:MediaFound
set _MI=
set _MA=
REM Run through all questions.
set _TI=0

REM For some reason, DOS sometimes fails to do this correctly on the first try.
REM So, make sure it is ready before moving on.
:Sticky
dir /a /b /p- FDASK*.BAT | vstr /l %_TI% | set /p _TA=
if "%_TA%" == "" goto Sticky

:Looping
dir /a /b /p- FDASK*.BAT | vstr /l %_TI% | set /p _TA=
if "%_TA%" == "" goto Finished
verrlvl 0
call %_TA%
if errorlevel 1 goto AbortBatch
vmath %_TI% + 1 | set /p _TI=
goto Looping

:Finished
verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done
set _TI=
set _TA=

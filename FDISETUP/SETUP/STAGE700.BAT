@echo off

REM Prompt user for all questions needed for install.

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% GATHERING_FRAME
vecho /n /t %FLANG% GATHERING
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
set _MT=
REM Run through all questions.
set _TI=0

vfdutil /c /p %FINSP%\ >NUL

REM For some reason, DOS sometimes fails to do this correctly on the first try.
REM So, make sure it is ready before moving on.
:Sticky
dir /on /a /b /p- FDASK*.BAT | vstr /b /l %_TI% | set /p _TA=
if "%_TA%" == "" goto Sticky

:Looping
vfdutil /c /p %FINSP%\ >NUL
dir /on /a /b /p- FDASK*.BAT | vstr /b /l %_TI% | set /p _TA=
if "%_TA%" == "" goto Finished

vfdutil /n %_TA% | set /p _TL=
call FDILANG.BAT %_TL% FDASK FDSETUP
set _TL=
verrlvl 0

call %_TA%
if errorlevel 1 goto AbortBatch
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vmath %_TI% + 1 | set /p _TI=

REM Fall-through if anyone changes the target installation directory.
REM Parent batch will go back to testing drive readiness.
if "%HTARGET%" == "%FTARGET%" goto Looping

:Finished
verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done
set _TI=
set _TA=

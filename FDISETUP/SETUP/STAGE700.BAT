@echo off

REM Prompt user for all questions needed for install.

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
set PKGDIR=
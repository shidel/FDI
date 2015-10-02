@echo off

REM Prompt user for all questions needed for install.

set _TI=0
vcls 0x07

:Lopping
dir /a /b /p- FDASK*.BAT | vstr /l %_TI% | set /p _TA=
if "%_TA%" == "" goto Finished
verrlvl 0
echo %_TA%
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
vdelay 2000
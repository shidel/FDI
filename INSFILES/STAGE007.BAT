@echo off

REM Prompt user for all questions needed for install.

call FDIWIND.BAT 8

vecho "Gathering some information for the installation."
vecho
vecho

call FDISCAN.BAT FDASK

:EachPath
set FDI_TSFL=0

:EachRepeat
type %TEMP%\FDIPATHS.LST | vstr /l %FDI_TSFL% | set /p FDI_TASK=
if "%FDI_TASK%" == "" goto EachDone
for %f in ( %FDI_TASK%\FDASK*.BAT ) do call %f

vmath %FDI_TSFL% + 1 | set /p FDI_TSFL=
goto EachRepeat

:EachDone
vpause
verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done
set FDI_TASK=
set FDI_TSFL=

@echo off

REM Thank the user for installing and offer to reboot.
call FDICLS.BAT
call FDIWIND.BAT 10
vecho /f %FLANG% DONE %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
vecho
vecho /f %FLANG% REBOOT?
call FDIOPTS.BAT 2
vecho /f %FLANG% REBOOT_YES
vecho /f %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

set FREBOOT=y
goto Done

:AbortBatch
set FREBOOT=n

:Done
verrlvl 0


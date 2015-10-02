@echo off

REM Thank the user for installing and offer to reboot.

call FDIWIND.BAT 10
vecho "Installation of " /f %TFH% "%OS_NAME% %OS_VERSION%" /f %TFF% " completed."
vecho
vecho "Do you want to reboot now?"
call FDIOPTS.BAT 2
vecho "  Yes - Please reboot now."
vecho "  No  - Exit to DOS." /n
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

set FREBOOT=y
goto Done

:AbortBatch
set FREBOOT=n

:Done
verrlvl 0


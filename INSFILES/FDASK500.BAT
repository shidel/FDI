@echo off

REM if advanced mode prompt for transfer system files.

if "%FADV%" == "" goto AssumeYes

:AdvancedMode
call FDIWIND.BAT 8
vecho /t %FLANG% XFER? %TFH% %FDRIVE% %TFF%
vecho
call FDIOPTS.BAT 2
vecho /t %FLANG% XFERY
vecho /n /t %FLANG% XFERN
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipSysXfer

:AssumeYes
set OSYS=y
verrlvl 0
goto Done

:SkipSysXfer
set OSYS=n
verrlvl 0

:Done

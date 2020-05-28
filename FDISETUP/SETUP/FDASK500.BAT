@echo off

REM if advanced mode prompt for transfer system files.

vinfo /m
if errorlevel 102 goto NotDOSBox
if errorlevel 101 goto IsDOSBox
:NotDOSBox
verrlvl 0

if "%FADV%" == "" goto AssumeYes

:AdvancedMode
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% XFER_FRAME
vecho /k0 /t %FLANG% XFER? %TFH% %FDRIVE% %TFF%
vecho /k0
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% XFER_OPTS
vecho /k0 /t %FLANG% XFERY
vecho /k0 /n /t %FLANG% XFERN
vchoice /k0 /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipSysXfer

:AssumeYes
set OSYS=y
verrlvl 0
goto Done

:IsDOSBox
:SkipSysXfer
set OSYS=n
verrlvl 0

:Done


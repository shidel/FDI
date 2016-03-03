@echo off

REM if advanced mode prompt for force MBR update.

if "%FADV%" == "" goto AssumeYes
if "%OSYS%" == "n" goto SkipSysXfer

:AdvancedMode
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% OBSS_FRAME
vecho /t %FLANG% OBSS? %TFH% %FDRIVE% %TFF%
vecho
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% OBSS_OPTS
vecho /t %FLANG% OBSSY
vecho /n /t %FLANG% OBSSN
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipSysXfer

:AssumeYes
set OBSS=y
verrlvl 0
goto Done

:SkipSysXfer
set OBSS=n
verrlvl 0

:Done

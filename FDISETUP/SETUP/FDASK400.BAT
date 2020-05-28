@echo off

REM if advanced mode prompt to remove old OS files.

if "%FADV%" == "" goto AssumeYes

:AdvancedMode
if exist %FTARGET%\NUL goto AskAdvanced
goto AssumeYes

:AskAdvanced
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% DELETE_FRAME
vecho /k0 /t %FLANG% DELETE? %TFH% %FTARGET% %TFF%
vecho /k0
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% DELETE_OPTS
vecho /k0 /t %FLANG% DELETEY
vecho /k0 /n /t %FLANG% DELETEN
vchoice /k0 /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipOption

:AssumeYes
set OCLEAN=y
verrlvl 0
goto Done

:SkipOption
set OCLEAN=n
verrlvl 0

:Done

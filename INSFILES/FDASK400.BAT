@echo off

REM if advanced mode prompt to remove old OS files.

if "%FADV%" == "" goto AssumeYes

:AdvancedMode
if exist %FTARGET%\NUL goto AskAdvanced
goto AssumeYes

:AskAdvanced
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% DELETE_FRAME
vecho /t %FLANG% DELETE? %TFH% %FTARGET% %TFF%
vecho
call FDIOPTS.BAT 2
vecho /t %FLANG% DELETEY
vecho /n /t %FLANG% DELETEN
vchoice /a %TFC% Ctrl-C /d 1

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

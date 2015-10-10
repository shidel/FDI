@echo off

@echo off

REM if advanced mode prompt to replace system config files.

if "%FADV%" == "" goto AssumeYes

:AdvancedMode
if exist %FTARGET%\NUL goto AskAdvanced
goto AssumeYes

:AskAdvanced
call FDIWIND.BAT 8
vecho "Remove all old files from %FTARGET%?"
vecho
call FDIOPTS.BAT 2
vecho "  Yes - Start fresh."
vecho "  No  - Leave it cluttered." /n
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipOption

:AssumeYes
set OCLEAN=y
verrlvl 0
goto Done

:SkipOtion
set OCLEAN=n
verrlvl 0

:Done
set _C=
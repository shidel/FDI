@echo off

REM if advanced mode prompt to replace system config files.

if "%FADV%" == "" goto AssumeYes

:AskAdvanced
call FDIWIND.BAT 8
vecho "Install V8Power Tools to %FTARGET%\V8Power?"
vecho
call FDIOPTS.BAT 2
vecho "  Yes - Install V8Power Tools."
vecho "  No  - Do not install them." /n
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipOption

:AssumeYes
set OV8P=y
verrlvl 0
goto Done

:SkipOtion
set OV8P=n
verrlvl 0

:Done
set _C=
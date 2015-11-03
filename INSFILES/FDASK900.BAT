@echo off

REM if advanced mode prompt to install copy of V8Power Tools files.

if "%FADV%" == "" goto AssumeYes

:AskAdvanced
call FDIWIND.BAT 8
vecho /t %FLANG% V8I? %TFH% %TFF%
vecho
call FDIOPTS.BAT 2
vecho /t %FLANG% V8IY
vecho /n /t %FLANG% V8IN
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipOption

:AssumeYes
set OV8P=y
verrlvl 0
goto Done

:SkipOption
set OV8P=n
verrlvl 0

:Done

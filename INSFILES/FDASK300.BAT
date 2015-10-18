@echo off

REM if advanced mode prompt to replace system config files.

if "%FADV%" == "" goto AssumeYes

:AdvancedMode
vfdutil /d %FTARGET% | set /p _C=
if exist %_C%\AUTOEXEC.BAT goto AskAdvanced
if exist %_C%\FDAUTO.BAT goto AskAdvanced
if exist %_C%\CONFIG.SYS goto AskAdvanced
if exist %_C%\FDCONFIG.SYS goto AskAdvanced
goto AssumeYes

:AskAdvanced
call FDIWIND.BAT 8
vecho "Replace the system configuration files?"
vecho
call FDIOPTS.BAT 2
vecho "  Yes - Transfer new default files."
vecho "  No  - Keep the old files." /n
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipOption

:AssumeYes
set OCFG=y
verrlvl 0
goto Done

:SkipOption
set OCFG=n
verrlvl 0

:Done
set _C=
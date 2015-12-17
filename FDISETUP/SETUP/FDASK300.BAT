@echo off

REM if advanced mode prompt to replace system config files.

if "%FADV%" == "" goto AssumeYes

:AdvancedMode
if exist %FDRIVE%\AUTOEXEC.BAT goto AskAdvanced
if exist %FDRIVE%\FDAUTO.BAT goto AskAdvanced
if exist %FDRIVE%\CONFIG.SYS goto AskAdvanced
if exist %FDRIVE%\FDCONFIG.SYS goto AskAdvanced
goto AssumeYes

:AskAdvanced
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% REPLACE_FRAME
vecho /t %FLANG% REPLACE?
vecho
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% REPLACE_OPTS
vecho /t %FLANG% REPLACEY
vecho /n /t %FLANG% REPLACEN
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

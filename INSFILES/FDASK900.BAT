@echo off

REM if advanced mode prompt to install copy of V8Power Tools files.

if not "%OALL%" == "y" goto AssumeNo
if "%FADV%" == "" goto AssumeYes

:AskAdvanced
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% V8_FRAME
vecho /t %FLANG% V8I? %TFH% %TFF%
vecho
vframe /b %TFB% /f %TFF% hidden /t %FLANG% V8_OPTS
vecho /t %FLANG% V8IY
vecho /n /t %FLANG% V8IN
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipOption

:AssumeYes
set OV8P=y
verrlvl 0
goto Done

:AssumeNo
set OV8P=n
verrlvl 0
goto Done

:SkipOption
set OV8P=n
verrlvl 0

:Done

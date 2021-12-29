@echo off

REM Configure Target Drive and Directory.

if "%FTSET%" == "y" goto Done
if "%FADV%" == "y" goto AskAdvanced
goto Done

:AskAdvanced
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% TARGET_FRAME
vecho /k0 /t %FLANG% TARGET?
vecho /p /c32 /n
:RepeatAsk
vask /c /t %FLANG% TARGET_ASK %TQF% %TQB% %FWAIT% %FTARGET% | set /p TTARGET=
if errorlevel 200 FDICTRLC.BAT %0
vfdutil /p %TTARGET%\ | set /p TTARGET=
if "%TTARGET%" == "" goto RepeatAsk
vinfo /d %TTARGET%
if errorlevel 6 goto RepeatAsk
if errorlevel 5 goto Accept
if errorlevel 3 goto RepeatAsk

:Accept
rem vgotoxy /k0 sol
rem vecho /k0 /n /e %TTARGET%
set FTARGET=%TTARGET%
set TTARGET=
vfdutil /d %FTARGET% | set /p FDRIVE=
verrlvl 0
set FTSET=y
goto Skipped

:Done
set FTSET=
vfdutil /d %FTARGET% | set /p FDRIVE=
verrlvl 0

:Skipped

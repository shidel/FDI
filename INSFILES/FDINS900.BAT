@echo off

if "%OV8P%" == "y" goto DoOption
goto AfterOption

:DoOption

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% V8POWER_FRAME
vecho /n /t %FLANG% V8POWER %TFH% %TFF%
vdelay %FDEL%

xcopy %FINSP%\..\V8POWER %FTARGET%\V8POWER\ >NUL
if errorlevel 1 goto Failed

if not "%FVERB%" == "y" goto AfterOption
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% V8POWER_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% V8POWER_DONE
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="Copying V8Power Tools files."
call FDFAIL.BAT cc "Problem installing V8Power Tools."
verrlvl 1

:AfterOption
set _C=
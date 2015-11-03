@echo off

if "%OV8P%" == "y" goto DoOption
goto AfterOption

:DoOption

call FDIWIND.BAT 5
vecho /n /t %FLANG% V8POWER %TFH% %TFF%
vdelay %FDEL%

xcopy %FINSP%\..\V8POWER %FTARGET%\V8POWER\ >NUL
if errorlevel 1 goto Failed

if not "%FVERB%" == "y" goto AfterOption
call FDIWIND.BAT 5
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
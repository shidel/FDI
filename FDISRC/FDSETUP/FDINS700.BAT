@echo off

REM Transfer system files.

if "%OSYS%" == "y" goto DoOption
goto AfterOption

:DoOption
vfdutil /d %FTARGET% | set /p _C=

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% XSYS_FRAME
vecho /n /t %FLANG% XSYS %TFH% %_C% %TFF%
vdelay %FDEL%

sys %_C%>NUL
if errorlevel 1 goto Failed
verrlvl 0

if not "%FVERB%" == "y" goto AfterOption
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% XSYS_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% XSYS_DONE
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="System file transfer to %_C% failed."
call FDFAIL.BAT cc "Error transfering system files to %_C%."
verrlvl 1

:AfterOption
set _C=
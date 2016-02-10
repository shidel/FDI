@echo off

REM Transfer system files.

if "%OSYS%" == "y" goto DoOption
goto AfterOption

:DoOption
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% XSYS_FRAME
vecho /n /t %FLANG% XSYS %TFH% %FDRIVE% %TFF%
vdelay %FDEL%

if exist %FDRIVE%\COMMAND.COM attrib -R -S -H %FDRIVE%\COMMAND.COM >NUL
if exist %FDRIVE%\KERNEL.SYS attrib -R -S -H %FDRIVE%\KERNEL.SYS >NUL

sys %FDRIVE%>NUL
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
set FERROR="System file transfer to %FDRIVE% failed."
call FDFAIL.BAT cc ERROR_XSYS %FDRIVE%
verrlvl 1

:AfterOption

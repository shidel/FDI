@echo off

REM Remove old config files.

if "%OCFG%" == "y" goto MaybeOption
goto AfterOption

:MaybeOption
if exist %FDRIVE%\AUTOEXEC.BAT goto DoOption
if exist %FDRIVE%\FDAUTO.BAT goto DoOption
if exist %FDRIVE%\CONFIG.SYS goto DoOption
if exist %FDRIVE%\FDCONFIG.SYS goto DoOption
goto AfterOption

:DoOption

if exist %FDRIVE%\FDAUTO.BAT attrib -R -S -H %FDRIVE%\FDAUTO.BAT >NUL
if exist %FDRIVE%\AUTOEXEC.BAT attrib -R -S -H %FDRIVE%\AUTOEXEC.BAT >NUL
if exist %FDRIVE%\CONFIG.SYS attrib -R -S -H %FDRIVE%\CONFIG.SYS >NUL
if exist %FDRIVE%\FDCONFIG.SYS attrib -R -S -H %FDRIVE%\FDCONFIG.SYS >NUL

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% CLEAN_FRAME
vecho /n /t %FLANG% CLEAN
vdelay %FDEL%

if exist %FDRIVE%\AUTOEXEC.BAT attrib -R -S -H %FDRIVE%\AUTOEXEC.BAT >NUL
if exist %FDRIVE%\AUTOEXEC.BAT del %FDRIVE%\AUTOEXEC.BAT
if errorlevel 1 goto Failed

if exist %FDRIVE%\FDAUTO.BAT attrib -R -S -H %FDRIVE%\FDAUTO.BAT >NUL
if exist %FDRIVE%\FDAUTO.BAT del %FDRIVE%\FDAUTO.BAT
if errorlevel 1 goto Failed

if exist %FDRIVE%\CONFIG.SYS attrib -R -S -H %FDRIVE%\CONFIG.SYS >NUL
if exist %FDRIVE%\CONFIG.SYS del %FDRIVE%\CONFIG.SYS
if errorlevel 1 goto Failed

if exist %FDRIVE%\FDCONFIG.SYS attrib -R -S -H %FDRIVE%\FDCONFIG.SYS >NUL
if exist %FDRIVE%\FDCONFIG.SYS del %FDRIVE%\FDCONFIG.SYS
if errorlevel 1 goto Failed
verrlvl 0

if not "%FVERB%" == "y" goto AfterOption
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% CLEAN_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% CLEAN_DONE
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="Cleaning up old configuration files."
call FDFAIL.BAT cc ERROR_REMOS
verrlvl 1

:AfterOption

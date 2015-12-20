@echo off

REM Remove old config files, maybe.

if "%OCFG%" == "y" goto MaybeOption
goto AfterOption

:MaybeOption
if exist %_C%\AUTOEXEC.BAT goto DoOption
if exist %_C%\FDAUTO.BAT goto DoOption
if exist %_C%\CONFIG.SYS goto DoOption
if exist %_C%\FDCONFIG.SYS goto DoOption
goto AfterOption

:DoOption
vfdutil /d %FTARGET% | set /p _C=

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% CLEAN_FRAME
vecho /n /t %FLANG% CLEAN
vdelay %FDEL%

if exist %_C%\AUTOEXEC.BAT attrib -R -S -H %_C%\AUTOEXEC.BAT >NUL
if exist %_C%\AUTOEXEC.BAT del %_C%\AUTOEXEC.BAT
if errorlevel 1 goto Failed

if exist %_C%\FDAUTO.BAT attrib -R -S -H %_C%\FDAUTO.BAT >NUL
if exist %_C%\FDAUTO.BAT del %_C%\FDAUTO.BAT
if errorlevel 1 goto Failed

if exist %_C%\CONFIG.SYS attrib -R -S -H %_C%\CONFIG.SYS >NUL
if exist %_C%\CONFIG.SYS del %_C%\CONFIG.SYS
if errorlevel 1 goto Failed

if exist %_C%\FDCONFIG.SYS attrib -R -S -H %_C%\FDCONFIG.SYS >NUL
if exist %_C%\FDCONFIG.SYS del %_C%\FDCONFIG.SYS
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
set _C=
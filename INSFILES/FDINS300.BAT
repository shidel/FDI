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

call FDIWIND.BAT 5
vecho "Cleaning out old configuration files." /n
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

call FDIWIND.BAT 5
vgotoxy /l sop
vecho "Old configuration files were removed." /n /e
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="Cleaning up old configuration files."
call FDFAIL.BAT "Problem removing old configuration files."
verrlvl 1

:AfterOption
set _C=
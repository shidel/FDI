@echo off

if "%OCFG%" == "y" goto DoOption
goto AfterOption

:DoOption

call FDIWIND.BAT 5
vecho "Installing fresh configuration files." /n
vdelay %FDEL%

vfdutil /d %FTARGET% | set /p _C=

copy %FINSP%\AUTOEXEC.NEW %_C%\AUTOEXEC.BAT >NUL
if errorlevel 1 goto Failed
copy %FINSP%\FDCONFIG.NEW %_C%\FDCONFIG.SYS >NUL
if errorlevel 1 goto Failed

if not "%FVERB%" == "y" goto AfterOption
call FDIWIND.BAT 5
vgotoxy /l sop
vecho "New config files were installed." /n /e
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="Copying configuration files."
call FDFAIL.BAT cc "Problem copying new configuration files."
verrlvl 1

:AfterOption
set _C=
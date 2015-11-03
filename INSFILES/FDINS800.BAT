@echo off

REM This should be improved to generate fresh config files based on all
REM options. Not just pick this or that config file. Requires some additional
REM tools abe created for V8Power Tools first. At present, %FEXT% is just
REM set to DEF in STAGE000.

if "%OCFG%" == "y" goto DoOption
goto AfterOption

:DoOption

call FDIWIND.BAT 5
vecho "Installing fresh configuration files." /n
vdelay %FDEL%

vfdutil /d %FTARGET% | set /p _C=

copy %FINSP%\AUTOEXEC.%FEXT% %_C%\AUTOEXEC.BAT >NUL
if errorlevel 1 goto Failed
copy %FINSP%\FDCONFIG.%FEXT% %_C%\FDCONFIG.SYS >NUL
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
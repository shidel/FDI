@echo off

REM This should be improved to generate fresh config files based on all
REM options. Not just pick this or that config file. Requires some additional
REM tools abe created for V8Power Tools first. At present, %FEXT% is just
REM set to DEF in STAGE000.

if "%OCFG%" == "y" goto DoOption
goto AfterOption

:DoOption

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% CONFIGS_FRAME
vecho /n /t %FLANG% CONFIGS
vdelay %FDEL%

REM Simple Autoexec.bat creation
type %FINSP%\AUTOEXEC.%FEXT%>%FDRIVE%\AUTOEXEC.BAT
if errorlevel 1 goto Failed

REM Simple CONFIG.SYS creation.
type %FINSP%\FDCONFIG.%FEXT%>%FDRIVE%\FDCONFIG.SYS
if errorlevel 1 goto Failed

REM Create the installed version ID file.
echo PLATFORM=%OS_NAME%>%FTARGET%\VERSION.FDI
if errorlevel 1 goto Failed
echo VERSION=%OS_VERSION%>>%FTARGET%\VERSION.FDI
if errorlevel 1 goto Failed

if not "%FVERB%" == "y" goto AfterOption
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% CONFIGS_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% CONFIGS_DONE
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="Copying configuration files."
call FDFAIL.BAT cc "Problem copying new configuration files."
verrlvl 1

:AfterOption

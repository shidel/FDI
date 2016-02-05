@echo off

REM Install fresh custom AUTOEXEC.BAT and FDCONFIG.SYS

if "%OCFG%" == "y" goto DoOption
goto AfterOption

:DoOption

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% CONFIGS_FRAME
vecho /n /t %FLANG% CONFIGS
vdelay %FDEL%

REM Simple Autoexec.bat creation

rem Embed Language configuration and codepage.
type %FINSP%\AUTOEXEC.%FEXT% |grep -B 1000 -i \$LANG_SET\$|grep -iv \$LANG_SET\$>%TEMP%\REPLACE.001
if errorlevel 1 goto Failed
if exist %LANG%\SETLANG.BAT type %LANG%\SETLANG.BAT | grep -iv "@ECHO OFF"|vstr /b/n>>%TEMP%\REPLACE.001
if errorlevel 1 goto Failed
type %FINSP%\AUTOEXEC.%FEXT% |grep -A 1000 -i \$LANG_SET\$|grep -iv \$LANG_SET\$>>%TEMP%\REPLACE.001
if errorlevel 1 goto Failed

copy /y %TEMP%\REPLACE.001 %TEMP%\REPLACE.002 >NUL
goto SkipLangText

rem Include translated text.
type %TEMP%\REPLACE.001|grep -B 1000 -i \$LANG_TEXT\$|grep -iv \$LANG_TEXT\$>%TEMP%\REPLACE.002
if errorlevel 1 goto Failed
echo (EN) English>>%TEMP%\REPLACE.002
if errorlevel 1 goto Failed
type EN\FDSETUP.DEF|grep -i ^AUTO_ |vstr /b/s "AUTO_" ""|vstr /n/b/s "=" ".EN=">>%TEMP%\REPLACE.002
if errorlevel 1 goto Failed
echo.>>%TEMP%\REPLACE.002
if errorlevel 1 goto Failed
if "%LANG%" == "EN" goto NoLangText
if not exist %LANG%\FDSETUP.DEF goto NoLangText
type %LANG%\FDSETUP.DEF | grep -i ^LANG_NAME\=|vstr /s "=" "=(%LANG%) "|vstr /n/b/f = 2>>%TEMP%\REPLACE.002
type %LANG%\FDSETUP.DEF | grep -i ^LANG_AUTHOR\=|vstr /s "=" "=by "|vstr /n/b/f = 2>>%TEMP%\REPLACE.002
if errorlevel 1 goto Failed
type %LANG%\FDSETUP.DEF|grep -i ^AUTO_ |vstr /b/s "AUTO_" ""|vstr /n/b/s "=" ".%LANG%=">>%TEMP%\REPLACE.002
if not exist %LANG%\nul goto NoLangText
if errorlevel 1 goto Failed
echo.>>%TEMP%\REPLACE.002
if errorlevel 1 goto Failed
:NoLangText
type %TEMP%\REPLACE.001 |grep -A 1000 -i \$LANG_TEXT\$|grep -iv \$LANG_TEXT\$>>%TEMP%\REPLACE.002
if errorlevel 1 goto Failed
:SkipLangText

:Sticky
echo %FTARGET% | vstr /n/f \ 2- | set /p DDIR=
if "%DDIR%" == "" goto Sticky
set DDIR=C:\%DDIR%

rem set LANG, DOSDIR and etc in AUTOEXEC.BAT
type %TEMP%\REPLACE.002 | vstr /n/s $FLANG$ %LANG% >%TEMP%\REPLACE.003
if errorlevel 1 goto Failed
type %TEMP%\REPLACE.003 | vstr /n/s $FTARGET$ %DDIR% >%TEMP%\REPLACE.004
if errorlevel 1 goto Failed
type %TEMP%\REPLACE.004 | vstr /n/s $FDRIVE$ C: >%TEMP%\REPLACE.005
if errorlevel 1 goto Failed
type %TEMP%\REPLACE.005 | vstr /n/s $OSNAME$ "%OS_NAME%" >%TEMP%\REPLACE.006
if errorlevel 1 goto Failed
type %TEMP%\REPLACE.006 | vstr /n/s $OSVER$ "%OS_VERSION%" >%FDRIVE%\AUTOEXEC.BAT
if errorlevel 1 goto Failed

rem set LANG, DOSDIR and etc in FDCONFIG.SYS
type %FINSP%\FDCONFIG.%FEXT% | vstr /n /s $FLANG$ %LANG% >%TEMP%\REPLACE.001
if errorlevel 1 goto Failed
type %TEMP%\REPLACE.001 | vstr /n /s $FTARGET$ %DDIR% >%TEMP%\REPLACE.002
if errorlevel 1 goto Failed
type %TEMP%\REPLACE.002 | vstr /n /s $FDRIVE$ C: >%FDRIVE%\FDCONFIG.SYS
if errorlevel 1 goto Failed

set DDIR=

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
call FDFAIL.BAT cc ERROR_CONFIG
verrlvl 1

:AfterOption

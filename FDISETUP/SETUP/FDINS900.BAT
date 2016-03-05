@echo off

REM Install fresh custom AUTOEXEC.BAT and FDCONFIG.SYS

if "%OCFG%" == "y" goto DoOption
goto AfterOption

:DoOption

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% ICONFIGS_FRAME
vecho /n /t %FLANG% ICONFIGS
vdelay %FDEL%

REM Simple Autoexec.bat creation

rem Embed Language configuration and codepage.
type %FINSP%\AUTOEXEC.DEF |grep -B 1000 -i \$LANG_SET\$|grep -iv \$LANG_SET\$>%TEMP%\REPLACE.001
if errorlevel 1 goto Failed
if exist %LANG%\SETLANG.BAT type %LANG%\SETLANG.BAT | grep -iv "@ECHO OFF"|vstr /b/n>>%TEMP%\REPLACE.001
if errorlevel 1 goto Failed
type %FINSP%\AUTOEXEC.DEF |grep -A 1000 -i \$LANG_SET\$|grep -iv \$LANG_SET\$>>%TEMP%\REPLACE.001
if errorlevel 1 goto Failed

copy /y %TEMP%\REPLACE.001 %TEMP%\REPLACE.002 >NUL
del %TEMP%\REPLACE.001 >NUL

:Sticky
echo %FTARGET% | vstr /n/f \ 2- | set /p DDIR=
if "%DDIR%" == "" goto Sticky
set DDIR=C:\%DDIR%

rem set LANG, DOSDIR and etc in AUTOEXEC.BAT
type %TEMP%\REPLACE.002 | vstr /n/s $FLANG$ %LANG% >%TEMP%\REPLACE.003
if errorlevel 1 goto Failed
del %TEMP%\REPLACE.002 >NUL
type %TEMP%\REPLACE.003 | vstr /n/s $FTARGET$ %DDIR% >%TEMP%\REPLACE.004
if errorlevel 1 goto Failed
del %TEMP%\REPLACE.003 >NUL
type %TEMP%\REPLACE.004 | vstr /n/s $FDRIVE$ C: >%TEMP%\REPLACE.005
if errorlevel 1 goto Failed
del %TEMP%\REPLACE.004 >NUL
type %TEMP%\REPLACE.005 | vstr /n/s $OSNAME$ "%OS_NAME%" >%TEMP%\REPLACE.006
del %TEMP%\REPLACE.005 >NUL
if errorlevel 1 goto Failed
type %TEMP%\REPLACE.006 | vstr /n/s $OSVER$ "%OS_VERSION%" >%FDRIVE%\AUTOEXEC.BAT
if errorlevel 1 goto Failed
del %TEMP%\REPLACE.006 >NUL

rem set LANG, DOSDIR and etc in FDCONFIG.SYS
type %FINSP%\FDCONFIG.DEF | vstr /n /s $FLANG$ %LANG% >%TEMP%\REPLACE.001
if errorlevel 1 goto Failed
type %TEMP%\REPLACE.001 | vstr /n /s $FTARGET$ %DDIR% >%TEMP%\REPLACE.002
if errorlevel 1 goto Failed
del %TEMP%\REPLACE.001 >NUL
type %TEMP%\REPLACE.002 | vstr /n /s $FDRIVE$ C: >%FDRIVE%\FDCONFIG.SYS
if errorlevel 1 goto Failed
del %TEMP%\REPLACE.002 >NUL

set DDIR=

REM Create the installed version ID file.
echo PLATFORM=%OS_NAME%>%FTARGET%\VERSION.FDI
if errorlevel 1 goto Failed
echo VERSION=%OS_VERSION%>>%FTARGET%\VERSION.FDI
if errorlevel 1 goto Failed

if not "%FVERB%" == "y" goto AfterOption
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% ICONFIGS_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% ICONFIGS_DONE
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="Copying configuration files."
call FDIFAIL.BAT cc ERROR_CONFIG
verrlvl 1

:AfterOption

@echo off

REM Install fresh custom AUTOEXEC.BAT and FDCONFIG.SYS

if "%OCFG%" == "y" goto DoOption
goto AfterOption

:DoOption

set DMNU=1

REM DBX=DosBox, QEM=QEMU, VBX=VirtualBox, VMW=VMware, EMU=Other Emulated
set FEXT=DEF
vinfo /m
if errorlevel 1 set FEXT=186
if errorlevel 2 set FEXT=286
if errorlevel 3 set FEXT=386
if errorlevel 4 set FEXT=486
if errorlevel 5 set FEXT=586
if errorlevel 6 set FEXT=686
if errorlevel 101 set FEXT=DBX
if errorlevel 102 set FEXT=QEM
if errorlevel 103 set FEXT=VBX
if errorlevel 104 set FEXT=VMW
if errorlevel 200 set FEXT=EMU
if "%FEXT%" == "VBX" goto IsVirtualBox
goto NotDOSBox

:IsVirtualBox
set DMNU=2

:NotDOSBox
verrlvl 0

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% ICONFIGS_FRAME
vecho /k0 /n /t %FLANG% ICONFIGS
vdelay %FDEL%

REM Simple AUTOEXEC.BAT creation

rem Embed Language configuration and codepage.
if not exist %FINSP%\AUTOEXEC.%FEXT% set FEXT=DEF
if not exist %FINSP%\AUTOEXEC.%FEXT% goto SkipAutoExec

type %FINSP%\AUTOEXEC.%FEXT% |grep -B 1000 -i \$LANG_SET\$|grep -iv \$LANG_SET\$>%TEMP%\AUTOEXEC.BAT
if errorlevel 1 goto Failed
if exist %LANG%\SETLANG.BAT type %LANG%\SETLANG.BAT | grep -iv "@ECHO OFF"|vstr /b/n>>%TEMP%\AUTOEXEC.BAT
if errorlevel 1 goto Failed
vstr >>%TEMP%\AUTOEXEC.BAT
if not exist %LANG%\KEYBOARD.LST goto NoKeyboards
type %LANG%\KEYBOARD.LST | grep -i "^VALUE.%FKB%=" | vstr /f = 2 | vstr /b/n>>%TEMP%\AUTOEXEC.BAT
vstr >>%TEMP%\AUTOEXEC.BAT
:NoKeyboards
if errorlevel 1 goto Failed
type %FINSP%\AUTOEXEC.%FEXT% |grep -A 1000 -i \$LANG_SET\$|grep -iv \$LANG_SET\$>>%TEMP%\AUTOEXEC.BAT
if errorlevel 1 goto Failed

:Sticky
echo %FTARGET% | vstr /n/f \ 2- | set /p DDIR=
if "%DDIR%" == "" goto Sticky
set DDIR=C:\%DDIR%

rem set LANG, DOSDIR and etc in AUTOEXEC.BAT
CALL FDISET.BAT BEGIN %TEMP%\AUTOEXEC.BAT
CALL FDISET.BAT SET $TZ$ %TZ%
CALL FDISET.BAT SET $FLANG$ %LANG%
CALL FDISET.BAT SET $FTARGET$ %DDIR%
CALL FDISET.BAT SET $FDRIVE$ C:
CALL FDISET.BAT SET $OSNAME$ "%OS_NAME%"
CALL FDISET.BAT SET $OSVER$ "%OS_VERSION%"
CALL FDISET.BAT SET $OS_NAME$ "%OS_NAME%"
CALL FDISET.BAT SET $OS_VERSION$ "%OS_VERSION%"
CALL FDISET.BAT END %FDRIVE%\$AUTOEXEC$
if errorlevel 1 goto Failed
del %TEMP%\AUTOEXEC.BAT>NUL

:SkipAutoExec
rem set LANG, DOSDIR and etc in FDCONFIG.SYS

set FEXT=086
vinfo /m
if errorlevel 1 set FEXT=186
if errorlevel 2 set FEXT=286
if errorlevel 3 set FEXT=386
if errorlevel 4 set FEXT=486
if errorlevel 5 set FEXT=586
if errorlevel 6 set FEXT=686
if errorlevel 101 set FEXT=DBX
if errorlevel 102 set FEXT=QEM
if errorlevel 103 set FEXT=VBX
if errorlevel 104 set FEXT=VMW
if errorlevel 200 set FEXT=EMU

if not exist %FINSP%\CONFIG.%FEXT% set FEXT=DEF
if not exist %FINSP%\CONFIG.%FEXT% goto SkipFDConfig
CALL FDISET.BAT BEGIN %FINSP%\CONFIG.%FEXT%
CALL FDISET.BAT SET $FLANG$ %LANG%
CALL FDISET.BAT SET $FTARGET$ %DDIR%
CALL FDISET.BAT SET $FDEFMENU$ %DMNU%
CALL FDISET.BAT SET $FDRIVE$ C:
CALL FDISET.BAT END %FDRIVE%\$CONFIG$
if errorlevel 1 goto Failed

:SkipFDConfig
verrlvl 0
set DDIR=

REM Create the installed version ID file.
echo PLATFORM=%OS_NAME%>%FTARGET%\VERSION.FDI
if errorlevel 1 goto Failed
echo VERSION=%OS_VERSION%>>%FTARGET%\VERSION.FDI
if errorlevel 1 goto Failed
grep -i "^RELEASE=" %FINSP%\VERSION.FDI>>%FTARGET%\VERSION.FDI
verrlvl 0

if not "%FVERB%" == "y" goto AfterOption
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% ICONFIGS_FRAME
vgotoxy /k0 sop
vecho /k0 /n /e /t %FLANG% ICONFIGS_DONE
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="Copying configuration files."
call FDIFAIL.BAT cc ERROR_CONFIG
verrlvl 1

:AfterOption
set FEXT=
set DMNU=
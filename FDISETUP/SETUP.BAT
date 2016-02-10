@echo off

REM FreeDOS 1.2+ Installer version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2016 Jerome Shidel.

REM Test for Presence of V8Power Tools ****************************************

REM Check current errorlevel is 255, then test by clearing it.
if errorlevel 255 goto ClearError

REM Check by setting errorlevel to 255.
:CheckPresence
verrlvl 255
if errorlevel 255 goto V8Present

REM V8Power Tools are not present. ********************************************
:V8Missing
echo.
echo V8Power Tools were not found. Please install them or try booting from the
echo installation media and trying again.
goto Done

REM Check by setting errorlevel to 0.
:ClearError
verrlvl 0
if errorlevel 1 goto V8Missing

REM V8Power Tools Found *******************************************************
:V8Present
verrlvl 0
vfdutil /c /p %0
FDSETUP\BIN\vfdutil /c /p %0

REM Reset Environment Variables on startup of USB stick.
vfdutil /d %COMSPEC% | set /p DRV=

set OLDPATH=%PATH%
if "%PATH%" == "\FDSetup\BIN" set OLDPATH=

if "%DOSDIR%" == "\FDSetup" set DOSDIR=%DRV%\FDSetup
if "%PATH%" == "\FDSetup\BIN" set PATH=%DOSDIR%\BIN
if "%AUTOFILE%" == "\AUTOEXEC.BAT" set AUTOFILE=%DRV%%AUTOFILE%
if "%AUTOFILE%" == "\FDAUTO.BAT" set AUTOFILE=%DRV%%AUTOFILE%
if "%CFGFILE%" == "\FDCONFIG.SYS" set CFGFILE=%DRV%%CFGFILE%
set DRV=

REM Temp Directory Test and Auto-configuration ********************************
CALL FDSETUP\SETUP\FDITEMP.BAT /Q
if errorlevel 1 goto NoTemp

:PathSetRepeat
FDSETUP\BIN\COMMAND.COM /E:1024 /C FDSETUP\BIN\vfdutil /p FDSETUP\ |FDSETUP\BIN\vstr /b|set /p TMD=
if "%TMD%" == "" goto PathSetRepeat
set PATH=%TMD%\BIN

:RepeatInfo
LBACACHE.COM INFO|grep "Caching floppy"|vstr /b/l TOTAL|set /p TMD=
if "%TMD%" == "" goto RepeatInfo
if "%TMD%" == "0" LBACACHE.COM buf 20 flop >NUL
set TMD=
goto RunInstaller

REM Run Installer *************************************************************
:RunInstaller
pushd
vfdutil /c /p %0
if not exist FDSETUP\SETUP\FDSETUP.BAT goto Error
if "%1" == "RECOVERY" goto Booted

:Manual
if not exist FDSETUP\BIN\COMMAND.COM goto Error
FDSETUP\BIN\COMMAND.COM /E:2048 /C FDSETUP\SETUP\FDSETUP.BAT %1 %2 %3 %4 %5 %6 %7 %8 %9
goto Afterwards

:Booted
call FDSETUP\SETUP\FDSETUP.BAT %1 %2 %3 %4 %5 %6 %7 %8 %9

:Afterwards
popd
if "%FREBOOT%" == "y" goto DoReboot
if not "%FDRIVE%" == "" %FDRIVE%
cd \
goto Done

REM Should never get here anymore since the reboot process used by vpause
REM will work from a sub shell. But, It doesn't hurt anything. So, I'm just
REM going to leave it in here.
:DoReboot
fdapm warmboot
goto Done

:NoTemp
vecho "Error creating temporary filesystem used for storage during installation."
vecho "Unable to continue."
goto Done

:Error
popd
vecho "Important installer files were not found. Please verify you have a"
vecho "complete version or download a new copy."

REM End of Batch Script *******************************************************
:Done
if not "%OLDPATH%" == "" set PATH=%OLDPATH%
set OLDPATH=
if not "%OLDTEMP%" == "" set TEMP=%OLDTEMP%
set OLDTEMP=

:EndOfBatch
set FDRIVE=
set FTARGET=
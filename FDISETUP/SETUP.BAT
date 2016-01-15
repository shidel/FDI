@echo off

REM FreeDOS 1.2+ Installer version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2016 Jerome Shidel.

rem if "%1" == "RECOVERY" goto RunInstaller
if exist FDSETUP\V8POWER\vfdutil.com goto AdjustPath

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
goto TempTest

:AdjustPath
FDSETUP\V8POWER\vfdutil /c /p %0

set OLDPATH=%PATH%
if "%PATH%" == "A:\FDSetup\BIN;A:\FDSetup\V8Power" set OLDPATH=

REM Temp Directory Test and Auto-configuration ********************************
:TempTest
if not "%TEMP%" == "" goto TempSet
FDSETUP\V8POWER\vinfo /d C:
if errorlevel 1 goto NoDriveC
FDSETUP\V8POWER\vfdutil /u C:\FDOS\TEST????.??? >NUL
if errorlevel 1 goto NoFDOS
if not exist C:\FDOS\TEMP\NUL mkdir C:\FDOS\TEMP
set TEMP=C:\FDOS\TEMP
goto HasTemp

:NoDriveC
goto NoTemp

:NoFDOS
FDSETUP\V8POWER\vfdutil /u C:\FREEDOS\TEST????.??? >NUL
if errorlevel 1 goto NoFREEDOS
if not exist C:\FREEDOS\TEMP\NUL mkdir C:\FREEDOS\TEMP
set TEMP=C:\FREEDOS\TEMP
goto HasTemp

:NoFREEDOS
FDSETUP\V8POWER\vfdutil /u C:\TEST????.??? >NUL
if errorlevel 1 goto NoTEMP
if not exist C:\FDTEMP.$$$\NUL mkdir C:\FDTEMP.$$$
set TEMP=C:\FDTEMP.$$$
goto HasTemp

:TempSet
vfdutil /u %TEMP%\TEST????.??? >NUL
if errorlevel 1 goto NoTEMP
goto HasTemp

:NoTEMP
FDSETUP\V8POWER\vfdutil /u A:\TEST????.??? >NUL
if errorlevel 1 goto V8Missing
if exist A:\FDSETUP\V8POWER\vfdutil.com goto IsFloppy
goto V8Missing

:TempRetry
SET TEMP=
goto TempTest

:IsFloppy
set PATH=A:\FDSETUP\BIN;A:\FDSETUP\V8POWER
goto RunInstaller

:HasTemp
FDSETUP\V8POWER\vinfo /d %TEMP%
if errorlevel 1 goto NoDriveC
FDSETUP\V8POWER\vfdutil /u %TEMP%\TEST????.??? >NUL
if errorlevel 1 goto NoDriveC
FDSETUP\BIN\COMMAND.COM /E:512 /C FDSETUP\V8POWER\vfdutil /p %0 | set /p TMD=
FDSETUP\BIN\COMMAND.COM /E:512 /C FDSETUP\V8POWER\vfdutil /p %TMD%\FDSETUP\ | set /p TMD=
set PATH=%TMD%\BIN;%TMD%\V8POWER
FDSETUP\BIN\COMMAND.COM /E:512 /C LBACACHE.COM INFO|grep -i "Caching floppy"|vstr|set /p TMD=
if "%TMD%" == "" LBACACHE.COM buf 20 flop >NUL
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
vfdutil /u %TEMP%\TEST????.??? >NUL
if errorlevel 1 set TEMP=
vfdutil /c /p %0
popd
if "%FREBOOT%" == "y" goto DoReboot
goto Done

REM Should never get here anymore since the reboot process used by vpause
REM will work from a sub shell. But, It doesn't hurt anything. So, I'm just
REM going to leave it in here.
:DoReboot
fdapm warmboot
goto Done

:Error
vecho "Important installer files were not found. Please verify you have a"
vecho "complete version or download a new copy."

REM End of Batch Script *******************************************************
:Done
if not "%OLDPATH%" == "" set PATH=%OLDPATH%
set OLDPATH=

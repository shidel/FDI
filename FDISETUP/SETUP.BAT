@echo off

REM FreeDOS 1.2+ Installer version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2015 Jerome Shidel.

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

:TempTest
set OLD_PATH=%PATH%
if not "%TEMP%" == "" goto HasTemp
FDSETUP\V8POWER\vfdutil /u C:\FDOS\TEST????.??? >NUL
if errorlevel 1 goto NoFDOS
if not exist C:\FDOS\TEMP\NUL mkdir C:\FDOS\TEMP
set TEMP=C:\FDOS\TEMP
goto HasTemp

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

:NoTEMP
FDSETUP\V8POWER\vfdutil /u A:\TEST????.??? >NUL
if errorlevel 1 goto V8Missing
if exist A:\FDSETUP\V8POWER\vfdutil.com goto IsFloppy
goto V8Missing

:IsFloppy
set PATH=A:\FDSETUP\BIN;A:\FDSETUP\V8POWER
goto RunInstaller

:HasTemp
FDSETUP\V8POWER\vfdutil /u %TEMP%\TEST????.??? >NUL
if errorlevel 1 goto V8Missing
FDSETUP\BIN\COMMAND.COM /E:2048/C FDSETUP\V8POWER\vfdutil /p %0 | set /p TMD=
set PATH=%TMD%\FDSETUP\BIN;%TMD%\FDSETUP\V8POWER
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
FDSETUP\BIN\LBACACHE.COM buf 20 flop >NUL
FDSETUP\BIN\COMMAND.COM /E:2048/C FDSETUP\SETUP\FDSETUP.BAT %1 %2 %3 %4 %5 %6 %7 %8 %9
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

:DoReboot
fdapm warmboot
goto Done

:Error
vecho "Important installer files were not found. Please verify you have a"
vecho "complete version or download a new copy."

REM End of Batch Script *******************************************************
:Done
if not "%OLD_PATH%" == "" set PATH=%OLD_PATH%
set OLD_PATH=
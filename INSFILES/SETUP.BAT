@echo off

REM FreeDOS 1.2+ Installer version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2015 Jerome Shidel.

REM Test for Presence of V8Power Tools ****************************************

REM Check current errorlevel is 255, then test by clearing it.
if errorlevel 255 goto ClearError

REM Check by setting errorlevel to 255.
:CheckPresence
verrlvl 255
if errorlevel 255 goto V8Present

REM V8Power Tools are not present. ********************************************
:V8Missing
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

REM Run Installer *************************************************************
REM Change to directory and path of this batch file.
pushd
vfdutil /c /p %0
if not exist FDSETUP\SETUP\FDSETUP.BAT goto Error
if "%1" == "RECOVERY" goto Booted

:Manual
if not exist FDSETUP\BIN\COMMAND.COM goto Error
FDSETUP\BIN\COMMAND.COM /E:2048/C FDSETUP\SETUP\FDSETUP.BAT %1 %2 %3 %4 %5 %6 %7 %8 %9
goto Afterwards

:Booted
call FDSETUP\SETUP\FDSETUP.BAT %1 %2 %3 %4 %5 %6 %7 %8 %9

:Afterwards
vfdutil /c /p %0
popd
goto Done

:Error
vecho "Important installer files were not found. Please verify you have a"
vecho "complete version or download a new copy."

REM End of Batch Script *******************************************************
:Done

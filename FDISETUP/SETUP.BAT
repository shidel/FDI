@echo off

REM FreeDOS 1.3+ Installer
REM Released Under GPL v2.0 License.
REM Copyright 2016 Jerome Shidel.

BREAK off

if "%1" == "debug" set FDEBUG=y
if "%1" == "RELOAD" goto SkipReload

REM Quick and Simple DOSBox Check *********************************************
if not exist FREEDOS\BIN\VINFO.COM goto CantTestDOSBoxNow
FREEDOS\BIN\VINFO.COM /M
if errorlevel 102 goto CantTestDOSBoxNow
if errorlevel 101 goto SkipDriveChange
:CantTestDOSBoxNow

REM Change to drive of SETUP.BAT -- Probably **********************************
set NOTEST=
if "%1" == "boot" set NOTEST=y
if "%1" == "cdrom" set NOTEST=y
if "%1" == "floppy" set NOTEST=y
if "%1" == "standard" set NOTEST=y
if "%1" == "eltorito" set NOTEST=y
if "%1" == "live" set NOTEST=y
if "%1" == "usb" set NOTEST=y
if "%NOTEST%" == "y" goto SkipDriveChange
for %%d in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do if "%0" == "%%d:SETUP" %%d:
for %%d in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do if "%0" == "%%d:SETUP.BAT" %%d:
for %%d in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do if "%0" == "%%d:\SETUP" %%d:
for %%d in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do if "%0" == "%%d:\SETUP.BAT" %%d:
for %%d in ( a b c d e f g h i j k l m n o p q r s t u v w x y z ) do if "%0" == "%%d:setup" %%d:
for %%d in ( a b c d e f g h i j k l m n o p q r s t u v w x y z ) do if "%0" == "%%d:setup.bat" %%d:
for %%d in ( a b c d e f g h i j k l m n o p q r s t u v w x y z ) do if "%0" == "%%d:\setup" %%d:
for %%d in ( a b c d e f g h i j k l m n o p q r s t u v w x y z ) do if "%0" == "%%d:\setup.bat" %%d:
cd \

:SkipDriveChange
REM Verify we ar on drive with SETUP.BAT **************************************
if "%NOTEST%" == "y" goto DriveCheckPassed
if exist SETUP.BAT goto DriveCheckPassed
if exist FREEDOS\BIN\VFDUTIL.COM goto DriveCheckPassed
goto FailDriveCheck

:DriveCheckPassed
REM Change to drive of SETUP.BAT with V8Power Tools ***************************
FREEDOS\BIN\VFDUTIL.COM /c /p %0
REM Set Drive of Installer ****************************************************
:FDIDrive

if "%1" == "RELOAD" goto SkipFDIDrive
call FREEDOS\SETUP\FDIDRIVE.BAT PRE %0
set FINSD=%RESULT%
set RESULT=
:SkipFDIDrive

REM Set Boot Drive ************************************************************
:BootDrive

if "%1" == "RELOAD" goto SkipBootDrive
call FREEDOS\SETUP\FDIDRIVE.BAT PRE %COMSPEC%
set FBOOTD=%RESULT%
set RESULT=
:SkipBootDrive

REM Relaunch with FreeCOM shell ***********************************************
:ReloadShell

if "%NOTEST%" == "y" goto SkipReload
if not exist FREEDOS\BIN\COMMAND.COM goto MissingFreeCOM
FREEDOS\BIN\COMMAND.COM /E:2048 /C %0 RELOAD %1 %2 %3 %4 %5 %6 %7 %8 %9
if errorlevel 1 goto FailReload
goto Done

:SkipReload

REM Startup super simple environment free space test **************************
REM ensure a 1K (Plus a little) of free space is available in the environment.
REM Should not need this, but here it is anyway.
set _A=0123456789012345
set _A=%_A%%_A%%_A%%_A%%_A%%_A%
set _B=%_A%
if "%_B%" == "" goto FailEnvTest
set _C=%_B%
if "%_C%" == "" goto FailEnvTest
set _D=%_C%
if "%_D%" == "" goto FailEnvTest
set _E=%_D%
if "%_E%" == "" goto FailEnvTest
set _F=%_E%
if "%_F%" == "" goto FailEnvTest
set _G=%_F%
if "%_G%" == "" goto FailEnvTest
set _H=%_G%
if "%_H%" == "" goto FailEnvTest
set _I=%_H%
if "%_I%" == "" goto FailEnvTest
set _J=%_I%
if "%_J%" == "" goto FailEnvTest
set _K=%_J%
if "%_K%" == "" goto FailEnvTest
set _A=
set _B=
set _C=
set _D=
set _E=
set _F=
set _G=
set _H=
set _I=
set _J=
set _K=
goto EnvPassed

:FailEnvTest
set _A=
set _B=
set _C=
set _D=
set _E=
set _F=
set _G=
set _H=
set _I=
set _J=
set _K=
goto FailBadOS

:EnvPassed

REM Adjust Booted environment variables ***************************************
:AdjustEnv

if "%NOTEST%" == "" goto NoAdjustEnv
set PATH=%FBOOTD%%PATH%
set DOSDIR=%FBOOTD%%DOSDIR%
set AUTOFILE=%FBOOTD%%AUTOFILE%
set CFGFILE=%FBOOTD%%CFGFILE%
if exist %DOSDIR%\NLS\NUL set NLSPATH=%DOSDIR%\NLS
if exist %DOSDIR%\HELP\NUL set HELPPATH=%DOSDIR%\HELP

:NoAdjustEnv

REM Help Screen ***************************************************************
if "%2" == "/?" goto ShowHelp
if "%2" == "/h" goto ShowHelp
if "%2" == "/H" goto ShowHelp
if "%2" == "/help" goto ShowHelp
if "%2" == "/HELP" goto ShowHelp
if "%2" == "help" goto ShowHelp
if "%2" == "HELP" goto ShowHelp
goto NoHelpDisplay

:ShowHelp
vecho /p /fLightGreen FreeDOS /fLightCyan 1.2 /s- /fWhite + /fGray " Installer (" /fWhite FDI /fGray ") version 1.00."
vecho Released Under GPL v2.0 License.
vecho Copyright 2016 Jerome Shidel. /p
vecho For advanced mode installation, use: /s- /fDarkGray ' "' /fWhite "SETUP adv" /fDarkGray '"' /fGray /p
goto Done

:NoHelpDisplay

REM Adjust pathspec ***********************************************************
set OLDPATH=%PATH%
set PATH=%FINSD%\FREEDOS\BIN;%FINSD%\FREEDOS\SETUP

REM Create Temporary Temp *****************************************************
call FREEDOS\SETUP\FDITEMP.BAT QUITE

REM Run Installer *************************************************************
if "%1" == "RELOAD" shift
CALL FREEDOS\SETUP\FDSETUP.BAT %1 %2 %3 %4 %5 %6 %7 %8 %9
cd \
if not "%FDRIVE%" == "" %FDRIVE%
cd \

REM Restore Settings **********************************************************
if not "%OLDPATH%" == "" set PATH=%OLDPATH%
if not "%OLDTEMP%" == "" set TEMP=%OLDTEMP%

goto Done

REM Failed to locate this file ************************************************
:FailDriveCheck
echo Unable to locate some files required for the installation. Please change to the
echo drive that contains this installation program and try again.
goto Done

REM Failed to pass tests after shell reload ***********************************
:FailBadOS
echo Unable to run installer under the current operating system and/or its settings.
echo Please boot the installer from one of the media provided for the installer.
goto Done

REM Failed to find FreeCOM shell **********************************************
:MissingFreeCOM
echo Enable to locate FreeCOM shell. Unable to proceed without FreeCOM.
goto Done

REM Failed to perform shell reload ********************************************
:FailReload
echo An error occurred while executing the FreeCOM shell. Please try to run the
echo installer by booting one of the installation media that is available.
goto Done

:Done
set OLDPATH=
set OLDTEMP=
set FDRIVE=
set FTARGET=
set FINSD=
set FBOOTD=
set NOTEST=

REM End of Batch Script *******************************************************
:EndOfBatch

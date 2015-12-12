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

REM V8Power Tools are not present.
:V8Missing
echo V8Power Tools were not found. Please install them or try booting from the
echo installation media and trying again.
goto DontDoAnything

REM Check by setting errorlevel to 0.
:ClearError
verrlvl 0
if errorlevel 1 goto V8Missing

REM V8Power Tools Found *******************************************************
:V8Present
verrlvl 0

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

verrlvl 0
goto EnvTestCleanup

:FailEnvTest
verrlvl 1

:EnvTestCleanup
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

if errorlevel 1 goto NoEnvSpace

REM Test for I/O redirection **************************************************
REM Test if SET /P is available. It does not function under DOSBox, PC-DOS,
REM MS-DOS and under the FreeDOS 4DOS shell. The standard FreeDOS shell and
REM later versions of Windows DOS support it.

set FPIPES=NO
if "%TEMP%" == "" goto NoPipeSupport
echo. | set /p FPIPES=
if "%FPIPES%" == "NO" goto NoPipeSupport
echo y| set /p FPIPES=
if not "%FPIPES%" == "y" goto NoPipeSupport
vcursor | set /p FCURSOR=

:NoPipeSupport
set FPIPES=

REM Configure initial mode ****************************************************
REM Change to directory and path of this batch file.
vfdutil /c /p "%0"

REM Configure commmand-line options
set FADV=
set FRECOVER=

if "%1" == "recovery" set FRECOVER=y
if "%1" == "RECOVERY" set FRECOVER=y
if "%1" == "adv" set FADV=y
if "%1" == "ADV" set FADV=y

REM Run Installer Stages ******************************************************

set FDIDFMT=NO

REM Run configuration stage.
set FSTAGE=000
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Detect if this version is already installed
if not "%FRECOVER%" == "y" goto SkipInstallCheck
set FSTAGE=100
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted
if "%FFOUND%" == "y" goto NoInstallNeeded
verrlvl 0
:SkipInstallCheck

REM Show Logo file if present.
call FDILANG.BAT FDSPLASH FDSETUP
if exist FDSPLASH.BAT call FDSPLASH.BAT
if errorlevel 1 goto Aborted

REM Set Installer theme.
set FSTAGE=200
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Welcome
set FSTAGE=300
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

:DiskTesting
REM Partitoned
set FSTAGE=400
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Formatted
set FSTAGE=500
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Pre install configuration and temp directory setups.
set FSTAGE=600
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Check requirements if testing is present.
call FDILANG.BAT FDCHECK FDSETUP
if exist FDCHECK.BAT call FDCHECK.BAT
if errorlevel 1 goto Aborted

REM Ask the user all of the Questions.
SET HTARGET=%FTARGET%
set FSTAGE=700
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted
if not "%HTARGET%" == "%FTARGET%" goto DiskTesting
SET HTARGET=

REM Do the installation.
set FSTAGE=800
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Post install stuff, like recommend reboot.
set FSTAGE=900
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Run cleanup stage.
set FSTAGE=999
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT

REM Ran all installer stages **************************************************
verrlvl 0
goto Completed

:NoInstallNeeded
REM Run cleanup stage.
set FSTAGE=999
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
call FDILANG.BAT FDNOTICE FDSETUP
if exist FDNOTICE.BAT call FDNOTICE.BAT
verrlvl 0
goto Finished

REM Installer completed successfully ******************************************
:Completed
verrlvl 0
goto Finished

REM Installer failed from missing stage file **********************************
:Error
set FSTAGE=999
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto NoCleanupStage
call STAGE%FSTAGE%.BAT
:NoCleanupStage
vcls /a 0x07
call FDILANG.BAT FDSETUP
vecho /t %FLANG% STAGE_ERROR %FSTAGE%
goto Finished

:NoEnvSpace
vfdutil /c/p %0
set FERROR="Insufficient free environment space."
goto AbortedNoCleanup

REM Installer failed to install or was aborted ********************************
:Aborted
set FSTAGE=999
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
:AbortedNoCleanup
call FDILANG.BAT FDSETUP
vcls /a 0x07
if "%FREBOOT%" == "y" goto DoReboot
if "%OS_NAME%" == "" goto NoOSName
vecho /t %FLANG% ABORTED "%OS_NAME% %OS_VERSION%"
vecho
:NoOSName
if not "%FERROR%" == "" vecho /fWhite "Error: " /fGray /n
if not "%FERROR%" == "" vecho %FERROR%
if not "%FERROR%" == "" vecho
call FDILANG.BAT FDERROR FDSETUP
if exist FDERROR.BAT call FDERROR.BAT
goto Finished

REM Post execution cleanup ****************************************************
:Finished
vfdutil /c /p %0

set FADV=
set FRECOVER=
set FSTAGE=
set FCURSOR=
set FERROR=
set FDEBUG=
set FWAIT=
set FDEL=
set FLANG=

if "%FREBOOT%" == "y" goto DoReboot
if "%FREBOOT%" == "n" goto DoExit
goto DontDoAnything

:DoReboot
vcls /a 0x07
fdapm warmboot
goto DontDoAnything

:DoExit
set FREBOOT=
vcls /a 0x07
call FDILANG.BAT FDTHANK FDSETUP
if exist FDTHANK.BAT call FDTHANK.BAT

REM End of Batch Script *******************************************************
:DontDoAnything

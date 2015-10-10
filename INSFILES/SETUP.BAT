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
echo V8Power Tools were not found. Please install or boot from this media and
echo try again.
goto DontDoAnything

REM Check by setting errorlevel to 0.
:ClearError
verrlvl 0
if errorlevel 1 goto V8Missing

REM V8Power Tools Found *******************************************************
:V8Present
verrlvl 0

REM Startup super simple environment free space test **************************
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

if errorlevel 1 set FERROR="Insufficient free environment space."
if errorlevel 1 goto Aborted

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
if not exist FDSETUP\SETUP\NUL goto Error
cd FDSETUP\SETUP

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
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Detect if this version is already installed
if not "%FRECOVER%" == "y" goto SkipInstallCheck
set FSTAGE=001
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted
if "%FFOUND%" == "y" goto NoInstallNeeded
verrlvl 0
:SkipInstallCheck

REM Show Logo file if present.
if exist FDSPLASH.BAT call FDSPLASH.BAT
if errorlevel 1 goto Aborted

REM Set Installer theme.
set FSTAGE=002
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Welcome
set FSTAGE=003
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Partitoned
set FSTAGE=004
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Formatted
set FSTAGE=005
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Pre install configuration and temp directory setups.
set FSTAGE=006
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Ask the user all of the Questions.
set FSTAGE=007
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Do the installation.
set FSTAGE=008
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Post install stuff, like recommend reboot.
set FSTAGE=009
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Run cleanup stage.
set FSTAGE=999
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT

REM Ran all installer stages **************************************************
verrlvl 0
goto Completed

:NoInstallNeeded
REM Run cleanup stage.
set FSTAGE=999
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
verrlvl 0
goto Finished

REM Installer completed successfully ******************************************
:Completed
verrlvl 0
goto Finished

REM Installer failed from missing stage file **********************************
:Error
set FSTAGE=999
if not exist STAGE%FSTAGE%.BAT goto NoCleanupStage
call STAGE%FSTAGE%.BAT
:NoCleanupStage
vcls /a 0x07
echo Unable to execute installer stage %FSTAGE%. It is possible the installer is
echo corrupt. Please re-download it or try a different method of installation.
goto Finished

REM Installer failed to install or was aborte**********************************
:Aborted
set FSTAGE=999
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
vcls /a 0x07
vecho /fWhite /bRed " Installation of %OS_NAME% %OS_VERSION% has been aborted." /e /fGray
vecho
if not "%FERROR%" == "" vecho /fWhite "Error: " /fGray /n
if not "%FERROR%" == "" vecho %FERROR%
if not "%FERROR%" == "" vecho
if exist FDERROR.BAT call FDERROR.BAT
goto Finished

REM Post execution cleanup ****************************************************
:Finished
cd ..\..

set FADV=
set FRECOVER=
set FSTAGE=
set FCURSOR=
set FERROR=
set FDEBUG=
set FWAIT=

if "%FREBOOT%" == "y" goto DoReboot
if "%FREBOOT%" == "n" goto DoExit
goto DontDoAnything

:DoReboot
vcls /a 0x07
reboot

:DoExit
vcls /a 0x07
if exist FDSETUP\SETUP\FDTHANK.BAT call FDSETUP\SETUP\FDTHANK.BAT
set FREBOOT=

REM End of Batch Script *******************************************************
:DontDoAnything

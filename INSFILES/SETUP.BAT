@echo off

REM FreeDOS Installer.
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

REM Test if SET /P is available. It does not function under DOSBox, PC-DOS,
REM MS-DOS and under the FreeDOS 4DOS shell. The standard FreeDOS shell and
REM later versions of Windows DOS support it.

set FPIPES=NO
if "%TEMP%" == "" goto NoPipeSupport
echo. | set /p FPIPES=
if "%FPIPES%" == "NO" goto NoPipeSupport
echo YES| set /p FPIPES=
if not "%FPIPES%" == "y" goto NoPipeSupport
vcursor | set /p FCURSOR=

:NoPipeSupport
set FPIPES=

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

REM Run configuration stage.
set FSTAGE=000
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

if not "%FRECOVER%" == "y" goto SkipInstallCheck

REM Detect if this version is already installed
set FSTAGE=001
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted
if "%FFOUND%" == "y" goto NoInstallNeeded
verrlvl 0

:SkipInstallCheck

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
if not "%FDEBUG%" == "y" goto NoPause
vgotoxy /g eop sor
vecho /g /a0x70 " Finished, Press a key... " /e /n
vpause /t %FWAIT%
:NoPause
vcls /a 0x07
goto Finished

REM Installer failed **********************************************************
:Error
set FSTAGE=999
if not exist STAGE%FSTAGE%.BAT goto NoCleanupStage
call STAGE%FSTAGE%.BAT
:NoCleanupStage
vcls /a 0x07
echo Unable to execute installer stage %FSTAGE%. It is possible the installer is
echo corrupt. Please re-download it or try a different method of installation.
goto Finished

REM Installer failed or was aborted *******************************************
:Aborted
set FSTAGE=999
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
vcls /a 0x07
vecho /fWhite /bRed " Installation of %OS_NAME% %OS_VERSION% was aborted." /e /fGray
vecho
if not "%FERROR%" == "" vecho %FERROR%
if not "%FERROR%" == "" vecho
goto Finished

REM Post execution cleanup ****************************************************
:Finished
cd ..\..

set FADV=
set FRECOVER=
set FSTAGE=
set FCURSOR=
set FERROR=

REM End of Batch Script *******************************************************
:DontDoAnything

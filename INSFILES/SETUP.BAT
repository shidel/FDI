@echo off

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

REM Change to directory and path of this batch file.
vfdutil /c /p "%0"
if not exist FDSETUP\SETUP\NUL goto Missing
cd FDSETUP\SETUP

REM Configure commmand-line options
set FDI_ADVANCED=
set FDI_RECOVERY=

if "%1" == "recovery" set FDI_RECOVERY=yes
if "%1" == "RECOVERY" set FDI_RECOVERY=yes
if "%1" == "adv" set FDI_ADVANCED=yes
if "%1" == "ADV" set FDI_ADVANCED=yes
if "%1" == "advanced" set FDI_ADVANCED=yes
if "%1" == "ADVANCED" set FDI_ADVANCED=yes

REM Run configuration stage.
set FDI_STAGE=CFG
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

if not "%FDI_RECOVERY%" == "yes" goto SkipInstallCheck
set FDI_STAGE=FDI
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 2 goto Finished
if errorlevel 1 goto Aborted

:SkipInstallCheck

REM Run Stage processor.
set FDI_STAGE=00
if not exist STAGE_%FDI_STAGE%.BAT goto Error
call STAGE_%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

REM Installer completed successfully ******************************************
:Completed
goto Finished

REM Installer failed or was aborted *******************************************
:Error
echo Unable to execute installer stage %FDI_STAGE%. It is possible the installer is
echo corrupt. Please re-download it or try a different method of installation.

REM Installer failed or was aborted *******************************************
:Aborted

REM Post execution cleanup ****************************************************
:Finished
REM Run cleanup stage.
set FDI_STAGE=END
if not exist STAGE%FDI_STAGE%.BAT goto NoCleanupStage
call STAGE%FDI_STAGE%.BAT
cd ..\..
:NoCleanupStage

set FDI_ADVANCED=
set FDI_RECOVERY=
set FDI_STAGE=
vfdutil /c /p "%0"

REM End of Batch Script *******************************************************
:DontDoAnything

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

REM Configure commmand-line options
set FDI_ADVANCED=
set FDI_RECOVERY=

if "%1" == "recovery" set FDI_RECOVERY=yes
if "%1" == "RECOVERY" set FDI_RECOVERY=yes
if "%1" == "adv" set FDI_ADVANCED=yes
if "%1" == "ADV" set FDI_ADVANCED=yes
if "%1" == "advanced" set FDI_ADVANCED=yes
if "%1" == "ADVANCED" set FDI_ADVANCED=yes

REM Change to drive and path of this batch file.

REM Run Installer.

set FDI_STAGE=0
vfdutil /c /p "%0"
if not exist "FDSETUP\SETUP\STAGE_0%FDI_STAGE%.BAT" goto Error
cd  FDSETUP\SETUP
call STAGE_%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

set FDI_STAGE=1
vfdutil /c /p "%0"
if not exist "FDSETUP\SETUP\STAGE_0%FDI_STAGE%.BAT" goto Error
cd  FDSETUP\SETUP
call STAGE_%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

REM Installer completed successfully ******************************************
:Completed
goto Finished

REM Installer failed or was aborted *******************************************
:Error
echo Unable to execute installer stage %FDI_STAGE%. It is possible the installer is
echo corrupt. Please redownload it or try a different method of installation.

REM Installer failed or was aborted *******************************************
:Aborted

REM Post execution cleanup ****************************************************
:Finished
set FDI_ADVANCED=
set FDI_RECOVERY=
set FDI_STAGE=
vfdutil /c /p "%0"

REM End of Batch Script *******************************************************
:DontDoAnything

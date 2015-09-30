@echo off

REM STAGERUN, runs through all stages.

REM Run configuration stage.
set FDI_STAGE=000
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

if not "%FDI_RECOVERY%" == "yes" goto SkipInstallCheck
set FDI_STAGE=001
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted
if "%FDI_EXISTS%" == "yes" goto NoInstallNeeded

verrlvl 0

:SkipInstallCheck

REM Set Installer theme.
set FDI_STAGE=002
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

REM Welcome
set FDI_STAGE=003
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

REM Partitoned
set FDI_STAGE=004
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

REM Formatted
set FDI_STAGE=005
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

REM Pre install configuration and temp directory setups.
set FDI_STAGE=006
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

set FDI_STAGE=007
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

:NoInstallNeeded

REM Run cleanup stage.
set FDI_STAGE=999
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT

verrlvl 0
goto Finished

:Error
set FDI_STAGE=999
if not exist STAGE%FDI_STAGE%.BAT goto NoCleanupStage
call STAGE%FDI_STAGE%.BAT
:NoCleanupStage
echo Unable to execute installer stage %FDI_STAGE%. It is possible the installer is
echo corrupt. Please re-download it or try a different method of installation.
verrlvl 1
goto Finished

REM Installer failed or was aborted *******************************************
:Aborted
set FDI_STAGE=999
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
verrlvl 1

REM Post execution cleanup ****************************************************
:Finished

@echo off

REM STAGE_00, runs through all stages.

set FDI_STAGE=01
if not exist STAGE_%FDI_STAGE%.BAT goto Error
call STAGE_%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

verrlvl 0
goto Finished

:Error
echo Unable to execute installer stage %FDI_STAGE%. It is possible the installer is
echo corrupt. Please re-download it or try a different method of installation.

REM Installer failed or was aborted *******************************************
:Aborted
verrlvl 1

REM Post execution cleanup ****************************************************
:Finished

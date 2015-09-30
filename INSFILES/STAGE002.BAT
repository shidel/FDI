@echo off

REM Basic (NUL) and Advanced (ADV) Theme Loader.

set FDI_THEME=NUL
if "%FDI_ADVANCED%" == "yes" set FDI_THEME=ADV
if not exist THEME%FDI_THEME%.BAT goto Error
call THEME%FDI_THEME%.BAT
if errorlevel 1 goto Aborted

verrlvl 0
goto Finished

REM Installer failed or was aborted *******************************************
:Aborted
verrlvl 1

REM Post execution cleanup ****************************************************
:Finished

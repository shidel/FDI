@echo off

REM Basic (NUL) and Advanced (ADV) Theme Loader.

set FTHEME=NUL
if "%FADV%" == "yes" set FTHEME=ADV
if not exist THEME%FTHEME%.BAT goto Error
call THEME%FTHEME%.BAT
if errorlevel 1 goto Aborted

verrlvl 0
goto Finished

REM Installer failed or was aborted *******************************************
:Aborted
verrlvl 1

REM Post execution cleanup ****************************************************
:Finished

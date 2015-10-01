@echo off

REM Test if current version of FreeDOS is already installed.
REM exit 0, not installed
REM exit 0, if found, but not this version set FFOUND=(version)
REM exit 0, if found, and is this version set FFOUND=yes
REM exit 1, Error

verrlvl 0
goto Finished

REM Installer failed or was aborted *******************************************
:Aborted
verrlvl 1

REM Post execution cleanup ****************************************************
:Finished

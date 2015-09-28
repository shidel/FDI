@echo off

REM STAGEFDI, Test if current version of FreeDOS is already installed.
REM exit 0, not installed
REM exit 1, Error
REM exit 2, it was found.

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

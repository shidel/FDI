@echo off

REM Reserved for testing system compatibility and requirements are met.

REM If requirements are not met, set errorlevel to 1. Also, it may be useful
REM to the user to set the FERROR message and/or include a custom FDERROR.BAT
REM as well.

REM FIRST is run after settings are loaded. But before any installer screens are
REM shown.

REM SECOND is run immediately after hard disk partitioning and formatting.

REM THIRD is run after all user prompts have been answered.

goto %1
goto FAILED

REM At present VirtualBox is not supported when installing from a booted
REM EL Torito CD-ROM.
:FIRST
if not "%FBOOTED%" == "CDROM" goto SUCCESS
vinfo /m
if errorlevel 104 goto SUCCESS
if errorlevel 103 goto FAILED
goto SUCCESS

:SECOND
goto SUCCESS

:THIRD
goto SUCCESS

:SUCCESS
verrlvl 0
goto DONE

:FAILED
verrlvl 1

:DONE
@echo off

REM Test if current version of FreeDOS is already installed.
REM exit 0, not installed
REM exit 0, if found, but not this version set FFOUND=(version)
REM exit 0, if found, and is this version set FFOUND=y
REM exit 1, Error

REM This can use some improvement later on when some additional functionality
REM is added to V8Power Tools. For now, just a dumb yes no file comparison
REM between version ID files will be used.

vinfo /d %FTARGET%
if errorlevel 1 goto NoDOS
fc /L VERSION.FDI %FTARGET%\VERSION.FDI>NUL
if errorlevel 1 goto OtherDOS
goto SameDOS

:NoDOS
:OtherDOS
set FFOUND=
verrlvl 0
goto Finished

:SameDOS
set FFOUND=y
verrlvl 0
goto Finished

REM Installer failed or was aborted *******************************************
:Aborted
verrlvl 1

REM Post execution cleanup ****************************************************
:Finished

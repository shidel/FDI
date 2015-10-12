@echo off

REM Set Package Lists
set OPBIN=%FINSP%\FDBASEB.LST
set OPSRC=
if "%OSRC%" == "y" set OPSRC=%FINSP%\FDBASES.LST
if "%OALL%" == "y" goto AllPackages
goto Done

:AllPackages
set OPBIN=%FINSP%\FDALLB.LST
if "%OSRC%" == "y" set OPSRC=%FINSP%\FDALLS.LST

:Done
verrlvl 0
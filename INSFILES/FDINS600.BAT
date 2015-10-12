@echo off

REM Set Package Lists
set FPBIN=%FINSP%\FDBASEB.LST
set FPSRC=
if "%OSRC%" == "y" set FPSRC=%FINSP%\FDBASES.LST
if "%OALL%" == "y" goto AllPackages
goto Done

:AllPackages
set FPBIN=%FINSP%\FDALLB.LST
if "%OSRC%" == "y" set FPSRC=%FINSP%\FDALLS.LST

:Done
verrlvl 0
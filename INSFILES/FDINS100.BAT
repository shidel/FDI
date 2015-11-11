@echo off

REM Set Package Lists
set FPKGS=%FINSP%\FDBASEB.LST
if "%OALL%" == "y" goto AllPackages
goto Done

:AllPackages
set FPKGS=%FINSP%\FDALLB.LST

:Done
verrlvl 0
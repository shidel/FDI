@echo off

REM Set Package Lists
set FPKGS=%FINSP%\FDBASEB.LST
if "%OALL%" == "y" set FPKGS=%FINSP%\FDALLB.LST

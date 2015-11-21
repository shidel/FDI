@echo off

REM Set Package Lists
set FPKGS=%FINSP%\FDPLBASE.LST
if "%OALL%" == "y" set FPKGS=%FINSP%\FDPLALL.LST

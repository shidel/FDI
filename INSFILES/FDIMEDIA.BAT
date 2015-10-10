@echo off

REM Test detects FreeDOS 1.x install media location.
if "%FMEDIA%" == "" goto Check
goto Done

:Check
REM Test Drive A/B actually exist to prevent single floppy change disk message.
if "%1" == "A" goto CheckDriveExists
if "%1" == "B" goto CheckDriveExists

:CheckFiles
vfdutil /u %1:\FDI?????.$$$ | set /p _E=
if "%_E%" == "" goto Done

if not exist %1:\FREEDOS\PACKAGES\BASE\NUL goto Done
set FMEDIA=%1:\FREEDOS\PACKAGES\BASE
goto Done

:CheckDriveExists
vinfo /d %1
if errorlevel 5 goto Done
goto CheckFiles

:Done
set _E=
verrlvl 0

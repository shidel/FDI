@echo off

REM Test for detecting FreeDOS 1.x install media location.
if "%FMEDIA%" == "" goto Check
goto CheckDone

:Check
REM Test Drive A/B actually exist to prevent single floppy change disk message.
if "%1" == "A" goto CheckDriveExists
if "%1" == "B" goto CheckDriveExists

:CheckFiles
vfdutil /u %1:\FDI?????.$$$ | set /p _CE=
if "%_CE%" == "" goto CheckDone

if not exist %1:\FREEDOS\PACKAGES\BASE\NUL goto CheckDone
set FMEDIA=%1:\FREEDOS\PACKAGES\BASE
goto CheckDone

:CheckDriveExists
vinfo /d %1
if errorlevel 5 goto CheckDone
goto CheckFiles

:CheckDone
set _CE=
verrlvl 0

@echo off

if "%1:\FDSETUP\SETUP" == "%FINSP%" goto Done
if exist %TEMP%\FDISCAN.LST del %TEMP%\FDISCAN.LST

REM Test Drive A/B actually exist to prevent single floppy change disk message.
if "%1" == "A" goto CheckDriveExists
if "%1" == "B" goto CheckDriveExists

:CheckFiles
vfdutil /u %1:\FDI?????.$$$ | set /p _TSFN=
if "%_TSFN%" == "" goto Done

if not exist %1:\FDSETUP\SETUP\NUL goto Done
echo %1:\FDSETUP\SETUP>>%TEMP%\FDIPATHS.LST
goto Done

:CheckDriveExists
vinfo /d %1
if errorlevel 5 goto Done
goto CheckFiles

:Done
set _TSFN=
if exist %TEMP%\FDISCAN.LST del %TEMP%\FDISCAN.LST
verrlvl 0
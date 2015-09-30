@echo off

if "%1:\FDSETUP\SETUP" == "%FDI_INSP%" goto Done
if exist %TEMP%\FDISCAN.LST del %TEMP%\FDISCAN.LST

if "%1" == "A" goto CheckDriveExists
if "%1" == "B" goto CheckDriveExists

:CheckFiles
vfdutil /u %1:\FDI?????.$$$ | set /p FDI_TSFN=
if "%FDI_TSFN%" == "" goto Done

if not exist %1:\FDSETUP\SETUP\NUL goto Done
echo %1:\FDSETUP\SETUP>>%TEMP%\FDIPATHS.LST
goto Done

:CheckDriveExists
vinfo /d %1
if errorlevel 5 goto Done
goto CheckFiles

:Done
set FDI_TSFN=
if exist %TEMP%\FDISCAN.LST del %TEMP%\FDISCAN.LST
verrlvl 0
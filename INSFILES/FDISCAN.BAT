@echo off

if "%1:\FDSETUP\SETUP" == "%FDI_INSP%" goto Done
if exist %TEMP%\FDISCAN.LST del %TEMP%\FDISCAN.LST

if "%1" == "A" goto CheckDriveExists
if "%1" == "B" goto CheckDriveExists

:CheckFiles
vfdutil /u %1:\FDI?????.$$$ | set /p FDI_TSFN=
if "%FDI_TSFN%" == "" goto Done

if not exist %1:\FDSETUP\SETUP\NUL goto Done
echo dir /a /b /p- %1:\FDSETUP\SETUP\FDASK*.BAT
dir /a /b /p- %1:\FDSETUP\SETUP\FDASK*.BAT
dir /a /b /p- %1:\FDSETUP\SETUP\FDASK*.BAT | vstr /l 0 | set /p FDI_TSFN=
echo test for %1:\FDSETUP\SETUP\%FDI_TSFN%
if not exist %1:\FDSETUP\SETUP\%FDI_TSFN% goto Failed
echo passed
echo %1:\FDSETUP\SETUP>>%TEMP%\FDIPATHS.LST
goto Done

:CheckDriveExists
vinfo /d %1
if errorlevel 5 goto Done
goto CheckFiles

:Failed
echo failed

:Done
set FDI_TSFN=
if exist %TEMP%\FDISCAN.LST del %TEMP%\FDISCAN.LST
verrlvl 0
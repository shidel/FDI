@echo off

if "%1:\FDSETUP\SETUP" == "%FDI_INSP%" goto :Done

if "%1" == "A" goto CheckDriveExists
if "%1" == "B" goto CheckDriveExists

:CheckFiles
if not exist %1:\FDSETUP\SETUP\NUL goto Done
dir /a /b /p- %1:\FDSETUP\SETUP\%2*.BAT>%TEMP%\FDSCAN.LST
type %TEMP%\FDSCAN.LST | vstr /l 0 | set /p FDI_TSFN=
if not exist %1:\FDSETUP\SETUP\%FDI_TSFN% goto Done
echo %1:\FDSETUP\SETUP>>%TEMP%\FDIPATHS.LST
goto Done

:CheckDriveExists
vinfo /d %1
if errorlevel 5 goto Done
goto CheckFiles

:Done
set FDI_TSFN=
if exist %TEMP%\FDSCAN.LST del %TEMP%\FDSCAN.LST
verrlvl 0
@echo off

REM Basically, this mini-tool, scans the current directory and then all
REM drives under the \FDSETUP\SETUP directory for matching %1.BAT files.
REM Then adds their paths to %TEMP%\FDIPATHS.LST file.

vprogress 0

set FDI_TSDM=0

vstr /n>%TEMP%\FDIPATHS.LST

CD | set /p FDI_TSFP=

dir /a /b /p- %FDI_TSFP%\%1*.BAT>%TEMP%\FDSCAN.LST

:IncludePath
if "%FDI_TSFP%" == "%FDI_TSMP%" goto NextDrive
type %TEMP%\FDSCAN.LST | vstr /l 0 | set /p FDI_TSFF=
if not exist %FDI_TSFP%\%FDI_TSFF% goto NextDrive
echo %FDI_TSFP%>>%TEMP%\FDIPATHS.LST
if "%FDI_TSMP%" == "" set FDI_TSMP=%FDI_TSFP%

:NextDrive
vmath %FDI_TSDM% + 1 | set /p FDI_TSDM=
vmath %FDI_TSDM% + 0x40 | set /p FDI_TSDL=
vstr /c %FDI_TSDL% | set /p FDI_TSDL=
vmath %FDI_TSDM% * 100 div 27 | set /p FDI_TSDP=
vprogress %FDI_TSDP%

if "%FDI_TSDM%" == "5" goto ScanDone
if "%FDI_TSDL%" == "A" goto CheckDriveExists
if "%FDI_TSDL%" == "B" goto CheckDriveExists

:CheckFiles
if not exist %FDI_TSDL%:\FDSETUP\SETUP\NUL goto NextDrive
vfdutil /p %FDI_TSDL%:\FDSETUP\SETUP\ | set /p FDI_TSFP=
dir /a /b /p- %FDI_TSFP%\%1*.BAT>%TEMP%\FDSCAN.LST
goto IncludePath

:CheckDriveExists
vinfo /d %FDI_TSDL%
if errorlevel 5 goto NextDrive
goto CheckFiles

:ScanDone
if exist %TEMP%\FDSCAN.LST del %TEMP%\FDSCAN.LST

set FDI_TSDM=
set FDI_TSDL=
set FDI_TSFP=
set FDI_TSMP=
set FDI_TSFF=
set FDI_TSDP=

verrlvl 0
@echo off

REM Post installer cleanup.

vfdutil /c /p "%0"
vcursor %FDI_CURSOR%

goto IgnoreTemp

vinfo /dC
if errorlevel 2 goto IgnoreTemp

if "%TEMP%" == "%FDI_TEMP%" set TEMP=C:\
if "%TMP%" == "%FDI_TEMP%" set TMP=C:\
if exist %FDI_TEMP%\NUL DELTREE /y %FDI_TEMP%\*.*>NUL
if exist %FDI_TEMP%\NUL RMDIR %FDI_TEMP%

:IgnoreTemp

rem if "%FDI_DEBUG%" == "yes" goto SkipClear
set FDI_DEBUG=
set FDI_VOLUME=
set FDI_FORMAT=
set FDI_PAUSE=
set FDI_TEMP=
set FDI_DIDFMT=
set FDI_THEME=
set FDI_EXISTS=

REM Clear Theme Variables
set FDI_SFG=
set FDI_SBG=
set FDI_SFC=

set FDI_TFG=
set FDI_TBG=
set FDI_THC=

set FDI_FFG=
set FDI_FBG=
set FDI_FHC=
set FDI_FBS=
set FDI_FCS=

set FDI_CYC=
set FDI_CNC=

set FDI_CFG=
set FDI_CHC=
set FDI_CBG=
set FDI_CBS=
set FDI_CCC=
set FDI_CAC=
set FDI_CCS=

set FDI_PBG=
set FDI_PBC=
set FDI_PCC=

:SkipClear


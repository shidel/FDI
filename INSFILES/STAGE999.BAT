@echo off

REM Post installer cleanup.

vfdutil /c /p "%0"
vcursor %FDI_CURSOR%

vinfo /dC
if errorlevel 2 goto IgnoreTemp

if exist %TEMP%\FDIPATHS.LST del %TEMP%\FDIPATHS.LST>NUL
if exist %FDI_TEMP%\NUL DELTREE /y %FDI_TEMP%\*.*>NUL
if exist %FDI_TEMP%\NUL RMDIR %FDI_TEMP%

:IgnoreTemp
set TEMP=%FDI_TEMPO%
set TMP=%FDI_TMPO%

rem if "%FDI_DEBUG%" == "yes" goto SkipClear
set FDI_DEBUG=
set FDI_VOLUME=
set FDI_FORMAT=
set FDI_PAUSE=
set FDI_TEMP=
set FDI_DIDFMT=
set FDI_THEME=
set FDI_EXISTS=
set FDI_INSP=
set FDI_BAK=
set FDI_SYS=
set FDI_TEMPO=
set FDI_TMPO=

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


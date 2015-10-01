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
set _SFG=
set _SBG=
set _SFC=

set _TFG=
set _TBG=
set _THC=

set _FFG=
set _FBG=
set _FHC=
set _FBS=
set _FCS=

set _CFG=
set _CHC=
set _CBG=
set _CBS=
set _CCC=
set _CAC=
set _CCS=

set _PBG=
set _PBC=
set _PCC=

:SkipClear


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
set TSF=
set TSB=
set TSC=

set TTF=
set TTB=
set TTH=

set TFF=
set TFB=
set TFH=
set TFS=
set TFC=

set TCF=
set TCH=
set TCB=
set TCS=
set TCC=

set TPB=
set TPF=
set TPH=

:SkipClear


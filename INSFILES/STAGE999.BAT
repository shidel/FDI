@echo off

REM Post installer cleanup.
vfdutil /c /p "%0"
if "%FCURSOR%" == "" vcursor small
if not "%FCURSOR%" == "" vcursor %FCURSOR%

vinfo /dC
if errorlevel 2 goto IgnoreTemp

if exist %TEMP%\FDIPATHS.LST del %TEMP%\FDIPATHS.LST>NUL
if exist %FTEMP%\NUL DELTREE /y %FTEMP%\*.*>NUL
if exist %FTEMP%\NUL RMDIR %FTEMP%

:IgnoreTemp
set TEMP=%FTEMPO%
set TMP=%FTMPO%

rem if "%FDEBUG%" == "y" goto SkipClear
set FDEBUG=
set FFMT=
set FWAIT=
set FTEMP=
set FTHEME=

set FDIDFMT=
set FFOUND=
set FINSP=
set FTEMPO=
set FTMPO=
set FCURSOR=

rem clear built-in installer options settings
set OVOL=
set OBAK=
set OSYS=

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

vdelay 2000

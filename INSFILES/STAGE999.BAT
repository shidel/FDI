@echo off

REM Post installer cleanup.
vfdutil /c /p "%0"
if "%FCURSOR%" == "" vcursor small
if not "%FCURSOR%" == "" vcursor %FCURSOR%

vinfo /dC
if errorlevel 2 goto IgnoreTemp

if exist %TEMP%\FDIPATHS.LST del %TEMP%\FDIPATHS.LST>NUL
if exist %TEMP%\FDIBINS.LST del %TEMP%\FDIBINS.LST>NUL
if exist %TEMP%\FDISRCS.LST del %TEMP%\FDISRCS.LST>NUL
if exist %FTEMP%\NUL DELTREE /y %FTEMP%\*.*>NUL
if exist %FTEMP%\NUL RMDIR %FTEMP%

:IgnoreTemp
set TEMP=%FTEMPO%
set TMP=%FTMPO%

rem if "%FDEBUG%" == "y" goto SkipClear
set FFMT=
set FTEMP=
set FTHEME=

set FDIDFMT=
set FFOUND=
set FINSP=
set FTEMPO=
set FTMPO=
set FCURSOR=
set FTARGET=
set FBAK=
set FVERB=
set FSCAN=
set FMEDIA=

rem clear built-in installer options settings
set OVOL=
set OBAK=
set OSYS=
set OCFG=
set OCLEAN=
set OALL=
set OSRC=
set OV8P=
set OPBIN=
set OPSRC=

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
set TFP=

set TCF=
set TCH=
set TCB=
set TCS=
set TCC=

set TPB=
set TPF=
set TPH=

:SkipClear

verrlvl 0

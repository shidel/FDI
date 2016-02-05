@echo off

REM Post installer cleanup.

if "%1" == "VARSONLY" goto VarsOnly
vfdutil /c /p %0
if "%FCURSOR%" == "" vcursor small
if not "%FCURSOR%" == "" vcursor %FCURSOR%

if "%TEMP%" == "" goto IgnoreTemp
vinfo /d %TEMP%
if errorlevel 2 goto IgnoreTemp

if exist %TEMP%\NUL deltree /y %TEMP%\*.*>NUL
:IgnoreTemp

:VarsOnly
rem if "%FDEBUG%" == "y" goto SkipClear
set FTHEME=

set FDIDFMT=
set FFOUND=
set FINSP=
set OLDTMP=
set FCURSOR=
set FTARGET=
set HTARGET=
set FBAK=
set FVERB=
set FMEDIA=
set FEXT=
set FLANG=
if not "%FCLANG%" == "" set LANG=
set FCLANG=
set FPKGS=

rem clear built-in installer options settings
set OVOL=
set OBAK=
set OSYS=
set OCFG=
set OCLEAN=
set OALL=
set OSRC=

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

set TQF=
set TQB=

:SkipClear
verrlvl 0

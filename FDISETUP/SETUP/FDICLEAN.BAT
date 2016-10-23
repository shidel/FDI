@echo off

REM Post installer cleanup.

if "%1" == "VARSONLY" goto VarsOnly
vfdutil /c /p %0

if "%1" == "TEMPONLY" goto KeepCursor
if "%FCURSOR%" == "" vcursor small
if not "%FCURSOR%" == "" vcursor %FCURSOR%
:KeepCursor

if "%FTMP%" == "" goto NoHDTemp
if not exist %FTMP%\NUL goto NoHDTemp
deltree /Y %FTMP%\*.* >NUL
rmdir %FTMP% >NUL
:NoHDTemp

if "%TEMP%" == "" goto IgnoreTemp
vinfo /d %TEMP%
if errorlevel 2 goto IgnoreTemp

if exist %TEMP%\NUL deltree /y %TEMP%\*.*>NUL
:IgnoreTemp

if "%1" == "TEMPONLY" goto SkipClear

:VarsOnly
rem if "%FDEBUG%" == "y" goto SkipClear
set FTHEME=

set FDIDFMT=
set FFOUND=
set FINSP=
set OLDTMP=
set FCURSOR=
set HTARGET=
set FBAK=
set FVERB=
set FMEDIA=
set FPKGS=
set FPSKP=
set FTSET=
set FTMP=
set FKB=

rem clear built-in installer options settings
set OVOL=
set OBAK=
set OSYS=
set OCFG=
set OCLEAN=
set OALL=
set OSRC=
set OBSS=
set OBPN=
set OBPD=

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

set PF=
set PO=

:SkipClear
verrlvl 0

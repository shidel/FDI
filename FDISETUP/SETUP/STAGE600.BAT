@echo off

REM Locate Package Media

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% GATHERING_FRAME
vecho /k0 /n /t %FLANG% GATHERING
vdelay %FDEL%

REM Locate installer packages media.

set PKGDIR=$PACKAGES$

REM Indirect check for packages on current drive
:IndirectPkgSource
set /e _MA=vfdutil /p ..\..\$PACKAGES$\
if "%_MA%" == "" goto IndirectPgkSource
if exist %_MA%\BASE\KERNEL.ZIP goto IndirectFound
:IndirectBaseSource
set /e _MA=vfdutil /p ..\..\
if "%_MA%" == "" goto IndirectBaseSource
if exist %_MA%\BASE\KERNEL.ZIP goto IndirectFound

REM Search all Drives C - Z
for %%d in ( C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do call FDIMEDIA.BAT %%d

if not "%FMEDIA%" == "" goto MediaFound
goto MissingMedia

:IndirectFound
set FMEDIA=%_MA%
goto MediaFound

:MissingMedia
set FERROR="Unable to locate installation packages."
call FDIFAIL.BAT ERROR_MEDIA
goto AbortBatch

:MediaFound
set _MA=

verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done
set PKGDIR=

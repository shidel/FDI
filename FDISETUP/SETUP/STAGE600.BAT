@echo off

REM Locate Package Media

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% GATHERING_FRAME
vecho /n /t %FLANG% GATHERING
vdelay %FDEL%

REM Locate installer packages media.

REM Check if single source install (packages on same media as installer)

REM TEST REPO CD
set _MI=..\..
if not exist %_MI%\BASE\NUL goto NotRepoCD
if not exist %_MI%\BASE\COMMAND.ZIP goto NotRepoCD
if not exist %_MI%\BASE\KERNEL.ZIP goto NotRepoCD

:SingleSource
pushd
cd %_MI% >NUL
:SetLoop
set /e FMEDIA=cd
if "%FMEDIA%" == "" goto SetLoop
popd
goto MediaFound

:NotRepoCD
set PKGDIR=$PKGDIR$

:FindMedia
REM For some reason, DOS sometimes fails to do this correctly on the first try.
echo %FINSD% | vstr /b /f : 1 | set /P _MA=
call FDIMEDIA.BAT %_MA%
set _MA=

set _MI=0
:MediaLoop
if "%_MI%" == "26" goto MissingMedia
vmath %_MI% + 1 | set /p _MT=
if "%_MT%" == "" goto MediaLoop
set _MI=%_MT%

vmath %_MI% + 64 | set /p _MA=
vstr /c %_MA% | set /p _MA=
call FDIMEDIA.BAT %_MA%

if not "%FMEDIA%" == "" goto MediaFound
goto MediaLoop

:MissingMedia
set FERROR="Unable to locate installation packages."
call FDIFAIL.BAT ERROR_MEDIA
goto AbortBatch

:MediaFound
set _MI=
set _MA=
set _MT=

verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done
set PKGDIR=

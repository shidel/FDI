@echo off

REM Configure Variables and stuff.
call FDSETUP\SETUP\STAGE000.BAT VersionOnly

set FLOPPY=A:
set VOLUME=FD-SETUP
set V8PATH=V8Power

echo FreeDOS install creator.
echo.

if not exist %V8PATH%\VERRLVL.COM goto MissingV8
%V8PATH%\verrlvl 0

:FormatDisk
pause Press a key to Format disk in drive %ODRV%
echo.
%V8PATH%\vstr /c13/c78/c13 | format %FLOPPY% /V:%VOLUME% /U
if errorlevel 1 goto Error
rem sys a:
if errorlevel 1 goto Error

goto Done

:MissingV8
echo ERROR: V8Power Tools are missing.
echo.
echo Download the latest version from 'http://up.lod.bz/V8Power'.
echo Then extract them making sure the V8PT binaries are located in the
echo '%V8%' directory. Then run this batch file again.
goto VeryEnd

:Done
%V8PATH%\vecho /p /bBlue /fYellow " Process has completed." /e /fGray /bBlack
%V8PATH%\verrlvl 0
goto VeryEnd

:Error
%V8PATH%\verrlvl 1
%V8PATH%\vecho /p /bRed /fYellow " An error has occurred." /e /fGray /bBlack

:VeryEnd
set OS_NAME=
set OS_VERSION=
set FLOPPY=
set VOLUME=
set V8PATH=
@echo off

if not "%1" == "findcd" goto Start

if not "%CDROM%" == "" goto EndOfFile
vecho /n /fDarkGray .
vfdutil /u %2:\TEMP????.??? >NUL
if errorlevel 1 goto EndOfFile
if not exist %2:\BASE\COMMAND.ZIP goto EndOfFile
if not exist %2:\BASE\KERNEL.ZIP goto EndOfFile
set CDROM=%2:
goto EndOfFile

:Start
pushd
SET OLDFDNPKG.CFG=%FDNPKG.CFG%
SET OLDDOSDIR=%DOSDIR%
SET OLDPATH=%PATH%

if not exist FDISETUP\SETUP\NUL goto BadLayout
if not exist FDIBUILD\FDIBUILD.CFG goto BadLayout
if not exist FDIBUILD\PACKAGES.LST goto BadLayout
if not exist FDISETUP\SETUP\STAGE000.BAT goto BadLayout

REM Configure Variables and stuff.
call FDISETUP\SETUP\STAGE000.BAT VersionOnly

set FLOPPY=A:
set VOLUME=FD-SETUP
set RAMDRV=
set RAMSIZE=1440K
set CDROM=

echo FreeDOS install disk creator.
echo.

if not exist V8POWER\VERRLVL.COM goto MissingV8
V8POWER\verrlvl 0

V8POWER\vfdutil /p %0 | set /p TEMPPATH=
if not exist %TEMPPATH%\V8POWER\VERRLVL.COM goto MissingV8

set PATH=%DOSDIR%\BIN;%TEMPPATH%\V8POWER
vgotoxy up up
vecho /fLightGreen "FreeDOS install disk creator." /p

vecho "Searching for CD-ROM containing packages" /n
for %%d in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do call %0 findcd %%d
if "%CDROM%" == "" goto NoCDROM
vgotoxy sol
vecho "Package media is " /fYellow %CDROM% /fGray /e /p

REM Making Ramdisk.
verrlvl 1
SHSURDRV /QQ /U
if errorlevel 2 goto NotLoaded
if errorlevel 1 goto NoRamDriver
:NotLoaded
SHSURDRV /QQ /D:%RAMSIZE%,A
if errorlevel 27 goto NoRamDrive
if errorlevel  1 set RAMDRV=A:
if errorlevel  2 set RAMDRV=B:
if errorlevel  3 set RAMDRV=C:
if errorlevel  4 set RAMDRV=D:
if errorlevel  5 set RAMDRV=E:
if errorlevel  6 set RAMDRV=F:
if errorlevel  7 set RAMDRV=G:
if errorlevel  8 set RAMDRV=H:
if errorlevel  9 set RAMDRV=I:
if errorlevel 10 set RAMDRV=J:
if errorlevel 11 set RAMDRV=K:
if errorlevel 12 set RAMDRV=L:
if errorlevel 13 set RAMDRV=M:
if errorlevel 14 set RAMDRV=N:
if errorlevel 15 set RAMDRV=O:
if errorlevel 16 set RAMDRV=P:
if errorlevel 17 set RAMDRV=Q:
if errorlevel 18 set RAMDRV=R:
if errorlevel 19 set RAMDRV=S:
if errorlevel 20 set RAMDRV=T:
if errorlevel 21 set RAMDRV=U:
if errorlevel 22 set RAMDRV=V:
if errorlevel 23 set RAMDRV=W:
if errorlevel 24 set RAMDRV=X:
if errorlevel 25 set RAMDRV=Y:
if errorlevel 26 set RAMDRV=Z:
if "%RAMDRV%" == "" goto NoRamDrive

vecho "Ramdrive is " /fYellow %RAMDRV% /fGray /p
mkdir %RAMDRV%\FDSETUP
mkdir %RAMDRV%\FDSETUP\BIN
set DOSDIR=%RAMDRV%\FDSETUP
set FDNPKG.CFG=FDIBUILD.CFG
set PATH=%RAMDRV%\FDSETUP\BIN;%RAMDRV%\FDSETUP\V8POWER;%PATH%

vecho "Copying V8Power Tools to Ramdrive."
xcopy /e V8POWER\*.* %RAMDRV%\FDSETUP\V8POWER\ >NUL
vecho
vfdutil /d %OLDDOSDIR% | vecho "Transferring system files from " /fYellow /i /fGrey " to Ramdrive." /p

:FormatDisk
vecho "Press a key to format the disk in drive " /fYellow %FLOPPY% /fGray "... " /n
vpause /fCyan /t 15 CTRL-C
if errorlevel 100 goto Error
vgotoxy left
vecho /fGray /e /p /p
vstr /c13/c78/c13 | format %FLOPPY% /V:%VOLUME% /U
if errorlevel 1 goto Error
rem sys a:
if errorlevel 1 goto Error
goto Done

:BadLayout
echo ERROR: Cannot locate needed files. Please download the FDI sources
echo again from http://github.com/shidel/FDI.
goto CleanUp

:MissingV8
echo ERROR: V8Power Tools are missing.
echo.
echo Download the latest version from 'http://up.lod.bz/V8Power'.
echo Then extract them making sure the V8PT binaries are located in the
echo '%V8%' directory. Then run this batch file again.
goto CleanUp

:Done
vecho /p /fLightGreen "Process has completed." /e /fGray /bBlack
verrlvl 0
goto CleanUp

:NoCDROM
vgotoxy sol
vecho /fLightRed "Unable to locate package CD-ROM media." /e /fGray
goto Error

:NoRamDriver
vecho /fLightRed "Unable to create Ramdrive." /fGray
goto Error

:NoRamDrive
vecho /fLightRed "Unable to create Ramdrive." /fGray
SHSURDRV /QQ /U
goto Error

:Error
verrlvl 1
vecho /p /bRed /fYellow " An error has occurred." /e /fGray /bBlack

:CleanUp
set OS_NAME=
set OS_VERSION=
set FLOPPY=
set VOLUME=
set RAMDRV=
set RAMSIZE=
set CDROM=
SET FDNPKG.CFG=%OLDFDNPKG.CFG%
SET DOSDIR=%OLDDOSDIR%
SET PATH=%OLDPATH%
SET OLDFDNPKG.CFG=
SET OLDDOSDIR=
SET OLDPATH=
popd

:EndOfFile
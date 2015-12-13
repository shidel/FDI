@echo off

if not "%1" == "findcd" goto Start

if not "%CDROM%" == "" goto EndOfFile
vecho /n /fDarkGray .
vinfo /d %2:\
if errorlevel 15 goto MaybeCD
if errorlevel 5 goto EndOfFile
:MaybeCD
vfdutil /u %2:\TEMP????.??? >NUL
if errorlevel 1 goto EndOfFile
if not exist %2:\BASE\COMMAND.ZIP goto EndOfFile
if not exist %2:\BASE\KERNEL.ZIP goto EndOfFile
set CDROM=%2:
goto EndOfFile

:Start
if "%TEMP%" == "" goto NoTempSet
pushd
SET OLDFDNPKG.CFG=%FDNPKG.CFG%
SET OLDDOSDIR=%DOSDIR%
SET OLDPATH=%PATH%

set FLOPPY=A:
set VOLUME=FD-SETUP
set RAMDRV=
set RAMSIZE=32M
set CDROM=
set KERNEL=KERNL386.SYS
set PACKGO=0
set PACKTRY=3

echo FreeDOS install disk creator.
echo.

if exist V8POWER\VERRLVL.COM goto V8TestSkip
if errorlevel 255 goto ClearError
verrlvl 255
if errorlevel 255 goto V8Found
:ClearError
verrlvl 0
if errorlevel 1 goto V8Missing
:V8Found
vfdutil /c /p %0
:V8TestSkip
if not exist FDISETUP\SETUP\NUL goto BadLayout
if not exist FDIBUILD\FDIBUILD.CFG goto BadLayout
if not exist FDIBUILD\PACKAGES.LST goto BadLayout
if not exist FDISETUP\SETUP\STAGE000.BAT goto BadLayout

REM Configure Variables and stuff.
call FDISETUP\SETUP\STAGE000.BAT VersionOnly

V8POWER\vfdutil /p %0 | set /p TEMPPATH=
if not exist %TEMPPATH%\V8POWER\VERRLVL.COM goto MissingV8

set PATH=%DOSDIR%\BIN;%TEMPPATH%\V8POWER
vgotoxy up up
vecho /fLightGreen "FreeDOS install disk creator." /p

vecho "Searching for CD-ROM containing packages" /n
for %%d in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do call %0 findcd %%d
if "%CDROM%" == "" goto NoCDROM
vgotoxy sol
vecho /e "Package media is" /fYellow %CDROM% /fGray /p

REM Making Ramdisk.
verrlvl 1
SHSURDRV /QQ /U
if errorlevel 2 goto NotLoaded
if errorlevel 1 goto MissingSHSURDRV
:NotLoaded
rem SHSURDRV /QQ /D:%RAMSIZE%,C1K,A
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

vecho Ramdrive is /fYellow %RAMDRV% /fGray /p
mkdir %RAMDRV%\FDSETUP
mkdir %RAMDRV%\FDSETUP\BIN
set DOSDIR=%RAMDRV%\FDSETUP
set FDNPKG.CFG=FDIBUILD\FDIBUILD.CFG

set PATH=%RAMDRV%\FDSETUP\BIN;%RAMDRV%\FDSETUP\V8POWER;%PATH%

vecho /n "Copying V8Power Tools to Ramdrive"
xcopy /y /e V8POWER\*.* %RAMDRV%\FDSETUP\V8POWER\ >NUL
vecho , /fLightGreen OK /fGray /p

if "%1" == "update" goto UpdateOnlyA

vfdutil /d %OLDDOSDIR% | vecho /n Transferring system files from /c32 /fYellow /i /fGrey to Ramdrive
pushd
vfdutil /c /p %OLDDOSDIR%
cd \
sys %RAMDRV% >NUL
if errorlevel 1 goto SysError
popd
vecho , /fLightGreen OK /fGray /p

vecho Installing packages to /fYellow %RAMDRV% /fGray
set PACKIDX=0
:PkgLoop
type FDIBUILD\PACKAGES.LST | vstr /l %PACKIDX% | set /p PACKFILE=
if not "%PACKIDX%" == "0" goto PkgCheck
if "%PACKFILE%" == "" goto PkgLoop
:PkgCheck
if "%PACKFILE%" == "" goto PkgDone
vmath %PACKIDX% + 1 | set /p PACKIDX=
vfdutil /n %PACKFILE% | set /p TEMPFILE=
if exist PACKAGES\%TEMPFILE%.ZIP set OVERRIDE=PACKAGES\%TEMPFILE%.ZIP
set PACKFILE=%CDROM%\%PACKFILE%.zip
if not "%OVERRIDE%" == ""  set PACKFILE=%OVERRIDE%
vecho /n/r4/c32 "%PACKFILE%"
if not "%OVERRIDE%" == "" vecho /s- /n ', ' /fLightRed "OVERRIDE" /fGray
set OVERRIDE=
set TEMPFILE=
verrlvl 250
fdinst install %PACKFILE% >NUL

if errorlevel 250 goto MissingFDINST
if errorlevel 1 goto PkgError
vecho /n ,  /fLightGreen OK /fGray
if exist %DOSDIR%\APPINFO\NUL deltree /Y %DOSDIR%\APPINFO >NUL
if exist %DOSDIR%\PACKAGES\NUL deltree /Y %DOSDIR%\PACKAGES >NUL
if exist %DOSDIR%\DOC\NUL deltree /Y %DOSDIR%\DOC >NUL
if exist %DOSDIR%\HELP\NUL deltree /Y %DOSDIR%\HELP >NUL
if exist %DOSDIR%\NLS\NUL deltree /Y %DOSDIR%\NLS >NUL
vecho ,  /fLightCyan Cleaned /fGray
goto PkgLoop
:PkgError
:ErrorFDINST
vecho /s- ', ' /fLightRed "ERROR" /fGray ', Ignored.'
goto PkgLoop

:PkgDone
set PACKFILE=
set PACKIDX=
vecho /fLightGreen Done /fGray /p

vecho /n "Replacing system files on Ramdrive"
copy %RAMDRV%\FDSETUP\BIN\COMMAND.COM %RAMDRV%\COMMAND.COM >NUL
copy %RAMDRV%\FDSETUP\BIN\%KERNEL% %RAMDRV%\KERNEL.SYS >NUL
vecho ,  /fLightGreen OK /fGray /p

:UpdateOnlyA
vecho /n "Adding installer files to Ramdrive"
xcopy /y FDISETUP\*.* %RAMDRV%\ >NUL
xcopy /y /e LANGUAGE\*.* %RAMDRV%\FDSETUP\SETUP\ >NUL
xcopy /y /e FDISETUP\SETUP\*.* %RAMDRV%\FDSETUP\SETUP\ >NUL
echo PLATFORM=%OS_NAME%>%RAMDRV%\FDSETUP\SETUP\VERSION.FDI
echo VERSION=%OS_VERSION%>>%RAMDRV%\FDSETUP\SETUP\VERSION.FDI
vecho , /fLightGreen OK /fGray /p

if not exist PACKAGES\NUL goto NoPackOverrides
vecho /n "Adding package overrides to Ramdrive"
xcopy /y /E PACKAGES\*.* %RAMDRV%\FDSETUP\SETUP\PACKAGES\ >NUL
vecho ,  /fLightGreen OK /fGray /p
:NoPackOverrides

if not exist BINARIES\NUL goto NoBinOverrides
vecho /s- /n "Adding binary overrides to Ramdrive"
xcopy /e /y BINARIES\*.* %RAMDRV%\FDSETUP\BIN\ >NUL
vecho ,  /fLightGreen OK /fGray /p
:NoBinOverrides

vecho /n "Removing unnecessary files and folders"
if exist %DOSDIR%\SETUP\TEMPLATE\NUL deltree /y %DOSDIR%\SETUP\TEMPLATE >NUL
set PACKIDX=0
:CleanLoop
type FDIBUILD\CLEANUP.LST | vstr /l %PACKIDX% | set /p PACKFILE=
if not "%PACKIDX%" == "0" goto CleanCheck
if "%PACKFILE%" == "" goto CleanLoop
:CleanCheck
if "%PACKFILE%" == "" goto CleanDone
vmath %PACKIDX% + 1 | set /p PACKIDX=
if exist %DOSDIR%\%PACKFILE%\NUL deltree /Y %DOSDIR%\%PACKFILE%\ >NUL
if exist %DOSDIR%\%PACKFILE%\NUL rmdir %DOSDIR%\%PACKFILE% >NUL
if exist %DOSDIR%\%PACKFILE% del %DOSDIR%\%PACKFILE% >NUL
goto CleanLoop
:CleanDone
set PACKFILE=
set PACKIDX=
vecho , /fLightGreen OK /fGray /p

if "%1" == "update" goto UpdateOnlyB
:FormatDisk
vecho Press a key to format the disk in drive /fYellow %FLOPPY% /s- /fGray ... /c32 /n
vpause /fCyan /t 15 CTRL-C
if errorlevel 100 goto Error
vgotoxy left
vecho /fGray /e /p /p
vstr /c13/c78/c13 | format %FLOPPY% /V:%VOLUME% /U
if errorlevel 1 goto Error
pushd
%RAMDRV%
cd \
sys a:
if errorlevel 1 goto SysError
popd
vecho

:UpdateOnlyB
vecho Copying files to floppy disk /fYellow %FLOPPY% /fGray /n
xcopy /y /S %RAMDRV%\FDSETUP %FLOPPY%\FDSETUP\ >NUL
xcopy /y FDISETUP\*.* %FLOPPY%\ >NUL
vecho ,  /fLightGreen OK /fGray
goto Done

:MissingV8
echo ERROR: V8Power Tools are missing.
echo.
echo Download the latest version from 'http://up.lod.bz/V8Power'.
echo Then extract them making sure the V8PT binaries are located in the
echo 'V8POWER' subdirectory. Then run this batch file again.
goto CleanUp

:MissingSHSURDRV
vecho /fLightRed "Unable to create Ramdrive." /fGray
goto Error

:MissingFDINST
vecho /fLightRed "Unable to install packages." /fGray
SHSURDRV /QQ /U
goto Error

:BadLayout
vecho /fLightRed "Cannot locate needed files. Please download the FDI sources again from"
vecho /fLightCyan "http://github.com/shidel/FDI" /fGray .
goto Error

:NoCDROM
vgotoxy sol
vecho /fLightRed "Unable to locate package CD-ROM media." /e /fGray
goto Error

:NoRamDrive
vecho /fLightRed "Unable to create Ramdrive." /fGray
SHSURDRV /QQ /U
goto Error

:ErrorFDINST
vecho ', ' /fLightRed "ERROR" /fGray
goto Error

:SysError
popd

:Error
vecho /p /bRed /fYellow " An error has occurred." /e /fGray /bBlack
verrlvl 1
goto Cleanup

:SkipErrors
vecho /fLightGreen OK /fGray

:SkipReport
vecho /fGray
if exist %RAMDRV%\PACKAGES.LST del %RAMDRV%\PACKAGES.LST
if exist %RAMDRV%\FDINST.LOG del %RAMDRV%\FDINST.LOG
if "%1" == "test2" goto DumpTemp
if "%1" == "testb" goto DumpTemp
verrlvl 0
goto CleanUp

:NoTempSet
if exist C:\FDOS\TEMP\NUL set TEMP=C:\FDOS\TEMP
if exist C:\FREEDOS\TEMP\NUL set TEMP=C:\FREEDOS\TEMP
if exist C:\TEMP\NUL set TEMP=C:\TEMP
if not "%TEMP%" == "" goto Start
echo TEMP directory not configured.
goto CleanUp


:DumpTemp
deltree -y %RAMDRV%\*.*
rmdir %RAMDRV%
verrlvl 0
goto CleanUp

:Done
vecho /p /fLightGreen Creation complete. /e /fGray /bBlack
verrlvl 0
goto CleanUp

:CleanUp
set OS_NAME=
set OS_VERSION=
set FLOPPY=
set VOLUME=
set RAMDRV=
set RAMSIZE=
set CDROM=
set KERNEL=
set PACKFILE=
set PACKNAME=
set PACKIDX=
set PACKCNT=
set PACKPER=
set PACKERR=
set PACKRETRY=
set PACKGO=
set PACKTRY=
set ELOG=

SET FDNPKG.CFG=%OLDFDNPKG.CFG%
SET DOSDIR=%OLDDOSDIR%
SET PATH=%OLDPATH%
SET OLDFDNPKG.CFG=
SET OLDDOSDIR=
SET OLDPATH=
set TEMPPATH=
popd

:EndOfFile
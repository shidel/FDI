@echo off

REM FreeDOS 1.2+ FDI development installation untility version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2016 Jerome Shidel.

if "%TEMP%" == "" goto Error

if not exist %0 goto BadSelf

set SRC=
set DRV=D:
set /e SRC=vfdutil /d %COMSPEC%
if "%SRC%" == "" goto ERROR
if not "%SRC%" == "C:" set DRV=C:

set OLD.TEMP=%TEMP%
set OLD.DOSDIR=%DOSDIR%
set OLD.FDNPKG=%FDNPKG.CFG%
set OLD.PATH=%PATH%

vcls /g
vgotoxy /y10
vecho /n /fLightRed WARNING: /fGray This batch file will transform your
vecho /n /c32 hard drive /fWhite %DRV% /fGray into a FDI based /p FreeDOS build
vecho /n /c32 environemnt. This will /fLightRed destroy /fGray any
vecho /n /c32 pre-existing programs or data /p that are currently on you drive
vecho /n /c32 /fWhite %DRV% /fGray /s- . /s+ If this is not what you desire,
vecho /n /c32 stop now!. /p /p Press /fWhite CTRL+C /fGray to abort... /c32
vpause /fLightRed /d 30 CTRL+C
if errorlevel 200 goto AbortC
vgotoxy sor
vecho /fGray /e /n Type "'yes'" to continue? /c32
set /e ASK=vask /bBlue /fWhite /d 10 /C
if errorlevel 200 goto AbortC
vgotoxy sor
vecho /bBlack /fGray /e /n Type "'yes'" to continue? /fWhite %ASK% /fGray /p /p
if "%ASK%" == "yes" goto MakeEnv
goto AbortC

:BadSelf
pushd
vfdutil /c/d %COMSPEC%
cd \FDSetup\BIN
call FDIDEV.BAT
popd
goto Done

:MakeEnv
REM Format Drive **************************************************************
vecho /n /fLightGreen Creating FDI build environment on drive /fWhite %DRV%
vecho /fGray /s- . /p
vdelay 1000
vecho Formatting drive /fWhite %DRV% /fGray /s- .
format %DRV% /V:FDIDEVEL /Q /U /S /Z:seriously
if errorlevel 1 goto Error
if "%DRV%" == "C:" fdisk /MBR 1 >NUL
if "%DRV%" == "C:" fdisk /ACTIVATE:1 1 >NUL
if "%DRV%" == "D:" fdisk /MBR 2 >NUL
if "%DRV%" == "D:" fdisk /ACTIVATE:1 2 >NUL
vdelay 500
vecho

REM Setup Install Environment *************************************************
vecho /n /fGray Preparing environment for installation
vdelay 1000

set PKG=
set INF=
if not exist %SRC%\FDSETUP\SETUP\FDNPBIN.CFG goto Error
if exist %SRC%\FDSETUP\PACKAGES\BASE\COMMAND.ZIP set PKG=%SRC%\FDSETUP\PACKAGES
if exist %SRC%\FDSETUP\PKGINFO\COMMAND.TXT set INF=%SRC%\FDSETUP\PKGINFO
if exist %SRC%\PACKAGES\BASE\COMMAND.ZIP set PKG=%SRC%
if exist %SRC%\PKGINFO\COMMAND.TXT set INF=%SRC%\PKGINFO
if "%PKG%" == "" goto Error
mkdir %DRV%\TEMP >NUL
if errorlevel 1 goto Error
set TEMP=%DRV%\TEMP
mkdir %DRV%\FREEDOS >NUL
if errorlevel 1 goto Error
set DOSDIR=%DRV%\FREEDOS
mkdir %DOSDIR%\BIN >NUL
if errorlevel 1 goto Error
type %SRC%\FDSETUP\SETUP\FDNPBIN.CFG|vstr /s %%FDRIVE%% %DRV%>%TEMP%\FDNPKG.CFG
if not exist %TEMP%\FDNPKG.CFG goto Error
set FDNPKG.CFG=%TEMP%\FDNPKG.CFG
vecho /s- , /s+ /fLightGreen OK /fGray /s- .
vdelay 500
vecho

REM Install Packages **********************************************************
vecho /n /fGray Installing packages for Build environemnt
goto SkipList

; Note: This list will be replace automatically with SETTINGS\PKG_FDI.LST
; on build by mkFDI.bat

base\command
base\kernel
base\deltree
base\xcopy
base\devload
base\attrib
base\shsucdx
util\shsufdrv
base\fdisk
base\fdapm
base\format
base\fc

util\v8power
util\fdimples

base\lbacache
util\grep
util\fdnpkg
archiver\zip

base\himemx
base\jemm
base\edit
base\mem
base\more
util\doslfn

util\udvd2

:SkipList
grep -A 1000 -i "goto SkipList" %0|grep -B 1000 -i "^:SkipList"|grep -iv "SkipList">%TEMP%\PKG.LST

:GetCount
grep -iv "^;" %TEMP%\PKG.LST | vstr /b/l total | set /p COUNT=
if "%COUNT%" == "" goto GetCount

set /e TEST=vmath %COUNT% + 1
vecho /s- , /s+ /fWhite %TEST% /fGray total. /p

set INDEX=0
:PackageLoop
if "%INDEX%" == "%COUNT%" goto PackageDone

:GetName
grep -iv "^;" %TEMP%\PKG.LST | vstr /b/l %INDEX% | set /p NAME=
if "%NAME%" == "" goto GetName
vecho /n /r5/c32 %NAME%
if not exist %PKG%\%NAME%.zip goto PackageMissing
fdinst install %PKG%\%NAME%.zip >NUL
if errorlevel 1 goto PackageError
set /e NAME=vfdutil /n %NAME%
type %DOSDIR%\PACKAGES\%NAME%.LST | vstr /s %DRV%\ C:\>%TEMP%\PACKAGE.LST
copy /y %TEMP%\PACKAGE.LST %DOSDIR%\PACKAGES\%NAME%.LST>NUL
del %TEMP%\PACKAGE.LST>NUL
vecho , /fLightGreen OK /fGray /s- .

:IndexInc
set /e TEST=vmath %INDEX% + 1
if "%TEST%" == "" goto IndexInc
set INDEX=%TEST%
set TEST=
goto PackageLoop

:PackageMissing
vecho /n , /fLightRed Missing /fGray /s- .
goto Error

:PackageError
vecho /n , /fLightRed Failed /fGray /s- .
goto Error

:PackageDone
type %SRC%\FDSETUP\SETUP\FDNPSRC.CFG|vstr /s %%FDRIVE%% %DRV%>%TEMP%\FDNPKG.CFG
if not exist %TEMP%\FDNPKG.CFG goto Error
set NAME=util\fdisrc
vecho /n /r5/c32 %NAME%
if not exist %PKG%\%NAME%.zip goto PackageMissing
fdinst install %PKG%\%NAME%.zip >NUL
if errorlevel 1 goto PackageError
vecho , /fLightGreen OK /fGray /s- .

vecho /p Packages, /s+ /fLightGreen OK /fGray /s- .
vdelay 500
vecho

REM Transfer Packages ********************************************************
vecho /n Transfering all packages to /fWhite %DRV% /fGray
xcopy /y /E %PKG%\*.* %DRV% >NUL
if not exist %DRV%\BASE\COMMAND.ZIP goto Error

vecho , /fLightGreen OK /fGray /s- .
vdelay 500
vecho

REM Transfer Packages Information *********************************************
if not exist %INF%\COMMAND.TXT goto NoInformation
vecho /n Transfering package information files to /fWhite %DRV% /fGray
if not exist %DRV%\PKGINFO\NUL mkdir %DRV%\PKGINFO
if not exist %DRV%\PKGINFO\NUL goto Error
xcopy /y /E %INF%\*.* %DRV%\PKGINFO\ >NUL
if not exist %DRV%\PKGINFO\COMMAND.TXT goto Error
vecho , /fLightGreen OK /fGray /s- .
vdelay 500
vecho
:NoInformation

REM Copy FDI Sources to root *************************************************
vecho /n Copying FDI Sources to %DRV%\FDI directory
mkdir %DRV%\FDI >NUL
xcopy /y /E %DOSDIR%\SOURCE\FDISRC\*.* %DRV%\FDI\>NUL
vecho , /fLightGreen OK /fGray /s- .
vdelay 500
vecho

REM Add V8Power to FDI Source *************************************************
vecho /n Adding V8Power Tools to FDI Sources
if not exist %PKG%\UTIL\V8POWER.ZIP goto Error
set DOSDIR=%TEMP%
fdinst install %PKG%\UTIL\V8POWER.ZIP >NUL
if errorlevel 1 goto Error
set DOSDIR=%DRV%\FREEDOS
copy /y %TEMP%\BIN\*.* %DRV%\FDI\V8POWER >NUL
vecho , /fLightGreen OK /fGray /s- .
vdelay 500
vecho

REM Create system config ******************************************************
vecho /n Creating system configuration for build environment
type %DRV%\FDI\FDISETUP\FDCONFIG.SYS|vstr /n/s \FDSetup C:\FreeDOS>%TEMP%\FDCONFIG.SYS
type %TEMP%\FDCONFIG.SYS |vstr /n/s "/P=\" "/P=C:\">%DRV%\FDCONFIG.SYS
type %DRV%\FDI\FDISETUP\AUTOEXEC.BAT|vstr /n/s '\FDSetup' "C:\FreeDOS">%TEMP%\AUTO.BAT
type %TEMP%\AUTO.BAT|vstr /n/s $LBA$ REM|vstr /n/s "$LH$ " "">%TEMP%\EXEC.BAT
type %TEMP%\EXEC.BAT|vstr /s "%%OS_NAME%%" "%OS_NAME%"|vstr /s "%%OS_VERSION%%" "%OS_VERSION%">%TEMP%\AUTO.BAT
type %TEMP%\AUTO.BAT|vstr /b/l 0>%DRV%\AUTOEXEC.BAT
echo SET TEMP=C:\TEMP>>%DRV%\AUTOEXEC.BAT
echo SET TMP=C:\TEMP>>%DRV%\AUTOEXEC.BAT
echo SET TZ=UTC>>%DRV%\AUTOEXEC.BAT
echo SET LANG=EN>>%DRV%\AUTOEXEC.BAT
type %TEMP%\AUTO.BAT|vstr /b/l 1:1000|grep -iv "^SET LANG=\|^rem">>%DRV%\AUTOEXEC.BAT
echo vecho /fLightCyan FreeDOS Installer /fGray build environment. /p>>%DRV%\AUTOEXEC.BAT
echo @echo off>%DRV%\mkFDI.bat
echo.>>%DRV%\mkFDI.bat
echo set TEMP=C:\TEMP>>%DRV%\mkFDI.bat
vstr /p "deltree /y %%TEMP%%\ >NUL">>%DRV%\mkFDI.bat
echo pushd>>%DRV%\mkFDI.bat
echo C:>>%DRV%\mkFDI.bat
echo cd \FDI>>%DRV%\mkFDI.bat
echo call C:\fdi\mkfdi.bat %%1 %%2 %%3 %%4 %%5 %%6 %%7 %%8 %%9>>%DRV%\mkFDI.bat
echo popd>>%DRV%\mkFDI.bat

type %SRC%\FDSETUP\SETUP\FDNPBIN.CFG|vstr /s "%%FDRIVE%%" "C:">%DOSDIR%\FDNPKG.CFG

vecho , /fLightGreen OK /fGray /s- .
vdelay 500
vecho

deltree /y %TEMP%\*.* >NUL

vecho /fLightGreen Drive /fWhite %DRV% /fLightGreen has been setup for /n
vecho /fWhite /c32 FDI /fLightGreen development. /fGray
vecho /p /n Please shutdown now.
vpause /fLightRed /d 30 CTRL+C
if errorlevel 200 goto Restore
vecho /fGray /bBlack /p/p
shutdown
goto Done
:Error
vecho /bBlack /fGray /p /p
vecho /bRed /fWhite /e ERROR: Aborted. /BBlack /fGray /p
goto Restore

:AbortC
vgotoxy sor
vecho /bBlack /fGray /e /fYellow Aborted. /fGray /p

:Restore
set TEMP=%OLD.TEMP%
set DOSDIR=%OLD.DOSDIR%
set FDNPKG.CFG=%OLD.FDNPKG%
set PATH=%OLD.PATH%

:Done
set SRC=
set DRV=
set ASK=
set PKG=
set INF=
set COUNT=
set INDEX=
set NAME=
set OLD.TEMP=
set OLD.DOSDIR=
set OLD.FDNPKG=
set OLD.PATH=

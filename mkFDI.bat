@echo off

if "%1" == "all" goto BuildAll
if not "%1" == "findcd" goto Start

if not "%CDROM%" == "" goto EndOfFile
vecho /n /fDarkGray .
vinfo /d %2:\
if errorlevel 15 goto MaybeCD
if errorlevel 5 goto EndOfFile
:MaybeCD
vfdutil /u %2:\TEMP????.??? >NUL
if errorlevel 1 goto EndOfFile
rem if not exist %2:\BOOT.IMG goto EndOfFile
rem if not exist %2:\BOOT.CAT goto EndOfFile
if not exist %2:\BASE\COMMAND.ZIP goto EndOfFile
if not exist %2:\BASE\KERNEL.ZIP goto EndOfFile
if not exist %2:\BASE\INDEX.LST goto EndOfFile
set CDROM=%2:
goto EndOfFile

:BuildAll
if "%2" == "off" set ALLOFF=y
rem call %0 info

call %0
call %0 cdrom B:
call %0 slim D:
call %0 usb E:

if "%ALLOFF%" == "y" shutdown

goto EndOfFile

:Start
set SELF=%0
SET OLDFDN=%FDNPKG.CFG%
SET OLDDOS=%DOSDIR%
SET OLDPATH=%PATH%
SET OSN=%OS_NAME%
SET OSV=%OS_VERSION%

set USB=
set ELT=
set SLIM=
set KERNEL=
set PKGDIR=
set FLOPPY=A:
set VOLUME=FD-SETUP
set RAMDRV=
set RAMSIZE=32M
set CDROM=
set TGO=0
set TTRY=3
set /e IDIR=vfdutil /d %TEMP%
set IDIR=%IDIR%\PKGINFO

if "%TZ%" == "" set TZ=EST

:ReadSettings
if "%1" == "" goto ReadDone

if "%1" == "help" goto Help
if "%1" == "cdrom" set ELT=y
if "%1" == "usb" set USB=y
if "%1" == "slim" set SLIM=y
if "%1" == "info" set INFO=y
if "%INFO%" == "y" goto InfoOnly

vfdutil /u %1\????????.??? >nul
if not errorlevel 1 set /e FLOPPY=vfdutil /d %1\test

shift
goto ReadSettings

:InfoOnly
shift
if not "%1" == "" set INFOPKG=%1
goto ReadSettings

:Help
pushd
echo FreeDOS Installer (FDI) Install Media Creator Utility
echo usage: mkfdi.bat [options]
echo.
echo [No Option]     Create Install Floppy on Drive A:
echo cdrom           Create CDROM Floppy on Drive A:
echo info  [package] Create all info files or specific package file.
echo slim  [drive]   Create Lite USB stick image on [drive]
echo usb   [drive]   Create Full USB stick image on [drive]
echo.
echo all  [off]      Build most FDI versions Floppy, cdrom B:, slim D: and usb E:
echo                 If off, then automatically power down afterwards.
echo.
goto CleanUp

:ReadDone


if "%SLIM%" == "y" set USB=y

if "%TEMP%" == "" goto NoTempSet
deltree /y %TEMP%\*.* >NUL
pushd

echo FreeDOS install disk creator.
echo.

:V8Retry

if exist V8POWER\VERRLVL.COM goto V8TestSkip
if errorlevel 255 goto ClearError
verrlvl 255
if errorlevel 255 goto V8Found
:ClearError
verrlvl 0
if errorlevel 1 goto MissingV8
:V8Found
goto CheckFiles
:V8TestSkip
:CheckFiles
vfdutil /c /p %SELF%
if not exist FDISETUP\SETUP\NUL goto BadLayout
if not exist SETTINGS\BUILD.CFG goto BadLayout
if not exist SETTINGS\PKG_FDI.LST goto BadLayout
if not exist FDISETUP\SETUP\STAGE000.BAT goto BadLayout
REM Configure Variables and stuff.
:TempLoop
cd | set /p TEMPPATH=
if "%TEMPPATH%" == "" goto TempLoop
V8POWER\vfdutil /p %TEMPPATH%\ | set /p TEMPPATH=
if "%TEMPPATH%" == "" goto TempLoop
if not exist %TEMPPATH%\V8POWER\VERRLVL.COM goto MissingV8
set TTRY=
call FDISETUP\SETUP\STAGE000.BAT VersionOnly
:RepeatNAME
type SETTINGS\VERSION.CFG|grep -iv ^;|grep -i ^PLATFORM|vstr /b/f = 2|set /p OS_NAME=
if "%OS_NAME%" == "" goto RepeatNAME
:RepeatVER
type SETTINGS\VERSION.CFG|grep -iv ^;|grep -i ^VERSION|vstr /b/f = 2|set /p OS_VERSION=
if "%OS_VERSION%" == "" goto RepeatVER
:RepeatID
type SETTINGS\VERSION.CFG|grep -iv ^;|grep -i ^VOLUME|vstr /b/f = 2|set /p VOLUMEID=
if "%VOLUMEID%" == "" goto RepeatID
:RepeatURL
type SETTINGS\VERSION.CFG|grep -iv ^;|grep -i ^URL|vstr /b/f = 2|set /p OS_URL=
if "%OS_URL%" == "" goto RepeatURL
:RepeatDIR
type SETTINGS\VERSION.CFG|grep -iv ^;|grep -i ^PKGDIR|vstr /b/f = 2|set /p PKGDIR=
if "%PKGDIR%" == "" goto RepeatDIR
:RepeatKERN
type SETTINGS\VERSION.CFG|grep -iv ^;|grep -i ^KERNEL|vstr /b/f = 2|set /p KERNEL=
if "%KERNEL%" == "" goto RepeatKERN

set PATH=%TEMPPATH%\V8POWER;%DOSDIR%\BIN
set TEMPPATH=

vgotoxy up up
vecho /fLightGreen "%OS_NAME% %OS_VERSION% install disk creator." /p

:NOWLoop
date /d | vstr /n/f ' ' 5- | set /p TNOW=
if "%TNOW%" == "" goto NOWLoop

if "%ELT%" == "y" vecho /fLightRed El Torito Floppy creation image mode! /fGray /p

if not "%USB%" == "y" goto NotHDImage
if "%SLIM%" == ""  vecho /fLightRed Full USB Stick creation mode! /fGray /p
if "%SLIM%" == "y" vecho /fLightRed Ultra-Slim USB Stick creation mode! /fGray /p

if "%FLOPPY%" == "A:" set FLOPPY=C:

REM Set Floppy
:SetFloppy
echo SETP | set /p SETP=
if "%SETP%" == "" goto SetFloppy
set SETP=
vecho /fYellow /bBlack /n Set Destination for installation media? /c32
if "%ALLOFF%" == "y" goto NoAsk
vask /c /fWhite /bBlue /d10 %FLOPPY% | set /p FLOPPY=
if errorlevel 200 goto CtrlCPressed
:NoAsk
vgotoxy sor
if "%FLOPPY%" == "" goto SetFloppy
vfdutil /d %FLOPPY% | set /p FLOPPY=
if errorlevel 1 goto SetDOSDIR
if "%FLOPPY%" == "" goto SetFloppy
vecho /fYellow /bBlack /n Set Destination for installation media? /c32
vecho /fWhite /bBlack /e %FLOPPY% /fGray /p

vfdutil /d %TEMP% | set /p TDIR=
if not "%TDIR%" == "%FLOPPY%" goto TempDirOK

pushd
vecho /fLightRed Temp directory cannot be on target filesystem. /fGray
goto Error

:TempDirOK

:NotHDImage
set FNUM=
rem if "%FLOPPY%" == "A:" set FNUM=0
rem if "%FLOPPY%" == "B:" set FNUM=0
if "%FLOPPY%" == "C:" set FNUM=1
if "%FLOPPY%" == "D:" set FNUM=2
if "%FLOPPY%" == "E:" set FNUM=3
if "%FLOPPY%" == "F:" set FNUM=4
if "%FLOPPY%" == "G:" set FNUM=5
if "%FLOPPY%" == "H:" set FNUM=6
if "%FLOPPY%" == "I:" set FNUM=7
if "%FLOPPY%" == "J:" set FNUM=8

set TDIR=

vecho "Searching for CD-ROM containing packages" /n
for %%d in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do call %SELF% findcd %%d
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

if not exist %TEMP%\NUL goto BadTemp
vfdutil /d %TEMP% | set /p TDRV=
if "%TDRV%" == "%RAMDRV%" goto BadTemp
set TDRV=

if "%INFO%" == "y" goto MakeInfo
if not "%USB%" == "y" goto NotUSB
if exist %IDIR%\COMMAND.TXT goto NotUSB
pushd
vecho Error, missing package information files. Run "'mkfdi info'"
goto CleanUp
:NotUSB

mkdir %RAMDRV%\FDSETUP
mkdir %RAMDRV%\FDSETUP\BIN
set DOSDIR=%RAMDRV%\FDSETUP
set FDNPKG.CFG=SETTINGS\BUILD.CFG

set PATH=%RAMDRV%\FDSETUP\BIN;%RAMDRV%\FDSETUP\V8POWER;%PATH%

vfdutil /d %OLDDOS% | vecho /n Transferring system files from /c32 /fYellow /i /fGrey to Ramdrive
pushd
vfdutil /c /p %OLDDOS%
cd \
sys %RAMDRV% >NUL
if errorlevel 1 goto SysError
popd
vecho , /fLightGreen OK /fGray /p

vecho Installing packages to /fYellow %RAMDRV% /fGray
set TIDX=0
:PkgLoop
type SETTINGS\PKG_FDI.LST | grep -iv ^; | vstr /b/l %TIDX% | set /p TFILE=
if not "%TIDX%" == "0" goto PkgCheck
if "%TFILE%" == "" goto PkgLoop
:PkgCheck
if "%TFILE%" == "" goto PkgDone
vmath %TIDX% + 1 | set /p TIDX=
vfdutil /n %TFILE% | set /p TEMPFILE=
if exist %CDROM%\%TFILE%.zip goto NotExtra
if exist %CDROM%\EXTRAS\%TEMPFILE%.zip set TFILE=EXTRAS\%TEMPFILE%
:NotExtra
if exist PACKAGES\%TEMPFILE%.ZIP set OVERRIDE=PACKAGES\%TEMPFILE%.ZIP
set TFILE=%CDROM%\%TFILE%.zip
if not "%OVERRIDE%" == ""  set TFILE=%OVERRIDE%
vecho /n/r4/c32 "%TFILE%"
if not "%OVERRIDE%" == "" vecho /s- /n ', ' /fLightRed "OVERRIDE" /fGray
set OVERRIDE=
set TEMPFILE=
verrlvl 250
fdinst install %TFILE% >NUL

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
set TFILE=
set TIDX=
vecho Packages /fLightGreen Done /fGray /s- . /p

vecho /n "Replacing system files on Ramdrive"
copy %RAMDRV%\FDSETUP\BIN\COMMAND.COM %RAMDRV%\COMMAND.COM >NUL
copy %RAMDRV%\FDSETUP\BIN\%KERNEL% %RAMDRV%\KERNEL.SYS >NUL
vecho ,  /fLightGreen OK /fGray /p

vecho /n "Adding installer files to Ramdrive"
xcopy /y FDISETUP\*.* %RAMDRV%\ >NUL

type %RAMDRV%\AUTOEXEC.BAT | vstr /n /s '$LH$ ' '' >%RAMDRV%\AUTOEXEC.TMP
copy /y %RAMDRV%\AUTOEXEC.TMP %RAMDRV%\AUTOEXEC.BAT >NUL
del %RAMDRV%\AUTOEXEC.TMP >NUL

set FBOOT=BOOT
if "%ELT%" == "y" set FBOOT=CDROM

type %RAMDRV%\AUTOEXEC.BAT | vstr /n /s '$BOOT$' %FBOOT% >%RAMDRV%\AUTOEXEC.TMP
copy /y %RAMDRV%\AUTOEXEC.TMP %RAMDRV%\AUTOEXEC.BAT >NUL
del %RAMDRV%\AUTOEXEC.TMP >NUL

if "%USB%" == "y" goto USBAuto
if "%ELT%" == "y" goto USBAuto
type %RAMDRV%\AUTOEXEC.BAT | vstr /n /s '$LBA$ ' '' >%RAMDRV%\AUTOEXEC.TMP
copy /y %RAMDRV%\AUTOEXEC.TMP %RAMDRV%\AUTOEXEC.BAT >NUL
del %RAMDRV%\AUTOEXEC.TMP >NUL
goto USBAutoDone
:USBAuto
type %RAMDRV%\AUTOEXEC.BAT | vstr /n /s '$LBA$ ' 'rem ' >%RAMDRV%\AUTOEXEC.TMP
copy /y %RAMDRV%\AUTOEXEC.TMP %RAMDRV%\AUTOEXEC.BAT >NUL
del %RAMDRV%\AUTOEXEC.TMP >NUL
:USBAutoDone

:PDIRLoopB
vfdutil /p \%PKGDIR%\NUL | vstr /b /f : 2- | set /p PDIR=
if "%PDIR%" == "" goto PDIRLoopB

xcopy /y /e LANGUAGE\*.* %RAMDRV%\FDSETUP\SETUP\ >NUL
xcopy /y /e FDISETUP\SETUP\*.* %RAMDRV%\FDSETUP\SETUP\ >NUL
copy /y SETTINGS\PKG_ALL.LST %RAMDRV%\FDSETUP\SETUP\FDPLALL.LST >NUL
copy /y SETTINGS\PKG_BASE.LST %RAMDRV%\FDSETUP\SETUP\FDPLBASE.LST >NUL
type SETTINGS\FDNPKG.CFG|vstr /n/s "$SOURCES$" "0">%RAMDRV%\FDSETUP\SETUP\FDNPBIN.CFG
type SETTINGS\FDNPKG.CFG|vstr /n/s "$SOURCES$" "1">%RAMDRV%\FDSETUP\SETUP\FDNPSRC.CFG

type FDISETUP\SETUP\STAGE000.BAT|vstr /n/s "$PLATFORM$" "%OS_NAME%">%TEMP%\STAGE000.BAT
type %TEMP%\STAGE000.BAT|vstr /n/s "$VERSION$" "%OS_VERSION%">%TEMP%\STAGE000.000
type %TEMP%\STAGE000.000|vstr /n/s "$OVOL$" "%VOLUMEID%">%DOSDIR%\SETUP\STAGE000.BAT
del %TEMP%\STAGE000.000 >nul
del %TEMP%\STAGE000.BAT >nul

type FDISETUP\SETUP\STAGE600.BAT|vstr /n/s "$PKGDIR$" "%PDIR%">%TEMP%\STAGE600.BAT
copy /y %TEMP%\STAGE600.BAT %DOSDIR%\SETUP\STAGE600.BAT>NUL
del %TEMP%\STAGE600.BAT >nul
set PDIR=

echo PLATFORM=%OS_NAME%>%RAMDRV%\FDSETUP\SETUP\VERSION.FDI
echo VERSION=%OS_VERSION%>>%RAMDRV%\FDSETUP\SETUP\VERSION.FDI

vecho , /fLightGreen OK /fGray /p

:RepeatLangs
dir /on /a /b /p- /s LANGUAGE\FDSETUP.DEF >%TEMP%\LANGLIST.LST
type %TEMP%\LANGLIST.LST |grep -iv TEMPLATE |vstr /b/l TOTAL| set /p LANGS=
if "%LANGS%" == "" goto RepeatLangs
del %TEMP%\LANGLIST.LST>NUL
type LANGUAGE\TEMPLATE\FDSETUP.DEF|grep ^LANG_|grep -v _ASK\=|grep -v _NAME\=|grep -v _AUTHOR\=|vstr /n/f _ 2>%TEMP%\LANGNAME.LST
type %TEMP%\LANGNAME.LST | vstr /b/l TOTAL | set /p LANGM=

vecho Creating language lists for /fYellow %LANGS% /fGray languages, /fLightCyan %LANGM% /fGray on menu.
set TIDX=0
:LangLoop
if "%TIDX%" == "%LANGM%" goto LangDone
type %TEMP%\LANGNAME.LST| vstr /b/l %TIDX% | set /p TNAME=
if "%TNAME%" == "" goto LangLoop
vmath %TIDX% + 1 | set /p TIDX=
echo %TNAME% | vstr /b/f = 1 | set /p TFILE=
vecho /r2/c32 /fYellow %TFILE% /s- /fGray : /n
set TTRY=0
set TIDS=
:IDLoop
if "%TTRY%" == "%LANGM%" goto IDDone
type %TEMP%\LANGNAME.LST| vstr /b/l %TTRY%|set /p TID=
if "%TID%" == "" goto IDLoop
echo %TID% | vstr /b/f = 1 | set /p TID=
:IncLoop
vmath %TTRY% + 1 | set /p TTM=
if "%TTM%" == "" goto IncLoop
set TTRY=%TTM%
set TTM=
:GOLoop
type LANGUAGE\%TFILE%\FDSETUP.DEF|grep LANG_%TID%|vstr /b/f = 2|set /p TGO=
if "%TGO%" == "" goto GOLoop
if not "%TIDS%" == "" set TIDS=%TIDS%,
set TIDS=%TIDS% '%TGO%'
goto IDLoop
:IDDone
echo %TIDS% | vstr /n /b /s "'" "" |vecho /i /n
type LANGUAGE\%TFILE%\FDSETUP.DEF| grep -B 1000 ^LANG_ASK\= >%TEMP%\FDSETUP.DEF
echo LANG_LIST=/r4/c32%TIDS% /e  |vstr /n/b/s "," " /e/p/r4/c32">>%TEMP%\FDSETUP.DEF
type LANGUAGE\%TFILE%\FDSETUP.DEF| grep -A 1000 ^LANG_ASK\= | grep -A 1000 -v ^LANG_ASK\= >>%TEMP%\FDSETUP.DEF
grep -A 1000 "^\*\*\*" %TEMP%\FDSETUP.DEF | grep -iv "^;\|^#|^\-" | vstr /b >%TEMP%\FDSETUP.TMP
copy /y %TEMP%\FDSETUP.TMP %RAMDRV%\FDSETUP\SETUP\%TFILE%\FDSETUP.DEF >NUL
del %TEMP%\FDSETUP.TMP >NUL
del %TEMP%\FDSETUP.DEF >NUL
vgotoxy /l eot next
vecho , /fLightGreen OK /a7
set TTRY=
set TID=
set TGO=
set TIDS=
goto LangLoop

:LangDone

vecho /p Updating STAGE300 language list /n
:LangCount
vmath 6 + %LANGM% | set /p TTM=
if "%TTM%" == "" goto LangCount

type FDISETUP\SETUP\STAGE300.BAT| grep -B 1000 ^:LanguageChange |vstr /n/b/s "$HEIGHT$" "/h%TTM%">%TEMP%\STAGE300.BAT
set TIDX=%LANGM%
echo.>>%TEMP%\STAGE300.BAT

:CodeLoop
set TTRY=
vmath %TIDX% + 100 | set /p TTRY=
if "%TTRY%" == "" goto CodeLoop
set TGO=%TTRY%
:CodeName
set TTRY=
vmath %TIDX% - 1 | set /p TTRY=
if "%TTRY%" == "" goto CodeName
type %TEMP%\LANGNAME.LST| vstr /b/l %TTRY% | vstr /b/f = 1 | set /p TNAME=
if "%TNAME%" == "" goto CodeName
echo set _WCI=%TIDX%>>%TEMP%\STAGE300.BAT
echo set LANG=%TNAME%>>%TEMP%\STAGE300.BAT
if "%TIDX%" == "1" goto CodeDone
echo if errorlevel %TGO% goto DoChange>>%TEMP%\STAGE300.BAT
:CodeDec
set TIDX=%TTRY%
vecho , /fLightCyan %TNAME% /s- /fGray /n
goto CodeLoop

:CodeDone
vecho , /fLightCyan %TNAME% /s- /fGray /n
echo.>>%TEMP%\STAGE300.BAT
set TTRY=
set TGO=
set TTM=
set TNAME=

type FDISETUP\SETUP\STAGE300.BAT| grep -A 1000 ^:DoChange >>%TEMP%\STAGE300.BAT
del %TEMP%\LANGNAME.LST>NUL
copy /y %TEMP%\STAGE300.BAT %RAMDRV%\FDSETUP\SETUP\STAGE300.BAT>NUL
del %TEMP%\STAGE300.BAT>NUL
vecho , /fLightGreen Done /fGray /p

vecho  Creating FreeDOS welcome message installation package with /n
if not exist %TEMP%\WELCOME\NUL mkdir %TEMP%\WELCOME>NUL
if not exist %TEMP%\WELCOME\APPINFO\NUL mkdir %TEMP%\WELCOME\APPINFO>NUL
if not exist %TEMP%\WELCOME\BIN\NUL mkdir %TEMP%\WELCOME\BIN>NUL
if not exist %TEMP%\WELCOME\NLS\NUL mkdir %TEMP%\WELCOME\NLS>NUL
type WELCOME\WELCOME.BAT| vstr /n/s $URL$ "%OS_URL%">%TEMP%\WELCOME\BIN\WELCOME.BAT
type WELCOME\APPINFO.LSM|vstr /s $VERSION$ "%OS_VERSION%"|vstr /b/s $DATE$ "%TNOW%">%TEMP%\WELCOME\APPINFO\WELCOME.LSM
set TNOW=
:NLSCount
set TCNT=
dir /a/b/s LANGUAGE\FDSETUP.DEF| grep -iv TEMPLATE\\|vstr /b/l total| set /p TCNT=
if "%TCNT%" == "" goto NLSCount
vmath %TCNT% + 1 | set /p TTRY=
if "%TTRY%" == "" goto NLSCount
set TIDX=%TCNT%
vecho /s- /c32 /fYellow %TCNT% /s+ /fGray languages.

:NLSLoop
if "%TIDX%" == "0" goto NLSDone
set TTRY=
vmath %TIDX% - 1 | set /p TTRY=
if "%TTRY%" == "" goto NLSLoop
if not "%TIDX%" == "%TCNT%" vecho , /c32 /n
set TIDX=%TTRY%

:NLSName
dir /a/b/s LANGUAGE\FDSETUP.DEF|grep -iv TEMPLATE\\|vstr /b/l %TIDX%|vstr /n/f LANGUAGE\ 2-|vstr /n/f \ 1|set /p TNAME=
if "%TNAME%" == "" goto NLSName
grep ^AUTO_ LANGUAGE\%TNAME%\FDSETUP.DEF >%TEMP%\WELCOME\NLS\WELCOME.%TNAME%
vecho /fLightCyan %TNAME% /s- /fGray /n
goto NLSLoop

:NLSDone
set TTRY=
set TTM=
set TNAME=
set TCNT=
pushd

vfdutil /c /p %TEMP%\WELCOME\
if exist ..\WELCOME.ZIP del ..\WELCOME.ZIP >NUL
zip -r -k -9 ..\WELCOME.ZIP *.* >NUL

if "%USB%" == "y" goto NotOnFloppy
if not exist %DOSDIR%\SETUP\PACKAGES\NUL mkdir %DOSDIR%\SETUP\PACKAGES>NUL
copy /y ..\WELCOME.ZIP %DOSDIR%\SETUP\PACKAGES\ >NUL
:NotOnFloppy
popd

vecho , /fLightGreen Done /fGray /p

if "%USB%" == "y" goto MakeFDISources
if "%ELT%" == "y" goto MakeFDISources
REM goto NoFDISources
:MakeFDISources
vecho /n "Creating FDI build environment source package"
grep -B 1000 -i "^goto SkipList" TOOLS\FDIDEV.BAT >%DOSDIR%\BIN\FDIDEV.BAT
grep -iv "^;" SETTINGS\PKG_FDI.LST | vstr /n/b >>%DOSDIR%\BIN\FDIDEV.BAT
grep -A 1000 -i "^:SkipList" TOOLS\FDIDEV.BAT >>%DOSDIR%\BIN\FDIDEV.BAT

mkdir %TEMP%\FDISRC >NUL
mkdir %TEMP%\FDISRC\APPINFO >NUL
mkdir %TEMP%\FDISRC\SOURCE >NUL
mkdir %TEMP%\FDISRC\SOURCE\FDISRC >NUL
xcopy /y /E *.* %TEMP%\FDISRC\SOURCE\FDISRC >NUL
del %TEMP%\FDISRC\SOURCE\FDISRC\V8POWER\V*.* >NUL
set /e TGO=cd
pushd
vfdutil /c /p %TEMP%\FDISRC\
type %TGO%\FDISETUP\APPINFO.LSM|vstr /s $VERSION$ "%OS_VERSION%"|vstr /b/s $DATE$ "%TNOW%">APPINFO\FDISRC.LSM
if exist ..\FDISRC.ZIP del ..\FDISRC.ZIP >NUL
zip -r -k -9 ..\FDISRC.ZIP *.* >NUL
popd

vecho , /fLightGreen Done /fGray /p
set TGO=
:NoFDISources

if "%USB%" == "y" goto NoPackOverrides
if "%ELT%" == "y" goto NoPackOverrides

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
if exist %DOSDIR%\BIN\README.TXT deltree /Y %DOSDIR%\BIN\README.TXT >NUL
if exist %DOSDIR%\SETUP\PACKAGES\README.TXT deltree /Y %DOSDIR%\SETUP\PACKAGES\README.TXT >NUL
if exist %DOSDIR%\SETUP\TEMPLATE\NUL deltree /y %DOSDIR%\SETUP\TEMPLATE >NUL
set TIDX=0
:CleanLoop
type SETTINGS\CLEANUP.LST | grep -iv ^; | vstr /b/l %TIDX% | set /p TFILE=
if not "%TIDX%" == "0" goto CleanCheck
if "%TFILE%" == "" goto CleanLoop
:CleanCheck
if "%TFILE%" == "" goto CleanDone
vmath %TIDX% + 1 | set /p TIDX=
if exist %DOSDIR%\%TFILE%\NUL deltree /Y %DOSDIR%\%TFILE%\ >NUL
if exist %DOSDIR%\%TFILE%\NUL rmdir %DOSDIR%\%TFILE% >NUL
if exist %DOSDIR%\%TFILE% del %DOSDIR%\%TFILE% >NUL
goto CleanLoop
:CleanDone
set TFILE=
set TIDX=
vecho , /fLightGreen OK /fGray /p

:FormatDisk
vecho Press a key to format the disk in drive /fYellow %FLOPPY% /s- /fGray ... /c32 /n
if not "%ALLOFF%" == "y" vpause /fCyan /t 15 CTRL-C
if errorlevel 100 goto Error
vgotoxy left
vecho /fGray /e /p
format %FLOPPY% /V:%VOLUME% /U /Z:seriously
if errorlevel 1 goto Error
vgotoxy /l eot sor
vecho /fGray Format, /fLightGreen OK /fGray /e /p
pushd
%RAMDRV%
cd \
sys %RAMDRV% %FLOPPY% /BOTH
vgotoxy /l eot
vecho /fGray , /fLightGreen OK /fGray /p
popd

if "%USB%" == "y" goto ROsys
if "%ELT%" == "y" goto ROsys
attrib +R %FLOPPY%\COMMAND.COM
attrib +R %FLOPPY%\KERNEL.SYS
goto sysDone
:ROsys
attrib +S +R %FLOPPY%\COMMAND.COM
attrib +S +R %FLOPPY%\KERNEL.SYS
:sysDone
vecho

if "%FNUM%" == "" goto NoMBR
vecho Updating MBR for floppy disk /fYellow %FLOPPY% /fGray /n
fdisk /mbr %FNUM%>NUL
if errorlevel 1 goto CopyFailed
fdisk /activate:1 %FNUM%>NUL
if errorlevel 1 goto CopyFailed
vgotoxy /l eot
vecho /fGray , /fLightGreen OK /fGray /p
:NoMBR

vecho Copying files to floppy disk /fYellow %FLOPPY% /fGray /n
xcopy /y /S %RAMDRV%\FDSETUP %FLOPPY%\FDSETUP\ >NUL
copy /y %RAMDRV%\AUTOEXEC.BAT %FLOPPY%\ >NUL
copy /y %RAMDRV%\FDCONFIG.SYS %FLOPPY%\ >NUL
copy /y %RAMDRV%\SETUP.BAT %FLOPPY%\ >NUL
if "%PKGDIR%" == "\" goto NoPKGFile
if "%PKGDIR%" == "\PACKAGES\" goto NoPKGFile
if "%PKGDIR%" == "\FDSETUP\PACKAGES\" goto NoPKGFile
if not exist %FLOPPY%\FDSETUP\BIN\FDIMPLES.EXE goto NoPKGFile
echo %PKGDIR% >%FLOPPY%\FDSETUP\BIN\FDIMPLES.DAT
:NoPKGFile
vecho ,  /fLightGreen OK /fGray

if not "%USB%" == "y" goto Done
vecho /p Copying required packages to floppy disk /fYellow %FLOPPY% /fGray /p

:RetryCount
if "%SLIM%" == "y" goto SlimCount
grep -iv ^; SETTINGS\PKG_ALL.LST SETTINGS\PKG_XTRA.LST | vstr /f : 2- | vstr /d/b/l TOTAL | set /p TCNT=
goto CheckCount
:SlimCount
grep -iv ^; SETTINGS\PKG_ALL.LST | vstr /d/b/l TOTAL | set /p TCNT=
:CheckCount
if "%TCNT%" == "" goto RetryCount
set TIDX=0

:CopyLoop
set TFILE=
if "%SLIM%" == "y" goto SlimFile
grep -iv ^; SETTINGS\PKG_ALL.LST SETTINGS\PKG_XTRA.LST | vstr /f : 2- | vstr /d/b/l %TIDX% | set /p TFILE=
goto CheckFile
:SlimFile
grep -iv ^; SETTINGS\PKG_ALL.LST | vstr /d/b/l %TIDX% | set /p TFILE=
:CheckFile
if "%TFILE%" == "" goto CopyLoop
if "%TFILE%" == "base\welcome" goto RetryInc
:DirLoop
vfdutil /p %FLOPPY%\%PKGDIR%\ | set /p TDIR=
if "%TDIR%" == "" goto DirLoop
if not exist %TDIR%\NUL mkdir %TDIR% >NUL
set TDIR=
:DestLoop
vfdutil /p %FLOPPY%\%PKGDIR%\%TFILE% | set /p TDIR=
if "%TDIR%" == "" goto DestLoop
:OvrLoop
vfdutil /n %FLOPPY%\%TFILE% | set /p TOVR=
if "%TOVR%" == "" goto OvrLoop
if exist %TDIR%\%TOVR%.zip goto RetryInc
vecho /r5/c32 %CDROM%\%TFILE%.zip "-->" %TDIR% /n
if not exist %TDIR%\NUL mkdir %TDIR% >NUL
if "%TFILE%" == "base\welcome" goto SkipPackage
if exist PACKAGES\%TOVR%.zip goto OverideCD
copy /y %CDROM%\%TFILE%.zip %TDIR%\ >NUL
if errorlevel 1 goto CopyFailed
goto CopyOK

:SkipPackage
vecho /n , /fLightCyan SKIPPED /fGray
goto CopyOK

:OverideCD
vecho /n , /fLightRed OVERRIDE /fGray
copy /y PACKAGES\%TOVR%.zip %TDIR%\ >NUL
if errorlevel 1 goto CopyFailed

:CopyOK
set /e TFILE=vfdutil /n %TFILE%
rem vecho /n ,%IDIR%\%TFILE%.txt
if not exist %IDIR%\%TFILE%.txt goto NoData
if not exist %FLOPPY%\FDSETUP\PKGINFO\nul mkdir %FLOPPY%\FDSETUP\PKGINFO >nul
copy /y %IDIR%\%TFILE%.txt %FLOPPY%\FDSETUP\PKGINFO\%TFILE%.TXT >nul
vecho /n , /fLightGreen DATA /fGray
goto ShowOK
:NoData
vecho /n , /fLightRed No Data /fGray
:ShowOK
vecho , /fLightGreen OK /fGray

:RetryInc
set TOVR=
set TFILE=
vmath %TIDX% + 1 | set /p TFILE=
if "%TFILE%" == "" goto RetryInc
set TIDX=%TFILE%
if not "%TCNT%" == "%TIDX%" goto CopyLoop

vecho /r5/c32 %TEMP%\welcome.zip "-->" %FLOPPY%%PKGDIR%BASE /n
copy /y %TEMP%\welcome.zip %FLOPPY%%PKGDIR%BASE >NUL
if errorlevel 1 goto CopyFailed
if not exist %FLOPPY%\FDSETUP\PKGINFO\nul mkdir %FLOPPY%\FDSETUP\PKGINFO >nul

set SPKG=WELCOME
pushd
vfdutil /c /p %TEMP%\%SPKG%\

set TDATA=
:WILoop:
dir /on/a/s/p-/b- | grep -A 1 "^Total "|grep -iv ^Total|vstr /b|set /p TDATA=
if "%TDATA%" == "" goto WILoop
:WIFLoop
echo %TDATA%|vstr /f " f" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p IFILES=
if "%IFILES%" == "" goto WIFLoop
:WISLoop
echo %TDATA%|vstr /f ")" 2|vstr /f "b" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p ISIZE=
if "%ISIZE%" == "" goto WISLoop
if not exist SOURCE\NUL goto WNoSources
:WSLoop
set TDATA=
dir /on/a/s/p-/b- SOURCE| grep -A 1 "^Total "|grep -iv ^Total|vstr /b|set /p TDATA=
if "%TDATA%" == "" goto WSLoop
:WSFLoop
echo %TDATA%|vstr /f " f" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p SFILES=
if "%SFILES%" == "" goto WSFLoop
:WSSLoop
echo %TDATA%|vstr /f ")" 2|vstr /f "b" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p SSIZE=
if "%SSIZE%" == "" goto WSSLoop
:WNoSources
set TDATA=
cd ..
if not exist WELCOME\appinfo\%SPKG%.lsm goto WPkgInfNoData

type %SPKG%\appinfo\%SPKG%.lsm|grep -B 1000 -i ^Copying-policy:|vstr /b>%SPKG%.PKG
if not "%ISIZE%" == "" echo Total-size:     %ISIZE%>>%SPKG%.PKG
if not "%IFILES%" == "" echo Total-files:    %IFILES%>>%SPKG%.PKG
if not "%SSIZE%" == "" echo Source-size:    %SSIZE%>>%SPKG%.PKG
if not "%SFILES%" == "" echo Source-files:   %SFILES%>>%SPKG%.PKG
if not "%ISIZE%" == "" vecho /n , /s- /fGray '(I-' /fCyan %IFILES% /fGray '/' /fYellow %ISIZE% /fGray )
if not "%SSIZE%" == "" vecho /n , /s- /fGray '(S-' /fCyan %SFILES% /fGray '/' /fYellow %SSIZE% /fGray )
type %SPKG%\appinfo\%SPKG%.lsm|grep -A 1000 -i ^Copying-policy:|grep -iv ^Copying-policy:|vstr /b>>%SPKG%.PKG
dir /on/a/s/p-/b  %TEMP%\%SPKG%\ |vstr /d/b/f "\welcome\" 2- | grep -i \\ >>%TEMP%\%SPKG%.PKG
type %SPKG%.PKG | vstr /b >%FLOPPY%\FDSETUP\PKGINFO\%SPKG%.TXT
:WPkgInfNoData
set ISIZE=
set SSIZE=
set IFILES=
set SFILES=
set SPKG=
popd
vecho , /fLightGreen OK /fGray


vecho /r5/c32 %TEMP%\fdisrc.zip "-->" %FLOPPY%%PKGDIR%UTIL /n
copy /y %TEMP%\fdisrc.zip %FLOPPY%%PKGDIR%UTIL >NUL
if errorlevel 1 goto CopyFailed

set SPKG=FDISRC
pushd
vfdutil /c /p %TEMP%\%SPKG%\

set TDATA=
:FSLoop
dir /on/a/s/p-/b- | grep -A 1 "^Total "|grep -iv ^Total|vstr /b|set /p TDATA=
if "%TDATA%" == "" goto FSLoop
:FSFLoop
echo %TDATA%|vstr /f " f" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p IFILES=
if "%IFILES%" == "" goto FSFLoop
:FSSLoop
echo %TDATA%|vstr /f ")" 2|vstr /f "b" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p ISIZE=
if "%ISIZE%" == "" goto FSSLoop
if not exist SOURCE\NUL goto FNoSources
:FSBLoop
set TDATA=
dir /on/a/s/p-/b- SOURCE| grep -A 1 "^Total "|grep -iv ^Total|vstr /b|set /p TDATA=
if "%TDATA%" == "" goto FSBLoop
:FSFBLoop
echo %TDATA%|vstr /f " f" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p SFILES=
if "%SFILES%" == "" goto FSFBLoop
:FSSBLoop
echo %TDATA%|vstr /f ")" 2|vstr /f "b" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p SSIZE=
if "%SSIZE%" == "" goto FSSBLoop
:FNoSources
set TDATA=
cd ..
if not exist %SPKG%\appinfo\%SPKG%.lsm goto FPkgInfNoData

type %SPKG%\appinfo\%SPKG%.lsm|grep -B 1000 -i ^Copying-policy:|vstr /b>%SPKG%.PKG
if not "%ISIZE%" == "" echo Total-size:     %ISIZE%>>%SPKG%.PKG
if not "%IFILES%" == "" echo Total-files:    %IFILES%>>%SPKG%.PKG
if not "%SSIZE%" == "" echo Source-size:    %SSIZE%>>%SPKG%.PKG
if not "%SFILES%" == "" echo Source-files:   %SFILES%>>%SPKG%.PKG
if not "%ISIZE%" == "" vecho /n , /s- /fGray '(I-' /fCyan %IFILES% /fGray '/' /fYellow %ISIZE% /fGray )
if not "%SSIZE%" == "" vecho /n , /s- /fGray '(S-' /fCyan %SFILES% /fGray '/' /fYellow %SSIZE% /fGray )
type %SPKG%\appinfo\%SPKG%.lsm|grep -A 1000 -i ^Copying-policy:|grep -iv ^Copying-policy:|vstr /b>>%SPKG%.PKG
dir /on/a/s/p-/b  %TEMP%\%SPKG%\ |vstr /d/b/f "\fdisrc\" 2- | grep -i \\ >>%TEMP%\%SPKG%.PKG
type %SPKG%.PKG | vstr /b >%FLOPPY%\FDSETUP\PKGINFO\%SPKG%.TXT
:FPkgInfNoData
set ISIZE=
set SSIZE=
set IFILES=
set SFILES=
set SPKG=
popd
vecho , /fLightGreen OK /fGray


REM Create LIST INDEX FILES
vecho /p Creating package index files for /fYellow %FLOPPY% /fGray /p
set TIDX=0

:ListDirCount
dir /on /a /b /p- %FLOPPY%\%PKGDIR% | vstr /b /l TOTAL | set /P TCNT=
if "%TCNT%" == "" goto ListDirCount

:ListDirLoop
dir /on /a /b /p- %FLOPPY%\%PKGDIR% | vstr /b /l %TIDX% | set /P TDIR=
if "%TDIR%" == "" goto ListDirLoop

if not exist %FLOPPY%\%PKGDIR%\%TDIR%\NUL goto ListExcluded
if not exist %CDROM%\%TDIR%\INDEX.LST goto ListExcluded

vecho /n /r5/c32 %TDIR%

set SIDX=0

dir /on /a /b /p- %FLOPPY%\%PKGDIR%\%TDIR%\*.ZIP >%TEMP%\FILELIST.DIR
:ListScanCount
type %TEMP%\FILELIST.DIR | vstr /b /l TOTAL | set /P SCNT=
if "%SCNT%" == "" goto ListScanCount
if "%SCNT%" == "0" goto ListExcluded

if not exist %CDROM%\%TDIR%\INDEX.LST goto ListScanLoop
grep -i ^FD-REPOV1 %CDROM%\%TDIR%\INDEX.LST >%TEMP%\INDEX.LST
if errorlevel 1 goto ListScanLoop

type %TEMP%\INDEX.LST >%FLOPPY%\%PKGDIR%\%TDIR%\INDEX.LST

:ListScanInfoA
type %TEMP%\INDEX.LST | vstr /b/t 1 | set /p SPKG=
if "%SPKG%" == "" goto ListScanInfoA
:ListScanInfoB
type %TEMP%\INDEX.LST | vstr /b/t 3 | set /p STMP=
if "%STMP%" == "" goto ListScanInfoB
vecho /n " (%STMP%:%SCNT%)"
set SPKG=
set STMP=
:ListScanLoop
type %TEMP%\FILELIST.DIR | vstr /b /l %SIDX% | vstr /u/b/f .ZIP 1 | set /P SPKG=
if "%SPKG%" == "" goto ListScanLoop

grep -i ^%SPKG% %CDROM%\%TDIR%\INDEX.LST >%TEMP%\INDEX.LST
if not errorlevel 1 type %TEMP%\INDEX.LST >>%FLOPPY%\%PKGDIR%\%TDIR%\INDEX.LST

:ListScanInc
vmath %SIDX% + 1 | set /p STMP=
if "%STMP%" == "" goto ListScanInc
set SIDX=%STMP%
set STMP=
if not "%SCNT%" == "%SIDX%" goto ListScanLoop

vecho , /fLightGreen OK /fGray
:ListExcluded
if exist %TEMP%\FILELIST.DIR del %TEMP%\FILELIST.DIR >nul
set SIDX=
set SCNT=
set SPKG=
set STMP=

:ListDirInc
set TFILE=
vmath %TIDX% + 1 | set /p TFILE=
if "%TFILE%" == "" goto ListDirInc
set TIDX=%TFILE%
if not "%TCNT%" == "%TIDX%" goto ListDirLoop

vecho /p/fLightGreen Complete. /fGray
goto Done

:MakeInfo
set TEMPDOS=T
popd
pushd
if "%FLOPPY%" == "A:" goto UseTempDrive
set /e IDIR=vfdutil /d %FLOPPY%
set IDIR=%IDIR%\PKGINFO
:UseTempDrive
REM Create LIST DATA FILES
vecho Creating package data files for /fYellow %CDROM% /fGray at /fYellow %IDIR% /fGray /p
set TIDX=0

mkdir %TEMP%\BIN >nul
set OD=%DOSDIR%
set DOSDIR=%TEMP%
echo maxcachetime 7200>%DOSDIR%\BIN\FDNPKG.CFG
echo installsources 1>>%DOSDIR%\BIN\FDNPKG.CFG
echo skiplinks 0>>%DOSDIR%\BIN\FDNPKG.CFG
echo dir drivers %%DOSDIR%%\drivers>>%DOSDIR%\BIN\FDNPKG.CFG
echo dir games %%DOSDIR%%\games>>%DOSDIR%\BIN\FDNPKG.CFG
echo dir source %%DOSDIR%%\source>>%DOSDIR%\BIN\FDNPKG.CFG
echo dir progs %%DOSDIR%%\progs>>%DOSDIR%\BIN\FDNPKG.CFG
echo dir links %%DOSDIR%%\links>>%DOSDIR%\BIN\FDNPKG.CFG

fdinst install %CDROM%\ARCHIVER\unzip.zip >nul
fdinst install %CDROM%\UTIL\cwsdpmi.zip >nul
set DOSDIR=%OD%
set OD=

set SIDX=0

:SetFilter
echo %TEMP% | vstr /s \ \\ | set /p FILTER=
if "%FILTER%" == "" goto SetFilter
if "%INFOPKG%" == "" goto AllPackages
dir /on /a /b /p- /s %CDROM%\%INFOPKG%.ZIP |grep -v \\_ | grep -iv ^%FILTER% >%TEMP%\FILELIST.DIR
goto DoneFilter
:AllPackages
dir /on /a /b /p- /s %CDROM%\*.ZIP |grep -v \\_ | grep -iv ^%FILTER% >%TEMP%\FILELIST.DIR
:DoneFilter
set FILTER=

:PkgInfScanCount
type %TEMP%\FILELIST.DIR | vstr /b /l TOTAL | set /P SCNT=
if "%SCNT%" == "" goto PkgInfScanCount
if "%SCNT%" == "0" goto PkgInfExcluded

:PkgInfScanLoop
type %TEMP%\FILELIST.DIR | vstr /b /l %SIDX% | vstr /u/b/f .ZIP 1 | set /P SPKG=
if "%SPKG%" == "" goto PkgInfScanLoop

:AdjustTDIR
set /e TDIR=vfdutil /p %SPKG%
set /e SPKG=vfdutil /n %SPKG%

:PkgInfScanInc
vmath %SIDX% + 1 | set /p STMP=
if "%STMP%" == "" goto PkgInfScanInc
set SIDX=%STMP%
set STMP=

if not exist %TDIR%\%SPKG%.zip goto PkgInfSkip

vecho /n /r2/c32 /FDarkGray "(%SIDX%/%SCNT%)" /fGray %TDIR%\%SPKG%.ZIP

pushd
vfdutil /c/p %TEMP%\
mkdir %TEMPDOS%>nul
cd %TEMPDOS%
rem ..\bin\unzip -o -qq -C %TDIR%\%SPKG%.zip appinfo/%SPKG%.lsm
..\bin\unzip -o -qq -C %TDIR%\%SPKG%.zip>nul
set TDATA=
:ILoop:
dir /on/a/s/p-/b- | grep -A 1 "^Total "|grep -iv ^Total|vstr /b|set /p TDATA=
if "%TDATA%" == "" goto ILoop
:IFLoop
echo %TDATA%|vstr /f " f" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p IFILES=
if "%IFILES%" == "" goto IFLoop
:ISLoop
echo %TDATA%|vstr /f ")" 2|vstr /f "b" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p ISIZE=
if "%ISIZE%" == "" goto ISLoop
if not exist SOURCE\NUL goto NoSources
:SLoop
set TDATA=
dir /on/a/s/p-/b- SOURCE| grep -A 1 "^Total "|grep -iv ^Total|vstr /b|set /p TDATA=
if "%TDATA%" == "" goto SLoop
:SFLoop
echo %TDATA%|vstr /f " f" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p SFILES=
if "%SFILES%" == "" goto SFLoop
:SSLoop
echo %TDATA%|vstr /f ")" 2|vstr /f "b" 1|vstr /b/s " " ""|vstr /b/s "," ""|set /p SSIZE=
if "%SSIZE%" == "" goto SSLoop
:NoSources
set TDATA=
..\bin\unzip -l %TDIR%\%SPKG%.zip|vstr /f : 2-|vstr /b/f ' ' 4-|vstr /s " " ""|vstr /b>%TEMP%\%SPKG%.lst
cd ..
if not exist %TEMPDOS%\appinfo\%SPKG%.lsm goto PkgInfNoData
if not exist %TEMP%\%SPKG%.lst goto PkgInfNoData

type %TEMPDOS%\appinfo\%SPKG%.lsm|grep -B 1000 -i ^Copying-policy:|vstr /b>%SPKG%.PKG
if not "%ISIZE%" == "" echo Total-size:     %ISIZE%>>%SPKG%.PKG
if not "%IFILES%" == "" echo Total-files:    %IFILES%>>%SPKG%.PKG
if not "%SSIZE%" == "" echo Source-size:    %SSIZE%>>%SPKG%.PKG
if not "%SFILES%" == "" echo Source-files:   %SFILES%>>%SPKG%.PKG
if not "%ISIZE%" == "" vecho /n , /s- /fGray '(I-' /fCyan %IFILES% /fGray '/' /fYellow %ISIZE% /fGray )
if not "%SSIZE%" == "" vecho /n , /s- /fGray '(S-' /fCyan %SFILES% /fGray '/' /fYellow %SSIZE% /fGray )
type %TEMPDOS%\appinfo\%SPKG%.lsm|grep -A 1000 -i ^Copying-policy:|grep -iv ^Copying-policy:|vstr /b>>%SPKG%.PKG
type %SPKG%.lst | vstr /b/d >>%SPKG%.PKG
set ISIZE=
set SSIZE=
set IFILES=
set SFILES=

if not exist %IDIR%\nul mkdir %IDIR% >nul
type %SPKG%.PKG | vstr /b >%IDIR%\%SPKG%.TXT
vecho , /fLightGreen OK /fGray
goto PkgInfThisDone
:PkgInfNoData
vecho , /fLightRed Failed /fGray
:PkgInfThisDone
if exist appinfo\%SPKG%.lsm del appinfo\%SPKG%.lsm >nul
if exist %TEMP%\%SPKG%.lst del %TEMP%\%SPKG%.lst >nul
deltree /y %TEMP%\%TEMPDOS% >nul
popd

:PkgInfSkip
if not "%SCNT%" == "%SIDX%" goto PkgInfScanLoop

:PkgInfExcluded
if exist %TEMP%\FILELIST.DIR del %TEMP%\FILELIST.DIR >nul
set SIDX=
set SCNT=
set SPKG=
set STMP=
set INFOPKG=

vecho /p/fLightGreen Complete. /fGray
verrlvl 0
set TEMPDOS=
goto CleanUp

:CopyFailed
vecho , /fLightRed Failed. /fGray /p
goto Error

:MissingV8
if "%TTRY%" == "" goto V8TryAgain
echo ERROR: V8Power Tools are missing.
echo.
echo Download the latest version from 'http://up.lod.bz/V8Power'.
echo Then extract them making sure the V8PT binaries are located in the
echo 'V8POWER' subdirectory. Then run this batch file again.
goto CleanUp

:V8TryAgain
set TTRY=again
goto V8Retry

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

:BadTemp
vecho /fLightRed "Temp directory %TEMP% cannot be on Ramdrive." /fGray
set TEMP=

goto Error

:ErrorFDINST
vecho ', ' /fLightRed "ERROR" /fGray
goto Error

:SysError
popd

:CtrlCPressed

:Error
vecho /p /bRed /fYellow " An error has occurred." /e /fGray /bBlack
verrlvl 1
goto Cleanup

:SkipErrors
vecho /fLightGreen OK /fGray

:SkipReport
vecho /fGray
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
pushd
goto CleanUp

:DumpTemp
deltree -y %RAMDRV%\*.*
rmdir %RAMDRV%
verrlvl 0
goto CleanUp

:Done
type SETTINGS\PKG_FDI.LST | grep -iv ^; | vstr /b/l TOTAL | set /p USED=
type SETTINGS\PKG_BASE.LST | grep -iv ^; | vstr /b/l TOTAL | set /p BASE=
type SETTINGS\PKG_ALL.LST | grep -iv ^; | vstr /b/l TOTAL | set /p ALL=
if "%SLIM%" == ""  type SETTINGS\PKG_XTRA.LST | grep -iv ^; | vstr /b/l TOTAL | set /p XTRA=
if "%SLIM%" == "y" set XTRA=0
dir /on /a /b /p- /s %CDROM%\*.zip | grep -iv \\_ | vstr /b/l TOTAL | set /p COUNT=

vecho /p /fLightGreen %OS_NAME% /fLightCyan %OS_VERSION% /fGray (%VOLUMEID%) /n
vecho /c32 /fYellow "%OS_URL%" /fGray
vecho /fWhite %LANGS% /fGray languages, /fWhite %LANGM% /fGray on menu.
vecho /fWhite %USED% /fGray of /fWhite %COUNT% /fGray packages used for boot image.
vecho Total packages in BASE /fWhite %BASE% /fGray /s- , /s+ ALL /fWhite %ALL% /fGray & EXTRA /fWhite %XTRA% /fGray /s-  .
vecho /p /fLightGreen Install Media Creation complete. /e /fGray /bBlack

set ALL=
set BASE=
set XTRA=
set COUNT=
set USED=

verrlvl 0
goto CleanUp

:CleanUp
set OS_NAME=%OSN%
set OS_VERSION=%OSV%
set OSN=
set OSV=
set VOLUMEID=
set FLOPPY=
set FNUM=
set VOLUME=
set RAMDRV=
set RAMSIZE=
set CDROM=
set KERNEL=
set PKGDIR=
set ELOG=
set LANGS=
set LANGM=
set SLIM=
set IDIR=

set TFILE=
set TNAME=
set TIDX=
set TCNT=
set TERR=
set TRETRY=
set TNOW=
set TTRY=
set TDIR=

set ELT=
set USB=
set OS_URL=

SET FDNPKG.CFG=%OLDFDN%
SET DOSDIR=%OLDDOS%
SET PATH=%OLDPATH%
SET OLDFDN=
SET OLDDOS=
SET OLDPATH=
set SELF=
set INFO=

rem goto NoTempRM
if "%TEMP%" == "" goto NoTempRM
if not exist %TEMP%\NUL goto NoTempRM
vfdutil /c /d %TEMP%
cd \
deltree /Y %TEMP%\*.* >NUL
:NoTempRM

popd


:EndOfFile

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
if not exist %2:\BOOT.IMG goto EndOfFile
if not exist %2:\BOOT.CAT goto EndOfFile
if not exist %2:\BASE\COMMAND.ZIP goto EndOfFile
if not exist %2:\BASE\KERNEL.ZIP goto EndOfFile
if not exist %2:\BASE\INDEX.LST goto EndOfFile
set CDROM=%2:
goto EndOfFile

:BuildAll
call %0
call %0 slim D:
call %0 usb E:
goto EndOfFile

:Start
set SELF=%0
SET OLDFDN=%FDNPKG.CFG%
SET OLDDOS=%DOSDIR%
SET OLDPATH=%PATH%
SET OSN=%OS_NAME%
SET OSV=%OS_VERSION%

set USB=
set SLIM=
set FLOPPY=A:
set VOLUME=FD-SETUP
set RAMDRV=
set RAMSIZE=32M
set CDROM=
set KERNEL=KERNL386.SYS
set TGO=0
set TTRY=3

if "%TZ%" == "" set TZ=EDT

:ReadSettings
if "%1" == "" goto ReadDone

if "%1" == "usb" set USB=y
if "%1" == "slim" set SLIM=y

vfdutil /u %1\????????.??? >nul
if not errorlevel 1 set /e FLOPPY=vfdutil /d %1\test

shift
goto ReadSettings

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
type SETTINGS\VERSION.CFG|grep -iv ^;|grep -i PLATFORM|vstr /b/f = 2|set /p OS_NAME=
if "%OS_NAME%" == "" goto RepeatNAME
:RepeatVER
type SETTINGS\VERSION.CFG|grep -iv ^;|grep -i VERSION|vstr /b/f = 2|set /p OS_VERSION=
if "%OS_VERSION%" == "" goto RepeatVER
:RepeatID
type SETTINGS\VERSION.CFG|grep -iv ^;|grep -i VOLUME|vstr /b/f = 2|set /p VOLUMEID=
if "%VOLUMEID%" == "" goto RepeatID
:RepeatURL
type SETTINGS\VERSION.CFG|grep -iv ^;|grep -i URL|vstr /b/f = 2|set /p OS_URL=
if "%OS_URL%" == "" goto RepeatURL

set PATH=%TEMPPATH%\V8POWER;%DOSDIR%\BIN
set TEMPPATH=

vgotoxy up up
vecho /fLightGreen "%OS_NAME% %OS_VERSION% install disk creator." /p

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
vask /c /fWhite /bBlue /d10 %FLOPPY% | set /p FLOPPY=
if errorlevel 200 goto CtrlCPressed
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
if "%USB%" == "y" goto USBAuto
type %RAMDRV%\AUTOEXEC.BAT | vstr /n /s '$LBA$ ' '' >%RAMDRV%\AUTOEXEC.TMP
copy /y %RAMDRV%\AUTOEXEC.TMP %RAMDRV%\AUTOEXEC.BAT >NUL
del %RAMDRV%\AUTOEXEC.TMP >NUL
goto USBAutoDone
:USBAuto
type %RAMDRV%\AUTOEXEC.BAT | vstr /n /s '$LBA$ ' 'rem ' >%RAMDRV%\AUTOEXEC.TMP
copy /y %RAMDRV%\AUTOEXEC.TMP %RAMDRV%\AUTOEXEC.BAT >NUL
del %RAMDRV%\AUTOEXEC.TMP >NUL
:USBAutoDone

xcopy /y /e LANGUAGE\*.* %RAMDRV%\FDSETUP\SETUP\ >NUL
xcopy /y /e FDISETUP\SETUP\*.* %RAMDRV%\FDSETUP\SETUP\ >NUL
copy /y SETTINGS\PKG_ALL.LST %RAMDRV%\FDSETUP\SETUP\FDPLALL.LST >NUL
copy /y SETTINGS\PKG_BASE.LST %RAMDRV%\FDSETUP\SETUP\FDPLBASE.LST >NUL
type SETTINGS\FDNPKG.CFG|vstr /n/s "$SOURCES$" "0">%RAMDRV%\FDSETUP\SETUP\FDNPBIN.CFG
type SETTINGS\FDNPKG.CFG|vstr /n/s "$SOURCES$" "1">%RAMDRV%\FDSETUP\SETUP\FDNPSRC.CFG
type FDISETUP\SETUP\STAGE000.BAT|vstr /n/s "$PLATFORM$" "%OS_NAME%">%TEMP%\STAGE000.BAT
type %TEMP%\STAGE000.BAT|vstr /n/s "$VERSION$" "%OS_VERSION%">%TEMP%\STAGE000.000
type %TEMP%\STAGE000.000|vstr /n/s "$OVOL$" "%VOLUMEID%">%DOSDIR%\SETUP\STAGE000.BAT
del %TEMP%\STAGE000.000
del %TEMP%\STAGE000.BAT

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
copy /y %TEMP%\FDSETUP.DEF %RAMDRV%\FDSETUP\SETUP\%TFILE%\FDSETUP.DEF >NUL
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
:NOWLoop
date /d | vstr /n/f ' ' 5- | set /p TGO=
if "%TGO%" == "" goto NOWLoop
type WELCOME\APPINFO.LSM|vstr /s $VERSION$ "%OS_VERSION%"|vstr /b/s $DATE$ "%TGO%">%TEMP%\WELCOME\APPINFO\WELCOME.LSM
set TGO=
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
set TGO=
set TTM=
set TNAME=
set TCNT=
pushd
vfdutil /c /p %TEMP%\WELCOME\
if exist ..\WELCOME.ZIP del ..\WELCOME.ZIP >NUL
zip -r -k -9 ..\WELCOME.ZIP *.* >NUL

if not exist %DOSDIR%\SETUP\PACKAGES\NUL mkdir %DOSDIR%\SETUP\PACKAGES>NUL
copy /y ..\WELCOME.ZIP %DOSDIR%\SETUP\PACKAGES\ >NUL
popd

vecho , /fLightGreen Done /fGray /p

if "%USB%" == "y" goto NoPackOverrides

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
vpause /fCyan /t 15 CTRL-C
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
sys %FLOPPY% /BOTH
if errorlevel 1 goto SysError
vgotoxy /l eot
vecho /fGray , /fLightGreen OK /fGray /p
popd

vecho Copying files to floppy disk /fYellow %FLOPPY% /fGray /n
xcopy /y /S %RAMDRV%\FDSETUP %FLOPPY%\FDSETUP\ >NUL
copy /y %RAMDRV%\AUTOEXEC.BAT %FLOPPY%\ >NUL
copy /y %RAMDRV%\FDCONFIG.SYS %FLOPPY%\ >NUL
copy /y %RAMDRV%\SETUP.BAT %FLOPPY%\ >NUL
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
:DestLoop
vfdutil /p %FLOPPY%\%TFILE% | set /p TDIR=
if "%TDIR%" == "" goto DestLoop
:OvrLoop
vfdutil /n %FLOPPY%\%TFILE% | set /p TOVR=
if "%TOVR%" == "" goto OvrLoop
if exist %TDIR%\%TFILE%.zip goto RetryInc
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
vecho , /fLightGreen OK /fGray

:RetryInc
set TOVR=
set TFILE=
vmath %TIDX% + 1 | set /p TFILE=
if "%TFILE%" == "" goto RetryInc
set TIDX=%TFILE%
if not "%TCNT%" == "%TIDX%" goto CopyLoop

vecho /p Creating package data files for /fYellow %FLOPPY% /fGray /p
set TIDX=0

:LstCount
dir /on /a /b /p- %FLOPPY%\ | vstr /b /l TOTAL | set /P TCNT=
if "%TCNT%" == "" goto LstCount

:LstLoop
dir /on /a /b /p- %FLOPPY%\ | vstr /b /l %TIDX% | set /P TDIR=
if "%TDIR%" == "" goto LstLoop

if not exist %FLOPPY%\%TDIR%\NUL goto Excluded
if not exist %CDROM%\%TDIR%\INDEX.LST goto Excluded

vecho /n /r5/c32 %TDIR%

set SIDX=0

:ScanCount
dir /on /a /b /p- %FLOPPY%\%TDIR%\*.ZIP | vstr /b /l TOTAL | set /P SCNT=
if "%SCNT%" == "" goto ScanCount
if "%SCNT%" == "0" goto Exclude

grep -i ^FD-REPOV1 %CDROM%\%TDIR%\INDEX.LST >%TEMP%\INDEX.LST
if errorlevel 1 goto ScanLoop

type %TEMP%\INDEX.LST >%FLOPPY%\%TDIR%\INDEX.LST

:ScanInfoA
type %TEMP%\INDEX.LST | vstr /b/t 1 | set /p SPKG=
if "%SPKG%" == "" goto ScanInfoA
:ScanInfoB
type %TEMP%\INDEX.LST | vstr /b/t 3 | set /p STMP=
if "%STMP%" == "" goto ScanInfoB
rem vstr /p "%SPKG%" /c9/p "Build time: 0" /c9/p "%STMP%" /c9/p "%SCNT%" -to- %FLOPPY%\%TDIR%\INDEX.LST
vecho /n " (%STMP%:%SCNT%)"
set SPKG=
set STMP=
:ScanLoop
dir /on /a /b /p- %FLOPPY%\%TDIR%\*.ZIP | vstr /b /l %SIDX% | vstr /u/b/f '.ZIP' 1 | set /P SPKG=
if "%SPKG%" == "" goto ScanLoop

grep -i ^%SPKG% %CDROM%\%TDIR%\INDEX.LST >%TEMP%\INDEX.LST
if not errorlevel 1 type %TEMP%\INDEX.LST >>%FLOPPY%\%TDIR%\INDEX.LST

rem vecho /n " %SPKG%"

:ScanInc
vmath %SIDX% + 1 | set /p STMP=
if "%STMP%" == "" goto ScanInc
set SIDX=%STMP%
set STMP=
if not "%SCNT%" == "%SIDX%" goto ScanLoop

vecho , /fLightGreen OK /fGray
:Excluded
set SIDX=
set SCNT=
set SPKG=
set STMP=

:LstInc
set TFILE=
vmath %TIDX% + 1 | set /p TFILE=
if "%TFILE%" == "" goto RetryInc
set TIDX=%TFILE%
if not "%TCNT%" == "%TIDX%" goto LstLoop

vecho /p/fLightGreen Complete. /fGray
goto Done

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
rem deltree /y %TEMP%\*.* >NUL
type SETTINGS\PKG_FDI.LST | grep -iv ^; | vstr /b/l TOTAL | set /p USED=
type SETTINGS\PKG_BASE.LST | grep -iv ^; | vstr /b/l TOTAL | set /p BASE=
type SETTINGS\PKG_ALL.LST | grep -iv ^; | vstr /b/l TOTAL | set /p ALL=
if "%SLIM%" == ""  type SETTINGS\PKG_XTRA.LST | grep -iv ^; | vstr /b/l TOTAL | set /p XTRA=
if "%SLIM%" == "y" set XTRA=0
dir /on /a /b /p- /s %CDROM%\*.zip | vstr /b/l TOTAL | set /p COUNT=

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
set VOLUME=
set RAMDRV=
set RAMSIZE=
set CDROM=
set KERNEL=
set ELOG=
set LANGS=
set LANGM=

set TFILE=
set TNAME=
set TIDX=
set TCNT=
set TERR=
set TRETRY=
set TGO=
set TTRY=
set TDIR=

set USB=
set OS_URL=

SET FDNPKG.CFG=%OLDFDN%
SET DOSDIR=%OLDDOS%
SET PATH=%OLDPATH%
SET OLDFDN=
SET OLDDOS=
SET OLDPATH=
set SELF=
popd

if "%TEMP%" == "" goto EndOfFile
if not exist %TEMP%\NUL goto EndOfFile
deltree /Y %TEMP%\*.* >NUL

:EndOfFile
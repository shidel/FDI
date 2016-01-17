@echo off

REM FreeDOS 1.2+ Package Tester version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2015 Jerome Shidel.

if "%1" == "MEDIA" goto MediaSearch
goto Startup

; Message Text
NOTEMP.EN=Unable to locate or configure TEMP directory.
NOMEDIA.EN=Unable to locate installation packages.
ABORT.EN=Unable to continue. Test aborted.
CTRLC.EN=Control+C detected. Test aborted.
MKDIRERR.EN=Unable to create directory. Test aborted.

WELCOME.EN=FreeDOS 1.2+ Package Tester version 1.00.
DOSDIR?.EN=Confirm %DOSDIR% target directory? /c32
TEMP?.EN=Confirm current %TEMP% directory? /c32
LOG?.EN=Confirm log file? /c32
LIST?.EN=Package Listing File? /c32
SCAN.EN=Locating package installation media
MEDIA.EN=Package installation media at %1
TIMES?.EN=Number of install iterations? /c32
RETRIES?.EN=Number of install retries? /c32
FIND.EN=Creating package list.
PACKAGES.EN=Detected /fLightCyan %1 /a7 packages
NUMBER.EN=/fDarkGray %1 of %2 /a7
COMPLETE.EN=Package test complete, /c32
RETRY.EN=/a7 /p /fYellow Retry /a7 /s- , /s+ %1, /c32
PASSED.EN=Passed.
FAILED.EN=Failed. %2 Errors with %1 Packages.
ABORT?.EN=Press Ctrl+C to ABORT...
START?.EN=Start with package number? /c32

FDIOK.EN=/a7 /fLightCyan /s- I
FDIERR.EN=/a7 /fLightRed /s- I
FDUERR.EN=/a7 /fLightRed /s- U
FDROK.EN=/a7 /fLightCyan /s- R
FDRERR.EN=/a7 /fLightRed /s- R
FDPOK.EN=/a7 /fLightCyan /s- P
FDPERR.EN=/a7 /fLightRed /s- P /s+ /p Unable to purge directory.

OK.EN=/s- /a7 , /s+ /fLightGreen OK /a7
ERROR.EN=/s- /a7 , /s+ /fLightRed ERROR /a7

; Default Test Settings
DOSDIR=C:\FDTEST
TEMP=C:\TEMP
TIMES=2
RETRIES=3

REM Package media search sub-batch utility ************************************
:MediaSearch
if not "%MEDIA%" == "" goto EndOfBatch
vecho /fDarkGray /n /s- .
vfdutil /u %2:\TEMP????.??? >NUL
if errorlevel 1 goto EndOfBatch
if not exist %2:\BASE\COMMAND.ZIP goto EndOfBatch
if not exist %2:\BASE\KERNEL.ZIP goto EndOfBatch
set MEDIA=%2:
goto EndOfBatch

REM Main Batch File Startup Section *******************************************
:StartUp
if "%OS_NAME%" == "" SET OS_NAME=FreeDOS
if "%OS_VERSION%" == "" SET OS_VERSION=1.2

pushd
SET OLDPATH=%PATH%
SET OLD_DOS=%DOSDIR%
SET OLD_TEMP=%TEMP%
SET OLD_FDNPKG=%FDNPKG.CFG%

SET SELF=%0
SET TLANG=%LANG%
if not exist %SELF% SET SELF=%0.BAT
if not exist %SELF% goto IdentityCrises
if "%TLANG%" == "" SET TLANG=EN
SET LNG=%TLANG%
SET TLANG=

REM Test for Presence of V8Power Tools ****************************************

REM Check current errorlevel is 255, then test by clearing it.
if errorlevel 255 goto ClearError

REM Check by setting errorlevel to 255.
:CheckPresence
verrlvl 255
if errorlevel 255 goto V8Present
goto V8Missing

REM Check by setting errorlevel to 0.
:ClearError
verrlvl 0
if errorlevel 1 goto V8Missing

REM V8Power Tools Found *******************************************************
:V8Present
verrlvl 0
vfdutil /c /p %0

REM Temp Dircectory Test and Auto-configuration********************************
:TempTest
if not "%TEMP%" == "" goto TempSet
vinfo /d C:
if errorlevel 1 goto NoDriveC
vfdutil /u C:\FDOS\TEMP\TEST????.??? >NUL
if errorlevel 1 goto NoFDOS
set TEMP=C:\FDOS\TEMP
goto HasTemp

:NoDriveC
goto NoTemp

:NoFDOS
vfdutil /u C:\FREEDOS\TEMP\TEST????.??? >NUL
if errorlevel 1 goto NoFREEDOS
set TEMP=C:\FREEDOS\TEMP
goto HasTemp

:NoFREEDOS
vfdutil /u C:\TEST????.??? >NUL
if errorlevel 1 goto NoTEMP
if not exist C:\FDTEMP.$$$\NUL mkdir C:\FDTEMP.$$$
set TEMP=C:\FDTEMP.$$$
goto HasTemp

:TempSet
vfdutil /u %TEMP%\TEST????.??? >NUL
if errorlevel 1 goto NoTEMP
goto HasTemp

:NoTEMP
if not "%TEMP%" == "" goto TempRetry
vecho /fYellow /bRed /e /n /t %SELF% NOTEMP.%LNG%
vecho /fGray /fBlack
goto Done

:TempRetry
SET TEMP=
goto TempTest

:HasTemp
vfdutil /u %TEMP%\TEST????.??? >NUL
if errorlevel 1 goto V8Missing
goto RunTests

REM Run Test ******************************************************************
:RunTests
vecho /a7 /p /fLightGreen /t %SELF% WELCOME.%LNG%
vecho /a7

REM Set DOSDIR
:SetDOSDIR
echo SETP | set /p SETP=
if "%SETP%" == "" goto SetDOSDIR
set SETP=
vecho /fYellow /bBlack /n /t %SELF% DOSDIR?.%LNG%
vask /c /fWhite /bBlue /d10 /t %SELF% DOSDIR | set /p DOSDIR=
if errorlevel 200 goto CtrlCPressed
vgotoxy sor
if "%DOSDIR%" == "" goto SetDOSDIR
vfdutil /f %DOSDIR% | set /p DOSDIR=
if exist %DOSDIR%\NUL goto SetDOSDIR
vfdutil /d %DOSDIR% | set /p DRIVE=
vfdutil /u %DRIVE%\TEST????.??? >NUL
if errorlevel 1 goto SetDOSDIR
vecho /a7 /n /t %SELF% DOSDIR?.%LNG%
vecho /a7 /e /fWhite %DOSDIR%
if not exist %DOSDIR%\NUL mkdir %DOSDIR%
if not exist %DOSDIR%\NUL goto Abort

REM Set TEMP
:SetTempDir
echo SETP | set /p SETP=
if "%SETP%" == "" goto SetTempDir
set SETP=
vecho /fYellow /bBlack /n /t %SELF% TEMP?.%LNG%
vask /c /fWhite /bBlue /d10 /t %SELF% TEMP | set /p TEMP=
if errorlevel 200 goto CtrlCPressed
vgotoxy sor
if "%TEMP%" == "" goto SetTempDir
vfdutil /f %TEMP% | set /p TEMP=
vfdutil /d %TEMP% | set /p DRIVE=
vfdutil /u %DRIVE%\TEST????.??? >NUL
if errorlevel 1 goto SetTempDir
vecho /a7 /n /t %SELF% TEMP?.%LNG%
vecho /a7 /e /fWhite %TEMP%
if not exist %TEMP%\NUL mkdir %TEMP%
if not exist %TEMP%\NUL goto Abort

REM Set Log File Name
:SetLogFile
echo SETP | set /p SETP=
if "%SETP%" == "" goto SetLogFile
set SETP=
vfdutil /d %DOSDIR% | set /p DRIVE=
vfdutil /n %0 | set /p NAME=
vecho /fYellow /bBlack /n /t %SELF% LOG?.%LNG%
vask /c /fWhite /bBlue /d10 %DRIVE%\%NAME%.LOG | set /p LOG=
if errorlevel 200 goto CtrlCPressed
vgotoxy sor
vfdutil /f %LOG% | set /p LOG=
if "%LOG%" == "" goto SetLogFile
vfdutil /d %LOG% | set /p DRIVE=
vfdutil /u %DRIVE%\TEST????.??? >NUL
if errorlevel 1 goto SetLogFile
SET DRIVE=
SET NAME=
vecho /a7 /n /t %SELF% LOG?.%LNG%
vecho /a7 /e /fWhite %LOG%
:RepeatDate
date /t | vstr /b /f is 2 | set /p NOWD=
if "%NOWD%" == "" goto RepeatDate
:RepeatTime
time /t | vstr /b /f is 2 | set /p NOWT=
if "%NOWT%" == "" goto RepeatTime
echo Created %NOWD% at %NOWT%|vstr /b/s "  " " "|vstr /b/s "  " " ">%LOG%
if not exist %LOG% goto SetLogFile

REM Set List File Name
:SetListFile
echo SETP | set /p SETP=
if "%SETP%" == "" goto SetListFile
set SETP=
vfdutil /d %DOSDIR% | set /p DRIVE=
vfdutil /n %0 | set /p NAME=
vecho /fYellow /bBlack /n /t %SELF% LIST?.%LNG%
vask /c /fWhite /bBlue /d10 %DRIVE%\%NAME%.LST | set /p LST=
if errorlevel 200 goto CtrlCPressed
vgotoxy sor
vfdutil /f %LST% | set /p LST=
if "%LST%" == "" goto SetListFile
vfdutil /d %LST% | set /p DRIVE=
vfdutil /u %DRIVE%\TEST????.??? >NUL
if errorlevel 1 goto SetListFile
SET DRIVE=
SET NAME=
vecho /a7 /n /t %SELF% LIST?.%LNG%
vecho /a7 /e /fWhite %LST%
echo Created %NOWD% at %NOWT%|vstr /b/s "  " " "|vstr /b/s "  " " ">%LST%
SET NOWD=
SET NOWT=

REM Set iterations
:SetTimes
echo SETP | set /p SETP=
if "%SETP%" == "" goto SetTimes
set SETP=
vecho /fYellow /bBlack /n /t %SELF% TIMES?.%LNG%
vask /c /fWhite /bBlue /d10 /t %SELF% TIMES | set /p TIMES=
if errorlevel 200 goto CtrlCPressed
vgotoxy sor
if "%TIMES%" == "" goto SetTimes
vecho /a7 /n /t %SELF% TIMES?.%LNG%
vecho /a7 /e /fWhite %TIMES%

REM Set retries
:SetRetries
echo SETP | set /p SETP=
if "%SETP%" == "" goto SetRetries
set SETP=
vecho /fYellow /bBlack /n /t %SELF% RETRIES?.%LNG%
vask /c /fWhite /bBlue /d10 /t %SELF% RETRIES | set /p RETRIES=
if errorlevel 200 goto CtrlCPressed
vgotoxy sor
if "%RETRIES%" == "" goto SetRetries
vecho /a7 /n /t %SELF% RETRIES?.%LNG%
vecho /a7 /e /fWhite %RETRIES%

REM Set Start
:SetStart
echo SETP | set /p SETP=
if "%SETP%" == "" goto SetRetries
set SETP=
vecho /fYellow /bBlack /n /t %SELF% START?.%LNG%
vask /c /fWhite /bBlue /d10 1 | set /p START=
if errorlevel 200 goto CtrlCPressed
vgotoxy sor
if "%START%" == "" goto SetStart
vecho /a7 /n /t %SELF% START?.%LNG%
vecho /a7 /e /fWhite %START%
:SetSubOne
vmath %START% - 1 | set /p TENV=
if "%TENV%" == "" goto SetSubOne
set START=%TENV%
set TENV=

vecho /a7

REM Locate Media
vecho /n /t %SELF% SCAN.%LNG%
for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do call %SELF% MEDIA %%d
vgotoxy sor
if "%MEDIA%" == "" goto MediaMissing
vecho /n /t %SELF% MEDIA.%LNG% %MEDIA%
vecho /n /t %SELF% OK.%LNG%
vecho /a7 /e /p

REM Make Package List
vecho /n /t %SELF% FIND.%LNG%
:RepeatFind
dir /on /a /b /p- /s %MEDIA%\*.zip | vstr /u/b >%TEMP%\PACKAGES.LST
type %TEMP%\PACKAGES.LST | vstr /b/l total | set /p PACKAGES=
if "%PACKAGES%" == "" goto RepeatFind
if "%PACKAGES%" == "0" goto RepeatFind
vgotoxy sor
vecho /n /t %SELF% PACKAGES.%LNG% %PACKAGES%
vecho /n /t %SELF% OK.%LNG%
vecho /a7 /e /p

REM Make FDNPKG Config File.
SET FDNPKG.CFG=%TEMP%\FDNPKG.CFG
echo maxcachetime 7200>%FDNPKG.CFG%
echo installsources 0>>%FDNPKG.CFG%
echo skiplinks 0>>%FDNPKG.CFG%
echo dir devel %DOSDIR%\devel>>%FDNPKG.CFG%
echo dir drivers %DOSDIR%\drivers>>%FDNPKG.CFG%
echo dir games %DOSDIR%\games>>%FDNPKG.CFG%
echo dir source %DOSDIR%\source>>%FDNPKG.CFG%
echo dir progs %DOSDIR%\>>%FDNPKG.CFG%
echo dir links %DOSDIR%\links>>%FDNPKG.CFG%

REM Test All Packages.
SET NUMBER=%START%
SET PPERR=0
SET PFERR=0

:NextPackage
SET PTERR=
deltree /y %TEMP%\FDINST.* >NUL
:RepeatNumber
vmath %NUMBER% + 1 | set /p TENV=
if "%TENV%" == "" goto RepeatNumber
set NUMBER=%TENV%
set TENV=
vmath %NUMBER% - 1 | set /p LINE=
type %TEMP%\PACKAGES.LST | vstr /b/l %LINE% | set /p FILE=
if "%FILE%" == "" goto TestComplete
vecho /n /t %SELF% NUMBER.%LNG% %NUMBER% %PACKAGES%
vfdutil /n %FILE% | set /p NAME=
set LINE=
:TestPackage
vecho /n /fGray /c32 - %FILE%, /c32
if not exist %DOSDIR%\NUL mkdir %DOSDIR%
if not exist %DOSDIR%\NUL goto MkDirError

set TIME=%TIMES%
set FIRST=yes

:TryPackage
if "%TIME%" == "0" goto DonePackage
vmath %TIME% - 1 | set /p TENV=
if "%TENV%" == "" goto TryPackage
set TIME=%TENV%
set TENV=
set RETRY=%RETRIES%

:RetryPackage
vmath %RETRY% - 1 | set /p TENV=
if "%TENV%" == "" goto RetryPackage
set RETRY=%TENV%
set TENV=

:RepeatLog
vfdutil /u %TEMP%\FDINST.??? | set /p FLOG=
if "%FLOG%" == "" goto RepeatLog
vecho /n /fDarkGray .
fdinst install %FILE% >%FLOG%
if errorlevel 1 goto InstallError
:RepeatCatch
grep -i \[\- %FLOG%|vstr /b/l total | set /p TENV=
if "%TENV%" == "" goto RepeatCatch
if not "%TENV%" == "0" goto CaughtError

vgotoxy left
vecho /n /t %SELF% FDIOK.%LNG%


echo %FILE% | vstr /n/d/f \ 2- | vstr /n/s .zip ''>>%LST%
grep -i "^Title\|^Version\|^Copying" %DOSDIR%\APPINFO\*.LSM>>%LST%
echo. >>%LST%

goto RemovePackage

:CaughtError
vgotoxy left
vecho /n /t %SELF% FDUERR.%LNG%
if "%FIRST%" == "yes" echo Uncaught install error with %FILE%>>%LOG%
if not "%FIRST%" == "yes" echo Uncaught re-install error with %FILE%>>%LOG%
goto PurgeDOS

:InstallError
set PTERR=y
vgotoxy left
vecho /n /t %SELF% FDIERR.%LNG%
if "%FIRST%" == "yes" echo Install error with %FILE%>>%LOG%
if not "%FIRST%" == "yes" echo Re-install error with %FILE%>>%LOG%
goto PurgeDOS

:RemovePackage
vfdutil /u %TEMP%\FDINST.??? | set /p FLOG=
if "%FLOG%" == "" goto RemovePackage
vecho /n /fDarkGray .
fdinst remove %NAME% >%FLOG%
if errorlevel 1 goto RemoveError
vgotoxy left
vecho /n /t %SELF% FDROK.%LNG%
set FIRST=no
goto TryPackage

:RemoveError
set PTERR=y
vgotoxy left
vecho /n /t %SELF% FDRERR.%LNG%
echo Remove error with %FILE%>>%LOG%

:PurgeDOS
vecho /n /fDarkGray .
deltree /y %DOSDIR%\*.* >NUL
if errorlevel 1 goto PurgeError
vgotoxy left
vecho /n /t %SELF% FDPOK.%LNG%
vecho /n /t %SELF% ERROR.%LNG%
vecho /a7
grep -i error %FLOG%|vstr /f ' to ' 2|vstr /b/n/s "%DOSDIR%\" ""|vstr /s "'" ""|vecho /n/i
grep -i error %FLOG%|vstr /f ' to ' 2|vstr /b/n/s "%DOSDIR%\" ""|vstr /s "'" "">>%LOG%
:RetryCount
grep -i error %FLOG%|vstr /f ' to ' 2|vstr /b/n/s "%DOSDIR%\" ""|vstr /b/l total | set /p TENV=
if "%TENV%" == "" goto RetryCount
vmath %PFERR% + %TENV% | set /p TENV=
if "%TENV%" == "" goto RetryCount
set PFERR=%TENV%
set TENV=
if "%RETRY%" == "0" goto FailedPackage
vecho /n /t %SELF% RETRY.%LNG% %NAME% %TENV%
set FIRST=yes
set TENV=
goto RetryPackage

:PurgeError
vgotoxy left
vecho /n /t %SELF% FDPERR.%LNG%
goto Abort

:FailedPackage
vecho /a7 /p /n /fYellow /t %SELF% ABORT?.%LNG%
vpause /fLightCyan /t 5 CTRL-C
if errorlevel 200 goto TestComplete
vgotoxy sor
vecho /a7 /e /n
goto NextPackage

:DonePackage
set TENV=
if "%PTERR%" == "" goto NoError
vmath %PPERR% + 1 | set /p TENV=
if "%TENV%" == "" goto DonePackage
set PPERR=%TENV%
set TENV=
vecho /a7
goto NextPackage
:NoError
vecho /a7 /t %SELF% OK.%LNG%
goto NextPackage

:TestComplete
vecho /n /a7 /p /t %SELF% COMPLETE.%LNG%
if "%PPERR%" == "0" goto Passed
vecho /n /fLightRed /t %SELF% FAILED.%LNG% %PPERR% %PFERR%
vecho /a7
goto Done
:Passed
vecho /n /fLightGreen /t %SELF% PASSED.%LNG%
vecho /a7
goto Done

REM Pre-V8Power Tools Error Messages ******************************************
:IdentityCrises
echo Unable to find myself.
goto Done

:V8Missing
echo.
echo V8Power Tools were not found. Please install them or try booting from the
echo installation media and trying again.
goto Done

REM V8Power Tools Available Error Messages ************************************
:MediaMissing
vecho /n /t %SELF% SCAN.%LNG%
vecho /n /t %SELF% ERROR.%LNG%
vecho /n /a7 /e
goto Abort

:CtrlCPressed
vecho /a7 /p /p /n /fWhite /bRed /e /t %SELF% CTRLC.%LNG%
vecho /a7 /p
goto Done

:MkDirError
vecho /n /t %SELF% ERROR.%LNG%
vecho /a7 /p /p /n /fWhite /bRed /e /t %SELF% MKDIRERR.%LNG%
vecho /a7 /p
goto Done

:Abort
vecho /a7 /p /p /n /fWhite /bRed /e /t %SELF% ABORT.%LNG%
vecho /a7 /p
goto Done

REM Normal batch shutdown procedure *******************************************
:Done
popd
SET SELF=
SET LNG=
SET MEDIA=
SET PACKAGES=
SET NUMBER=
SET NAME=
SET FILE=
SET PATH=%OLDPATH%
SET DRIVE=
SET LOG=
SET LST=
SET TIMES=
SET RETRIES=
SET FLOG=
SET TIME=
SET RETRY=
SET LINE=
SET PPERR=
SET PTERR=
SET PFERR=
set FIRST=
set START=

if "%TEMP%" == "" goto NoCleanTemp
if not exist %TEMP%\NUL  goto NoCleanTemp
deltree -y %TEMP%\*.* >NUL
if not "%OLD_TEMP%" == "%TEMP%" rmdir %TEMP% >NUL
:NoCleanTemp
SET TEMP=%OLD_TEMP%
if "%DOSDIR%" == "" goto NoCleanDOS
if not exist %DOSDIR%\NUL  goto NoCleanDOS
deltree -y %DOSDIR%\*.* >NUL
if not "%OLD_DOS%" == "%DOSDIR%" rmdir %DOSDIR% >NUL
:NoCleanDOS
SET DOSDIR=%OLD_DOS%
SET FDNPKG.CFG=%OLD_FDNPKG%
SET OLDPATH=
SET OLD_DOS=
SET OLD_TEMP=
SET OLD_FDNPKG=

REM The very last command line of the batch file (for Sub-utilties) ***********
:EndOfBatch

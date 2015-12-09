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

WELCOME.EN=FreeDOS 1.2+ Package Tester version 1.00.
DOSDIR?.EN=Confirm %DOSDIR% target directory? /c32
TEMP?.EN=Confirm current %TEMP% directory? /c32
FIND.EN=Locating package installation media
MEDIA.EN=Package installation media at %1

OK.EN=/s- /a7 , /c32 /fLightGreen OK /a7
ERROR.EN=/s- /a7 , /c32 /fLightRed ERROR /a7

; Default Test Settings
DOSDIR=C:\TEST
TEMP=C:\TEMP

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
SET OLD_PATH=%PATH%
SET OLD_DOS=%DOSDIR%
SET OLD_TEMP=%TEMP%

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
vfdutil /u C:\FDOS\TEST????.??? >NUL
if errorlevel 1 goto NoFDOS
if not exist C:\FDOS\TEMP\NUL mkdir C:\FDOS\TEMP
set TEMP=C:\FDOS\TEMP
goto HasTemp

:NoFDOS
vfdutil /u C:\FREEDOS\TEST????.??? >NUL
if errorlevel 1 goto NoFREEDOS
if not exist C:\FREEDOS\TEMP\NUL mkdir C:\FREEDOS\TEMP
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
vecho /fYellow /bBlack /n /t %SELF% DOSDIR?.%LNG%
vask /c /fWhite /bBlue /d10 /t %SELF% DOSDIR | set /p DOSDIR=
if errorlevel 200 goto CtrlCPressed
vgotoxy sor
vecho /a7 /n /t %SELF% DOSDIR?.%LNG%
vecho /a7 /e /fWhite %DOSDIR%

REM Set TEMP
vecho /fYellow /bBlack /n /t %SELF% TEMP?.%LNG%
vask /c /fWhite /bBlue /d10 /t %SELF% TEMP | set /p TEMP=
if errorlevel 200 goto CtrlCPressed
vgotoxy sor
vecho /a7 /n /t %SELF% TEMP?.%LNG%
vecho /a7 /e /fWhite %TEMP%
vecho /a7

REM Locate Media
vecho /n /t %SELF% FIND.%LNG%

for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do call %SELF% MEDIA %%d

vgotoxy sor
if "%MEDIA%" == "" goto MediaMissing

vecho /n /t %SELF% MEDIA.%LNG% %MEDIA%
vecho /n /t %SELF% OK.%LNG%
vecho /a7 /e /p

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
vecho /n /t %SELF% FIND.%LNG%
vecho /n /t %SELF% ERROR.%LNG%
vecho /n /a7 /e
goto Abort

:CtrlCPressed
vecho /a7 /p /p /n /fWhite /bRed /e /t %SELF% CTRLC.%LNG%
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
SET PATH=%OLD_PATH%
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
SET OLD_PATH=
SET OLD_DOS=
SET OLD_TEMP=

REM The very last command line of the batch file (for Sub-utilties) ***********
:EndOfBatch

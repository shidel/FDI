@echo off

set ODOSDIR=%DOSDIR%
set OFDNPKG=%FDNPKG.CFG%

REM Run entire install process.

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% INSTALL_FRAME
vecho /t %FLANG% INSTALL %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
vecho
vecho /t %FLANG% INSTALL?
call FDIOPTS.BAT 2
vecho /t %FLANG% INSTALL_YES "%OS_NAME% %OS_VERSION%"
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 2

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

:DoInstall

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PREPARING_FRAME
vecho /n /t %FLANG% PREPARING
vdelay %FDEL%

REM Scan for all install file paths.
echo %FINSP%>%TEMP%\FDIPATHS.LST

if not "%FSCAN%" == "y" goto NoVendorScanning
for %%d in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do call FDISCAN.BAT %%d
:NoVendorScanning

REM Configure FDINST package manager.
set FDNPKG.CFG=%FINSP%\FDNPBIN.CFG
if "%OSRC%" == "y" SET FDNPKG.CFG=%FINSP%\FDNPSRC.CFG
set DOSDIR=%FTARGET%

REM Scan each install file path
set _TSI=0

:LoopingPath
type %TEMP%\FDIPATHS.LST | vstr /l %_TSI% | set /p _TSA=
if "%_TSA%" == "" goto FinishedPath
verrlvl 0

set _TI=0
:LoopingList
dir /a /b /p- %_TSA%\FDINS*.BAT | vstr /l %_TI% | set /p _TA=
if "%_TA%" == "" goto FinishedList

vfdutil /n %_TA% | set /p _TL=
call FDILANG.BAT %_TL% FDINS FDSETUP
set _TL=

verrlvl 0
if not exist %_TSA%\%_TA% goto FinishedList
vfdutil /c/d %_TSA%\
pushd
vfdutil /c/p %_TSA%\
call %_TA%
if errorlevel 1 goto AbortBatch
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
popd
vfdutil /c/p %FINSP%\

vmath %_TI% + 1 | set /p _TI=
goto LoopingList
:FinishedList

if errorlevel 1 goto AbortBatch
vmath %_TSI% + 1 | set /p _TSI=
goto LoopingPath

:FinishedPath
vfdutil /c/p %FINSP%\
verrlvl 0
goto Done

:AbortBatch
vfdutil /c/p %FINSP%\
verrlvl 1

:Done
set _TSI=
set _TSA=
set _TI=
set _TA=
set DOSDIR=%ODOSDIR%
set ODOSDIR=
set FDNPKG.CFG=%OFDNPKG%
set OFDNPKG=
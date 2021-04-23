@echo off

REM Run entire install process.

set OLDDOS=%DOSDIR%
set OLDFDN=%FDNPKG.CFG%

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% INSTALL_FRAME
vecho /k0 /t %FLANG% INSTALL %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
vecho /k0
vecho /k0 /t %FLANG% INSTALL?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% INSTALL_OPTS
vecho /k0 /t %FLANG% INSTALL_YES "%OS_NAME% %OS_VERSION%"
vecho /k0 /n /t %FLANG% EXIT
vchoice /k0 /a %TFC% Ctrl-C /d 2

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

:DoInstall
REM From here on, we will keep the language setting.
set FCLANG=

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PREPARING_FRAME
vecho /k0 /n /t %FLANG% PREPARING
vdelay %FDEL%

REM Configure FDINST package manager.
:GetFDINSTVersion
fdinst | vstr /n /l 0 | vstr /n /f " " 2 | set /p FDNVER=
if "%FDNVER%" == "" goto GetFDINSTVersion

REM Override for pre-release versions of FDNPKG
set FDNVER=v0.99.7

set DOSDIR=%FTARGET%
set FDNPKG.CFG=%TEMP%\FDNPKG.CFG
if "%FDNVER%" == "v0.99.6" goto OldFDINST

:NewFDNPKG
set _TC=
if "%FDRIVE%" == "C:" goto MapDisabled
echo %FTARGET% | vstr /d /f : 2| set /p _TC=
if "%_TC%" == "" goto NewFDNPKG
set DOSDIR=C:%_TC%

:SetMapDrives
set _TC=
echo %FDRIVE% | vstr /d /f : 1 | set /p _TC=
if "%_TC%" == "" goto SetMapDrives
set _TC=mapdrives c%_TC%
goto MapEnabled

:OldFDINST

:MapDisabled
set _TC=#mapdrives cc
:MapEnabled
set _TI=0
type %FINSP%\..\BIN\FDNPKG.CFG|vstr /n /s #mapdrives "%_TC%" >%TEMP%\FDNPKG.1
type %TEMP%\FDNPKG.1|vstr /n/s "sources 0" "sources %OSRC%" >%TEMP%\FDNPKG.2
type %TEMP%\FDNPKG.2|vstr /n/s %%DOSDRV%% C: >%FDNPKG.CFG%
del  %TEMP%\FDNPKG.1 >NUL
del  %TEMP%\FDNPKG.2 >NUL
goto ReadyFDINST

:ReadyFDINST

if "%FDEBUG%" == "y" call FDBUG.BAT shell Ready. About to run install scripts.

REM Scan each installer in program file path
set _TI=0
set _TC=

vfdutil /c/p %FINSP%\

:Sticky
dir /on /a /b /p- %FINSP%\FDINS*.BAT | vstr /b /l TOTAL | set /p _TC=
if "%_TC%" == "" goto Sticky

:LoopingList
if "%_TI%" == "%_TC%" goto FinishedList
dir /on /a /b /p- %FINSP%\FDINS*.BAT | vstr /b /l %_TI% | set /p _TA=
rem echo TC %_TC% TI %_TI% TA %_TA%
if "%_TA%" == "" goto LoopingList

vfdutil /n %_TA% | set /p _TL=
set _TL=

verrlvl 0
if not exist %_TA% goto FinishedList
pushd
call %_TA%
if errorlevel 1 goto FailedInstaller
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
popd

set _TT=
:LoopMath
vmath %_TI% + 1 | set /p _TT=
if "%_TT%" == "" goto LoopMath
set _TI=%_TT%
set _TT=
goto LoopingList

:FinishedList
if exist %FTARGET%\BIN\FDNPKG.CFG goto ReplaceConfig
verrlvl 0
goto DoneCheckWarning

:ReplaceConfig
copy /y %FTARGET%\BIN\FDNPKG.CFG %FTARGET%\BIN\FDNPKG.DEF>NUL
type %FINSP%\..\BIN\FDNPKG.CFG | vstr /n/s "sources 0" "sources %OSRC%" >%FTARGET%\BIN\FDNPKG.1
type %FTARGET%\BIN\FDNPKG.1 | vstr /n/s %%FDRIVE%% C: >%FTARGET%\BIN\FDNPKG.1
type %FTARGET%\BIN\FDNPKG.2 | vstr /n/s mapdrives #mapdrives >%FTARGET%\BIN\FDNPKG.CFG
del %FTARGET%\BIN\FDNPKG.1 >NUL
del %FTARGET%\BIN\FDNPKG.2 >NUL
copy /y %FTARGET%\BIN\FDNPKG.CFG %FTARGET%\BIN\FDNPKG.BAK>NUL
verrlvl 0
goto DoneCheckWarning

:FailedInstaller
popd
goto AbortBatch

:DoneCheckWarning
del %FDNPKG.CFG%>NUL
set FDNPKG.CFG=
if exist %FTARGET%\BIN\FDNPKG.CFG set FDNPKG.CFG=%FTARGET%\BIN\FDNPKG.CFG
if not "%OSYS%" == "y" goto RebootWarning
if not "%OBSS%" == "y" goto RebootWarning
goto NoWarning
:RebootWarning
vinfo /m
if errorlevel 102 goto vmWarning
if errorlevel 101 goto NoWarning
:vmWarning
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% REBOOT_FRAME
vecho /k0 /n /t %FLANG% REBOOT_WARN.1 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% REBOOT_WARN.2 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% REBOOT_WARN.3 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% REBOOT_WARN.4 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% REBOOT_WARN.5 %TFH% "%OS_NAME%" %TFF%
vdelay 5000
vgotoxy /g eop sor
vecho /k0 /n /t %FLANG% PAUSE
vpause /fLightCyan /t %FWAIT% CTRL-C
:NoWarning
verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done
set _TI=
set _TA=
set _TC=
set DOSDIR=%OLDDOS%
set OLDDOS=
set FDNPKG.CFG=%OLDFDN%
set OLDFDN=
set FDNVER=

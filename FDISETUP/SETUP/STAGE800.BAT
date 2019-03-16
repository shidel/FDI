@echo off

REM Run entire install process.

set OLDDOS=%DOSDIR%
set OLDFDN=%FDNPKG.CFG%

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% INSTALL_FRAME
vecho /t %FLANG% INSTALL %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
vecho
vecho /t %FLANG% INSTALL?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% INSTALL_OPTS
vecho /t %FLANG% INSTALL_YES "%OS_NAME% %OS_VERSION%"
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 2

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

:DoInstall
REM From here on, we will keep the language setting.
set FCLANG=

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PREPARING_FRAME
vecho /n /t %FLANG% PREPARING
vdelay %FDEL%

REM Configure FDINST package manager.
set FDNPKG.CFG=%TEMP%\FDNPBIN.CFG
set _TI=0
set _TC=
:SetMapDrive
if "%FDRIVE%" == "C:" goto MapDisabled
echo %FDRIVE% | vstr /d /f : 1 | set /p _TC=
if "%_TC%" == "" goto SetMapDrive
set _TC=mapdrive c%_TC%
goto MapEnabled
:MapDisabled
set _TC=#mapdrive cc
:MapEnabled
if "%OSRC%" == "y" SET set _TI=1
type %FINSP%\FDNPKG.CFG|vstr /n /s $SOURCES$ %_TI% |vstr /n /s #mapdrive %_TC% >%FDNPKG.CFG%
set DOSDIR=%FTARGET%

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
copy /y %DOSDIR%\BIN\FDNPKG.CFG %DOSDIR%\BIN\FDNPKG.BAK>NUL
rem type %FDNPKG.CFG% | vstr /n /s %%FDRIVE%% C: >%DOSDIR%\BIN\FDNPKG.CFG
type %FDNPKG.CFG% | vstr /n /s %%FDRIVE%% C:| vstr /n /s mapdrive #mapdrive>%DOSDIR%\BIN\FDNPKG.CFG
verrlvl 0
goto DoneCheckWarning

:FailedInstaller
popd
goto AbortBatch

:DoneCheckWarning
del %FDNPKG.CFG%>NUL
set FDNPKG.CFG=
if exist %DOSDIR%\BIN\FDNPKG.CFG set FDNPKG.CFG=%DOSDIR%\BIN\FDNPKG.CFG
if not "%OSYS%" == "y" goto RebootWarning
if not "%OBSS%" == "y" goto RebootWarning
goto NoWarning
:RebootWarning
vinfo /m
if errorlevel 102 goto vmWarning
if errorlevel 101 goto NoWarning
:vmWarning
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% REBOOT_FRAME
vecho /n /t %FLANG% REBOOT_WARN.1 %TFH% "%OS_NAME%" %TFF%
vecho /n /t %FLANG% REBOOT_WARN.2 %TFH% "%OS_NAME%" %TFF%
vecho /n /t %FLANG% REBOOT_WARN.3 %TFH% "%OS_NAME%" %TFF%
vecho /n /t %FLANG% REBOOT_WARN.4 %TFH% "%OS_NAME%" %TFF%
vecho /n /t %FLANG% REBOOT_WARN.5 %TFH% "%OS_NAME%" %TFF%
vdelay 5000
vgotoxy /g eop sor
vecho /n /t %FLANG% PAUSE
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

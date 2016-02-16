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
set FDNPKG.CFG=%FINSP%\FDNPBIN.CFG
if "%OSRC%" == "y" SET FDNPKG.CFG=%FINSP%\FDNPSRC.CFG
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
call FDILANG.BAT %_TL% FDINS FDSETUP
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
goto Done

:ReplaceConfig
copy /y %DOSDIR%\BIN\FDNPKG.CFG %DOSDIR%\BIN\FDNPKG.BAK>NUL
type %FDNPKG.CFG% | vstr /n /s %%FDRIVE%% %FDRIVE% >%DOSDIR%\BIN\FDNPKG.CFG
verrlvl 0
goto Done

:FailedInstaller
popd

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

@echo off

set OLDDOS=%DOSDIR%
set OLDFDN=%FDNPKG.CFG%

REM Run entire install process.

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

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PREPARING_FRAME
vecho /n /t %FLANG% PREPARING
vdelay %FDEL%

REM Scan for all install file paths.

REM Configure FDINST package manager.
set FDNPKG.CFG=%FINSP%\FDNPBIN.CFG
if "%OSRC%" == "y" SET FDNPKG.CFG=%FINSP%\FDNPSRC.CFG
set DOSDIR=%FTARGET%

REM Scan each install file path
set _TI=0
:LoopingList
vfdutil /c/p %FINSP%\
dir /on /a /b /p- FDINS*.BAT | vstr /b /l %_TI% | set /p _TA=
if "%_TA%" == "" goto FinishedList

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

vmath %_TI% + 1 | set /p _TI=
goto LoopingList

:FinishedList
verrlvl 0
goto Done

:FailedInstaller
popd

:AbortBatch
verrlvl 1

:Done
set _TI=
set _TA=
set DOSDIR=%OLDDOS%
set OLDDOS=
set FDNPKG.CFG=%OLDFDN%
set OLDFDN=
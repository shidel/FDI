@echo off

REM FreeDOS 1.2+ Lanuage Tester version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2015 Jerome Shidel.

if "%1" == "CLS" goto ClearScreen
if "%1" == "STANDBY" goto StandBy
if "%1" == "" goto NOLANG
set OLD_LANG=%LANG%
set LANG=%1
if "%2" == "" goto %2

:0
call %0 CLS 0 FDSETUP DEF
call %0 STANDBY
if Errorlevel 1 goto Done

vcls /a7
goto Done

:ClearScreen
call FDISETUP\SETUP\STAGE000.BAT VersionOnly
set PART=%2
set FLANG=LANGUAGE\%LANG%\FDSETUP.DEF
call FDISETUP\SETUP\THEME%4.BAT
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vgotoxy /x1 /y1
vcls /b %TTB% /f %TTF% EOL
vgotoxy /x30 /y1
vecho /t %FLANG% TITLE %TTF% "%OS_NAME%" %TTH% "%OS_VERSION%"
set FLANG=LANGUAGE\%LANG%\%3.DEF
vecho "Theme: %4"
vecho "Section: %PART%"
vecho "Resource: %FLANG%"
goto EndOfBatch

:StandBy
vgotoxy eop sor
vecho /fBlack /bGray "Press a key or" /fRed "CTRL+C" /fBlack /s- ... /e /n
vpause /d 10 CTRL+C
if errorlevel 1 goto Abort
goto EndOfBatch

:Abort
vcls /a7
vecho "Section: %PART%"
vecho "Resource: %FLANG%"
verrlvl 1
goto EndOfBatch

:NOLANG
vecho "No Language specified."
verrlvl 1

:Done
set PART=
set LANG=%OLD_LANG%
set OLD_LANG=
call FDISETUP\SETUP\STAGE999.BAT VARSONLY

REM The very last command line of the batch file (for Sub-utilties) ***********
:EndOfBatch

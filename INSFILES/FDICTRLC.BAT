@echo off

REM Control-C Handler
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /f %TCF% /b %TCB% /w60 /h12 /c /y7 hidden shadow
vframe /f %TCF% /b %TCB% /w58 /h12 /c /y7 %TCS%
vframe /f %TCF% /b %TCB% /w56 /h10 /c /y8 hidden
vecho "You have pressed " /f %TCH% "CTRL-C" /f %TCF% "."
vecho
vecho "Are you sure you wish to abort the installation?"
vframe /w44 /h6 /c /y12 hidden
vecho "  Yes - Please return to DOS."
vecho "  No  - I want to continue."
vecho
if "%FADV%" == "" vecho "  No  - Switch to Advanced Mode." /n
if "%FADV%" == "y" vecho "  No  - Switch to Basic Mode." /n
vchoice /a %TCC% /d 2 Ctrl-C

if errorlevel 200 goto AbortBatch
if errorlevel 3 goto SwitchMode
if errorlevel 2 goto ContinueBatch
verrlvl 1
goto AbortBatch

:SwitchMode
verrlvl 0
if "%FADV%" == "y" goto SwitchBasic
set FADV=y
call STAGE200.BAT
call FDICLS.BAT
goto ContinueBatch

:SwitchBasic
verrlvl 0
set FADV=
call STAGE200.BAT
call FDICLS.BAT
goto ContinueBatch

:ContinueBatch
verrlvl 0
%1 %2 %3 %4 %5 %6 %7 %8 %9

:AbortBatch


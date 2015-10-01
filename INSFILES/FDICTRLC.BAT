@echo off

REM Control-C Handler
vcls /f %_SFG% /b %_SBG% /c %_SFC% /y2 /h24
vframe /f %_CFG% /b %_CBG% /w60 /h12 /c /y7 hidden shadow
vframe /f %_CFG% /b %_CBG% /w58 /h12 /c /y7 %_CBS%
vframe /f %_CFG% /b %_CBG% /w56 /h10 /c /y8 hidden
vecho "You have pressed " /f %_CHC% "CTRL-C" /f %_CFG% "."
vecho
vecho "Are you sure you wish to abort the installation?"
vframe /w44 /h6 /c /y12 hidden
vecho "  Yes - Please return to DOS."
vecho "  No  - I want to continue."
vecho
if "%FDI_ADVANCED%" == "" vecho "  No  - Switch to Advanced Mode." /n
if "%FDI_ADVANCED%" == "yes" vecho "  No  - Switch to Basic Mode." /n
vchoice /a %_CCS% /d 2 Ctrl-C

if errorlevel 200 goto AbortBatch
if errorlevel 3 goto SwitchMode
if errorlevel 2 goto ContinueBatch
verrlvl 1
goto AbortBatch

:SwitchMode
verrlvl 0
if "%FDI_ADVANCED%" == "yes" goto SwitchBasic
set FDI_ADVANCED=yes
call STAGE002.BAT
call FDICLS.BAT
goto ContinueBatch

:SwitchBasic
verrlvl 0
set FDI_ADVANCED=
call STAGE002.BAT
call FDICLS.BAT
goto ContinueBatch

:ContinueBatch
verrlvl 0
%1 %2 %3 %4 %5 %6 %7 %8 %9

:AbortBatch


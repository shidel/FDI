@echo off

REM Control-C Handler
vcls /f %FDI_SFG% /b %FDI_SBG% /c %FDI_SFC% /y2 /h24
vframe /f %FDI_CFG% /b %FDI_CBG% /w60 /h12 /c /y7 hidden shadow
vframe /f %FDI_CFG% /b %FDI_CBG% /w58 /h12 /c /y7 %FDI_CBS%
vframe /f %FDI_CFG% /b %FDI_CBG% /w56 /h10 /c /y8 hidden
vecho "You have pressed " /f %FDI_CHC% "CTRL-C" /f %FDI_CFG% "."
vecho
vecho "Are you sure you wish to abort the installation?"
vframe /w44 /h6 /c /y12 hidden
vecho /f %FDI_CCC% "  Yes " /f %FDI_CFG% "- Please return to DOS."
vecho /f %FDI_CAC% "  No  " /f %FDI_CFG% "- I want to continue."
vecho
if "%FDI_ADVANCED%" == "" vecho /f %FDI_CAC% "  No  " /f %FDI_CFG% "- Switch to Advanced Mode." /n
if "%FDI_ADVANCED%" == "yes" vecho /f %FDI_CAC% "  No  " /f %FDI_CFG% "- Switch to Basic Mode." /n
vchoice /a %FDI_CCS% /d 2 Ctrl-C

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
if errorlevel 1 goto AbortBatch
goto ContinueBatch

:SwitchBasic
verrlvl 0
set FDI_ADVANCED=
call STAGE002.BAT
if errorlevel 1 goto AbortBatch
goto ContinueBatch

:ContinueBatch
verrlvl 0
%1 %2 %3 %4 %5 %6 %7 %8 %9

:AbortBatch


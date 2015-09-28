@echo off

:ControlCPress
vcls /f %FDI_SFG% /b %FDI_SBG% /c %FDI_SFC% /y2 /h24
vframe /f %FDI_CFG% /b %FDI_CBG% /w60 /h10 /c /y7 hidden shadow
vframe /f %FDI_CFG% /b %FDI_CBG% /w58 /h10 /c /y7 %FDI_CBS%
vframe /f %FDI_CFG% /b %FDI_CBG% /w56 /h8 /c /y8 hidden
vecho "You have pressed " /f %FDI_CHC% "CTRL-C" /f %FDI_CFG% "."
vecho
vecho "Are you sure you wish to abort the installation?"
vframe /w44 /h4 /c /y12 hidden
vecho /f %FDI_CCC% "  Yes " /f %FDI_CFG% "- Please return to DOS."
vecho /f %FDI_CAC% "  No  " /f %FDI_CFG% "- I want to continue." /n
vchoice /a %FDI_CCS% /d 2 Ctrl-C

if errorlevel 200 goto AbortBatch
if errorlevel 2 goto ContinueBatch

verrlvl 1
goto AbortBatch

:ContinueBatch
verrlvl 0
%1

:AbortBatch


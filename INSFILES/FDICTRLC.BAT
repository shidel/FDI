@echo off

REM Clear entire screen.
vcls /f %FDI_SFG% /b %FDI_SBG% /c %FDI_SFC%

REM Draw the Title Bar
vgotoxy /x1 /y1
vcls /b %FDI_TBG% /f %FDI_TFG% EOL
vgotoxy /x30 /y1
vecho /f %FDI_TFG% "%OS_NAME% " /f  %FDI_THC% "%OS_VERSION%" /f %FDI_TFG% " Installer"

:ControlCPress
vcls /fGray /bBlue /y2 /h24
vframe /bRed /fWhite /w60 /h10 /c /y7 hidden shadow
vframe /bRed /fWhite /w58 /h10 /c /y7 single
vframe /bRed /fWhite /w56 /h8 /c /y8 hidden
vecho "You have pressed " /fYellow "CTRL-C" /fWhite "."
vecho
vecho "Are you sure you wish to abort the installation?"
vframe /w44 /h4 /c /y12 hidden
vecho /fLightMagenta "  Yes " /fGray "- Please return to DOS."
vecho /fLightGreen "  No  " /fGray "- I want to continue." /n
vchoice /fYellow /bBlue /d 2 Ctrl-C

if errorlevel 200 goto AbortBatch
if errorlevel 2 goto ContinueBatch

verrlvl 1
goto AbortBatch

:ContinueBatch
verrlvl 0
%1

:AbortBatch


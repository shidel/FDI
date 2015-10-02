@echo off

REM Transfer system files.

vcls 0x07
echo System file Transfer
vdleay 1000
verrlvl 0
goto AfterSysXfer

:BeginInstall
vcls /fWhite /bBlue /y2 /h24
vgotoxy down down
vecho /fGray "Transferring " /fLightGreen %OS_NAME% /fGray " boot files..."
vecho

REM **** Launch transfer system files ****
rem sys C:
REM **** Returned from transfering system files ****

set ReturnFromC=AfterSysXfer
vgotoxy eop sor
vecho /n /fLightGreen "Press a key... " /e
vpause /fLightCyan /t %PAUSING% CTRL-C
if errorlevel 200 goto ControlCPress

:AfterSysXfer

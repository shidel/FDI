@echo off

REM Welcome to the installer, continue or exit.

if "%1" == "Welcome" goto NoTitleClear

vcursor hide

call FDICLS.BAT
goto Welcome

:NoTitleClear
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24

:Welcome
REM Draw the welcome screen.
vframe /b %TFB% /f %TFF% /w60 /h10 /c /y7 hidden shadow
vframe /b %TFB% /f %TFF% /w58 /h10 /c /y7 %TFS%
vframe /b %TFB% /f %TFF% /w56 /h8 /c /y8 hidden
if "%FADV%" == "y" goto AdvancedMesssage
vecho /t %FLANG% HELLO %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
goto Spacer
:AdvancedMesssage
vecho /t %FLANG% HELLO_ADV %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
:Spacer
vecho
vecho /t %FLANG% PROCEED
vframe /b %TFB% /f %TFF% /w40 /h4 /c /y12 hidden
vecho /t %FLANG% YES
vecho /n /t %FLANG% NO
vchoice /a %TFC% Ctrl-C

if errorlevel 200 FDICTRLC.BAT %0 Welcome
if errorlevel 2 goto Done

verrlvl 0
goto Done

:Done
@echo off

REM Installation package selection.

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PAC_FRAME
vecho /t %FLANG% PACS? %TFH% %OS_NAME% %TFF%
vecho
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% PAC_OPTS
vecho /t %FLANG% PACBO
vecho /t %FLANG% PACBS
vecho
vecho /t %FLANG% PACAO
vecho /n /t %FLANG% PACAS
vchoice /a %TFC% Ctrl-C /d 3

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 4 goto OptAllSrc
if errorlevel 3 goto OptAll
if errorlevel 2 goto OptBasicSrc
if errorlevel 1 goto OptBasic

:OptBasic
set OALL=n
set OSRC=n
goto Done

:OptBasicSrc
set OALL=n
set OSRC=y
goto Done

:OptAll
set OALL=y
set OSRC=n
goto Done

:OptAllSrc
set OALL=y
set OSRC=y
goto Done

:Done
verrlvl 0

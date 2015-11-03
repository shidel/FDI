@echo off

REM Installation package selection.

call FDIWIND.BAT 11
vecho /t %FLANG% PACS? %TFH% %OS_NAME% %TFF%
vecho
call FDIOPTS.BAT 5
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

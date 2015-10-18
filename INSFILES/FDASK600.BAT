@echo off

REM if advanced mode prompt to replace system config files.

call FDIWIND.BAT 11
vecho "What " /f %TFH% %OS_NAME% /f %TFF% " packages do you want to install?"
vecho
call FDIOPTS.BAT 5
vecho "  Basic packages only."
vecho "  Basic packages with sources only."
vecho
vecho "  All the packages."
vecho "  All the packages and their sources." /n
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

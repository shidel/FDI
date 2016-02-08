@echo off

REM Installation package selection.

if exist %FINSP%\FDPLALL.LST goto HasAllPacs
if "%FADV%" == "y" goto BaseAdvOnly
set PF=PAC_FRAME_B
set PO=PAC_OPTS_B
goto PromptUser
:BaseAdvOnly
set PF=PAC_FRAME_BD
set PO=PAC_OPTS_BD
goto PromptUser
:HasAllPacs
if not exist %DOSDIR%\BIN\FDIMPLES.EXE goto AllOnly
if "%FADV%" == "y" goto AllAdv
:AllOnly
set PF=PAC_FRAME
set PO=PAC_OPTS
goto PromptUser
:AllAdv
set PF=PAC_FRAME_D
set PO=PAC_OPTS_D
goto PromptUser

:PromptUser
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% %PF%
vecho /t %FLANG% PACS? %TFH% %OS_NAME% %TFF%
vecho
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% %PO%
vecho /t %FLANG% PACBO
vecho /n /t %FLANG% PACBS
if not exist %FINSP%\FDPLALL.LST goto HasNoAll
vecho /p
vecho /t %FLANG% PACAO
vecho /n /t %FLANG% PACAS
:HasNoAll
if not exist %DOSDIR%\BIN\FDIMPLES.EXE goto NotAdv
if not "%FADV%" == "y" goto NotAdv
vecho /p
vecho /t %FLANG% PACDO_ADV
vecho /n /t %FLANG% PACDS_ADV
:NotAdv
vchoice /a %TFC% Ctrl-C /d 3

if errorlevel 200 FDICTRLC.BAT %0

if errorlevel 6 goto OptDetailedSrc
if errorlevel 5 goto OptDetailed

if not exist %FINSP%\FDPLALL.LST goto CheckOptShift
if errorlevel 4 goto OptAllSrc
if errorlevel 3 goto OptAll
goto CheckBase

:CheckOptShift
if errorlevel 4 goto OptDetailedSrc
if errorlevel 3 goto OptDetailed

:CheckBase
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

:OptDetailed
set OALL=?
set OSRC=n
%DOSDIR%\BIN\FDIMPLES.EXE
if errorlevel 200 FDICTRLC.BAT %0
goto Done

:OptDetailedSrc
set OALL=?
set OSRC=y
%DOSDIR%\BIN\FDIMPLES.EXE
if errorlevel 200 FDICTRLC.BAT %0
goto Done

:Done
set PF=
set PO=
verrlvl 0

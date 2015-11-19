@echo off

REM Check state of drive %FDRIVE% (C:), check if it needs partitioned.
REM If so, prompt to run partitioner then reboot.

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24

if not "%1" == "" goto %1

vinfo /d %FDRIVE%

if errorlevel 100 goto Done
if errorlevel 15 goto NoSuchDrive
if errorlevel 5 goto IgnoreThisError
if errorlevel 2 goto WrongTypeDrive

:IgnoreThisError
REM Drive C exists.
verrlvl 0
goto Done

:NoSuchDrive
:WrongTypeDrive
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% NOPART_FRAME
vecho /t %FLANG% NOPART %TFH% %FDRIVE% %TFF%
vecho
vecho /t %FLANG% PART?
vframe /b %TFB% /f %TFF% hidden /t %FLANG% NOPART_OPTS
vecho /t %FLANG% PART_YES %FDRIVE%
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 2

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

vcls /a0x07
if "%FCURSOR%" == "" vcursor small
if not "%FCURSOR%" == "" vcursor %FCURSOR%

REM **** Launch Partitioning Program ****
fdisk 1
REM **** Returned from Partitioning ****

vcursor hide
:AfterPartitioned
call FDICLS.BAT

vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PARTED_FRAME
vecho /t %FLANG% PARTED
vecho
vecho /t %FLANG% REBOOT?
vframe /b %TFB% /f %TFF% hidden /t %FLANG% PARTED_OPTS
vecho /t %FLANG% REBOOT_YES
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C

if errorlevel 200 FDICTRLC.BAT %0 AfterPartitioned
if errorlevel 2 goto AbortBatch

vcls /a0x07
vecho /t %FLANG% REBOOT
vecho
fdapm warmboot
set FREBOOT=y
goto AbortBatch

:AbortBatch
verrlvl 1

:Done
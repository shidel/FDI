@echo off

REM Check state of drive %FDRIVE% (C:), check if it needs partitioned.
REM If so, prompt to run partitioner then reboot.

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24

if not "%1" == "" goto %1

if not "%TEMP%" == "" goto FDiskTest

vinfo /d %FDRIVE%

if errorlevel 100 goto Done
if errorlevel 15 goto NoSuchDrive
if errorlevel 5 goto IgnoreThisError
if errorlevel 2 goto WrongTypeDrive

:IgnoreThisError
REM Drive C exists.
verrlvl 0
goto Done

:FDiskTest
fdisk /info 1 | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto IgnoreThisError
fdisk /info 2 | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto IgnoreThisError
fdisk /info 3 | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto IgnoreThisError
fdisk /info 4 | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto IgnoreThisError
fdisk /info 5 | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto IgnoreThisError
fdisk /info 6 | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto IgnoreThisError
fdisk /info 7 | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto IgnoreThisError
fdisk /info 8 | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto IgnoreThisError
goto NoSuchDrive

:NoSuchDrive
:WrongTypeDrive
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% NOPART_FRAME
vecho /t %FLANG% NOPART %TFH% %FDRIVE% %TFF%
vecho
vecho /t %FLANG% PART?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% NOPART_OPTS
vecho /t %FLANG% PART_YES %FDRIVE%
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 2

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

if "%FADV%" == "y" goto ManualPartition
if not "%TEMP%" == "" goto AutoPartition

:ManualPartition
verrlvl 0
vcls /a0x07
if "%FCURSOR%" == "" vcursor small
if not "%FCURSOR%" == "" vcursor %FCURSOR%

REM **** Launch Partitioning Program ****
if "%FDRIVE%" == "D:" fdisk 2
if not "%FDRIVE%" == "D:" fdisk 1
REM **** Returned from Partitioning ****

vcursor hide
goto AfterPartitioned

:AutoPartition
verrlvl 0

if "%FDRIVE%" == "D:" fdisk /info 2 | grep %>NUL
if not "%FDRIVE%" == "D:" fdisk /info 1 | grep %>NUL
if not errorlevel 1 goto ManualPartition

if "%FDRIVE%" == "D:" fdisk /auto 2>NUL
if not "%FDRIVE%" == "D:" fdisk /auto 1>NUL
if errorlevel 1 goto ManualPartition

if "%FDRIVE%" == "D:" fdisk /mbr 2>NUL
if not "%FDRIVE%" == "D:" fdisk /mbr 1>NUL
if errorlevel 1 goto ManualPartition

if "%FDRIVE%" == "D:" fdisk /activate:1 2>NUL
if not "%FDRIVE%" == "D:" fdisk /activate:1 1>NUL
if errorlevel 1 goto ManualPartition

:AfterPartitioned
call FDICLS.BAT

vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PARTED_FRAME
vecho /t %FLANG% PARTED
vecho
vecho /t %FLANG% REBOOT?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% PARTED_OPTS
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
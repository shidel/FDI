@echo off

REM Check state of drive %FDRIVE% (C:), check if it needs partitioned.
REM If so, prompt to run partitioner then reboot.

vinfo /m
if errorlevel 102 goto NotDOSBox
if errorlevel 101 goto IsDOSBox
:NotDOSBox
verrlvl 0

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24

if not "%1" == "" goto %1

if "%FDRAMDRV%" == "C:" goto FDiskTest
vfdutil /u %FDRIVE%\TEMP????.??? >NUL
if not errorlevel 1 goto Done

if not "%TEMP%" == "" goto FDiskTest

vinfo /d %FDRIVE%

if errorlevel 100 goto Done
if errorlevel 15 goto NoSuchDrive
if errorlevel 5 goto IgnoreThisError
if errorlevel 2 goto WrongTypeDrive

:IsDOSBox
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
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% NOPART_FRAME
vecho /k0 /t %FLANG% NOPART %TFH% %FDRIVE% %TFF%
vecho /k0
vecho /k0 /t %FLANG% PART?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% NOPART_OPTS
vecho /k0 /t %FLANG% PART_YES %FDRIVE%
vecho /k0 /n /t %FLANG% EXIT
vchoice /k0 /a %TFC% Ctrl-C /d 2

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
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PARTING_FRAME
vecho /k0 /n /t %FLANG% PARTING
vdelay %FDEL%

verrlvl 0

if "%FDRIVE%" == "D:" fdisk /info 2 | grep %>NUL
if not "%FDRIVE%" == "D:" fdisk /info 1 | grep %>NUL
if not errorlevel 1 goto ManualPartition

if "%FDRIVE%" == "D:" fdisk /auto 2>NUL
if not "%FDRIVE%" == "D:" fdisk /auto 1>NUL
if errorlevel 1 goto ManualPartition

vdelay %FDEL%

:AfterPartitioned
call FDICLS.BAT

vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PARTED_FRAME
vecho /k0 /t %FLANG% PARTED
vecho
vecho /k0 /t %FLANG% REBOOT?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% PARTED_OPTS
vecho /k0 /t %FLANG% REBOOT_YES
vecho /k0 /n /t %FLANG% EXIT
vchoice /k0 /a %TFC% Ctrl-C

if errorlevel 200 FDICTRLC.BAT %0 AfterPartitioned
if errorlevel 2 goto AbortBatch

vcls /a0x07
vecho /k0 /t %FLANG% REBOOT
vecho
fdapm warmboot
set FREBOOT=y
goto AbortBatch

:AbortBatch
verrlvl 1

:Done
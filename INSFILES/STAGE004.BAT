@echo off

REM Check state of drive C:, check if it needs partitioned.
REM If so, prompt to run partitioner then reboot.

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24

if not "%1" == "" goto %1

vinfo /dC

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
vframe /b %TFB% /f %TFF% /w60 /h10 /c /y7 hidden shadow
vframe /b %TFB% /f %TFF% /w58 /h10 /c /y7 %TFS%
vframe /b %TFB% /f %TFF% /w56 /h8 /c /y8 hidden
vecho "Drive " /f  %TFH% C: /f %TFF% " does not appear to be partitioned."
vecho
vecho "Do you wish to partition your drive?"
vframe /b %TFB% /f %TFF% /w40 /h4 /c /y12 hidden
vecho "  Yes - Launch Partitioner."
vecho "  No  - Return to DOS" /n
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

vframe /b %TFB% /f %TFF% /w60 /h11 /c /y7 hidden shadow
vframe /b %TFB% /f %TFF% /w58 /h11 /c /y7 %TFS%
vframe /b %TFB% /f %TFF% /w56 /h9 /c /y8 hidden
vecho /n "You must reboot your computer for the new partitioning"
vecho "scheme to take effect."
vecho
vecho "Do you wish to reboot now?"
vframe /b %TFB% /f %TFF% /w40 /h4 /c /y13 hidden
vecho "  Yes - Please reboot now."
vecho "  No  - Return to DOS" /n
vchoice /a %TFC% Ctrl-C

if errorlevel 200 FDICTRLC.BAT %0 AfterPartitioned
if errorlevel 2 goto AbortBatch

vcls /a0x07
vecho "The computer will now reboot."
vecho
reboot
goto AbortBatch

:AbortBatch
verrlvl 1

:Done
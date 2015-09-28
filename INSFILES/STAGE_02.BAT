@echo off

vcls /f %FDI_SFG% /b %FDI_SBG% /c %FDI_SFC% /y2 /h24

if not "%1" == "" goto %1

REM Check state of drive C:, check if it needs partitioned.
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
vframe /b %FDI_FBG% /f %FDI_FFG% /w60 /h10 /c /y7 hidden shadow
vframe /b %FDI_FBG% /f %FDI_FFG% /w58 /h10 /c /y7 %FDI_FBS%
vframe /b %FDI_FBG% /f %FDI_FFG% /w56 /h8 /c /y8 hidden
vecho "Drive " /f  %FDI_FHC% C /f %FDI_FFG% " does not appear to be partitioned."
vecho
vecho "Do you wish to partition your drive?"
vframe /b %FDI_FBG% /f %FDI_FFG% /w40 /h4 /c /y12 hidden
vecho /f %FDI_CYC% "  Yes " /f %FDI_FFG% "- Launch Partitioner."
vecho /f %FDI_CNC% "  No  " /f %FDI_FFG% "- Return to DOS" /n
vchoice /a %FDI_FCS% Ctrl-C /d 2

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

vcls /a0x07
vcursor %FDI_CURSOR%

REM **** Launch Partitioning Program ****
fdisk 1
REM **** Returned from Partitioning ****

vcursor hide
:AfterPartitioned
call FDICLS.BAT

vframe /b %FDI_FBG% /f %FDI_FFG% /w60 /h11 /c /y7 hidden shadow
vframe /b %FDI_FBG% /f %FDI_FFG% /w58 /h11 /c /y7 %FDI_FBS%
vframe /b %FDI_FBG% /f %FDI_FFG% /w56 /h9 /c /y8 hidden
vecho /n "You must reboot your computer for the new partitioning"
vecho "scheme to take effect."
vecho
vecho "Do you wish to reboot now?"
vframe /b %FDI_FBG% /f %FDI_FFG% /w40 /h4 /c /y13 hidden
vecho /f %FDI_CYC% "  Yes " /f %FDI_FFG% "- Please reboot now."
vecho /f %FDI_FCS% "  No  " /f %FDI_FFG% "- Return to DOS" /n
vchoice /a %FDI_FCS% Ctrl-C

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
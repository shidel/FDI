@echo off

REM Check state of drive C:, check if it needs formatted.
REM If so, prompt to run format, then retest. If fails again,
REM prompt to reboot.

vcls /f %FDI_SFG% /b %FDI_SBG% /c %FDI_SFC% /y2 /h24

if not "%1" == "" goto %1

vinfo /dC

if errorlevel 5 goto NotFormatted
if errorlevel 2 goto WrongTypeDrive

REM Drive C is formatted.
verrlvl 0
goto Done

:WrongTypeDrive
goto Done

:NotFormatted
vframe /b %FDI_FBG% /f %FDI_FFG% /w60 /h10 /c /y7 hidden shadow
vframe /b %FDI_FBG% /f %FDI_FFG% /w58 /h10 /c /y7 %FDI_FBS%
vframe /b %FDI_FBG% /f %FDI_FFG% /w56 /h8 /c /y8 hidden
vecho "Drive " /f %FDI_FHC% C /f %FDI_FFG% " does not appear to be formatted."
vecho
vecho "Do you wish to format your drive?"
vframe /b %FDI_FBG% /f %FDI_FFG% /w44 /h4 /c /y12 hidden
vecho /f %FDI_CYC% "  Yes " /f %FDI_FFG% "- Please erase and format drive C."
vecho /f %FDI_CNC% "  No  " /f %FDI_FFG% "- Return to DOS" /n
vchoice /a %FDI_FCS% Ctrl-C /d 2

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

vcls /f %FDI_SFG% /b %FDI_SBG% /y2 /h24
vgotoxy down
vecho /fGray "Formatting drive " /fWhite C /fGray "..."
vecho
vcursor %FDI_CURSOR%

REM **** Launch Formatting Program ****
format C: /V:%FDI_VOLUME% %FDI_FORMAT%
REM **** Returned from Formatting ****

set FDI_DIDFMT=YES

vcursor hide
vgotoxy eop sor
vecho /n /fLightGreen " Press a key... " /e
vpause /fLightCyan /t %FDI_PAUSE% CTRL-C

if errorlevel 200 FDICTRLC.BAT %0 AfterFormat

:AfterFormat
vinfo /dC

REM **** May want to say, we still cannot read C and offer to reboot. ****
if errorlevel 2 goto StillCannotReadC

verrlvl 0
goto Done

:StillCannotReadC

vframe /b %FDI_FBG% /f %FDI_FFG% /w60 /h11 /c /y7 hidden shadow
vframe /b %FDI_FBG% /f %FDI_FFG% /w58 /h11 /c /y7 %FDI_FBS%
vframe /b %FDI_FBG% /f %FDI_FFG% /w56 /h9 /c /y8 hidden
vecho /n "Having a problem reading Drive " /f %FDI_FHC% C /f %FDI_FFG% "."
vecho "A system reboot may help."
vecho
vecho "Do you wish to reboot now?"
vframe /b %FDI_FBG% /f %FDI_FFG% /w40 /h4 /c /y13 hidden
vecho /f %FDI_CYC% "  Yes " /f %FDI_FFG% "- Please reboot now."
vecho /f %FDI_FCS% "  No  " /f %FDI_FFG% "- Return to DOS" /n
vchoice /a %FDI_FCS% Ctrl-C

if errorlevel 200 FDICTRLC.BAT %0 StillCannotReadC
if errorlevel 2 goto AbortBatch
vcls /a0x07
vecho "The computer will now reboot."
vecho
reboot
goto AbortBatch

:AbortBatch
verrlvl 1

:Done
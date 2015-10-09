@echo off

REM Check state of drive C:, check if it needs formatted.
REM If so, prompt to run format, then retest. If fails again,
REM prompt to reboot.

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24

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
vframe /b %TFB% /f %TFF% /w60 /h10 /c /y7 hidden shadow
vframe /b %TFB% /f %TFF% /w58 /h10 /c /y7 %TFS%
vframe /b %TFB% /f %TFF% /w56 /h8 /c /y8 hidden
vecho "Drive " /f %TFH% C /f %TFF% " does not appear to be formatted."
vecho
vecho "Do you wish to format your drive?"
vframe /b %TFB% /f %TFF% /w44 /h4 /c /y12 hidden
vecho "  Yes - Please erase and format drive C."
vecho "  No  - Return to DOS" /n
vchoice /a %TFC% Ctrl-C /d 2

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

vcls /f %TSF% /b %TSB% /y2 /h24
vgotoxy down
vecho /fGray "Formatting drive " /fWhite C /fGray "..."
vecho
if "%FCURSOR%" == "" vcursor small
if not "%FCURSOR%" == "" vcursor %FCURSOR%

REM **** Launch Formatting Program ****
format C: /V:%OVOL% %FFMT%
REM **** Returned from Formatting ****

set FDIDFMT=y

vcursor hide
vgotoxy eop sor
vecho /n /fLightGreen " Press a key... " /e
vpause /fLightCyan /t %FWAIT% CTRL-C

if errorlevel 200 FDICTRLC.BAT %0 AfterFormat

:AfterFormat
vinfo /dC

REM **** May want to say, we still cannot read C and offer to reboot. ****
if errorlevel 2 goto StillCannotReadC

verrlvl 0
goto Done

:StillCannotReadC
set FERROR="Unable to read drive C: after format."
call FDIFAIL.BAT "Having a problem reading drive " /f %TFH% C: /f %TFF% "."

:AbortBatch
verrlvl 1

:Done
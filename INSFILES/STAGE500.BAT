@echo off

REM Check state of drive %FDRIVE% (C:), check if it needs formatted.
REM If so, prompt to run format, then retest. If fails again,
REM prompt to reboot.

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24

if not "%1" == "" goto %1

vinfo /d %FDRIVE%

if errorlevel 5 goto NotFormatted
if errorlevel 2 goto WrongTypeDrive

REM Drive %FDRIVE% is formatted.
verrlvl 0
goto Done

:WrongTypeDrive
goto Done

:NotFormatted
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% NOFORMAT_FRAME
vecho /t %FLANG% NOFORMAT %TFH% %FDRIVE% %TFF%
vecho
vecho /t %FLANG% FORMAT?
vframe /b %TFB% /f %TFF% hidden /t %FLANG% NOFORMAT_OPTS
vecho /t %FLANG% FORMAT_YES %FDRIVE%
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 2

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

vcls /f %TSF% /b %TSB% /y2 /h24
vgotoxy down
vecho /t %FLANG% FORMATTING %FDRIVE%
vecho
if "%FCURSOR%" == "" vcursor small
if not "%FCURSOR%" == "" vcursor %FCURSOR%

REM **** Launch Formatting Program ****
format %FDRIVE% /V:%OVOL% %FFMT%
REM **** Returned from Formatting ****

set FDIDFMT=y

vcursor hide
vgotoxy eop sor
vecho /n /t %FLANG% PAUSE
vpause /fLightCyan /t %FWAIT% CTRL-C

if errorlevel 200 FDICTRLC.BAT %0 AfterFormat

:AfterFormat
vinfo /d %FDRIVE%

REM **** May want to say, we still cannot read C and offer to reboot. ****
if errorlevel 2 goto StillCannotReadC

verrlvl 0
goto Done

:StillCannotReadC
set FERROR="Unable to read drive %FDRIVE% after format."
call FDIFAIL.BAT ERROR_READC

:AbortBatch
verrlvl 1

:Done
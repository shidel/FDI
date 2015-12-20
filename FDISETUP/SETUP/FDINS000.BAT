@echo off

REM Debug mode only. To display current environment variables.

if not "%FDEBUG%" == "y" goto NoDebugInfo

vcls /a 0x07
set | more
vgotoxy eop sor
vecho /n /t %FLANG% PRESSKEY
vpause /t 30

call FDICLS.BAT

:NoDebugInfo
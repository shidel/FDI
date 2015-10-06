@echo off

if not "%FDEBUG%" == "y" goto NoDebugInfo

vcls /a 0x07
set | more
vgotoxy eop sor
vecho "Press a key..." /n
vpause /t 30

call FDICLS

:NoDebugInfo
@echo off

if not "%FINSP%" == "" vfdutil /c/p %FINSP%\

call FDICLS.BAT

vframe /b %TFB% /f %TFF% /w74 /h11 /c /y7 hidden shadow
vframe /b %TFB% /f %TFF% /w72 /h11 /c /y7 %TFS%
vframe /b %TFB% /f %TFF% /w70 /h9 /c /y8 hidden
vecho "%1 %2 %3 %4 %5 %6 %7 %8"
vecho "A reboot may help."
vecho
vecho "Do you wish to reboot now?"
vframe /b %TFB% /f %TFF% /w40 /h4 /c /y13 hidden
vecho "  Yes - Please reboot now."
vecho "  No  - Return to DOS" /n
vchoice /a %TFC% Ctrl-C

if errorlevel 200 FDIFAIL.BAT %0 %1 %2 %3 %4 %5 %6 %7 %8
if errorlevel 2 goto AbortBatch
vcls /a0x07
vecho "The computer will now reboot."
vecho
reboot
goto AbortBatch

:AbortBatch
verrlvl 1


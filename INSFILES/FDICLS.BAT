@echo off

REM Clear entire screen.
vcls /f %TSF% /b %TSB% /c %TSC%

REM Draw the Title Bar
vgotoxy /x1 /y1
vcls /b %TTB% /f %TTF% EOL
vgotoxy /x30 /y1
vecho /f %TTF% "%OS_NAME% " /f  %TTH% "%OS_VERSION%" /f %TTF% " Installer"

@echo off

REM Clear entire screen (Minus title bar)

vcls /g /f %TSF% /b %TSB% /c %TSC% /y2 /h24

REM Draw the Title Bar
vgotoxy /g /x1 /y1
vcls /b %TTB% /f %TTF% EOL
vgotoxy /x30 /y1
vecho /k0 /t %FLANG% TITLE %TTF% "%OS_NAME%" %TTH% "%OS_VERSION%"

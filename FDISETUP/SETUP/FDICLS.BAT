@echo off

REM Clear entire screen (Minus title bar)

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24

REM Draw the Title Bar
vgotoxy /x1 /y1
vcls /b %TTB% /f %TTF% EOL
vgotoxy /x30 /y1
vecho /t %FLANG% TITLE %TTF% "%OS_NAME%" %TTH% "%OS_VERSION%"

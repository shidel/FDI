@echo off

REM Clear entire screen.
vcls /f %_SFG% /b %_SBG% /c %_SFC%

REM Draw the Title Bar
vgotoxy /x1 /y1
vcls /b %_TBG% /f %_TFG% EOL
vgotoxy /x30 /y1
vecho /f %_TFG% "%OS_NAME% " /f  %_THC% "%OS_VERSION%" /f %_TFG% " Installer"

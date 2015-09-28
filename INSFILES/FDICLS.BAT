@echo off

REM Clear entire screen.
vcls /f %FDI_SFG% /b %FDI_SBG% /c %FDI_SFC%

REM Draw the Title Bar
vgotoxy /x1 /y1
vcls /b %FDI_TBG% /f %FDI_TFG% EOL
vgotoxy /x30 /y1
vecho /f %FDI_TFG% "%OS_NAME% " /f  %FDI_THC% "%OS_VERSION%" /f %FDI_TFG% " Installer"

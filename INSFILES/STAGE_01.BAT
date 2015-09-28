@echo off

:MainPrompt
call FDICLS.BAT

REM Draw the welcome screen.
vframe /b %FDI_FBG% /f %FDI_FFG% /w60 /h10 /c /y7 hidden shadow
vframe /b %FDI_FBG% /f %FDI_FFG% /w58 /h10 /c /y7 %FDI_FBS%
vframe /b %FDI_FBG% /f %FDI_FFG% /w56 /h8 /c /y8 hidden
vecho "Welcome to the installation program for " /f %FDI_FHC% "%OS_NAME% %OS_VERSION%" /f %FDI_FFG% "."
vecho
vecho "Do you wish to proceed?"
vframe /w40 /h4 /c /y12 hidden
vecho /f %FDI_CYC% "  Yes " /f %FDI_FFG% "- Continue with Installation"
vecho /f %FDI_CNC% "  No  " /f %FDI_FFG% "- Return to DOS" /n
vchoice /a %FDI_FCS% Ctrl-C

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto Done

verrlvl 0
goto Done

:Done
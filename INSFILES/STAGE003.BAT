@echo off

REM Welcome to the installer, continue or exit.

vcursor hide

call FDICLS.BAT

REM Draw the welcome screen.
vframe /b %_FBG% /f %_FFG% /w60 /h10 /c /y7 hidden shadow
vframe /b %_FBG% /f %_FFG% /w58 /h10 /c /y7 %_FBS%
vframe /b %_FBG% /f %_FFG% /w56 /h8 /c /y8 hidden
if "%FDI_ADVANCED%" == "yes" goto AdvancedMesssage
vecho "Welcome to the installation program for " /f %_FHC% "%OS_NAME% %OS_VERSION%" /f %_FFG% "."
goto Spacer
:AdvancedMesssage
vecho "Welcome to the advanced installer for " /f %_FHC% "%OS_NAME% %OS_VERSION%" /f %_FFG% "."
:Spacer
vecho
vecho "Do you wish to proceed?"
vframe /b %_FBG% /f %_FFG% /w40 /h4 /c /y12 hidden
vecho "  Yes - Continue with Installation"
vecho "  No  - Return to DOS" /n
vchoice /a %_FCS% Ctrl-C

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto Done

verrlvl 0
goto Done

:Done
@echo off

REM Thank the user for installing and offer to reboot.

call FDICLEAN.BAT TEMPONLY
if "%TEMP%" == "" goto NoTemp
if not exist %TEMP%\NUL goto NoTemp
goto HasTemp
:NoTemp
set TEMP=%FTARGET%\TEMP
if not exist %TEMP%\NUL mkdir %TEMP% >NUL
:HasTemp
call FDICLS.BAT
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% COMPLETE_FRAME
vecho /t %FLANG% COMPLETE %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
vecho
vecho /t %FLANG% REBOOT?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% COMPLETE_OPTS
vecho /t %FLANG% REBOOT_YES
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 1 postal 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto NoRestart

set FREBOOT=y
goto Done

:NoRestart
set FREBOOT=n

:Done
verrlvl 0


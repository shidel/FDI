@echo off

REM Control-C Handler

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TCB% /f %TCF% %TCS% textbox /t %FLANG% CTRLC_FRAME
vecho /k0 /t %FLANG% CTRLC %TCH% %TCF%
vecho /k0
vecho /k0 /t %FLANG% CTRLC?
vframe /p0 /b %TCB% /f %TCF% optionbox /t %FLANG% CTRLC_OPTS
vecho /k0 /t %FLANG% CTRLCY
vecho /k0 /t %FLANG% CTRLCN
vecho /k0
if "%FADV%" == "" vecho /k0 /n /t %FLANG% CTRLCA
if "%FADV%" == "y" vecho /k0 /n /t %FLANG% CTRLCB

vchoice /k0 /a %TCC% /d 2 Ctrl-C

if errorlevel 200 goto AbortBatch
if errorlevel 3 goto SwitchMode
if errorlevel 2 goto ContinueBatch
verrlvl 1
goto AbortBatch

:SwitchMode
verrlvl 0
if "%FADV%" == "y" goto SwitchBasic
set FADV=y
call STAGE200.BAT
call FDICLS.BAT
goto ContinueBatch

:SwitchBasic
verrlvl 0
set FADV=
call STAGE200.BAT
call FDICLS.BAT
goto ContinueBatch

:ContinueBatch
verrlvl 0
%1 %2 %3 %4 %5 %6 %7 %8 %9

:AbortBatch

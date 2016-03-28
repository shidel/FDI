@echo off

REM Control-C Handler

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TCB% /f %TCF% %TCS% textbox /t %FLANG% CTRLC_FRAME
vecho /t %FLANG% CTRLC %TCH% %TCF%
vecho
vecho /t %FLANG% CTRLC?
vframe /b %TCB% /f %TCF% optionbox /t %FLANG% CTRLC_OPTS
vecho /t %FLANG% CTRLCY
vecho /t %FLANG% CTRLCN
vecho
if "%FADV%" == "" vecho /n /t %FLANG% CTRLCA
if "%FADV%" == "y" vecho /n /t %FLANG% CTRLCB

vchoice /a %TCC% /d 2 Ctrl-C

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

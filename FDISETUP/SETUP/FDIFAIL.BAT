@echo off

REM Display error message box. Option to Exit or reboot.
REM In advanced mode, it may also provide a Ignore and continue option.

if not "%FINSP%" == "" vfdutil /c/p %FINSP%\

call FDICLS.BAT

if not "%FADV%" == "y" goto NoContinue

if "%1" == "cc" goto CanContinue

:NoContinue

vframe /p0 /b %TCB% /f %TCF% %TCS% textbox /t %FLANG% FAIL_FRAME
if "%1" == "cc" goto SkipFirstA
vecho /k0 /t %FLANG% %1 %2 %3 %4 %5 %6 %7 %8
goto AfterSkipA
:SkipFirstA
vecho /k0 /t %FLANG% %2 %3 %4 %5 %6 %7 %8
:AfterSkipA
vecho /k0 /t %FLANG% FAILH
vecho /k0
vecho /k0 /t %FLANG% FAIL?
vframe /p0 /b %TCB% /f %TCF% optionbox /t %FLANG% FAIL_OPTS
vecho /k0 /t %FLANG% FAILY
vecho /k0 /n /t %FLANG% FAILN
vchoice /k0 /a %TFC% Ctrl-C

if errorlevel 200 goto CtrlCPress
if errorlevel 2 goto AbortBatch
goto DoReboot

:CanContinue
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% FAILADV_FRAME
vecho /k0 /t %FLANG% %2 %3 %4 %5 %6 %7 %8
vecho /k0 /t %FLANG% FAILH
vecho /k0
vecho /k0 /t %FLANG% FAIL?
vframe /p0 /b %TCB% /f %TCF% optionbox /t %FLANG% FAILADV_OPTS
vecho /k0 /t %FLANG% FAILY
vecho /k0 /t %FLANG% FAILN
vecho /k0
vecho /k0 /n /t %FLANG% FAILI
vchoice /k0 /a %TFC% Ctrl-C

if errorlevel 200 goto CtrlCPress
if errorlevel 3 goto ContinueAnyway
if errorlevel 2 goto AbortBatch

:DoReboot
vcls /a0x07
vecho /k0 /t %FLANG% FAILR
vecho /k0
fdapm warmboot
set FREBOOT=y
goto AbortBatch

:CtrlCPress
FDICTRLC.BAT %0 %1 %2 %3 %4 %5 %6 %7 %8

:AbortBatch
verrlvl 1
goto Done

:ContinueAnyway
set FERROR=
verrlvl 0
goto Done

:Done
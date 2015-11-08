@echo off

if not "%FINSP%" == "" vfdutil /c/p %FINSP%\

call FDICLS.BAT

set TLANG=%FLANG%
call FDILANG.BAT FDSETUP

if not "%FADV%" == "y" goto NoContinue

if "%1" == "cc" goto CanContinue

:NoContinue

vframe /b %TFB% /f %TFF% /w74 /h11 /c /y7 hidden shadow
vframe /b %TFB% /f %TFF% /w72 /h11 /c /y7 %TFS%
vframe /b %TFB% /f %TFF% /w70 /h9 /c /y8 hidden
if "%1" == "cc" goto SkipFirstA
vecho /t %FLANG% %1 %2 %3 %4 %5 %6 %7 %8
goto AfterSkipA
:SkipFirstA
vecho /t %FLANG% %2 %3 %4 %5 %6 %7 %8
:AfterSkipA
vecho /t %FLANG% FAILH
vecho
vecho /t %FLANG% FAIL?
vframe /b %TFB% /f %TFF% /w40 /h4 /c /y13 hidden
vecho /t %FLANG% FAILY
vecho /n /t %FLANG% FAILN
vchoice /a %TFC% Ctrl-C

if errorlevel 200 goto CtrlCPress
if errorlevel 2 goto AbortBatch
goto DoReboot

:CanContinue
vframe /b %TFB% /f %TFF% /w74 /h13 /c /y7 hidden shadow
vframe /b %TFB% /f %TFF% /w72 /h13 /c /y7 %TFS%
vframe /b %TFB% /f %TFF% /w70 /h11 /c /y8 hidden
vecho /t %FLANG% %2 %3 %4 %5 %6 %7 %8
vecho /t %FLANG% FAILH
vecho
vecho /t %FLANG% FAIL?
vframe /b %TFB% /f %TFF% /w40 /h6 /c /y13 hidden
vecho /t %FLANG% FAILY
vecho /t %FLANG% FAILN
vecho
vecho /n /t %FLANG% FAILI
vchoice /a %TFC% Ctrl-C

if errorlevel 200 CtrlCPress
if errorlevel 3 goto ContinueAnyway
if errorlevel 2 goto AbortBatch

:DoReboot
vcls /a0x07
vecho /t %FLANG% FAILR
vecho
reboot
goto AbortBatch

:CtrlCPress
set FLANG=%TLANG%
set TLANG=
FDICTRLC.BAT %0 %1 %2 %3 %4 %5 %6 %7 %8

:AbortBatch
verrlvl 1
goto Done

:ContinueAnyway
set FERROR=
verrlvl 0
goto Done

:Done
set FLANG=%TLANG%
set TLANG=

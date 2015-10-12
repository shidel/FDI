@echo off

call FDIWIND.BAT 7
vecho /n "Installing software package"
vgotoxy /l eop sor
vprogres /f %TFP% 0

if not exist %FTARGET%\NUL mkdir %FTARGET%
if errorlevel 1 goto AbortDir

REM Run through all binaries to be installed.
set _PI=0

REM For some reason, DOS sometimes fails to do this correctly on the first try.
REM So, make sure it is ready before moving on.
:BinSticky
type %OPBIN% | vstr /l %_PI% | set /p _PA=
if "%_PA%" == "" goto BinSticky
type %OPBIN% | vstr /l TOTAL | set /p _PM=
if "%_PM%" == "0" goto BinDone

:BinLoop
type %OPBIN% | vstr /l %_PI% | set /p _PA=
vmath %_PI% mul 100 div %_PM% | set /p _PP=
verrlvl 0
if "%_PA%" == "" goto BinSkip
if not exist %FMEDIA%\%_PA%.zip goto BinSkip
vgotoxy /l sop /x 29
vecho "'" /f %TFH% %_PA% /f %TFF% "'" /e /n

vfdutil /c/p %FTARGET%\
verrlvl 0
unzip -qq -o %FMEDIA%\%_PA%.zip >NUL
if errorlevel 1 goto BinError
vfdutil /c/p %FINSP%\

:BinSkip
vgotoxy /l eop sor
vprogres /f %TFP% %_PP%
if "%_PI%" == "%_PM%" goto BinDone
vmath %_PI% + 1 | set /p _PI=
goto BinLoop

:BinError
echo unzip -qq -o %FMEDIA%\%_PA%.zip
vdelay 4000
vfdutil /c/p %FINSP%\
verrlvl 1
goto Done

:BinDone
vdelay %FDEL%

if not "%OSRC%" == "y" goto Success

goto Success

:AbortDir
set FERROR="Unable to create %FTARGET% directory."
call %FINSP%\FDIFAIL.BAT "Unable to create %FTARGET% directory."
goto Done

:AbortBin
set FERROR="Unable to install %_PA% package."
call %FINSP%\FDIFAIL.BAT "Unable to install the %_PA% package."
goto Done

:AbortSrc
set FERROR="Unable to install %_PA% source."
call %FINSP%\FDIFAIL.BAT "Unable to install the %_PA% source."
goto Done

:Success
verrlvl 0

:Done
set _PA=
set _PI=
set _PP=
set _PM=
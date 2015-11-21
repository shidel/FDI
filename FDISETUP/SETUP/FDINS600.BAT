@echo off

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PAC_FRAME
vecho /n /t %FLANG% PACBM
vgotoxy /l eop sor
vprogres /f %TFP% 0

if not exist %FTARGET%\NUL mkdir %FTARGET%
if errorlevel 1 goto AbortDir

REM Restore Preserved Package Data and FreeDOS files if Present
if not exist %TEMP%\SAVED\NUL goto :NoSavedData
xcopy /E %TEMP%\SAVED\*.* %FTARGET%\ >NUL
verrlvl 0

:NoSavedData
REM Run through all binaries to be installed.
set _PI=0

REM For some reason, DOS sometimes fails to do this correctly on the first try.
REM So, make sure it is ready before moving on.
:PkgSticky
type %FPKGS% | vstr /l %_PI% | set /p _PA=
if "%_PA%" == "" goto PkgSticky
type %FPKGS% | vstr /l TOTAL | set /p _PM=
if "%_PM%" == "0" goto PkgDone

:PkgLoop
type %FPKGS% | vstr /l %_PI% | set /p _PA=
vmath %_PI% mul 100 div %_PM% | set /p _PP=
verrlvl 0
if "%_PA%" == "" goto PkgSkip
rem if not exist %FMEDIA%\%_PA%.zip goto PkgSkip
vgotoxy /l sop
vecho /e /n /t %FLANG% PACBI %TFH% %_PA% %TFF%

vfdutil /c/p %FTARGET%\
verrlvl 0
call %FINSP%\FDIPKG.BAT %_PA%
if errorlevel 1 goto PkgError
vfdutil /c/p %FINSP%\

:PkgSkip
vgotoxy /l eop sor
vprogres /f %TFP% %_PP%
if "%_PI%" == "%_PM%" goto PkgDone
vmath %_PI% + 1 | set /p _PI=
goto PkgLoop

:PkgError
vfdutil /c/p %FINSP%\
verrlvl 1
goto AbortPkg

:PkgDone
vdelay %FDEL%
goto Success

:AbortDir
set FERROR="Unable to create %FTARGET% directory."
call %FINSP%\FDIFAIL.BAT ERROR_MKDOS %FTARGET%
goto Done

:AbortPkg
set FERROR="Unable to install '%_PA%' package."
call %FINSP%\FDIFAIL.BAT cc ERROR_PACKAGE %_PA%
if errorlevel 1 goto Done
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PAC_FRAME
vecho /n /t %FLANG% PACBM
goto PkgSkip

:Success
if not exist %FTARGET%\TEMP\NUL mkdir %FTARGET%\TEMP
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PACDONE_FRAME
vecho /n /t %FLANG% PACDONE
vdelay %FDEL%
verrlvl 0

:Done
set _PA=
set _PI=
set _PP=
set _PM=
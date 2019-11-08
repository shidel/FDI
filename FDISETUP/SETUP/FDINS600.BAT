@echo off

REM Install Packages.
if "%FDEBUG%" == "y" call FDBUG.BAT shell Immediately before package installation

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IPAC_FRAME
vecho /n /t %FLANG% IPACBM
vgotoxy /l eop sor
vprogres /f %TFP% 0

if not exist %FTARGET%\NUL mkdir %FTARGET%
if errorlevel 1 goto AbortDir
if not exist %FTARGET%\TEMP\NUL mkdir %FTARGET%\TEMP >NUL
if errorlevel 1 goto AbortDir
if not exist %FTARGET%\PACKAGES\NUL mkdir %FTARGET%\PACKAGES >NUL
if errorlevel 1 goto AbortDir

REM Run through all binaries to be installed.
set _PI=0

REM For some reason, DOS sometimes fails to do this correctly on the first try.
REM So, make sure it is ready before moving on.
:PkgSticky
type %FPKGS% | grep -iv ^; | vstr /b/l total | set /p _PM=
if "%_PM%" == "" goto PkgSticky

:PkgLoop
type %FPKGS% | grep -iv ^; | vstr /b/l %_PI% | set /p _PA=
if "%_PA%" == "" goto PkgLoop

vgotoxy /l sop
vecho /n /t %FLANG% IPACBI %TFH% %_PA% %TFF%
vecho /f %TFF% /e /n

vfdutil /c/p %FTARGET%\
verrlvl 0
call %FINSP%\FDIPKG.BAT %_PA%
if errorlevel 1 goto PkgError
vfdutil /c/p %FINSP%\

:PkgSkip
vgotoxy /l eop sor
vprogres /f %TFP% %_PI% of %_PM%

:PkgIncSticky
set _PT=
set /e _PT=vmath %_PI% + 1
if "%_PT%" == "" goto PkgIncSticky
set _PI=%_PT%
set _PT=

if "%_PI%" == "%_PM%" goto PkgDone
goto PkgLoop

:PkgError
vfdutil /c/p %FINSP%\
verrlvl 1
goto AbortPkg

:PkgDone

if "%FDNVER%" == "v0.99.5" goto OldFDINST
goto LinksDone

:OldFDINST
REM After FDNPKG v0.99.5 Links are no longer batch files. They are COMs.

REM Adjust Links if needed.
if "%FDRIVE%" == "C:" goto LinksDone

if not exist %FTARGET%\LINKS\NUL goto LinksDone

:LinksSticky
dir /on /a /b /p- %FTARGET%\LINKS\*.BAT | vstr /b/l TOTAL | set /p _PM=
if "%_PM%" == "" goto PkgSticky
if "%_PM%" == "0" goto LinksDone

set _PI=0
:LinksLoop
dir /on /a /b /p- %FTARGET%\LINKS\*.BAT | vstr /b/l %_PI% | set /p _PA=
if "%_PA%" == "" goto LinksLoop
if not exist %FTARGET%\LINKS\%_PA% goto LinkSkip

grep ^%FDRIVE% %FTARGET%\LINKS\%_PA% >NUL
if errorlevel 1 goto LinkSkip

type %FTARGET%\LINKS\%_PA% | vstr /s %FDRIVE% C:>%TEMP%\LINK.TMP
copy /y %TEMP%\LINK.TMP %FTARGET%\LINKS\%_PA% >NUL
del %TEMP%\LINK.TMP >NUL

:LinkSkip
set _PT=
set /e _PT=vmath %_PI% + 1
if "%_PT%" == "" goto LinkSkip
set _PI=%_PT%
set _PT=
if not "%_PI%" == "%_PM%" goto LinksLoop

:LinksDone
vgotoxy /l eop sor
vprogres /f %TFP% 100
vdelay %FDEL%

REM Restore Preserved Package Data and FreeDOS files if Present
if "%FPBAK%" == "" goto NoSavedData
if not exist %FPBAK%\NUL goto NoSavedData
xcopy /S /N %FPBAK%\*.* %FTARGET%\ >NUL
deltree /Y %FPBAK%\*.* >NUL
rmdir %FPBAK% >NUL
set FPBAK=

:NoSavedData
verrlvl 0
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
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IPAC_FRAME
vecho /n /t %FLANG% IPACBM
goto PkgSkip

:Success
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IPACDONE_FRAME
vecho /n /t %FLANG% IPACDONE
vdelay %FDEL%
verrlvl 0

:Done

set _PA=
set _PI=
set _PM=
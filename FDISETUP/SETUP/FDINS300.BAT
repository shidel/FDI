@echo off

REM Remove old conflicting packages.

if not exist %FTARGET%\APPINFO\NUL goto Done

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IRMPACK_FRAME
vecho /n /t %FLANG% IRMPACKS
vgotoxy /l eop sor
vprogres /f %TFP% 0

REM Run through all binaries to be installed.
set _PI=0

REM For some reason, DOS sometimes fails to do this correctly on the first try.
REM So, make sure it is ready before moving on.
:PkgSticky
type %FPKGS% | grep -iv ^; | vstr /b/l %_PI% | set /p _PA=
if "%_PA%" == "" goto PkgSticky
type %FPKGS% | grep -iv ^; | vstr /b/l TOTAL | set /p _PM=
if "%_PM%" == "0" goto PkgDone

:PkgLoop
type %FPKGS% | grep -iv ^; | vstr /b/l %_PI% | set /p _PA=
vgotoxy /l eop sor
vprogres /f %TFP% %_PI% of %_PM%
if "%_PA%" == "" goto PkgDone

if not "%OCLEAN%" == "y" goto IncludeBase
vfdutil /p ?:\%_PA% | set /p _PD=
vfdutil /n ?:\%_PA% | set /p _PA=
if "%_PD%" == "?:\BASE" goto PkgBase
:IncludeBase
if exist %FTARGET%\APPINFO\%_PA%\NUL goto PkgRemove
if exist %FTARGET%\APPINFO\%_PA%.LSM goto PkgRemove
if exist %FTARGET%\PACKAGES\%_PA%\NUL goto PkgRemove
if exist %FTARGET%\PACKAGES\%_PA%.LST goto PkgRemove
goto PkgSkip
:PkgRemove
vgotoxy /l sop
vecho /e /n /t %FLANG% IRMPACKN %TFH% %_PA% %TFF%

if not exist %FTARGET%\PACKAGES\%_PA%.LST goto TryAnyway
type %FTARGET%\PACKAGES\%_PA%.LST |vstr /n /s "C:\" "%FDRIVE%" >%FTARGET%\PACKAGES\FDISETUP.LST
FDINST remove FDISETUP >NUL
del %FTARGET%\PACKAGES\FDISETUP.LST >NUL

set _PL=y
goto PkgNext

:TryAnyway
FDINST remove %_PA% >NUL
set _PL=y
goto PkgNext

:PkgBase
if exist %FTARGET%\APPINFO\%_PA%.LSM del %FTARGET%\APPINFO\%_PA%.LSM >NUL
if exist %FTARGET%\APPINFO\%_PA%\NUL deltree /y %FTARGET%\APPINFO\%_PA% >NUL
if exist %FTARGET%\PACKAGES\%_PA%.LST del %FTARGET%\PACKAGES\%_PA%.LST >NUL
if exist %FTARGET%\PACKAGES\%_PA%\NUL deltree /y %FTARGET%\PACKAGES\%_PA% >NUL

:PkgSkip
if not "%_PL%" == "y" goto PkgNext
set _PL=
vgotoxy /l sop
vecho /e /n /t %FLANG% IRMPACKS

:PkgNext
vmath %_PI% + 1 | set /p _PI=
goto PkgLoop

:PkgError
vfdutil /c/p %FINSP%\
verrlvl 1
goto AbortPkg

:PkgDone
if not "%OCLEAN%" == "y" goto PkgNoSave
if not exist %FTARGET%\PACKAGES\NUL goto PkgNoSave

set FPBAK=%FDRIVE%\PKGFILES.FDI

:OldPkgLoop
if not exist %FTARGET%\PACKAGES\NUL goto OldAppLoop
dir /on /a /b /p- %FTARGET%\PACKAGES\*.* | vstr /b/l total | set /p _PA=
if "%_PA%" == "" goto OldPkgLoop
if "%_PA%" == "0" goto OldAppLoop
if not exist %FPBAK%\NUL mkdir %FPBAK% >NUL
xcopy /E /Y %FTARGET%\PACKAGES\*.* %FPBAK%\PACKAGES\ >NUL
:OldAppLoop
if not exist %FTARGET%\APPINFO\NUL goto OldLnkLoop
dir /on /a /b /p- %FTARGET%\APPINFO\*.* | vstr /b/l total | set /p _PA=
if "%_PA%" == "" goto OldAppLoop
if "%_PA%" == "0" goto OldLnkLoop
if not exist %FPBAK%\NUL mkdir %FPBAK% >NUL
xcopy /E /Y %FTARGET%\APPINFO\*.* %FPBAK%\APPINFO\ >NUL
:OldLnkLoop
if not exist %FTARGET%\LINKS\NUL goto PkgNoSave
dir /on /a /b /p- %FTARGET%\LINKS\*.* | vstr /b/l total | set /p _PA=
if "%_PA%" == "" goto OldLnkLoop
if "%_PA%" == "0" goto PkgNoSave
if not exist %FPBAK%\NUL mkdir %FPBAK% >NUL
xcopy /E /Y %FTARGET%\LINKS\*.* %FPBAK%\LINKS\ >NUL

:PkgNoSave
vdelay %FDEL%

set _PA=
set _PI=
set _PD=
set _PM=
set _PL=

:Done
verrlvl 0
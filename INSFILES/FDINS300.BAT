@echo off

REM Remove old conflicting packages

REM Generate Conflicting package file
echo COMMAND>%TEMP%\CONFICT.LST

REM Run through all binaries to be installed.
set _PI=0

REM For some reason, DOS sometimes fails to do this correctly on the first try.
REM So, make sure it is ready before moving on.
:PkgSticky
type %FPKGS% | vstr /l %_PI% | set /p _PA=
if "%_PA%" == "" goto PkgSticky

:PkgLoop
type %FPKGS% | vstr /l %_PI% | set /p _PA=
if "%_PA%" == "" goto PkgDone

vfdutil /p ?:\%PA% | set /p _PM=
if "%_PM%" == "?:\BASE" goto PkgSkip

vfdutil /n ?:\%PA% | set /p _PA=
if exist %FTARGET%\APPINFO\%_PA%.LSM echo %_PA%>%TEMP%\CONFICT.LST

:PkgSkip
vmath %_PI% + 1 | set /p _PI=
goto PkgLoop

:PkgError
vfdutil /c/p %FINSP%\
verrlvl 1
goto AbortPkg

:PkgDone
set _PA=
set _PI=
set _PM=
verrlvl 0verrlvl 0
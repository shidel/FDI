@echo off

REM Remove old conflicting packages
if not exist %FTARGET%\APPINFO\NUL goto Done
call FDIWIND.BAT 7
vecho /n /t %FLANG% RMPACKS
vgotoxy /l eop sor
vprogres /f %TFP% 0

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
vgotoxy /l eop sor
vprogres /f %TFP% %_PP%
if "%_PM%" == "%_PI" goto MaxPercent
vmath %_PI% + 1 | set /p _PI=
verrlvl 0

:MaxPercent
if "%_PA%" == "" goto PkgDone

if not "%OCLEAN%" == "y" goto IncludeBase

vfdutil /p ?:\%_PA% | set /p _PD=
if "%_PD%" == "?:\BASE" goto PkgSkip
:IncludeBase

vfdutil /n ?:\%_PA% | set /p _PA=
if not exist %FTARGET%\APPINFO\%_PA%.LSM goto PkgSkip
FDINST remove %_PA% >NUL
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
set _PD=
set _PM=
set _PP=

:Done
verrlvl 0
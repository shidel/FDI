@echo off

REM if binary packages contain the sources, set NOSRC=y
REM that will allow them to be installed in one pass when %1 is bin and
REM %OSRC% is y without requireing a two step process for SOURCE/BINARY
REM packages.

if "%1" == "bin" goto BinPackage
if "%1" == "src" goto SrcPackage

goto Failed

:BinPackage
if not exist %FMEDIA%\%2.zip goto Failed
unzip -qq -o %FMEDIA%\%2.zip >NUL
if errorlevel 1 goto Failed
goto Success

:SrcPackage
verrlvl 1
if errorlevel 1 goto Failed
goto Success

:Failed
verrlvl 1
goto Done

:Success
verrlvl 0
goto Done

:Done

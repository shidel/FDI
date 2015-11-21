@echo off

:BinPackage
if not exist %FMEDIA%\%1.zip goto Failed
rem unzip -qq -o %FMEDIA%\%1.zip >NUL
fdinst install %FMEDIA%\%1.zip >NUL
if errorlevel 1 goto Failed
goto Success

:Failed
verrlvl 1
goto Done

:Success
verrlvl 0
goto Done

:Done

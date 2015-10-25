@echo off

:Retry
set FLANG=
if "%FINSP%" == "" goto PreINSP

if "%1" == "" goto WPNone

if not "%FADV%" == "y" goto WPDefault
if not exist %FINSP%\%LANG%\%1.ADV goto WPDefault
set FLANG=%FINSP%\%LANG%\%1.ADV
goto Done

:WPDefault
if not exist %FINSP%\%LANG%\%1.DEF goto WPNext
set FLANG=%FINSP%\%LANG%\%1.DEF
goto Done

:WPNext
shift
goto Retry

:WPNone
set FLANG=EN\FDSETUP.DEF
goto Done

:PreINSP
if "%1" == "" goto PSNone

if not "%FADV%" == "y" goto PSDefault
if not exist %LANG%\%1.ADV goto PSDefault
set FLANG=%LANG%\%1.ADV
goto Done

:PSDefault
if not exist %LANG%\%1.DEF goto PSNext
set FLANG=%LANG%\%1.DEF
goto Done

:PSNext
shift
goto Retry

:PSNone
set FLANG=EN\FDSETUP.DEF

:Done

@echo off

REM Package installation mini-batch utility.

if "%1" == "" goto Success

:BinPackage
vfdutil /n %1 | set /p TEMPFILE=
if "%TEMPFILE%" == "" goto BinPackage
if exist %FINSP%\PACKAGES\%TEMPFILE%.ZIP goto OverrideA
if exist %FINSP%\..\PACKAGES\%TEMPFILE%.ZIP goto OverrideB
vfdutil /u %FMEDIA%\%1.zip >nul
if errorlevel 1 goto FoundPackage
goto Missing
:FoundPackage
set /e TEMPFILE=vfdutil /f %FMEDIA%\%1.zip
if "%TEMPFILE%" == "" goto FoundPackage
fdinst install %TEMPFILE% >nul
:CheckSuccess
if errorlevel 1 goto Failed
goto Success

:OverrideA
fdinst install %FINSP%\PACKAGES\%TEMPFILE%.ZIP >nul
goto CheckSuccess

:OverrideB
fdinst install %FINSP%\..\PACKAGES\%TEMPFILE%.ZIP >nul
goto CheckSuccess

:Missing
if "%FPSKP%" == "y" goto Success

:Failed
verrlvl 1
goto Done

:Success
verrlvl 0
goto Done

:Done
set TEMPFILE=
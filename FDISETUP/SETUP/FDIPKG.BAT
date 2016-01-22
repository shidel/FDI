@echo off

REM Package installation mini-batch utility.

:BinPackage
vfdutil /n %1 | set /p TEMPFILE=
if exist %FINSP%\PACKAGES\%TEMPFILE%.ZIP goto OverrideA
if exist %FINSP%\..\PACKAGES\%TEMPFILE%.ZIP goto OverrideB
if not exist %FMEDIA%\%1.zip goto Failed
fdinst install %FMEDIA%\%1.zip >nul
:CheckSuccess
if errorlevel 1 goto Failed
goto Success

:OverrideA
fdinst install %FINSP%\PACKAGES\%TEMPFILE%.ZIP >nul
goto CheckSuccess

:OverrideB
fdinst install %FINSP%\..\PACKAGES\%TEMPFILE%.ZIP >nul
goto CheckSuccess

:Failed
verrlvl 1
goto Done

:Success
verrlvl 0
goto Done

:Done
set TEMPFILE=
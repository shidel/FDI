@echo off

REM Package installation mini-batch utility.

:BinPackage
vfdutil /n %1 | set /p TEMPFILE=
if exist %FINSP%\PACKAGES\%TEMPFILE%.ZIP goto OverrideA
if exist %FINSP%\..\PACKAGES\%TEMPFILE%.ZIP goto OverrideB
vfdutil /u %FMEDIA%\%1.zip >nul
if errorlevel 1 goto FoundPackage
goto Missing
:FoundPackage
set /e TEMPFILE=vfdutil /f %FMEDIA%\%1.zip
fdinst install %TEMPFILE% >nul
:CheckSuccess
if errorlevel 1 goto Failed
set /e TEMPFILE=vfdutil /n %1
if not exist %FTARGET%\PACKAGES\%TEMPFILE%.LST goto Success
type %FTARGET%\PACKAGES\%TEMPFILE%.LST |vstr /n /s "%FDRIVE%" "C:\">%FTARGET%\PACKAGES\FDISETUP.LST
copy /y %FTARGET%\PACKAGES\FDISETUP.LST %FTARGET%\PACKAGES\%TEMPFILE%.LST >NUL
del %FTARGET%\PACKAGES\FDISETUP.LST >NUL
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
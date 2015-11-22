@echo off

:BinPackage
if not exist %FMEDIA%\%1.zip goto Failed
vfdutil /n %PACKFILE% | set /p TEMPFILE=
if exist %FINSP%\PACKAGES\%TEMPFILE%.ZIP goto OverrideA
if exist %FINSP%\..\PACKAGES\%TEMPFILE%.ZIP goto OverrideB
fdinst install %FMEDIA%\%1.zip >>%FDRIVE%\FDSETUP.LOG
:CheckSuccess
if errorlevel 1 goto Failed
goto Success

:OverrideA
fdinst install %FINSP%\PACKAGES\%TEMPFILE%.ZIP >>%FDRIVE%\FDSETUP.LOG
goto CheckSuccess

:OverrideB
fdinst install %FINSP%\..\PACKAGES\%TEMPFILE%.ZIP >>%FDRIVE%\FDSETUP.LOG
goto CheckSuccess

:Failed
verrlvl 1
goto Done

:Success
verrlvl 0
goto Done

:Done
set TEMPFILE=
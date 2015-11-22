@echo off

:BinPackage
if not exist %FMEDIA%\%1.zip goto Failed
rem unzip -qq -o %FMEDIA%\%1.zip >NUL
if exist %FINSP%\PACKAGES\%PACKFILE%.ZIP goto OverrideA
if exist %FINSP%\..\PACKAGES\%PACKFILE%.ZIP goto OverrideB
fdinst install %FMEDIA%\%1.zip >NUL
:CheckSuccess
if errorlevel 1 goto Failed
goto Success

:OverrideA
fdinst install %FINSP%\PACKAGES\%PACKFILE%.ZIP >NUL
goto CheckSuccess

:OverrideB
fdinst install %FINSP%\..\PACKAGES\%PACKFILE%.ZIP >NUL
goto CheckSuccess

:Failed
verrlvl 1
goto Done

:Success
verrlvl 0
goto Done

:Done

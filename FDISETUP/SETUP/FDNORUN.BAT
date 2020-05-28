@echo off

REM Reserved for custom message display when installation is not supported
REM on the current platform.

REM If a language file FDNOTICE.DEF exists, it will be automatically loaded
REM prior to running this file.

rem vecho /k0 /fGray /bBlack /p
vecho /k0 /fLightRed /bBlack /n /t %FLANG% NORUN.1 "%OS_NAME%" "%OS_VERSION%"
vecho /k0 /fLightRed /bBlack /n /t %FLANG% NORUN.2 "%OS_NAME%" "%OS_VERSION%"
vecho /k0 /fGray /bBlack /p

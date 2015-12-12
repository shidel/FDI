@echo off

REM Reserved for custom error message displaying.

REM If a language file FDNOTICE.DEF exists, it will be automatically loaded
REM prior to running this file.

REM When the current version of the OS is already installed, this file will
REM be called prior to exiting the batch file instead of automatically
REM starting the install process.

vecho /fDarkGray /x 0x2a /fGray
vecho /n /fDarkGray '***' /fGray
vecho /n /t %FLANG% NOTICE.1 "%OS_NAME%" "%OS_VERSION%"
vgotoxy eor left left
vecho /fDarkGray /x 0x2a /fGray /p /n /fDarkGray '***' /fGray
vecho /n /t %FLANG% NOTICE.2
vgotoxy eor left left
vecho /fDarkGray /x 0x2a /fGray /p /fDarkGray /x 0x2a /fGray /p

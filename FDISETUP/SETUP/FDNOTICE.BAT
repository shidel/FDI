@echo off

REM Reserved for custom message display when installation was not needed or
REM performed.

REM If a language file FDNOTICE.DEF exists, it will be automatically loaded
REM prior to running this file.

REM When the current version of the OS is already installed, this file will
REM be called prior to exiting the batch file instead of automatically
REM starting the install process.

vecho /k0 /fDarkGray /x 0x2a /fGray
vecho /k0 /n /fDarkGray '***' /fGray
vecho /k0 /n /t %FLANG% NOTICE.1 "%OS_NAME%" "%OS_VERSION%"
vgotoxy eor left left
vecho /k0 /fDarkGray /x 0x2a /fGray /p /n /fDarkGray '***' /fGray
vecho /k0 /n /t %FLANG% NOTICE.2
vgotoxy eor left left
vecho /k0 /fDarkGray /x 0x2a /fGray /p /fDarkGray /x 0x2a /fGray /p

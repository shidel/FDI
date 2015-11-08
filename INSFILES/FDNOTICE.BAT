@echo off

REM Reserved for custom error message displaying.

REM If a language file FDNOTICE.DEF exists, it will be automatically loaded
REM prior to running this file.

REM When the current version of the OS is already installed, this file will
REM be called prior to exiting the batch file instead of automatically
REM starting the install process.

vecho /fDarkGray /x 0x2a /fGray
vecho /n /fDarkGray '***' /fGray
vecho /n /r5/c32 /fGreen "%OS_NAME%" /fCyan " %OS_VERSION%" /fGray " is already installed."
vgotoxy eor left left
vecho /fDarkGray /x 0x2a /fGray /y /n /fDarkGray '***' /fGray
vecho /n /r5/c32 "You can start the installer manually by running '" /fCyan SETUP.BAT /fGray "'"
vgotoxy eor left left
vecho /fDarkGray /x 0x2a /fGray /y /fDarkGray /x 0x2a /fGray /y

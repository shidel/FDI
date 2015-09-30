@echo off

REM Configure the installer.

set FDI_DEBUG=yes

REM Set operating system TITLE and VERSION for installer, not cleared at exit.
set OS_NAME=FreeDOS
set OS_VERSION=1.1a

REM Formatted volume label
set FDI_VOLUME=FreeDOS2015

REM Drive C Formatting options.
set FDI_FORMAT=/Q /U /Z:seriously

REM Pause duration after Format and System file transfers.
set FDI_PAUSE=15

REM Default Temp Directory.
set FDI_TEMP=C:\FDI_TEMP.$$$

REM Flag for remembering if drive was formatted.
set FDI_DIDFMT=NO

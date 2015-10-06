@echo off

REM Configure the installer.

set FDEBUG=y

REM Set operating system TITLE and VERSION for installer, not cleared at exit.
set OS_NAME=FreeDOS
set OS_VERSION=1.1a

REM Formatted volume label
set OVOL=FreeDOS2015

REM Drive C Formatting options.
set FFMT=/Q /U /Z:seriously

REM Pause duration after Format and System file transfers.
set FWAIT=15

REM Default TEMP directory.
set FTEMP=C:\FDTEMP.$$$

REM Target path to install FreeDOS
set FTARGET=C:\FDOS


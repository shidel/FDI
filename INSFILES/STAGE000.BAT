@echo off

REM Configure the installer.

set FDEBUG=n

REM Set operating system TITLE and VERSION for installer, not cleared at exit.
set OS_NAME=FreeDOS
set OS_VERSION=1.1a

REM Set Timezone so unzip doesn't complain.
set TZ=UTC

REM Formatted volume label
set OVOL=FreeDOS2015

REM Drive C Formatting options.
set FFMT=/Q /U /Z:seriously

REM Pause duration after Format and System file transfers. (seconds)
set FWAIT=15

REM Pause after displaying non-interactive messages. (milliseconds)
set FDEL=2000

REM Default TEMP directory.
set FTEMP=C:\FDTEMP.$$$

REM Target path to install FreeDOS
set FTARGET=C:\FDOS

REM Backup path to when archiving.
set FBAK=C:\FDBACKUP

REM Show when little operations that complete.
set FVERB=n

REM Scan for vendor media installers.
set FSCAN=n
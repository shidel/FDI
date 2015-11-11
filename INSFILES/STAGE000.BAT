@echo off

REM Configure the installer. **************************************************

REM Set operating system TITLE and VERSION for installer, not cleared at exit.
set OS_NAME=FreeDOS
set OS_VERSION=1.1a

if "%1" == "VersionOnly" goto Done

REM Remove trailing spaces from LANG variable.
if %LANG% == EN set FLANG=EN
if %LANG% == ES set FLANG=ES

REM Debug Mode
set FDEBUG=n

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

REM Target path to install FreeDOS
set FDRIVE=C:
set FTARGET=%FDRIVE%\FDOS

REM Default TEMP directory.
set FTEMP=%FDRIVE%\FDTEMP.$$$

REM Backup path to when archiving.
set FBAK=%FDRIVE%\FDBACKUP

REM Show when little operations that complete.
set FVERB=n
if "%FADV%" == "y" set FVERB=y

REM Scan for vendor media installers.
set FSCAN=n

REM New config file extension to be used for replacing AUTOEXEC.BAT and
REM FDCONFIG.SYS.
set FEXT=DEF

REM Dual source packages, set it to y if true
set FDUALP=

:Done
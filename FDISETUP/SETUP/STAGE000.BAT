@echo off

REM Configure the installer. **************************************************

REM Set operating system TITLE and VERSION for installer, not cleared at exit.
set OS_NAME=FreeDOS
set OS_VERSION=1.2-pre3

if "%1" == "VersionOnly" goto Done

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

REM Try to import some stuff from autoexec.bat and fdconfig.sys
set HLANG=%LANG%
if "%TEMP%" == "" goto AdjustData
vfdutil /u %TEMP%\TEST????.??? >NUL
if errorlevel 1 goto AdjustData
vfdutil /u C:\TEST????.??? >NUL
if errorlevel 1 goto AdjustData

echo @ECHO OFF>%TEMP%\FDIMPORT.000
if not exist C:\FDCONFIG.SYS goto NoFDCONFIG
grep -i "!SET " C:\FDCONFIG.SYS |grep -i " LANG=\| DOSDIR="|vstr /n /s ! "">>%TEMP%\FDIMPORT.000
goto CheckAuto

:NoFDCONFIG
if not exist C:\CONFIG.SYS goto CheckAuto
grep -i "!SET " C:\FDCONFIG.SYS|grep -i " LANG=\| DOSDIR="|vstr /n /s ! "">>%TEMP%\FDIMPORT.000

:CheckAuto
if not exist C:\AUTOEXEC.BAT goto NoAuto
grep -i -v "REM " C:\AUTOEXEC.BAT|grep -i "SET "|grep -i " LANG=\| DOSDIR=">>%TEMP%\FDIMPORT.000

:NoAuto
type %TEMP%\FDIMPORT.000|vstr /n /s " DOSDIR=" " FTARGET="|vstr /n /s "  " " ">%TEMP%\FDIMPORT.BAT

call %TEMP%\FDIMPORT.BAT
del %TEMP%\FDIMPORT.000
del %TEMP%\FDIMPORT.BAT
if "%FTARGET%" == "" goto AdjustData
vfdutil /d %FTARGET% | set /p FDRIVE=

:AdjustData
if not "%HLANG%" == "" set LANG=%HLANG%
if "%LANG%" == "" set FCLANG=y
if "%LANG%" == "" set LANG=EN

REM Remove trailing spaces from LANG variable.
if %LANG% == EN set LANG=EN
if %LANG% == ES set LANG=ES

REM Langage not supported switch to english
if not exist %LANG%\NUL set LANG=EN
set HLANG=
:Done

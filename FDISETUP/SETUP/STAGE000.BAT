@echo off

REM Configure the installer. **************************************************

REM Set operating system TITLE and VERSION for installer, not cleared at exit.
set OS_NAME=$PLATFORM$
set OS_VERSION=$VERSION$

if "%1" == "VersionOnly" goto Done

REM Debug Mode
set FDEBUG=n

REM Formatted volume label
set OVOL=$OVOL$

REM Pause duration after Format and System file transfers. (seconds)
set FWAIT=15

REM Pause after displaying non-interactive messages. (milliseconds)
set FDEL=2000

REM Target path to install FreeDOS
if not "%FINSD%" == "C:" set FDRIVE=C:
if "%FINSD%" == "C:" set FDRIVE=D:
set FTARGET=%FDRIVE%\FDOS

REM Backup path to when archiving.
set FBAK=%FDRIVE%\FDBACKUP

REM Show when little operations that complete.
set FVERB=n
if "%FADV%" == "y" set FVERB=y

REM Skip Missing packages.
set FPSKP=y

REM Set installers path
SET FINSP=%FINSD%\FDSETUP\SETUP

REM Try to import some stuff from autoexec.bat and fdconfig.sys
set HLANG=%LANG%
set HTZ=%TZ%

if "%TEMP%" == "" goto NoImport
vfdutil /u %TEMP%\TEST????.??? >NUL
if errorlevel 1 goto NoImport
vinfo /d %FDRIVE%
if errorlevel 1 goto NoImport
vfdutil /u %FDRIVE%\TEST????.??? >NUL
if errorlevel 1 goto NoImport

echo @ECHO OFF>%TEMP%\FDIMPORT.000
if not exist %FDRIVE%\FDCONFIG.SYS goto NoFDCONFIG
grep -i "!SET " %FDRIVE%\FDCONFIG.SYS |grep -i " LANG=\| DOSDIR="|vstr /n /s ! "">>%TEMP%\FDIMPORT.000
grep -i "!SET " %FDRIVE%\FDCONFIG.SYS |grep -i " TZ="|vstr /n /s ! "">>%TEMP%\FDIMPORT.000
goto CheckAuto

:NoFDCONFIG
if not exist %FDRIVE%\CONFIG.SYS goto CheckAuto
grep -i "!SET " %FDRIVE%\CONFIG.SYS|grep -i " LANG=\| DOSDIR="|vstr /n /s ! "">>%TEMP%\FDIMPORT.000
grep -i "!SET " %FDRIVE%\CONFIG.SYS |grep -i " TZ="|vstr /n /s ! "">>%TEMP%\FDIMPORT.000

:CheckAuto
if not exist %FDRIVE%\AUTOEXEC.BAT goto NoAuto
grep -i -v "REM " %FDRIVE%\AUTOEXEC.BAT|grep -i "SET "|grep -i " LANG=\| DOSDIR=">>%TEMP%\FDIMPORT.000
grep -i -v "REM " %FDRIVE%\AUTOEXEC.BAT|grep -i "SET "|grep -i " TZ=">>%TEMP%\FDIMPORT.000

:NoAuto
if not exist %TEMP%\FDIMPORT.000 goto Done
type %TEMP%\FDIMPORT.000|vstr /u/n/s " DOSDIR=" " TDOS="|vstr /n /s "  " " ">%TEMP%\FDIMPORT.BAT

call %TEMP%\FDIMPORT.BAT
del %TEMP%\FDIMPORT.000
del %TEMP%\FDIMPORT.BAT

if "%TDOS%" == "" goto NoImport
if "%TDOS%" == "\FDSetup" goto NoImport
if "%TDOS%" == "\FDSETUP" goto NoImport

SET FTARGET=%TDOS%

:RepeatDrive
vfdutil /d %FTARGET% | set /p FDRIVE=
if "%FDRIVE%" == "" goto RepeatDrive
if not "%FBOOTD%" == "%FDRIVE%" goto NotSelf
if not "%FINSD%" == "%FBOOTD%" goto NotSelf

if not "%FDRIVE%" == "C:" set TDOS=C:
if "%FDRIVE%" == "C:" set TDOS=D:
set FDRIVE=%TDOS%
set FTARGET=%FDRIVE%\FDOS

:NotSelf
set FBAK=%FDRIVE%\FDBACKUP

:NoImport
verrlvl 0
set TDOS=

:AdjustData
if not "%HLANG%" == "" set LANG=%HLANG%
if "%LANG%" == "" set FCLANG=y
if "%FADV%" == "y" set FCLANG=y
if "%LANG%" == "" set LANG=EN

if not "%HTZ%" == "" set TZ=%HTZ%
if "%TZ%" == "" set TZ=UTC

REM Remove trailing spaces from LANG variable.
if %LANG% == EN set LANG=EN
if %LANG% == ES set LANG=ES
if %LANG% == EO set LANG=EO
if %LANG% == FR set LANG=FR
if %LANG% == DE set LANG=DE
if %LANG% == NL set LANG=NL
if %LANG% == TR set LANG=TR

REM Langage not supported switch to english
if not exist %LANG%\NUL set LANG=EN
set HLANG=
set HTZ=
:Done


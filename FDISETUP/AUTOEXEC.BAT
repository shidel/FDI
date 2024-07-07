@echo off
SET DOSDIR=\FREEDOS
SET LANG=
SET TZ=
SET PATH=%dosdir%\BIN

SET DIRCMD=/P /OGN /Y
rem SET COPYCMD=/-Y

rem SET TEMP=%dosdir%\TEMP
rem SET TMP=%TEMP%

if exist %dosdir%\NLS\NUL set NLSPATH=%dosdir%\NLS
if exist %dosdir%\HELP\NUL set HELPPATH=%dosdir%\HELP

if not exist %dosdir%\bin\uhdd.sys goto NoUHDD
DEVLOAD /H %dosdir%\bin\uhdd.sys /s5 /h
:NoUHDD

echo.
call CDROM.BAT

rem FDAPM APMDOS
rem DOSLFN

goto SkipLBACache
if not exist %dosdir%\bin\lbacache.com goto NoLBACache
vecho /g
verrlvl 1
LBACACHE.COM buf 20 flop
if errorlevel 1 goto NoLBACache
if not exist %dosdir%\bin\tickle.com goto NoLBACache
TICKLE.COM
:NoLBACache

:SkipLBACache

SET OS_NAME=$OS_NAME$
SET OS_VERSION=$OS_VERSION$
SET AUTOFILE=%0
SET CFGFILE=\$CONFIG$
alias reboot=fdapm warmboot
alias reset=fdisk /reboot
alias halt=fdapm poweroff
alias shutdown=fdapm poweroff

if exist %dosdir%\bin\fdnet.bat call %dosdir%\bin\fdnet.bat start
if exist %dosdir%\bin\fdassist.bat call %dosdir%\bin\fdassist.bat

if not exist SETUP.BAT goto Done
:RunSetup
vecho /k0 /p Done processing startup files /fCyan FDCONFIG.SYS /a7 and /fCyan $AUTOEXEC$ /a7/p
vdelay 1500
CALL SETUP.BAT $BOOT$

:Done
if exist %dosdir%\bin\cdrom.bat call %dosdir%\bin\cdrom.bat display
if exist %dosdir%\bin\welcome.bat call %dosdir%\bin\welcome.bat
$OS_BOOT_WARNING$

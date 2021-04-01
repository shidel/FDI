@echo off
SET DOSDIR=\FREEDOS
SET LANG=
SET TZ=
SET PATH=%dosdir%\BIN

SET DIRCMD=/P /OGN /Y

rem SET TEMP=%dosdir%\TEMP
rem SET TMP=%TEMP%
rem SET NLSPATH=%dosdir%\NLS
rem SET HELPPATH=%dosdir%\HELP
rem SET COPYCMD=/-Y

echo.
call CDROM.BAT

rem FDAPM APMDOS
rem DOSLFN
rem LBACACHE.COM buf 20 flop

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

goto SkipLanguageData

***** Language specific text data.
English (EN)
AUTO_HELP=Type /fWhite %1 /fGray to get support on commands and navigation.
AUTO_WELCOME=Welcome to the /fGreen %1 /fCyan %2 /fGray operating system ( /s- /fYellow "%3" /fGray )

:SkipLanguageData
vecho /k0 /p Done processing startup files /fCyan FDCONFIG.SYS /a7 and /fCyan $AUTOEXEC$ /a7/p

if exist SETUP.BAT CALL SETUP.BAT $BOOT$

if not exist %DOSDIR%\BIN\WELCOME.BAT goto V8Welcome
call WELCOME.BAT
goto Done

:V8Welcome
set LANGFILE=FREEDOS\SETUP\%LANG%\FDSETUP.DEF
if not exist %LANGFILE% SET LANGFILE=%0
if not exist %DOSDIR%\BIN\HELP.EXE goto NoHelp
vecho /k0 /t %LANGFILE% AUTO_HELP HELP
vecho /k0
:NoHelp
vecho /k0 /t %LANGFILE% AUTO_WELCOME %OS_NAME% %OS_VERSION% http://www.freedos.org
vecho  /k0
set LANGFILE=

:Done
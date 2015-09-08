@echo off
SET LANG=EN
SET MTCPCFG=%dosdir%\MTCP.CFG
SET WATTCP.CFG=%dosdir%
SET PATH=%dosdir%\BIN
SET PATH=%path%;%dosdir%\V8Power
SET NLSPATH=%dosdir%\NLS
SET HELPPATH=%dosdir%\HELP
SET TEMP=%dosdir%\TEMP
SET TMP=%TEMP%
SET BLASTER=A220 I5 D1 H5 P330
SET DIRCMD=/P /OGN /4
SET COPYCMD=/-Y
if "%config%"=="4" goto end
SHSUCDX /QQ /D3
LH SHSUCDHD /QQ /F:FDBOOTCD.ISO
LH FDAPM APMDOS
IF "%config%"=="2" LH SHARE
LH DOSLFN
REM NLSFUNC %dosdir%\BIN\COUNTRY.SYS
REM DISPLAY CON=(EGA),858,2)
REM MODE CON CP PREP=((858) %dosdir%\CPI\EGA.CPX)
REM KEYB US,858,%dosdir%\bin\keyboard.sys
REM CHCP 858
REM LH PCNTPK INT=0x60
REM DHCP
MOUSE
DEVLOAD /H /Q %dosdir%\BIN\UIDE.SYS /H /D:FDCD0001 /S5
SHSUCDX /QQ /~ /D:?SHSU-CDR,D /D:?SHSU-CDH,D /D:?FDCD0001,D /D:?FDCD0002,D /D:?FDCD0003,D
MEM /C /N
IF NOT "%config%"=="4" SHSUCDX /D
GOTO END
:END
SET AUTOFILE=%0
SET CFGFILE=A:\FDCONFIG.SYS
alias reboot=fdapm warmboot
alias reset=fdisk /reboot
alias halt=fdapm poweroff
alias shutdown=fdapm poweroff
alias cfg=edit %cfgfile%
alias auto=edit %0
echo Done processing startup files %cfgfile% and %0
vecho /n "Type " /fWhite HELP
vecho /fGray " to get support on commands and navigation"
vecho
vecho /n "Welcome to the " /fCyan "FreeDOS 1.1"
vecho /fGray " operating system (http://www.freedos.org)" /e

SETUP.BAT
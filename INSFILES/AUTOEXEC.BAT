@echo off
SET LANG=EN
rem SET MTCPCFG=%dosdir%\MTCP.CFG
rem SET WATTCP.CFG=%dosdir%
SET PATH=%dosdir%\BIN
SET PATH=%path%;%dosdir%\V8Power
SET NLSPATH=%dosdir%\NLS
SET HELPPATH=%dosdir%\HELP
rem SET TEMP=%dosdir%\TEMP
rem SET TMP=%TEMP%
rem SET BLASTER=A220 I5 D1 H5 P330
rem SET DIRCMD=/P /OGN /4
rem SET COPYCMD=/-Y
SHSUCDX /QQ /D3
LH SHSUCDHD /QQ /F:FDBOOTCD.ISO
LH FDAPM APMDOS
REM LH SHARE
LH DOSLFN
REM NLSFUNC %dosdir%\BIN\COUNTRY.SYS
REM DISPLAY CON=(EGA),858,2)
REM MODE CON CP PREP=((858) %dosdir%\CPI\EGA.CPX)
REM KEYB US,858,%dosdir%\bin\keyboard.sys
REM CHCP 858
REM LH PCNTPK INT=0x60
REM DHCP
REM MOUSE
DEVLOAD /H /Q %dosdir%\BIN\UIDE.SYS /H /D:FDCD0001 /S5
SHSUCDX /QQ /~ /D:?SHSU-CDR,D /D:?SHSU-CDH,D /D:?FDCD0001,D /D:?FDCD0002,D /D:?FDCD0003,D
REM MEM /C /N
SHSUCDX /D

SET AUTOFILE=%0
SET CFGFILE=A:\FDCONFIG.SYS
alias reboot=fdapm warmboot
alias reset=fdisk /reboot
alias halt=fdapm poweroff
alias shutdown=fdapm poweroff
rem alias cfg=edit %cfgfile%
rem alias auto=edit %0

vecho "Done processing startup files %cfgfile% and %0"
vecho

if exist SETUP.BAT CALL SETUP.BAT RECOVERY

vecho "Type " /fWhite HELP /fGray " to get support on commands and navigation"
vecho
vecho /n "Welcome to the " /fGreen "%OS_NAME%" /fCyan " %OS_VERSION%"
vecho /fGray " operating system (" /fYellow "http://www.freedos.org" /fGray ")" /e
vecho

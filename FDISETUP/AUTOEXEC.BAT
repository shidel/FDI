@echo off
SET DOSDIR=A:\FDSetup
SET LANG=
SET PATH=%dosdir%\BIN

rem SET MTCPCFG=%dosdir%\MTCP.CFG
rem SET WATTCP.CFG=%dosdir%
rem SET NLSPATH=%dosdir%\NLS
rem SET HELPPATH=%dosdir%\HELP
rem SET TEMP=%dosdir%\TEMP
rem SET TMP=%TEMP%
rem SET BLASTER=A220 I5 D1 H5 P330
rem SET DIRCMD=/P /OGN /4
rem SET COPYCMD=/-Y

LH LBACACHE.COM buf 20 flop

DEVLOAD /H /Q %dosdir%\BIN\UDVD2.SYS /D:FDCD0001

SHSUCDX /QQ /D3

rem LH SHSUCDHD /QQ /F:FDBOOTCD.ISO

LH FDAPM APMDOS

rem LH SHARE

LH DOSLFN
rem NLSFUNC %dosdir%\BIN\COUNTRY.SYS
rem DISPLAY CON=(EGA),858,2)
rem MODE CON CP PREP=((858) %dosdir%\CPI\EGA.CPX)
rem KEYB US,858,%dosdir%\bin\keyboard.sys
rem CHCP 858
rem LH PCNTPK INT=0x60
rem DHCP
rem MOUSE

rem DEVLOAD /H /Q %dosdir%\BIN\UIDE.SYS /H /D:FDCD0001 /S5

SHSUCDX /QQ /~ /D:?SHSU-CDR,D /D:?SHSU-CDH,D /D:?FDCD0001,D /D:?FDCD0002,D /D:?FDCD0003,D

rem MEM /C /N

SHSUCDX /D

SET AUTOFILE=%0
SET CFGFILE=A:\FDCONFIG.SYS
alias reboot=fdapm warmboot
alias reset=fdisk /reboot
alias halt=fdapm poweroff
alias shutdown=fdapm poweroff

rem alias cfg=edit %cfgfile%
rem alias auto=edit %0
goto SkipLanguageData

***** Language specific text data.
English (EN)
AUTO_HELP=Type /fWhite %1 /fGray to get support on commands and navigation.
AUTO_WELCOME=Welcome to the /fGreen %1 /fCyan %2 /fGray operating system ( /s- /fYellow "%3" /fGray )

:SkipLanguageData
vecho /p Done processing startup files /fCyan %cfgfile% /a7 and /fCyan %0 /a7 /p

if exist SETUP.BAT CALL SETUP.BAT RECOVERY

set LANGFILE=FDSETUP\SETUP\%LANG%\FDSETUP.DEF
if not exist %LANGFILE% SET LANGFILE=%0
vecho /t %LANGFILE% AUTO_HELP HELP
vecho
vecho /t %LANGFILE% AUTO_WELCOME %OS_NAME% %OS_VERSION% http://www.freedos.org
vecho
set LANGFILE=
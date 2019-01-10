@ECHO OFF

REM Language settings that are always loaded at system startup.

IF NOT EXIST %DOSDIR%\BIN\MKEYB.EXE GOTO NoKeyB

REM MKEYB is present with FreeDOS BASE install. But is not present on the
REM FreeDOS installer boot media. So, these settings are only applied when
REM seen by the installed systems AUTOEXEC.BAT.

REM NLSFUNC %dosdir%\BIN\COUNTRY.SYS
REM DISPLAY CON=(EGA),858,2)
REM MODE CON CP PREP=((858) %dosdir%\CPI\EGA.CPX)
REM KEYB US,858,%dosdir%\bin\keyboard.sys
REM CHCP 858

MKEYB GR
REM MKEYB GR2
REM MKEYB SG

:NoKeyB

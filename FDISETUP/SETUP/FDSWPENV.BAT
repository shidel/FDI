@echo off

REM Post installation no reboot process. Swap environment to installed.

REM Only valid installer variables are FDRIVE and FTARGET. All others have
REM been cleared.

set DOSDIR=%FTARGET%

set PATH=%DOSDIR%\BIN
if exist %DOSDIR%\LINKS\NUL set PATH=%PATH%;%DOSDIR%\LINKS

set COMSPEC=%DOSDIR%\BIN\COMMAND.COM
SET NLSPATH=%DOSDIR%\NLS
SET HELPPATH=%DOSDIR%\HELP

set AUTOFILE=%FDRIVE%\AUTOEXEC.BAT
set CFGFILE=%FDRIVE%\FDCONFIG.SYS

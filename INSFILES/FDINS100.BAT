@echo off

if "%OBAK%" == "" goto AfterBackup
if not "%OBAK%" == "n" goto MakeBackup
goto AfterBackup

:MakeBackup
vfdutil /d %FTARGET% | set /p _C=

call FDIWIND.BAT 7
vecho /n "Creating backup"
vgotoxy /l eop sor
vprogres /f %TFH% 0

if "%OBAK%" == "z" goto ZipBackup

REM Backup to as renamed file  ************************************************
:SimpleBackup

goto AfterBackup

REM Backup to archive file ****************************************************
:ZipBackup

if not exist %FBAK%\NUL mkdir %FBAK%

vfdutil /u %FBAK%\FDOS????.ZIP | set /p _AF=
set _AL=%TEMP%\FDBACKUP.LST
date /d>%_AL%
echo %_AL% >>%_AL%

vgotoxy /l sop eol right right
vecho /n "'" /f %TFH% "%_AF%" /f %TFF% "'"
vgotoxy /l eop sor
vprogres /f %TFP% 5

if exist %_C%\FDAUTO.BAT echo %_C%\FDAUTO.BAT >>%_AL%
if exist %_C%\AUTOEXEC.BAT echo %_C%\AUTOEXEC.BAT >>%_AL%
if exist %_C%\CONFIG.SYS echo %_C%\CONFIG.SYS >>%_AL%
if exist %_C%\FDCONFIG.SYS echo %_C%\FDCONFIG.SYS >>%_AL%
if exist %_C%\KERNEL.SYS echo %_C%\KERNEL.SYS >>%_AL%
if exist %_C%\COMMAND.COM echo %_C%\COMMAND.COM >>%_AL%

REM EXTRAS
if exist %_C%\DRDOS.386 echo %_C%\DRDOS.386 >>%_AL%
if exist %_C%\WINA20.386 echo %_C%\WINA20.386 >>%_AL%
if exist %_C%\IBMBIO.COM echo %_C%\IBMBIO.COM >>%_AL%
if exist %_C%\IBMDOS.COM echo %_C%\IBMDOS.COM >>%_AL%
if exist %_C%\IO.SYS echo %_C%\IO.SYS >>%_AL%
if exist %_C%\MSDOS.SYS echo %_C%\MSDOS.SYS >>%_AL%

vprogres /f %TFP% 10

set _BN=1
if not exist %FTARGET%\NUL goto BackupRun
dir /A /B /P- %FTARGET%\*.*>>%_AL%

:BackupRun
REM For some reason, DOS sometimes fails to do this next line correctly.
type %_AL%|vstr /L TOTAL|set /p _BM=
REM So, if it's value does not get set. Do it again. Might have to do
REM with internal buffers or caching.
if "%_BM%" == "" goto BackupRun

:BackupLoop
REM vmath processes only from left to right!!!!!
vmath %_BN% mul 90 div %_BM% + 10 | set /p _BP=

vgotoxy /l eop sor

vprogres /f %TFP% %_BP%

type %_AL% | vstr /L %_BN% | set /p _BF=

REM kind of a kludge, but i still need to do string/line prefixing in vstr
if exist %FTARGET%\%_BF%\NUL set _BF=%FTARGET%\%_BF%
if exist %FTARGET%\%_BF% set _BF=C%FTARGET%\%_BF%

zip -q -9 -S -u -r -b %TEMP% %_AF% %_BF%
if errorlevel 1 goto FailedZipBackup

if "%_BN%" == "%_BM%" goto BackupComplete
vmath %_BN% + 1 | set /p _BN=
goto BackupLoop

REM Backup complete ***********************************************************
:BackupComplete
if exist %_AL% del %_AL%
vgotoxy /l eop sor
vecho /n /f %TFF% "Backup complete." /e
vdelay %FDEL%
goto AfterBackup

:FailedZipBackup
set FERROR="Making backup archive %_AF%."
if errorlevel 1 call FDIFAIL.BAT "Making backup archive %_AF%."
goto AfterBackup

:AfterBackup
set _BM=
set _BF=
set _BP=
set _BN=
set _AL=
set _AF=
set _C=
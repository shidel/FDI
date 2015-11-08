@echo off

if "%OBAK%" == "" goto AfterBackup
if not "%OBAK%" == "n" goto MakeBackup
goto AfterBackup

:MakeBackup
vfdutil /d %FTARGET% | set /p _C=

call FDIWIND.BAT 7
vecho /n /t %FLANG% BACKUP
vgotoxy /l eop sor
vprogres /f %TFP% 0

if "%OBAK%" == "z" goto ZipBackup

REM Backup to a renamed file  *************************************************
:SimpleBackup
vfdutil /u %_C%\FDOS_OLD.??? | set /p _AF=

mkdir %_AF%

set _AL=%TEMP%\FDBACKUP.LST
date /d>%_AL%
rem echo %_AL% >>%_AL%

vgotoxy /l sop eol right right
vecho /n /t %FLANG% TARGET %TFH% %_AF% %TFF%
vgotoxy /l eop sor
vprogres /f %TFP% 5

REM copy Config files to root directory as old versions.
vfdutil /u %_C%\FDAUTO.??? | set /p _BF=
if exist %_C%\FDAUTO.BAT copy %_C%\FDAUTO.BAT %_BF% >NUL
if errorlevel 1 goto CopyBackupFailed

vfdutil /u %_C%\AUTOEXEC.??? | set /p _BF=
if exist %_C%\AUTOEXEC.BAT copy %_C%\AUTOEXEC.BAT %_BF% >NUL
if errorlevel 1 goto CopyBackupFailed

vfdutil /u %_C%\CONFIG.??? | set /p _BF=
if exist %_C%\CONFIG.SYS copy %_C%\CONFIG.SYS %_BF% >NUL
if errorlevel 1 goto CopyBackupFailed

vfdutil /u %_C%\FDCONFIG.??? | set /p _BF=
if exist %_C%\FDCONFIG.SYS copy %_C%\FDCONFIG.SYS %_BF% >NUL
if errorlevel 1 goto CopyBackupFailed

REM make list of files.
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
if not exist %FTARGET%\NUL goto CopyBackupRun
dir /A /B /P- %FTARGET%\*.*>>%_AL%

:CopyBackupRun
REM For some reason, DOS sometimes fails to do this next line correctly.
type %_AL%|vstr /L TOTAL|set /p _BM=
REM So, if it's value does not get set. Do it again. Might have to do
REM with internal buffers or caching.
if "%_BM%" == "" goto CopyBackupRun

:CopyBackupLoop
REM vmath processes only from left to right!!!!!
vmath %_BN% mul 90 div %_BM% + 10 | set /p _BP=

vgotoxy /l eop sor

vprogres /f %TFP% %_BP%

if "%_BN%" == "%_BM%" goto BackupComplete

type %_AL% | vstr /L %_BN% | set /p _BF=
if "%_BF%" == "" goto PostCopy

REM kind of a kludge, but i still need to do string/line prefixing in vstr
if exist %FTARGET%\%_BF%\NUL goto FDOSSubDir
if exist %FTARGET%\%_BF% goto FDOSFile
goto NormalFile

:FDOSSubDir
mkdir %_AF%\%_BF%
if errorlevel 1 goto CopyBackupFailed
dir /A /B /P- %FTARGET%\%_BF%\*.* | vstr /l total | set /p _BT=
verrlvl 0
if "%_BT%" == "0" goto PostCopy
xcopy /y /q /e /r %FTARGET%\%_BF%\*.* %_AF%\%_BF%\ >NUL
goto PostCopy

:FDOSFile
xcopy /y /q %FTARGET%\%_BF% %_AF%\ >NUL
goto PostCopy

:NormalFile
xcopy /y /q %_BF% %_AF%\ >NUL

:PostCopy
if errorlevel 1 goto CopyBackupFailed

vmath %_BN% + 1 | set /p _BN=
goto CopyBackupLoop

REM Backup to archive file ****************************************************
:ZipBackup

if not exist %FBAK%\NUL mkdir %FBAK%

vfdutil /u %FBAK%\FDOS????.ZIP | set /p _AF=
set _AL=%TEMP%\FDBACKUP.LST
date /d>%_AL%
rem echo %_AL% >>%_AL%

vgotoxy /l sop eol right right
vecho /n /t %FLANG% TARGET %TFH% %_AF% %TFF%
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
if not exist %FTARGET%\NUL goto ZipBackupRun
dir /A /B /P- %FTARGET%\*.*>>%_AL%

:ZipBackupRun
REM For some reason, DOS sometimes fails to do this next line correctly.
type %_AL%|vstr /L TOTAL|set /p _BM=
REM So, if it's value does not get set. Do it again. Might have to do
REM with internal buffers or caching.
if "%_BM%" == "" goto ZipBackupRun

:ZipBackupLoop
REM vmath processes only from left to right!!!!!
vmath %_BN% mul 90 div %_BM% + 10 | set /p _BP=

vgotoxy /l eop sor

vprogres /f %TFP% %_BP%

if "%_BN%" == "%_BM%" goto BackupComplete

type %_AL% | vstr /L %_BN% | set /p _BF=

REM kind of a kludge, but i still need to do string/line prefixing in vstr
if exist %FTARGET%\%_BF%\NUL set _BF=%FTARGET%\%_BF%
if exist %FTARGET%\%_BF% set _BF=%FTARGET%\%_BF%

zip -q -9 -S -u -r -b %TEMP% %_AF% %_BF%
if errorlevel 1 goto ZipBackupFailed

vmath %_BN% + 1 | set /p _BN=
goto ZipBackupLoop

REM Backup complete ***********************************************************
:BackupComplete
if exist %_AL% del %_AL%
vgotoxy /l eop sor
vecho /n /e /t %FLANG% BACKUP_DONE %TFF%
vdelay %FDEL%
goto AfterBackup

:ZipBackupFailed
vdelay %FDEL%
set FERROR="Making backup archive %_AF%."
call FDIFAIL.BAT ERROR_BACKZIP %_AF%.
goto AfterBackup

:CopyBackupFailed
vdelay %FDEL%
set FERROR="Making backup."
call FDIFAIL.BAT ERROR_BACKUP
goto AfterBackup

:AfterBackup
set _BM=
set _BF=
set _BP=
set _BN=
set _BT=
set _AL=
set _AF=
set _C=
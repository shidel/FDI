@echo off

REM Create a Backup folder or Zip archive.

set HTMP=%TEMP%

if "%OBAK%" == "" goto AfterBackup
if not "%OBAK%" == "n" goto MakeBackup
goto AfterBackup

:MakeBackup

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% BACKUP_FRAME
vecho /n /t %FLANG% BACKUP
vgotoxy /l eop sor
vprogres /f %TFP% 0

if exist %FDRIVE%\COMMAND.COM attrib -R -S -H %FDRIVE%\COMMAND.COM >NUL
if exist %FDRIVE%\KERNEL.SYS attrib -R -S -H %FDRIVE%\KERNEL.SYS >NUL
if exist %FDRIVE%\FDAUTO.BAT attrib -R -S -H %FDRIVE%\FDAUTO.BAT >NUL
if exist %FDRIVE%\AUTOEXEC.BAT attrib -R -S -H %FDRIVE%\AUTOEXEC.BAT >NUL
if exist %FDRIVE%\CONFIG.SYS attrib -R -S -H %FDRIVE%\CONFIG.SYS >NUL
if exist %FDRIVE%\FDCONFIG.SYS attrib -R -S -H %FDRIVE%\FDCONFIG.SYS >NUL

if exist %FDRIVE%\DRDOS.386 attrib -R -S -H %FDRIVE%\DRDOS.386 >NUL
if exist %FDRIVE%\WINA20.386 attrib -R -S -H %FDRIVE%\WINA20.386 >>NUL
if exist %FDRIVE%\IBMBIO.COM attrib -R -S -H %FDRIVE%\IBMBIO.COM >NUL
if exist %FDRIVE%\IBMDOS.COM attrib -R -S -H %FDRIVE%\IBMDOS.COM >NUL
if exist %FDRIVE%\IO.SYS attrib -R -S -H %FDRIVE%\IO.SYS >NUL
if exist %FDRIVE%\MSDOS.SYS attrib -R -S -H %FDRIVE%\MSDOS.SYS >NUL

if "%OBAK%" == "z" goto ZipBackup

REM Backup to a renamed file  *************************************************
:SimpleBackup
vfdutil /u %FDRIVE%\FDOS_OLD.??? | set /p _AF=
if "%_AF" == "" goto SimpleBackup
mkdir %_AF% >NUL

set _AL=%_AF%\FDBACKUP.LST
date /d >%_AL%

vgotoxy /l sop eol right right
vecho /n /t %FLANG% TARGET %TFH% %_AF% %TFF%
vgotoxy /l eop sor
vprogres /f %TFP% 5

REM copy Config files to root directory as old versions.
:FDAutoLoop
vfdutil /u %FDRIVE%\FDAUTO.??? | set /p _BF=
if "%_BF%" == "" goto FDAutoLoop
if exist %FDRIVE%\FDAUTO.BAT copy %FDRIVE%\FDAUTO.BAT %_BF% >NUL
if errorlevel 1 goto CopyBackupFailed

:AutoLoop
vfdutil /u %FDRIVE%\AUTOEXEC.??? | set /p _BF=
if "%_BF%" == "" goto AutoLoop
if exist %FDRIVE%\AUTOEXEC.BAT copy %FDRIVE%\AUTOEXEC.BAT %_BF% >NUL
if errorlevel 1 goto CopyBackupFailed

:CfgLoop
vfdutil /u %FDRIVE%\CONFIG.??? | set /p _BF=
if "%_BF%" == "" goto CfgLoop
if exist %FDRIVE%\CONFIG.SYS copy %FDRIVE%\CONFIG.SYS %_BF% >NUL
if errorlevel 1 goto CopyBackupFailed

:FDCfgLoop
vfdutil /u %FDRIVE%\FDCONFIG.??? | set /p _BF=
if "%_BF%" == "" goto FDCfgLoop
if exist %FDRIVE%\FDCONFIG.SYS copy %FDRIVE%\FDCONFIG.SYS %_BF% >NUL
if errorlevel 1 goto CopyBackupFailed

REM make list of files.
if exist %FDRIVE%\FDAUTO.BAT echo %FDRIVE%\FDAUTO.BAT >>%_AL%
if exist %FDRIVE%\AUTOEXEC.BAT echo %FDRIVE%\AUTOEXEC.BAT >>%_AL%
if exist %FDRIVE%\CONFIG.SYS echo %FDRIVE%\CONFIG.SYS >>%_AL%
if exist %FDRIVE%\FDCONFIG.SYS echo %FDRIVE%\FDCONFIG.SYS >>%_AL%
if exist %FDRIVE%\KERNEL.SYS echo %FDRIVE%\KERNEL.SYS >>%_AL%
if exist %FDRIVE%\COMMAND.COM echo %FDRIVE%\COMMAND.COM >>%_AL%

REM EXTRAS
if exist %FDRIVE%\DRDOS.386 echo %FDRIVE%\DRDOS.386 >>%_AL%
if exist %FDRIVE%\WINA20.386 echo %FDRIVE%\WINA20.386 >>%_AL%
if exist %FDRIVE%\IBMBIO.COM echo %FDRIVE%\IBMBIO.COM >>%_AL%
if exist %FDRIVE%\IBMDOS.COM echo %FDRIVE%\IBMDOS.COM >>%_AL%
if exist %FDRIVE%\IO.SYS echo %FDRIVE%\IO.SYS >>%_AL%
if exist %FDRIVE%\MSDOS.SYS echo %FDRIVE%\MSDOS.SYS >>%_AL%

set _BN=1
if not exist %FTARGET%\NUL goto BackupComplete
dir /ON /A /B /P- %FTARGET%\*.*>>%_AL%

:CopyBackupRun
REM For some reason, DOS sometimes fails to do this next line correctly.
type %_AL%|vstr /L TOTAL|set /p _BM=
if "%_BM%" == "" goto CopyBackupRun

:CopyBackupLoop
vgotoxy /l eop sor

vprogres /f %TFP% %_BN% of %_BM%

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
dir /ON /A /B /P- %FTARGET%\%_BF%\*.* | vstr /l total | set /p _BT=
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

set TEMP=%FBAK%

vfdutil /u %FBAK%\FDOS????.ZIP | set /p _AF=
set _AL=%TEMP%\FDBACKUP.LST
date /d>%_AL%

vgotoxy /l sop eol right right
vecho /n /t %FLANG% TARGET %TFH% %_AF% %TFF%
vgotoxy /l eop sor
vprogres /f %TFP% 5

if exist %FDRIVE%\FDAUTO.BAT echo %FDRIVE%\FDAUTO.BAT >>%_AL%
if exist %FDRIVE%\AUTOEXEC.BAT echo %FDRIVE%\AUTOEXEC.BAT >>%_AL%
if exist %FDRIVE%\CONFIG.SYS echo %FDRIVE%\CONFIG.SYS >>%_AL%
if exist %FDRIVE%\FDCONFIG.SYS echo %FDRIVE%\FDCONFIG.SYS >>%_AL%
if exist %FDRIVE%\KERNEL.SYS echo %FDRIVE%\KERNEL.SYS >>%_AL%
if exist %FDRIVE%\COMMAND.COM echo %FDRIVE%\COMMAND.COM >>%_AL%

REM EXTRAS
if exist %FDRIVE%\DRDOS.386 echo %FDRIVE%\DRDOS.386 >>%_AL%
if exist %FDRIVE%\WINA20.386 echo %FDRIVE%\WINA20.386 >>%_AL%
if exist %FDRIVE%\IBMBIO.COM echo %FDRIVE%\IBMBIO.COM >>%_AL%
if exist %FDRIVE%\IBMDOS.COM echo %FDRIVE%\IBMDOS.COM >>%_AL%
if exist %FDRIVE%\IO.SYS echo %FDRIVE%\IO.SYS >>%_AL%
if exist %FDRIVE%\MSDOS.SYS echo %FDRIVE%\MSDOS.SYS >>%_AL%

set _BN=1
if not exist %FTARGET%\NUL goto BackupComplete
dir /ON /A /B /P- %FTARGET%\*.*>>%_AL%

:ZipBackupRun
REM For some reason, DOS sometimes fails to do this next line correctly.
type %_AL%|vstr /L TOTAL|set /p _BM=
REM So, if it's value does not get set. Do it again. Might have to do
REM with internal buffers or caching.
if "%_BM%" == "" goto ZipBackupRun

:ZipBackupLoop
vgotoxy /l eop sor

vprogres /f %TFP% %_BN% of %_BM%

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
call FDIFAIL.BAT ERROR_BACKZIP %_AF%
goto AfterBackup

:CopyBackupFailed
vdelay %FDEL%
set FERROR="Making backup."
call FDIFAIL.BAT ERROR_BACKUP %_AF%
goto AfterBackup

:AfterBackup
set _BM=
set _BF=
set _BN=
set _BT=
set _AL=
set _AF=

set TEMP=%HTMP%
set HTMP=
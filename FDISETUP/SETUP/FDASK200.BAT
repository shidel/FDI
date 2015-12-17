@echo off

if "%FDIDFMT%" == "y" goto SkipBackup
if exist %FDRIVE%\FDAUTO.BAT goto QueryBackup
if exist %FDRIVE%\AUTOEXEC.BAT goto QueryBackup
if exist %FDRIVE%\CONFIG.SYS goto QueryBackup
if exist %FDRIVE%\FDCONFIG.SYS goto QueryBackup
if exist %FDRIVE%\KERNEL.SYS goto QueryBackup
if exist %FDRIVE%\COMMAND.COM goto QueryBackup
if exist %FDRIVE%\DRDOS.386 goto QueryBackup
if exist %FDRIVE%\WINA20.386 goto QueryBackup
if exist %FDRIVE%\IBMBIO.COM goto QueryBackup
if exist %FDRIVE%\IBMDOS.COM goto QueryBackup
if exist %FDRIVE%\IO.SYS copy goto QueryBackup
if exist %FDRIVE%\MSDOS.SYS goto QueryBackup
if exist %FTARGET%\NUL goto QueryBackup
goto SkipBackup

:QueryBackup
if "%FADV%" == "y" goto QueryBackupAdv

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% BACKUP_FRAME
vecho /t %FLANG% BACKUP %TFH% %FDRIVE% %TFF%
vecho
vecho /t %FLANG% BACKUP?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% BACKUP_OPTS
vecho /t %FLANG% BACKUPY
vecho /n /t %FLANG% BACKUPN
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipBackup

set OBAK=y
verrlvl 0
goto Done

:QueryBackupAdv
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% BACKUPADV_FRAME
vecho /t %FLANG% BACKUP %TFH% %FDRIVE% %TFF%
vecho
vecho /t %FLANG% BACKUP?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% BACKUPADV_OPTS
vecho /t %FLANG% BACKUPY
vecho /t %FLANG% BACKUPZ
vecho /n /t %FLANG% BACKUPN
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 3 goto SkipBackup
if errorlevel 2 goto ZipBackup

set OBAK=y

verrlvl 0
goto Done

:ZipBackup
set OBAK=z
verrlvl 0
goto Done

:SkipBackup
set OBAK=n
verrlvl 0

:Done

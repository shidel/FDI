@echo off

if "%FDIDFMT%" == "y" goto SkipBackup
if exist C:\FDAUTO.BAT goto QueryBackup
if exist C:\AUTOEXEC.BAT goto QueryBackup
if exist C:\CONFIG.SYS goto QueryBackup
if exist C:\FDCONFIG.SYS goto QueryBackup
if exist C:\KERNEL.SYS goto QueryBackup
if exist C:\COMMAND.COM goto QueryBackup
if exist C:\DRDOS.386 goto QueryBackup
if exist C:\WINA20.386 goto QueryBackup
if exist C:\IBMBIO.COM goto QueryBackup
if exist C:\IBMDOS.COM goto QueryBackup
if exist C:\IO.SYS copy goto QueryBackup
if exist C:\MSDOS.SYS goto QueryBackup
if exist C:\FDOS\NUL goto QueryBackup
goto SkipBackup

:QueryBackup
if "%FADV%" == "y" goto QueryBackupAdv

call FDIWIND.BAT 10
vecho "A previous operating system was detected on drive " /f %TFH% C /f %TFF% "."
vecho
vecho "Do you wish to backup the old files?"
call FDIOPTS.BAT 2
vecho "  Yes - Please backup first."
vecho "  No  - Install without backing up." /n
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipBackup

set OBAK=y
verrlvl 0
goto Done

:QueryBackupAdv
call FDIWIND.BAT 11
vecho "A previous operating system was detected on drive " /f %TFH% C /f %TFF% "."
vecho
vecho "Do you wish to backup the old files?"
call FDIOPTS.BAT 3
vecho "  Yes - Please backup to a folder."
vecho "  Yes - Please backup as zip archive."
vecho "  No  - Install without backing up." /n
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
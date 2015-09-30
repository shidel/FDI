@echo off

if "%FDI_DIDFMT%" == "YES" goto SkipBackup
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
if "%FDI_ADVANCED%" == "yes" goto QueryBackupAdv

call FDIWIND.BAT 10
vecho "A previous operating system was detected on drive " /f %FDI_FHC% C /f %FDI_FFG% "."
vecho
vecho "Do you wish to backup the old files?"
call FDIOPTS.BAT 2
vecho /f %FDI_CYC% "  Yes " /f %FDI_FFG% "- Please backup first."
vecho /f %FDI_CNC% "  No  " /f %FDI_FFG% "- Install without backing up." /n
vchoice /a %FDI_FCS% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipBackup

set FDI_BAK=yes

verrlvl 0
goto Done

:QueryBackupAdv
call FDIWIND.BAT 11
vecho "A previous operating system was detected on drive " /f %FDI_FHC% C /f %FDI_FFG% "."
vecho
vecho "Do you wish to backup the old files?"
call FDIOPTS.BAT 3
vecho /f %FDI_CYC% "  Yes " /f %FDI_FFG% "- Please backup to a folder."
vecho /f %FDI_CYC% "  Yes " /f %FDI_FFG% "- Please backup as zip archive."
vecho /f %FDI_CNC% "  No  " /f %FDI_FFG% "- Install without backing up." /n
vchoice /a %FDI_FCS% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 3 goto SkipBackup
if errorlevel 2 goto ZipBackup

set FDI_BAK=yes

verrlvl 0
goto Done

:ZipBackup
set FDI_BAK=zip
verrlvl 0
goto Done

:SkipBackup
set FDI_BAK=no
verrlvl 0

:Done
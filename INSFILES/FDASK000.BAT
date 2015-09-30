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
call FDIWIND.BAT 10
vecho "A previous operating system was detected on drive " /fRed C /fBlack "."
vecho
vecho "Do you wish to backup the old files?"
call FDIOPTS.BAT 2
vecho /fGreen "  Yes " /fBlack "- Please backup first."
vecho /fRed "  No  " /fBlack "- Install without backing up." /n
vchoice /fYellow /bBlue /d 1 Ctrl-C

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipBackup

verrlvl 0
goto Done

:SkipBackup
verrlvl 0

:Done
@echo off

REM Transfer system files.

if "%OSYS%" == "y" goto DoOption
goto AfterOption

:DoOption
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IXSYS_FRAME
vecho /n /t %FLANG% IXSYS %TFH% %FDRIVE% %TFF%
vdelay %FDEL%

if exist %FDRIVE%\COMMAND.COM attrib -R -S -H %FDRIVE%\COMMAND.COM >NUL
if exist %FDRIVE%\KERNEL.SYS attrib -R -S -H %FDRIVE%\KERNEL.SYS >NUL

REM Remove NON-FREEDOS Stuff
if exist %FDRIVE%\DRDOS.386 attrib -R -S -H %FDRIVE%\DRDOS.386 >NUL
if exist %FDRIVE%\DRDOS.386 del %FDRIVE%\DRDOS.386 >NUL

if exist %FDRIVE%\WINA20.386 attrib -R -S -H %FDRIVE%\WINA20.386 >NUL
if exist %FDRIVE%\WINA20.386 del %FDRIVE%\WINA20.386 >NUL

if exist %FDRIVE%\IBMBIO.COM attrib -R -S -H %FDRIVE%\IBMBIO.COM >NUL
if exist %FDRIVE%\IBMBIO.COM del %FDRIVE%\IBMBIO.COM >NUL

if exist %FDRIVE%\IBMDOS.COM attrib -R -S -H %FDRIVE%\IBMDOS.COM >NUL
if exist %FDRIVE%\IBMDOS.COM del %FDRIVE%\IBMDOS.COM >NUL

if exist %FDRIVE%\IO.SYS attrib -R -S -H %FDRIVE%\IO.SYS >NUL
if exist %FDRIVE%\IO.SYS del %FDRIVE%\IO.SYS >NUL

if exist %FDRIVE%\MSDOS.SYS attrib -R -S -H %FDRIVE%\MSDOS.SYS >NUL
if exist %FDRIVE%\MSDOS.SYS del %FDRIVE%\MSDOS.SYS >NUL

if exist %FTARGET%\BOOT.BSS attrib -R -S -H %FTARGET%\BOOT.BSS >NUL
if exist %FTARGET%\BOOT.BSS del %FTARGET%\BOOT.BSS >NUL

if exist %FTARGET%\BOOT.MBR attrib -R -S -H %FTARGET%\BOOT.MBR >NUL
if exist %FTARGET%\BOOT.MBR del %FTARGET%\BOOT.MBR >NUL

REM Backup MBR
if "%OBPD%" == "" goto NoMBRBackup
pushd
vfdutil /c /p %FTARGET%\
fdisk /SMBR %OBPD% >NUL
popd
:NoMBRBackup

if not "%OBSS%" == "y" goto NotForceBSS
sys %FBOOTD% %FDRIVE% /BOTH /BACKUPBS %FTARGET%\BOOT.BSS >NUL
if errorlevel 1 goto Failed

if "%OBPD%" == "" goto AfterSys
fdisk /MBR %OBPD% >NUL
if errorlevel 1 goto Failed

if "%OBPN%" == "" goto AfterSys
fdisk /ACTIVATE:%OBPN% %OBPD% >NUL
if errorlevel 1 goto Failed
goto AfterSYS

:NotForceBSS
sys %FBOOTD% %FDRIVE% /BACKUPBS %FTARGET%\BOOT.BSS >NUL
if errorlevel 1 goto Failed

goto AfterSYS

:AfterSYS
verrlvl 0
if not "%FVERB%" == "y" goto AfterOption
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IXSYS_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% IXSYS_DONE
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="System file transfer to %FDRIVE% failed."
call FDIFAIL.BAT cc ERROR_XSYS %FDRIVE%
verrlvl 1

:AfterOption

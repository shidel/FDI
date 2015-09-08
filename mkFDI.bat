@echo off

REM Install Disk Options.
set VOLUMEID=FD_SETUP

REM Source file input settings.
set IDRV=C:
set IDOS=%IDRV%\FDOS
set IBIN=%IDOS%\BIN
set IINS=INSFILES
set IV8P=V8Power

REM Output to file system tree structure.
set ODRV=A:
set ODIR=%ODRV%
set ODOS=%ODIR%\FreeDOS
set OBIN=%ODOS%\BIN
set OV8P=%ODOS%\V8Power

if "%1" == "" call mkClean.bat
if not "%1" == "" goto %1

echo FreeDOS install creator.
echo.

if not exist %IV8P%\VERRLVL.COM goto MissingV8
V8Power\verrlvl 0

:FormatDisk
%IDRV%
pause Press a key to Format disk in drive %ODRV%
echo.
format %ODRV% /V:%VOLUMEID% /U
if errorlevel 1 goto Error
sys a:
if errorlevel 1 goto Error

:MakeTree
if not exist %ODOS%\NUL mkdir %ODOS%
if not exist %OBIN%\NUL mkdir %OBIN%
if not exist %ODOS%\CPI\NUL mkdir %ODOS%\CPI
if not exist %ODOS%\NLS\NUL mkdir %ODOS%\NLS
if not exist %ODOS%\HELP\NUL mkdir %ODOS%\HELP
if not exist %ODOS%\TEMP\NUL mkdir %ODOS%\TEMP
if not exist %OV8P%\NUL mkdir %OV8P%
if not "%1" == "" goto VeryEnd

:CopyBIN
echo Copying basic FreeDOS binaries.

set CPFILE=COMMAND.COM
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=COUNTRY.SYS
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=DELTREE.COM
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=DEVLOAD.COM
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=DOSLFN.COM
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=FDAPM.COM
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=FDISK.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=FDISK.INI
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=FDISK131.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=FDISKPT.INI
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=FORMAT.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=HIMEMX.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=JEMM386.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=JEMMEX.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=MEM.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=MOUSE.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=SHSUCDHD.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=SHSUCDRD.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=SHSUCDX.COM
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=SHSUFDRV.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=SHSURDRV.EXE
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=SYS.COM
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=UIDE.SYS
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=XMGR.SYS
copy %IBIN%\%CPFILE% %OBIN%
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

echo.
if not "%1" == "" goto VeryEnd

:CopyV8
if not exist %IV8P%\NUL goto MissingV8
echo Copying V8Power Tools.

set CPFILE=LICENSE
copy %IV8P%\%CPFILE% %OV8P%
if errorlevel 1 goto ErrorCopy
if not exist %OV8P%\%CPFILE% goto ErrorCopy

set CPFILE=V8POWER.TXT
copy %IV8P%\%CPFILE% %OV8P%
if errorlevel 1 goto ErrorCopy
if not exist %OV8P%\%CPFILE% goto ErrorCopy

set CPFILE=*.COM
copy %IV8P%\%CPFILE% %OV8P%
if errorlevel 1 goto ErrorCopy
if not exist %OV8P%\VINFO.COM goto ErrorCopy

echo.
if not "%1" == "" goto VeryEnd

:CopyCFG
echo Copying config files.

set CPFILE=AUTOEXEC.BAT
copy %IINS%\%CPFILE% %ODIR%\
if errorlevel 1 goto ErrorCopy
if not exist %ODIR%\%CPFILE% goto ErrorCopy

set CPFILE=FDCONFIG.SYS
copy %IINS%\%CPFILE% %ODIR%\
if errorlevel 1 goto ErrorCopy
if not exist %ODIR%\%CPFILE% goto ErrorCopy

echo.
if not "%1" == "" goto VeryEnd

:CopyINS
echo Copying setup installer files.

set CPFILE=SETUP.BAT
copy %IINS%\%CPFILE% %ODIR%\
if errorlevel 1 goto ErrorCopy
if not exist %ODIR%\%CPFILE% goto ErrorCopy

echo.
if not "%1" == "" goto VeryEnd

goto Done

:MissingV8
echo ERROR: V8Power Tools are missing.
echo.
echo Download the latest version from 'http://up.lod.bz/V8Power'.
echo Then extract them making sure the V8PT binaries are located in the
echo '%IV8P%' directory.
echo Then run this batch file again.
goto Error

:ErrorCopy
echo.
echo ERROR: Copying '%CPFILE%'.

:Error
echo.
echo Aborted.
goto VeryEnd

:Done
echo Finished.

:VeryEnd
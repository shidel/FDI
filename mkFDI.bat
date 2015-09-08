@echo off

REM Source file input settings.
set IDRV=C:
set IDOS=%IDRV%\FDOS
set IBIN=%IDOS%\BIN
set IV8P=V8Power

REM Output to file system tree structure.
set ODIR=FLOPPY
set ODOS=%ODIR%\FreeDOS
set OBIN=%ODOS%\BIN
set OV8P=%ODOS%\V8Power

REM Output to floppy disk.
set ODRV=A:

if "%1" == "" call mkClean.bat
if not "%1" == "" goto %1

echo FreeDOS install creator.
echo.

:MakeTree
if not exist %ODIR% mkdir %ODIR%
if not exist %ODOS% mkdir %ODOS%
if not exist %OBIN% mkdir %OBIN%
if not exist %ODOS%\CPI mkdir %ODOS%\CPI
if not exist %ODOS%\NLS mkdir %ODOS%\NLS
if not exist %ODOS%\HELP mkdir %ODOS%\HELP
if not exist %ODOS%\TEMP mkdir %ODOS%\TEMP
if not exist %OV8P%\CPI mkdir %OV8P%
if not "%1" == "" goto VeryEnd

:CopyV8
if not exist %IV8P% goto MissingV8
echo Copying V8Power Tools.

set CPFILE=LICENSE
copy %IV8P%\%CPFILE% %OV8P% >NUL
if errorlevel 1 goto ErrorCopy
if not exist %OV8P%\%CPFILE% goto ErrorCopy

set CPFILE=V8POWER.TXT
copy %IV8P%\%CPFILE% %OV8P% >NUL
if errorlevel 1 goto ErrorCopy
if not exist %OV8P%\%CPFILE% goto ErrorCopy

set CPFILE=*.COM
copy %IV8P%\%CPFILE% %OV8P% >NUL
if errorlevel 1 goto ErrorCopy
if not exist %OV8P%\%CPFILE% goto ErrorCopy

if not "%1" == "" goto VeryEnd

:CopyBIN
echo Copying basic FreeDOS binaries.

set CPFILE=COMMAND.COM
copy %IBIN%\%CPFILE% %OBIN% >NUL
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=DEVLOAD.COM
copy %IBIN%\%CPFILE% %OBIN% >NUL
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

set CPFILE=DOSLFN.COM
copy %IBIN%\%CPFILE% %OBIN% >NUL
if errorlevel 1 goto ErrorCopy
if not exist %OBIN%\%CPFILE% goto ErrorCopy

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
echo.
echo Finished.

:VeryEnd
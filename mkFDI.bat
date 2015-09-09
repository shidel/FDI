@echo off

REM Install Disk Options.
set VOLUMEID=FD-SETUP

REM Source file input settings.
set IDRV=C:
set IDOS=%IDRV%\FDOS
set IINS=INSFILES
set IV8P=V8Power

REM Output to file system tree structure.
set ODRV=A:
set ODIR=%ODRV%
set ODOS=%ODIR%\FreeDOS
set OV8P=%ODOS%\V8Power

echo FreeDOS install creator.
echo.

if not exist %IV8P%\VERRLVL.COM goto MissingV8
V8Power\verrlvl 0

:FormatDisk
%IDRV%
pause Press a key to Format disk in drive %ODRV%
echo.
V8Power\vstr /c13/c78/c13 | format %ODRV% /V:%VOLUMEID% /U
if errorlevel 1 goto Error
sys a:
if errorlevel 1 goto Error

:MakeTree
if not exist %ODOS%\NUL mkdir %ODOS%
if not exist %ODOS%\BIN\NUL mkdir %ODOS%\BIN
if not exist %ODOS%\CPI\NUL mkdir %ODOS%\CPI
if not exist %ODOS%\NLS\NUL mkdir %ODOS%\NLS
if not exist %ODOS%\HELP\NUL mkdir %ODOS%\HELP
if not exist %ODOS%\TEMP\NUL mkdir %ODOS%\TEMP
if not exist %OV8P%\NUL mkdir %OV8P%
if not "%1" == "" goto VeryEnd

goto CopyBIN

:CopyList
set COUNTER=0
:CopyLoop
type %IINS%\%CPLST% | V8Power\vstr /L %COUNTER% | set /p CPFILE=
if "%CPFILE%" == "" goto %CPRET%
copy %CPSRC%\%CPFILE% %CPDST%
if errorlevel 1 goto ErrorCopy
if not exist %CPDST%\%CPFILE% goto ErrorCopy
V8power\vmath %COUNTER% + 1 | set /p COUNTER=
goto CopyLoop

:CopyBIN
echo.
echo Copying basic FreeDOS binaries.
set CPLST=FDBIN.lst
set CPSRC=%IDOS%\BIN
set CPDST=%ODOS%\BIN
set CPRET=CopyHelp
goto CopyList

:CopyHelp
echo.
echo Copying some FreeDOS Help files.
set CPLST=FDHELP.lst
set CPSRC=%IDOS%\HELP
set CPDST=%ODOS%\HELP
set CPRET=CopyV8
goto CopyList

:CopyV8
echo.
echo Copying required V8Power Tools.
set CPLST=V8Power.lst
set CPSRC=%IV8P%
set CPDST=%OV8P%
set CPRET=CopyCFG
goto CopyList

:CopyCFG
echo.
echo Copying config files.

set CPFILE=AUTOEXEC.BAT
copy %IINS%\%CPFILE% %ODIR%\
if errorlevel 1 goto ErrorCopy
if not exist %ODIR%\%CPFILE% goto ErrorCopy

set CPFILE=FDCONFIG.SYS
copy %IINS%\%CPFILE% %ODIR%\
if errorlevel 1 goto ErrorCopy
if not exist %ODIR%\%CPFILE% goto ErrorCopy

:CopyINS
echo.
echo Copying setup installer files.

set CPFILE=SETUP.BAT
copy %IINS%\%CPFILE% %ODIR%\
if errorlevel 1 goto ErrorCopy
if not exist %ODIR%\%CPFILE% goto ErrorCopy

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
set COUNTER=
set CPFILE=
set CPLST=
set CPSRC=
set CPDST=
set CPRET=

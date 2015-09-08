@echo off

REM Source file input settings.
set IDRV=C:
set IDOS=%IDRV%\FDOS
set IBIN=%IDOS%\BIN

REM Output to file system tree structure.
set ODIR=FLOPPY
set ODOS=%ODIR%\FreeDOS
set OBIN=%ODOS%\BIN

REM Output to floppy disk.
set ODRV=A:

if "%1" == "" call mkClean.bat
if not "%1" == "" goto %1

echo FreeDOS install creator.

:Tree
if not exist %ODIR% mkdir %ODIR%
if not exist %ODOS% mkdir %ODOS%
if not exist %OBIN% mkdir %OBIN%
if not "%1" == "" goto VeryEnd

:Done

:VeryEnd
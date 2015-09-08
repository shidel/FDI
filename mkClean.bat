@echo off

set ODIR=FLOPPY

if not exist %ODIR% goto Done

echo Performing cleanup.

if exist %ODIR%\NUL deltree %ODIR%

echo.

:Done

@echo off

set ODIR=FLOPPY
set ODOS=%ODIR%\FreeDOS
set OV8P=%ODOS%\V8Power

if not exist %ODIR% goto Done

echo Performing cleanup.

if exist %ODOS%\BIN\NUL del %ODOS%\BIN\*.*
if exist %ODOS%\BIN rmdir %ODOS%\BIN

if exist %ODOS%\CPI\NUL del %ODOS%\CPI\*.*
if exist %ODOS%\CPI rmdir %ODOS%\CPI

if exist %ODOS%\NLS\NUL del %ODOS%\NLS\*.*
if exist %ODOS%\NLS rmdir %ODOS%\NLS

if exist %ODOS%\HELP\NUL del %ODOS%\HELP\*.*
if exist %ODOS%\HELP rmdir %ODOS%\HELP

if exist %ODOS%\TEMP\NUL del %ODOS%\TEMP\*.*
if exist %ODOS%\TEMP rmdir %ODOS%\TEMP

if exist %OV8P%\NUL del %OV8P%\*.*
if exist %OV8P% rmdir %OV8P%

if exist %ODOS%\NUL del %ODOS%\*.*
if exist %ODOS% rmdir %ODOS%

if exist %ODIR%\NUL del %ODIR%\*.*
if exist %ODIR% rmdir %ODIR%

echo.

:Done

@echo off

set OUT=FLOPPY

if not exist %OUT% goto Done

echo Performing cleanup.

if exist %OUT%\FreeDOS\BIN\NUL del %OUT%\FreeDOS\BIN\*.*
if exist %OUT%\FreeDOS\BIN rmdir %OUT%\FreeDOS\BIN

if exist %OUT%\FreeDOS\NUL del %OUT%\FreeDOS\*.*
if exist %OUT%\FreeDOS rmdir %OUT%\FreeDOS

if exist %OUT%\NUL del %OUT%\*.*
if exist %OUT% rmdir %OUT%

:Done

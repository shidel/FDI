@echo off

set OUT=FLOPPY`

if not exist %OUT% goto Done

echo Performing cleanup.

if exist %OUT% del %OUT%\*.*
if exist %OUT% rmdir %OUT%

:Done

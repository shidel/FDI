@echo off

set OUT=FLOPPY

if "%1" == "" call mkClean.bat
if not "%1" == "" goto %1

echo FreeDOS installer creator.

:Directory
if not exist %OUT% mkdir %OUT%
if not "%1" == "" goto VeryEnd

:Done

:VeryEnd
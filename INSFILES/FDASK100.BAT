@echo off

REM Configure Target Drive and Directory.

REM Later advanced mode will prompt to change it.

:Done
vfdutil /d %FTARGET% | set /p FDRIVE=
verrlvl 0
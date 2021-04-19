@echo off

REM Language specific adjustments

if "%LANG%" == "EN" goto NoCommand

if not exist %FTARGET%\NLS\CMD-%LANG%.COM goto NoCommand

copy /y %FTARGET%\NLS\CMD-%LANG%.COM %FTARGET%\BIN\COMMAND.COM >NUL
copy /y %FTARGET%\NLS\CMD-%LANG%.COM %FDRIVE%\COMMAND.COM >NUL

:NoCommand

if exist %FTARGET%\BIN\COMMAND.COM goto Done
if not exist %FDRIVE%\COMMAND.COM goto Done

copy /y %FDRIVE%\COMMAND.COM %FTARGET%\BIN\COMMAND.COM >NUL

:Done
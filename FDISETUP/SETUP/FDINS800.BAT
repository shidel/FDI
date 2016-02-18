@echo off

REM Language specific adjustments

if "%LANG%" == "EN" goto Done

if not exist %FTARGET%\NLS\CMD-%LANG%.COM goto NoCommand

copy /y %FTARGET%\NLS\CMD-%LANG%.COM %FTARGET%\BIN\COMMAND.COM >NUL
copy /y %FTARGET%\NLS\CMD-%LANG%.COM %FDRIVE%\COMMAND.COM >NUL

:NoCommand

:Done
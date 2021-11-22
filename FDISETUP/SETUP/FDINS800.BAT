@echo off

REM Language specific adjustments

rem if "%LANG%" == "EN" goto NoCommand

if not exist %FTARGET%\BIN\FREECOM\XSWAP\CMD-%LANG%.COM goto NoCommand

REM Replace with language specific version of FreeCOM

copy /y %FTARGET%\BIN\FREECOM\XSWAP\CMD-%LANG%.COM %FTARGET%\BIN\COMMAND.COM >NUL
copy /y %FTARGET%\BIN\FREECOM\XSWAP\CMD-%LANG%.COM %FDRIVE%\COMMAND.COM >NUL

:NoCommand
if exist %FTARGET%\BIN\COMMAND.COM goto Done
if not exist %FDRIVE%\COMMAND.COM goto Done

REM If no version of FreeCOM is in the BIN dir, copy the one installed by SYS
copy /y %FDRIVE%\COMMAND.COM %FTARGET%\BIN\COMMAND.COM >NUL

:Done
@ECHO off

if not exist %DOSDIR%\BIN\VECHO.COM goto SIMPLEMSG
if not exist %NLSPATH%\NUL goto SIMPLEMSG

set LANGFILE=%NLSPATH%\WELCOME.%LANG%
if not exist %LANGFILE% set LANGFILE=%NLSPATH%\WELCOME.EN
if not exist %LANGFILE% goto SIMPLEMSG

vecho /k0 /g/p /t %LANGFILE% AUTO_DONE %cfgfile% %autofile%
if not exist %DOSDIR%\BIN\HELP.EXE goto NoHelp
vecho /k0 /g/p /t %LANGFILE% AUTO_HELP HELP
:NoHelp
vecho /k0 /g/p /t %LANGFILE% AUTO_WELCOME %OS_NAME% %OS_VERSION% "$URL$"
vecho /k0 /g
goto DONE

:SIMPLEMSG
echo.
echo Done processing startup files %cfgfile% and %autofile%
echo.
if not exist %DOSDIR%\BIN\HELP.EXE goto NoSimpleHelp
echo Type HELP to get support on commands and navigation.
:NoSimpleHelp
echo Welcome to the %OS_NAME% %OS_VERSION% operating system ($URL$)
echo.
goto DONE

:DONE
set LANGFILE=

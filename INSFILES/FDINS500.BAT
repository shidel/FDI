@echo off

REM Transfer system files.

if "%OSYS%" == "y" goto DoOption
goto AfterOption

:DoOption
vfdutil /d %FTARGET% | set /p _C=

call FDIWIND.BAT 5
vecho "Transferring system boot files to drive " /f %TFH% %_C% /f %TFF% '.' /n
vdelay %FDEL%

sys %_C%>NUL
if errorlevel 1 goto Failed
verrlvl 0

if not "%FVERB%" == "y" goto AfterOption
call FDIWIND.BAT 5
vgotoxy /l sop
vecho "System file transfer complete." /n /e
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="System file transfer to %_C% failed."
call FDFAIL.BAT "Error transfering system files to %_C%."
verrlvl 1

:AfterOption
set _C=
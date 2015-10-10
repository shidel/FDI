@echo off

REM Transfer system files.

if "%OSYS%" == "y" goto SystemXfer
goto AfterSysXfer

:SystemXfer
vfdutil /d %FTARGET% | set /p _C=

call FDIWIND.BAT 5
vecho "Transferring system boot files to drive " /f %TFH% %_C% /f %TFF% '.' /n
vdelay %FDEL%

sys %_C%>NUL
if errorlevel 1 goto Failed
verrlvl 0

call FDIWIND.BAT 5
vgotoxy /l sop
vecho "System file transfer complete." /n /e
vdelay %FDEL%

goto AfterSysXfer

:Failed
set FERROR="System file transfer to %_C% failed."
verrlvl 1

:AfterSysXfer
set _C=
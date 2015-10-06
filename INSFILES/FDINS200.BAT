@echo off

REM Transfer system files.

if "%OSYS%" == "y" goto SystemXfer
goto AfterSysXfer

:SystemXfer
vfdutil /d %FTARGET% | set /p _C=

call FDIWIND.BAT 5
vecho "Transferring system boot files to drive " /f %TFH% %_C% /f %TFF% '.' /n
vdelay 1000

sys %_C%>NUL
if errorlevel 1 goto Failed
verrlvl 0
goto AfterSysXfer

:Failed
set FERROR="System file transfer to %_C% failed."
verrlvl 1

:AfterSysXfer
set _C=
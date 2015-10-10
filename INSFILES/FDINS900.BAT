@echo off

if "%OV8P%" == "y" goto DoOption
goto AfterOption

:DoOption

call FDIWIND.BAT 5
vecho "Installing a copy of V8Power Tools." /n
vdelay %FDEL%

xcopy %FINSP%\..\V8POWER %FTARGET%\V8POWER\ >NUL
if errorlevel 1 goto Failed

if not "%FVERB%" == "y" goto AfterOption
call FDIWIND.BAT 5
vgotoxy /l sop
vecho "V8Power Tools were installed." /n /e
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="Copying V8Power Tools files."
call FDFAIL.BAT "Problem installing V8Power Tools."
verrlvl 1

:AfterOption
set _C=
@echo off

REM Remove old files in FreeDOS target

if not exist %FTARGET%\NUL goto AfterOption
if "%OCLEAN%" == "y" goto DoOption
goto AfterOption

:DoOption
pushd
vfdutil /c/p %FTARGET%
cd \
popd

call FDIWIND.BAT 5
vecho /n /t %FLANG% RMOS %TFH% %FTARGET% %TFF%
vdelay %FDEL%

attrib -R -S -H %FTARGET% >NUL

dir /A /B /P- %FTARGET%\*.* | vstr /l total | set /p _BT=
if "%_BT%" == "0" goto NoFileAttrib
attrib -R -S -H /D %FTARGET%\ >NUL

:NoFileAttrib

if "%_BT%" == "0" goto NoFileDump
deltree /y %FTARGET%\*.* >NUL
if errorlevel 1 goto Failed

:NoFileDump
rmdir %FTARGET% >NUL
if errorlevel 1 goto Failed

if not "%FVERB%" == "y" goto AfterOption
call FDIWIND.BAT 5
vgotoxy /l sop
vecho /n /e /t %FLANG% RMOS_DONE
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="Cleaning up old system files."
call FDFAIL.BAT cc "Had a problem removing old system files."
verrlvl 1

:AfterOption
set _BT=
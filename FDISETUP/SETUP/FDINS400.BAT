@echo off

REM Remove old files in FreeDOS target.

if not exist %FTARGET%\NUL goto AfterOption
if "%OCLEAN%" == "y" goto DoOption
goto AfterOption

:DoOption
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IRMOS_FRAME
vecho /n /t %FLANG% IRMOS %TFH% %FTARGET% %TFF%
vdelay %FDEL%

cd %FDRIVE%\
vfdutil /c/p %FINSP%\

:CountLoop
dir /ON /A /B /P- %FTARGET%\*.* | vstr /l total | set /p _BT=
if "%_BT%%" == "" goto CountLoop

if "%_BT%" == "0" goto NoFileAttrib
attrib -R -S -H /D %FTARGET%\ >NUL
:NoFileAttrib

if "%_BT%" == "0" goto NoFileDump
deltree /y %FTARGET%\*.* >NUL
if errorlevel 1 goto Failed

:NoFileDump
rmdir %FTARGET% >NUL
if errorlevel 1 goto Failed

if not exist %FTARGET%\NUL mkdir %FTARGET% >NUL
if not exist %FTARGET%\TEMP\NUL mkdir %FTARGET%\TEMP >NUL

if not "%FVERB%" == "y" goto AfterOption
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IRMOS_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% IRMOS_DONE
vdelay %FDEL%

goto AfterOption

:Failed
if not exist %FTARGET%\NUL mkdir %FTARGET% >NUL
if not exist %FTARGET%\TEMP\NUL mkdir %FTARGET%\TEMP >NUL

set FERROR="Cleaning up old system files."
call FDFAIL.BAT cc "Had a problem removing old system files."
verrlvl 1

:AfterOption
set _BT=

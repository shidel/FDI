@echo off

REM Remove old files in FreeDOS target

if not exist %FTARTGET%\NUL goto AfterOption
if "%OCLEAN%" == "y" goto DoOption
goto AfterOption

:DoOption

call FDIWIND.BAT 5
vecho "Removing old files from '" /f %TFH% %FTARGET% /f %TFF% "'." /n
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
vfdutil /c/p %FTARGET%
cd \
vfdutil /c/p %FINSP%
rmdir %FTARGET% >NUL
if errorlevel 1 goto Failed

if not "%FVERB%" == "y" goto AfterOption
call FDIWIND.BAT 5
vgotoxy /l sop
vecho "Old operating system files were removed." /n /e
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="Cleaning up old system files."
call FDFAIL.BAT cc "Had a problem removing old system files."
verrlvl 1

:AfterOption
set _BT=
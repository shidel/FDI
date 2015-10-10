@echo off

REM Remove old files in FreeDOS target

if not exist %FTARTGET%\NUL goto AfterOption
if "%OCLEAN%" == "y" goto DoOption
goto AfterOption

:DoOption

call FDIWIND.BAT 5
vecho "Removing old files from %FTARGET%." /n
vdelay %FDEL%

attrib -R -S -H %FTARGET% >NUL
attrib -R -S -H %FTARGET%\ >NUL

deltree /y %FTARGET%\*.* >NUL
if errorlevel 1 goto Failed

rmdir %FTARGET% >NUL
if errorlevel 1 goto Failed

call FDIWIND.BAT 5
vgotoxy /l sop
vecho "Old operating system files were removed." /n /e
vdelay %FDEL%

goto AfterOption

:Failed
set FERROR="Cleaning up old system files."
call FDFAIL.BAT "Problem removing old system files."
verrlvl 1

:AfterOption
set _C=
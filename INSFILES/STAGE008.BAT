@echo off

REM Run entire install process.

call FDIWIND.BAT 10
vecho "We are now ready to install " /f %TFH% "%OS_NAME% %OS_VERSION%" /f %TFF% "."
vecho
vecho "Do you want to install now?"
call FDIOPTS.BAT 2
vecho "  Yes - Please install %OS_NAME%."
vecho "  No  - Exit to DOS." /n
vchoice /a %TFC% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto AbortBatch

:DoInstall

call FDIWIND.BAT 5
vecho "Preparing for the installation." /n
vdelay 1000

REM Scan for all install file paths.
echo %FINSP%>%TEMP%\FDIPATHS.LST
for %d in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do call FDISCAN.BAT %d

REM Scan each install file path
set _TSI=0

:LoopingPath
type %TEMP%\FDIPATHS.LST | vstr /l %_TSI% | set /p _TSA=
if "%_TSA%" == "" goto FinishedPath
verrlvl 0

set _TI=0
:Looping
dir /a /b /p- %_TSA%\FDINS*.BAT | vstr /l %_TI% | set /p _TA=
if "%_TA%" == "" goto Finished
verrlvl 0
if not exist %_TSA%\%_TA% goto AbortBatch
vfdutil /c/p %_TSA%\
call %_TA%
if errorlevel 1 goto AbortBatch
vfdutil /c/p %FINSP%\

:MissingFile
vmath %_TI% + 1 | set /p _TI=
goto Looping
:Finished

if errorlevel 1 goto AbortBatch
vmath %_TSI% + 1 | set /p _TSI=
goto LoopingPath

:FinishedPath
vfdutil /c/p %FINSP%\
verrlvl 0
goto Done

:AbortBatch
vfdutil /c/p %FINSP%\
verrlvl 1

:Done
set _TSI=
set _TSA=
set _TI=
set _TA=

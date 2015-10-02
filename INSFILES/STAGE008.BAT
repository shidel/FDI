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

echo %FINSP%>%TEMP%\FDIPATHS.LST
for %d in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do call FDISCAN.BAT %d

:EachPath
set _TSFL=0

:EachRepeat
type %TEMP%\FDIPATHS.LST | vstr /l %_TSFL% | set /p _TASK=
if "%_TASK%" == "" goto EachDone
for %f in ( %_TASK%\FDASK*.BAT ) do call %f

vmath %_TSFL% + 1 | set /p _TSFL=
goto EachRepeat

:EachDone
verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done
set _TASK=
set _TSFL=

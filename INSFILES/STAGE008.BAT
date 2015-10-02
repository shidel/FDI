@echo off

REM Run entire install process.

vecho "Preparing for the installation." /n

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

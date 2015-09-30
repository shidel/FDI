@echo off

REM Prompt user for all questions needed for install.

call FDIWIND.BAT 5

vecho "Gathering some information for the installation." /n

echo %FDI_INSP%>%TEMP%\FDIPATHS.LST
for %d in ( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ) do call FDISCAN.BAT %d FDASK

vdelay 1000

:EachPath
set FDI_TSFL=0

:EachRepeat
type %TEMP%\FDIPATHS.LST | vstr /l %FDI_TSFL% | set /p FDI_TASK=
if "%FDI_TASK%" == "" goto EachDone
for %f in ( %FDI_TASK%\FDASK*.BAT ) do call %f

vmath %FDI_TSFL% + 1 | set /p FDI_TSFL=
goto EachRepeat

:EachDone
verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done
set FDI_TASK=
set FDI_TSFL=

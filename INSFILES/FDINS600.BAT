@echo off

REM Create Package Lists
if exist %TEMP%\FDIBINS.LST del %TEMP%\FDIBINS.LST
if exist %TEMP%\FDISRCS.LST del %TEMP%\FDISRCS.LST

type %FINSP%\FDBASEB.LST>%TEMP%\FDIBINS.LST
if "%OSRC%" == "y" type %FINSP%\FDBASES.LST>%TEMP%\FDISRCS.LST
if "%OALL%" == "y" goto AddMore
goto Done

:AddMore
type %FINSP%\FDMOREB.LST>>%TEMP%\FDIBINS.LST
if "%OSRC%" == "y" type %FINSP%\FDMORES.LST>>%TEMP%\FDISRCS.LST

:Done
verrlvl 0
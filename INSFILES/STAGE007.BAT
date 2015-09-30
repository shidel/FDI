@echo off

REM Prompt user for all questions needed for install.

call FDIWIND.BAT 8

vecho "Gathering some information for the installation."
vecho
vecho

call FDISCAN.BAT FDASK

verrlvl 0
goto Done

:IncludeFiles
set FDI_TSFL=0

:IncludeRepeat
type %TEMP%\FDSCAN.LST | vstr /l %FDI_TSFL% | set /p FDI_TSFF=
if "%FDI_TSFF%" == "" goto IncludeDone
echo %FDI_TSFP%\%FDI_TSFF%>>%TEMP%\%1.LST
vmath %FDI_TSFL% + 1 | set /p FDI_TSFL=
goto IncludeRepeat

:IncludeDone
if exist %TEMP%\FDSCAN.LST del %TEMP%\FDSCAN.LST
set FDI_TSFL=
set FDI_TSFF=
set FDI_TSFP=

verrlvl 0
goto Done

:AbortBatch
verrlvl 1

:Done

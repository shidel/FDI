@echo off

REM Test for detecting FreeDOS 1.x install media location.

if "%FMEDIA%" == "" goto Check
goto CheckDone

:Check
REM Test Drive A/B actually exist to prevent single floppy change disk message.
if "%1" == "A" goto CheckDriveExists
if "%1" == "B" goto CheckDriveExists

:CheckFiles
vinfo /d %1:\
if errorlevel 15 goto MaybeCD

if errorlevel 5 goto CheckDone

REM FreeDOS 1.1 Version *******************************************************
rem if not exist %1:\FREEDOS\PACKAGES\BASE\NUL goto CheckDone
rem set FMEDIA=%1:\FREEDOS\PACKAGES\BASE

REM www.ibiblio.org ALL_CD.ISO based Version **********************************
rem if not exist %1:\BASE\NUL goto CheckDone
rem if not exist %1:\BASE\COMMAND.ZIP goto CheckDone
rem if not exist %1:\BASE\INDEX.LST goto CheckDone

:MaybeCD
vfdutil /u %1:%PKGDIR%\BASE\FDI?????.$$$ >NUL
if errorlevel 1 goto RepoCDCheck
vfdutil /u %1:%PKGDIR%\BASE\COMMAND.ZIP >NUL
if not errorlevel 1 goto RepoCDCheck
rem vfdutil /u %1:%PKGDIR%\BASE\KERNEL.ZIP >NUL
rem if not errorlevel 1 goto RepoCDCheck
vfdutil /u %1:%PKGDIR%\BASE\INDEX.LST >NUL
if not errorlevel 1 goto RepoCDCheck
set FMEDIA=%1:%PKGDIR%
goto CheckFound

:RepoCDCheck
vfdutil /u %1:\BASE\FDI?????.$$$ >NUL
if errorlevel 1 goto CheckDone
vfdutil /u %1:\BASE\COMMAND.ZIP >NUL
if not errorlevel 1 goto CheckDone
rem vfdutil /u %1:\BASE\KERNEL.ZIP >NUL
rem if not errorlevel 1 goto CheckDone
vfdutil /u %1:\BASE\INDEX.LST >NUL
if not errorlevel 1 goto CheckDone

set FMEDIA=%1:
goto CheckFound

:CheckDriveExists
vinfo /d %1
if errorlevel 5 goto CheckDone
goto CheckFiles

:CheckFound

:CheckDone
verrlvl 0

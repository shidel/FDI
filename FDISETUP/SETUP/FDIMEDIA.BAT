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
if errorlevel 15 goto InstallMedia

if errorlevel 5 goto CheckDone

REM FreeDOS 1.1 Version *******************************************************
rem depriciated, no longer updated
rem if not exist %1:\FREEDOS\PACKAGES\BASE\NUL goto InstallMedia
rem set FMEDIA=%1:\FREEDOS\PACKAGES\BASE

REM FreeDOS 1.2+ Version *******************************************************
:InstallMedia

REM Will succeed if drive and path exist
vfdutil /u %1:%PKGDIR%\BASE\FDI?????.$$$ >NUL
if errorlevel 1 goto RepoCDCheck

REM Will fail if package file exists
vfdutil /u %1:%PKGDIR%\BASE\KERNEL.ZIP >NUL
if not errorlevel 1 goto RepoCD

set FMEDIA=%1:%PKGDIR%
goto CheckFound

REM www.ibiblio.org ALL_CD.ISO & some FreeDOS 1.2 media ***********************
:RepoCD
vfdutil /u %1:\BASE\FDI?????.$$$ >NUL
if errorlevel 1 goto CheckDone
vfdutil /u %1:\BASE\KERNEL.ZIP >NUL
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

@echo off

set RETRY=yes

if "%1" == "REQUIRED" goto Required
if "%TEMP%" == "" goto MakeTemp
call \FREEDOS\SETUP\FDIDRIVE.BAT PRE %TEMP%
if "%RESULT%" == "%FINSD%" goto MakeTemp
if "%RESULT%" == "%FBOOTD%" goto MakeTemp

:NoReset
if "%TEMP%" == "" goto MakeTemp
vfdutil /u %TEMP%\TEST????.??? >NUL
if errorlevel 1 goto MakeTemp
goto Done

:MakeTemp
set TEMP=

vinfo /m
if errorlevel 103 goto NotDOSBox
if errorlevel 102 goto IsQEMU
if errorlevel 101 goto IsDOSBox

:NotDOSBox
verrlvl 0

:TryRAMDrive
if exist \FREEDOS\BIN\FDRAMDRV.BAT CALL \FREEDOS\BIN\FDRAMDRV.BAT
set RAMDRV=%FDRAMDRV%
if "%FDRAMDRV%" == "" goto NoRamDrive

:SetTempPath
set TEMP=%RAMDRV%\TEMP
set RAMDRV=
set RETRY=

if "%1" == "QUITE" goto TempExists

echo Temporary directory set to %TEMP%.

:TempExists
if not exist %TEMP%\NUL mkdir %TEMP% >NUL
if not exist %TEMP%\NUL goto NoRamDrive

verrlvl 0
goto Done

:Assimilate
set RAMDRV=%FDRAMDRV%
goto SetTempPath

:TryAgain
set RETRY=
goto TryRAMDrive

:NoRamDrive
if not "%RETRY%" == "" goto TryAgain
set RAMDRV=
set TEMP=
verrlvl 1
goto Done

:Required
vinfo /d %FDRIVE%
if errorlevel 1 goto Failed
vfdutil /u %FDRIVE%\????????.??? >NUL
if errorlevel 1 goto Failed
set FTMP=%FDRIVE%\FDITEMP.$$$
if exist %FTMP%\NUL goto PathExists
mkdir %FTMP% >NUL
if not exist %FTMP%\NUL goto Failed
:PathExists
if "%TEMP%" == "" set TEMP=%FTMP%
goto done

:IsQEMU
if not "%FDRAMDRV%" == "" goto Assimilate
:QEMU
if exist \FREEDOS\BIN\FDRAMDRV.BAT CALL \FREEDOS\BIN\FDRAMDRV.BAT
set RAMDRV=%FDRAMDRV%
if "%FDRAMDRV%" == "" goto Failed
goto SetTempPath

:IsDOSBox
if not "%FDRAMDRV%" == "" goto Assimilate
:Failed
set TEMP=
set FTMP=
verrlvl 1

:Done
set RETRY=
set RESULT=


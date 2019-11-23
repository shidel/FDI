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

:Begining
if not "%FDRAMDRV%" == "" goto Assimilate
verrlvl 1
SHSURDRV /QQ /U >NUL
if errorlevel 2 goto NotLoaded
if not errorlevel 1 goto NoRamDrive
:NotLoaded
SHSURDRV /QQ /C /D:100K,A >NUL
if errorlevel 27 goto NoRamDrive
if errorlevel  1 set RAMDRV=A:
if errorlevel  2 set RAMDRV=B:
if errorlevel  3 set RAMDRV=C:
if errorlevel  4 set RAMDRV=D:
if errorlevel  5 set RAMDRV=E:
if errorlevel  6 set RAMDRV=F:
if errorlevel  7 set RAMDRV=G:
if errorlevel  8 set RAMDRV=H:
if errorlevel  9 set RAMDRV=I:
if errorlevel 10 set RAMDRV=J:
if errorlevel 11 set RAMDRV=K:
if errorlevel 12 set RAMDRV=L:
if errorlevel 13 set RAMDRV=M:
if errorlevel 14 set RAMDRV=N:
if errorlevel 15 set RAMDRV=O:
if errorlevel 16 set RAMDRV=P:
if errorlevel 17 set RAMDRV=Q:
if errorlevel 18 set RAMDRV=R:
if errorlevel 19 set RAMDRV=S:
if errorlevel 20 set RAMDRV=T:
if errorlevel 21 set RAMDRV=U:
if errorlevel 22 set RAMDRV=V:
if errorlevel 23 set RAMDRV=W:
if errorlevel 24 set RAMDRV=X:
if errorlevel 25 set RAMDRV=Y:
if errorlevel 26 set RAMDRV=Z:
if "%RAMDRV%" == "" goto NoRamDrive

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
goto Begining

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
vinfo /dc:
REM Error 15 - Not Present / Invalid Drive Letter
if errorlevel 16 goto Failed
if not errorlevel 15 goto Failed
devload srdxms.sys >NUL
vinfo /dc:
REM Error 5 - Not Formated
if errorlevel 6 goto Failed
if not errorlevel 5 goto Failed
if errorlevel 1 srdisk 100K >NUL
if errorlevel 1 goto Failed
vinfo /dc:
if errorlevel 3 goto Failed
if not errorlevel 2 goto Failed
vfdutil /u C:\TEST????.$$$ >NUL
if errorlevel 1 goto Failed
set RAMDRV=C:
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


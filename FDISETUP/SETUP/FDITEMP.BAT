@echo off

set TEMP=
set RETRY=yes

rem if not "%TEMP%" == "" goto TempExists

:Begining
verrlvl 1
SHSURDRV /QQ /U
if errorlevel 2 goto NotLoaded
if not errorlevel 1 goto NoRamDrive
:NotLoaded
SHSURDRV /QQ /D:200K,A
if errorlevel 28 goto NoRamDrive
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

set TEMP=%RAMDRV%\TEMP
set RAMDRV=
set RETRY=

if "%1" == "/Q" goto TempExists
if "%1" == "/q" goto TempExists

echo Temporary directory set to %TEMP%.

:TempExists
if not exist %TEMP%\NUL mkdir %TEMP% >NUL
if not exist %TEMP%\NUL goto NoRamDrive

verrlvl 0
goto Done

:TryAgain
set RETRY=
goto Begining

:NoRamDrive
if not "%RETRY%" == "" goto TryAgain
set RAMDRV=
set TEMP=
set RETRY=
verrlvl 1
:Done
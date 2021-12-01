@echo off

REM maybe prompt for force MBR update if possible and not blank.

vinfo /m
if errorlevel 102 goto NotDOSBox
if errorlevel 101 goto IsDOSBox
:NotDOSBox
verrlvl 0

set OBPC=2

if "%OSYS%" == "n" goto SkipSysXfer

REM Find drive number where drive letter resides.
set OBPD=1
fdisk /info %OBPD% | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto DriveFound
set OBPD=2
fdisk /info %OBPD% | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto DriveFound
set OBPD=3
fdisk /info %OBPD% | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto DriveFound
set OBPD=4
fdisk /info %OBPD% | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto DriveFound
set OBPD=5
fdisk /info %OBPD% | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto DriveFound
set OBPD=6
fdisk /info %OBPD% | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto DriveFound
set OBPD=7
fdisk /info %OBPD% | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto DriveFound
set OBPD=8
fdisk /info %OBPD% | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto DriveFound
set OBPD=
set OBPN=
goto SkipSysXfer

:DriveFound
fdisk /info %OBPD% | grep -i ^Contents | grep "^ %FDRIVE%" >NUL
if not errorlevel 1 goto FindComplex

:FindSimple
set OBPN=
fdisk /info %OBPD% | grep "^ %FDRIVE%" | vstr /b /f " " 3 | set /p OBPN=
if "%OBPN%" == "" goto FindSimple
goto FindCount

:FindComplex
set OBPN=?
fdisk /info %OBPD% | grep -B 100 -i ^Contents | grep "^ %FDRIVE%" >NUL
if errorlevel 1 goto PromptUser
set OBPN=
fdisk /info %OBPD% | grep -B 100 -i ^Contents | grep "^ %FDRIVE%" | vstr /b /f " " 3 | set /p OBPN=
if "%OBPN%" == "" goto FindComplex

:FindCount
set OBPC=
fdisk /info %OBPD% | grep % | vstr /b /l total | set /p OBPC=
if "%OBPC%" == "" goto FindCount

if not "%OBPC%" == "1" set OBPC=2

:PromptUser
if "%FADV%" == "y" goto AdvancedMode

REM check that data was populated correctly
if "%OBPD%" == "" goto PromptMBR
if "%OBPN%" == "" goto PromptMBR

vinfo /E %OBPN%
if errorlevel 10 goto PromptMBR
goto AssumeYes

:PromptMBR
set OBPC=1

:AdvancedMode
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% OBSS_FRAME
vecho /k0 /t %FLANG% OBSS? %TFH% %FDRIVE% %TFF% %OBPD% %OBPN%
vecho  /k0
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% OBSS_OPTS
vecho /k0 /t %FLANG% OBSSY
vecho /k0 /n /t %FLANG% OBSSN
vchoice /k0 /a %TFC% Ctrl-C /d %OBPC%

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipSysXfer

:AssumeYes
set OBSS=y
if "%OBPN%" == "?" set OBPN=
verrlvl 0
goto Done

:IsDOSBox
:SkipSysXfer
set OBSS=n
set OBPD=
set OBPN=
verrlvl 0

:Done
set OBPC=
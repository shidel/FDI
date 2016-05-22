@echo off

REM FreeDOS 1.2+ Installer version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2016 Jerome Shidel.

set FCURSOR=small
if "%TEMP%" == "" goto NoReadCursor
vcursor | set /p FCURSOR=
:NoReadCursor

REM Configure initial mode ****************************************************
REM Change to directory and path of this batch file.
vfdutil /c /p %0

REM Configure commmand-line options
set FADV=
set FBOOTED=

if "%1" == "BOOT" set FBOOTED=y
if "%1" == "CDROM" set FBOOTED=CDROM
if "%1" == "adv" set FADV=y
if "%1" == "ADV" set FADV=y
if "%1" == "MBRZAP" set FADV=y

REM Run Installer Stages ******************************************************

set FDIDFMT=NO

REM Run configuration stage.
set FSTAGE=000
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

:DetectPreviousInstall
REM Detect if this version is already installed
if "%FBOOTED%" == "" goto SkipInstallCheck
set FSTAGE=100
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted
if exist FDCHECK.BAT call FDCHECK.BAT FIRST
if errorlevel 1 goto PlatformNotSupported
if "%FFOUND%" == "y" goto NoInstallNeeded
verrlvl 0
:SkipInstallCheck

REM Show Logo file if present.
if exist FDSPLASH.BAT call FDSPLASH.BAT
if errorlevel 1 goto Aborted

REM Set Installer theme.
set FSTAGE=200
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

if "%1" == "MBRZAP" goto DiskTesting

REM Welcome
set FSTAGE=300
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

:DiskTesting
REM Partitoned
set FSTAGE=400
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Formatted
set FSTAGE=500
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Beyond this point, a temp directory is required.
set FSTAGE=TMP
call FDITEMP.BAT REQUIRED
if errorlevel 1 goto Error

REM Check requirements if testing is present.
if exist FDCHECK.BAT call FDCHECK.BAT SECOND
if errorlevel 1 goto Aborted

if "%1" == "MBRZAP" goto MBRZAP

REM Locate Package Media.
set FSTAGE=600
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Ask the user all of the Questions.
SET HTARGET=%FTARGET%
set FSTAGE=700
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted
if not "%HTARGET%" == "%FTARGET%" goto DiskTesting
SET HTARGET=

if exist FDCHECK.BAT call FDCHECK.BAT THIRD
if errorlevel 1 goto Aborted

REM Do the installation.
set FSTAGE=800
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

:PostInstall
REM Post install stuff, like recommend reboot.
set FSTAGE=900
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

:CleanUp
REM Run cleanup stage.
if "%FREBOOT%" == "y" goto DoReboot
call FDICLEAN.BAT

REM Ran all installer stages **************************************************
verrlvl 0
goto Completed

REM Ran all installer stages **************************************************
:MBRZAP
SET HTARGET=%FTARGET%
set FSTAGE=700
set OSYS=y
vcursor hide
call FDILANG.BAT FDSETUP
call FDICLS.BAT
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
if not exist FDASK100.BAT goto Error
verrlvl 0
call FDASK100.BAT
if errorlevel 1 goto Aborted
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
if not "%HTARGET%" == "%FTARGET%" goto DiskTesting
SET HTARGET=
if not exist FDASK600.BAT goto Error
verrlvl 0
call FDASK600.BAT
if errorlevel 1 goto Aborted
if not "%OBSS%" == "y" vcls /g /a7
if not "%OBSS%" == "y" goto CleanUp
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
if not exist FDINS700.BAT goto Error
verrlvl 0
call FDINS700.BAT
if errorlevel 1 goto Aborted
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
goto PostInstall

:NoInstallNeeded
REM Run cleanup stage.
call FDICLEAN.BAT
if exist FDNOTICE.BAT call FDNOTICE.BAT
verrlvl 0
set FDRIVE=
goto Finished

:PlatformNotSupported
REM Run cleanup stage.
call FDICLEAN.BAT
if exist FDNORUN.BAT call FDNORUN.BAT
verrlvl 0
set FDRIVE=
goto Finished

REM Installer completed successfully ******************************************
:Completed
verrlvl 0
goto Finished

REM Installer failed from missing stage file **********************************
:Error
call FDICLEAN.BAT
:NoCleanupStage
vcls /a 0x07
vecho /t %FLANG% STAGE_ERROR %FSTAGE%
set FDRIVE=
goto Finished

REM Installer failed to install or was aborted ********************************
:Aborted
call FDICLEAN.BAT
:AbortedNoCleanup
vcls /a 0x07
if "%FREBOOT%" == "y" goto DoReboot
if "%OS_NAME%" == "" goto NoOSName
vecho /t %FLANG% ABORTED "%OS_NAME% %OS_VERSION%"
vecho
:NoOSName
if not "%FERROR%" == "" vecho /fWhite "Error: " /fGray /n
if not "%FERROR%" == "" vecho %FERROR%
if not "%FERROR%" == "" vecho
if exist FDERROR.BAT call FDERROR.BAT
set FDRIVE=
goto Finished

REM Post execution cleanup ****************************************************
:Finished
vfdutil /c /p %0

if "%FREBOOT%" == "y" goto DoReboot

set FADV=
set FBOOTED=
set FSTAGE=
set FCURSOR=
set FERROR=
set FDEBUG=
set FWAIT=
set FDEL=
set FLANG=

if "%FREBOOT%" == "n" goto DoExit

set FDRIVE=
set FTARGET=

goto DontDoAnything

:DoReboot
call FDICLEAN.BAT TEMPONLY
vcls /a 0x07

if "%CACHED%" == "NO" goto NoFlush
if "%TEMP%" == "" goto JustFlush
lbacache STAT | grep -i caching >NUL
if errorlevel 1 goto NoFlush
:JustFlush
lbacache SYNC
lbacache STOP
:NoFlush

vline hidden
vgotoxy /g eop sor
vecho /bRed /e /n /t %FLANG% REBOOT_PAUSE White Yellow

REM POSTAL for vpause is an undocumented option. Generally, it should only
REM be used in extremely rare cases. When specified, instead of returning to
REM DOS after the pause is completed. vpause will initiate the BIOS POST system.
REM (Power On Self Test). Basically, it is a forced reboot. If care is not
REM taken, any disk write caches and buffers will be lost and will result in
REM file system corruption. For this reason, the POSTAL option will always
REM remain undocumented.
vpause /fLightCyan /d 60 CTRL+C POSTAL
if errorlevel 200 goto SkipReboot

REM We really cannot get here unless something went really, really wrong.
fdapm warmboot
REM goto DontDoAnything

:SkipReboot
set FREBOOT=n
goto CleanUp

:DoExit
set FREBOOT=
vcls /a 0x07
if exist FDTHANK.BAT call FDTHANK.BAT
rem set FLANG=
if exist FDSWPENV.BAT call FDSWPENV.BAT
if not "%FDRIVE%" == "" cd %FDRIVE%\
cd \

REM End of Batch Script *******************************************************
:DontDoAnything
rem set FLANG=
if not "%FCLANG%" == "" set LANG=
set FCLANG=

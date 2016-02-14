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
if "%1" == "adv" set FADV=y
if "%1" == "ADV" set FADV=y

REM Run Installer Stages ******************************************************

set FDIDFMT=NO

REM Run configuration stage.
set FSTAGE=000
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Detect if this version is already installed
if not "%FBOOTED%" == "y" goto SkipInstallCheck
set FSTAGE=100
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted
if "%FFOUND%" == "y" goto NoInstallNeeded
verrlvl 0
:SkipInstallCheck

REM Show Logo file if present.
call FDILANG.BAT FDSPLASH FDSETUP
if exist FDSPLASH.BAT call FDSPLASH.BAT
if errorlevel 1 goto Aborted

REM Set Installer theme.
set FSTAGE=200
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Welcome
set FSTAGE=300
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

:DiskTesting
REM Partitoned
set FSTAGE=400
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Formatted
set FSTAGE=500
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Reserved. Final stage prior to testing requirements and user prompts.
set FSTAGE=600
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Beyond this point, a temp directory is required.
set FSTAGE=TMP
call FDITEMP.BAT REQUIRED
if errorlevel 1 goto Error

REM Check requirements if testing is present.
call FDILANG.BAT FDCHECK FDSETUP
if exist FDCHECK.BAT call FDCHECK.BAT
if errorlevel 1 goto Aborted

REM Ask the user all of the Questions.
SET HTARGET=%FTARGET%
set FSTAGE=700
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted
if not "%HTARGET%" == "%FTARGET%" goto DiskTesting
SET HTARGET=

REM Do the installation.
set FSTAGE=800
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Post install stuff, like recommend reboot.
set FSTAGE=900
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
if errorlevel 1 goto Aborted

REM Run cleanup stage.
set FSTAGE=999
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT

REM Ran all installer stages **************************************************
verrlvl 0
goto Completed

:NoInstallNeeded
REM Run cleanup stage.
set FSTAGE=999
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
call FDILANG.BAT FDNOTICE FDSETUP
if exist FDNOTICE.BAT call FDNOTICE.BAT
verrlvl 0
set FDRIVE=
goto Finished

REM Installer completed successfully ******************************************
:Completed
verrlvl 0
goto Finished

REM Installer failed from missing stage file **********************************
:Error
call FDILANG.BAT FDSETUP
if not exist STAGE999.BAT goto NoCleanupStage
call STAGE999.BAT
:NoCleanupStage
vcls /a 0x07
call FDILANG.BAT FDSETUP
vecho /t %FLANG% STAGE_ERROR %FSTAGE%
set FDRIVE=
goto Finished

REM Installer failed to install or was aborted ********************************
:Aborted
set FSTAGE=999
call FDILANG.BAT FDSETUP
if not exist STAGE%FSTAGE%.BAT goto Error
call STAGE%FSTAGE%.BAT
:AbortedNoCleanup
call FDILANG.BAT FDSETUP
vcls /a 0x07
if "%FREBOOT%" == "y" goto DoReboot
if "%OS_NAME%" == "" goto NoOSName
vecho /t %FLANG% ABORTED "%OS_NAME% %OS_VERSION%"
vecho
:NoOSName
if not "%FERROR%" == "" vecho /fWhite "Error: " /fGray /n
if not "%FERROR%" == "" vecho %FERROR%
if not "%FERROR%" == "" vecho
call FDILANG.BAT FDERROR FDSETUP
if exist FDERROR.BAT call FDERROR.BAT
set FDRIVE=
goto Finished

REM Post execution cleanup ****************************************************
:Finished
vfdutil /c /p %0

set FADV=
set FBOOTED=
set FSTAGE=
set FCURSOR=
set FERROR=
set FDEBUG=
set FWAIT=
set FDEL=
set FLANG=

if "%FREBOOT%" == "y" goto DoReboot
if "%FREBOOT%" == "n" goto DoExit

set FDRIVE=
set FTARGET=

goto DontDoAnything

:DoReboot
call FDILANG.BAT FDSETUP
vcls /a 0x07
lbacache SYNC
lbacache STOP
vline hidden
vgotoxy eop sor
vecho /bRed /e /n /t %FLANG% REBOOT_PAUSE White Yellow

REM POSTAL for vpause is an undocumented option. Generally, it should only
REM be used in extremely rare cases. When specified, instead of returning to
REM DOS after the pause is completed. vpause will initiate the BIOS POST system.
REM (Power On Self Test). Basically, it is a forced reboot. If care is not
REM taken, any disk write caches and buffers will be lost and will result in
REM file system corruption. For this reason, the POSTAL option will always
REM remain undocumented.
vpause /fLightCyan /d 30 CTRL+C POSTAL
if errorlevel 200 goto DoExit

REM We really cannot get here unless something went really, really wrong.
fdapm warmboot
goto DontDoAnything

:DoExit
set FREBOOT=
vcls /a 0x07
call FDILANG.BAT FDTHANK FDSETUP
if exist FDTHANK.BAT call FDTHANK.BAT
set FLANG=
if exist FDSWPENV.BAT call FDSWPENV.BAT
if not "%FDRIVE%" == "" cd %FDRIVE%\
cd \

REM End of Batch Script *******************************************************
:DontDoAnything

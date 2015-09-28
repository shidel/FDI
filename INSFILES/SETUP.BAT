@echo off

REM FreeDOS Installer.
REM Released Under GPL v2.0 License.
REM Created by Jerome Shidel.

REM Test for Presence of V8Power Tools ****************************************

REM Check current errorlevel is 255, then test by clearing it.
if errorlevel 255 goto ClearError

REM Check by setting errorlevel to 255.
:CheckPresence
verrlvl 255
if errorlevel 255 goto V8Present

REM V8Power Tools are not present.
:V8Missing
echo V8Power Tools were not found. Please install or boot from this media and
echo try again.
goto DontDoAnything

REM Check by setting errorlevel to 0.
:ClearError
verrlvl 0
if errorlevel 1 goto V8Missing

REM V8Power Tools Found *******************************************************
:V8Present
verrlvl 0

REM Test if SET /P is available. It does not function under DOSBox, PC-DOS,
REM MS-DOS and under the FreeDOS 4DOS shell. The standard FreeDOS shell and
REM later versions of Windows DOS support it.

set FDI_PIPES=NO
if "%TEMP%" == "" goto NoPipeSupport
echo. | set /p FDI_PIPES=
if "%FDI_PIPES%" == "NO" goto NoPipeSupport
echo YES| set /p FDI_PIPES=
if not "%FDI_PIPES%" == "YES" goto NoPipeSupport
vcursor | set /p FDI_CURSOR=
goto PipeSupport

:NoPipeSupport
set FDI_CURSOR=small

:PipeSupport

REM Change to directory and path of this batch file.
vfdutil /c /p "%0"
if not exist FDSETUP\SETUP\NUL goto Error
cd FDSETUP\SETUP

REM Configure commmand-line options
set FDI_ADVANCED=
set FDI_RECOVERY=

if "%1" == "recovery" set FDI_RECOVERY=yes
if "%1" == "RECOVERY" set FDI_RECOVERY=yes
if "%1" == "adv" set FDI_ADVANCED=yes
if "%1" == "ADV" set FDI_ADVANCED=yes
if "%1" == "advanced" set FDI_ADVANCED=yes
if "%1" == "ADVANCED" set FDI_ADVANCED=yes

REM Run configuration stage.
set FDI_STAGE=CFG
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

if not "%FDI_RECOVERY%" == "yes" goto SkipInstallCheck
set FDI_STAGE=FDI
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 2 goto Finished
if errorlevel 1 goto Aborted

:SkipInstallCheck

REM Set Installer theme.
set FDI_THEME=NUL
if "%FDI_ADVANCED%" == "yes" set FDI_THEME=ADV
if not exist THEME%FDI_THEME%.BAT goto Error
call THEME%FDI_THEME%.BAT
if errorlevel 1 goto Aborted

REM Run Stage processor.
vcursor hide
set FDI_STAGE=RUN
if not exist STAGE%FDI_STAGE%.BAT goto Error
call STAGE%FDI_STAGE%.BAT
if errorlevel 1 goto Aborted

REM Installer completed successfully ******************************************
:Completed
if not "%FDI_DEBUG%" == "yes" goto NoPause
vgotoxy /g eop sor
vecho /g /a0x70 " Finished, Press a key... " /e /n
vpause /t %FDI_PAUSE%
:NoPause
vcls /a 0x07
goto Finished

REM Installer failed or was aborted *******************************************
:Error
vcls /a 0x07
echo Unable to execute installer stage %FDI_STAGE%. It is possible the installer is
echo corrupt. Please re-download it or try a different method of installation.
goto Finished

REM Installer failed or was aborted *******************************************
:Aborted
vcls /a 0x07
vecho /fWhite /bRed " Installation of %OS_NAME% %OS_VERSION% was aborted." /e /fGray
vecho
if not "%FDI_ERROR%" == "" vecho %FDI_ERROR%
if not "%FDI_ERROR%" == "" vecho
goto Finished

REM Post execution cleanup ****************************************************
:Finished
REM Run cleanup stage.
set FDI_STAGE=END
if not exist STAGE%FDI_STAGE%.BAT goto NoCleanupStage
call STAGE%FDI_STAGE%.BAT
cd ..\..
:NoCleanupStage

vfdutil /c /p "%0"
vcursor %FDI_CURSOR%

set FDI_ADVANCED=
set FDI_RECOVERY=
set FDI_STAGE=
set FDI_PIPES=
set FDI_CURSOR=
set FDI_ERROR=

REM End of Batch Script *******************************************************
:DontDoAnything

@echo off

REM Set operating system TITLE and VERSION for installer, not cleared at exit.
set OS_NAME=FreeDOS
set OS_VERSION=1.1a
set VOL_NAME=FreeDOS2015

REM Set other installer options. Cleared at exit.

REM Drive C Formatting options.
set FMTCOPTS=/Q /U /Z:seriously

REM Pause duration after Format and System file transfers.
set PAUSING=15

REM Default Temp Directory.
set FDTEMP=C:\FDTEMP

REM Flag for remembering if drive was formatted.
set WASFORMATED=NO

REM Test for Presence of V8Power Tools
if errorlevel 255 goto ClearError

:CheckPresence
verrlvl 255
if errorlevel 255 goto V8Present

:V8Missing
echo V8Power Tools were not found.
goto DontDoAnything

:ClearError
verrlvl 0
if errorlevel 1 goto V8Missing

:V8Present
verrlvl 0

REM When booting /CheckStatus switch is provided. This way the installer knows
REM it wasn't the user requesting the installer and the disk is being used
REM for recovery or booting.
if not "%1" == "/CheckStatus" goto SkipCheckingStatus

REM **** Check if it is already installed ****
REM Test should "set FDINSSTATUS=INSTALLED" if the OS is installed.
REM **** End of checking ****

if "%FDINSSTATUS%" == "INSTALLED" goto DontDoAnything

:SkipCheckingStatus

REM Test if SET /P is available. It does not function under DOSBox, PC-DOS,
REM MS-DOS and under the FreeDOS 4DOS shell. The standard FreeDOS shell and
REM later versions of Windows DOS support it.

set PIPES_OK=NO
if "%TEMP%" == "" goto NoPipeSupport
echo. | set /p PIPES_OK=
if "%PIPES_OK%" == "NO" goto NoPipeSupport
echo YES| set /p PIPES_OK=
if not "%PIPES_OK%" == "YES" goto NoPipeSupport
vcursor | set /p EXIT_CURSOR=
goto StartBatch

:NoPipeSupport
set EXIT_CURSOR=small

REM **** Start of the installer ****
:StartBatch
set ReturnFromC=StartBatch
vcursor hide

REM Clear entire screen.
vcls /fGray /bBlue

REM Draw the Title Bar
vgotoxy /x1 /y1
vcls /bGray /fBlack EOL
vgotoxy /x30 /y1
vecho /fBlack "%OS_NAME% " /fRed "%OS_VERSION%" /fBlack " Installer"

REM Draw the welcome screen.
vframe /bGray /fBlack /w60 /h10 /c /y7 hidden shadow
vframe /bGray /fBlack /w58 /h10 /c /y7 single
vframe /bGray /fBlack /w56 /h8 /c /y8 hidden
vecho "Welcome to the installation program for " /fRed "%OS_NAME% %OS_VERSION%" /fBlack "."
vecho
vecho "Do you wish to proceed?"
vframe /w40 /h4 /c /y12 hidden
vecho /fGreen "  Yes " /fBlack "- Continue with Installation"
vecho /fRed "  No  " /fBlack "- Return to DOS" /n
vchoice /fYellow /bBlue Ctrl-C

if errorlevel 200 goto ControlCPress
if errorlevel 2 goto DoNotInstall

vinfo /dC

if errorlevel 100 goto AbortBatch
if errorlevel 15 goto NoSuchDrive
if errorlevel 5 goto NotFormatted
if errorlevel 2 goto WrongTypeDrive

REM Drive C is OK.

goto PrepForInstall

:NoSuchDrive
:WrongTypeDrive
set ReturnFromC=WrongTypeDrive
vcls /fGray /bBlue /y2 /h24
vframe /bGray /fBlack /w60 /h10 /c /y7 hidden shadow
vframe /bGray /fBlack /w58 /h10 /c /y7 single
vframe /bGray /fBlack /w56 /h8 /c /y8 hidden
vecho "Drive " /fRed C /fBlack " does not appear to be partitioned."
vecho
vecho "Do you wish to partition your drive?"
vframe /w40 /h4 /c /y12 hidden
vecho /fGreen "  Yes " /fBlack "- Launch Partitioner."
vecho /fRed "  No  " /fBlack "- Return to DOS" /n
vchoice /fYellow /bBlue /d 2 Ctrl-C

if errorlevel 200 goto ControlCPress
if errorlevel 2 goto AbortBatch

vcls /a0x07
vcursor %EXIT_CURSOR%

REM **** Launch Partitioning Program ****
fdisk 1
REM **** Returned from Partitioning ****

vcursor hide
:AfterPartitioned
set ReturnFromC=AfterPartitioned

vcls /fGray /bBlue
vcls /bGray /fBlack EOL
vgotoxy /x30
vecho /fBlack "%OS_NAME% " /fRed "%OS_VERSION%" /fBlack " Installer"
vframe /bGray /fBlack /w60 /h11 /c /y7 hidden shadow
vframe /bGray /fBlack /w58 /h11 /c /y7 single
vframe /bGray /fBlack /w56 /h9 /c /y8 hidden
vecho /n "You must reboot your computer for the new partitioning"
vecho "scheme to take effect."
vecho
vecho "Do you wish to reboot now?"
vframe /w40 /h4 /c /y13 hidden
vecho /fGreen "  Yes " /fBlack "- Please reboot now."
vecho /fRed "  No  " /fBlack "- Return to DOS" /n
vchoice /fYellow /bBlue Ctrl-C

if errorlevel 200 goto ControlCPress
if errorlevel 2 goto AbortBatch
vcls /a0x07
vecho "The computer will now reboot."
vecho
reboot
goto AbortBatch

:NotFormatted
set ReturnFromC=NotFormatted
vcls /fGray /bBlue /y2 /h24
vframe /bGray /fBlack /w60 /h10 /c /y7 hidden shadow
vframe /bGray /fBlack /w58 /h10 /c /y7 single
vframe /bGray /fBlack /w56 /h8 /c /y8 hidden
vecho "Drive " /fRed C /fBlack " does not appear to be formatted."
vecho
vecho "Do you wish to format your drive?"
vframe /w44 /h4 /c /y12 hidden
vecho /fGreen "  Yes " /fBlack "- Please erase and format drive C."
vecho /fRed "  No  " /fBlack "- Return to DOS" /n
vchoice /fYellow /bBlue /d 2 Ctrl-C

if errorlevel 200 goto ControlCPress
if errorlevel 2 goto AbortBatch

vcls /fWhite /bBlue /y2 /h24
vgotoxy down
vecho /fGray "Formatting drive " /fWhite C /fGray "..."
vecho
vcursor %EXIT_CURSOR%

REM **** Launch Formatting Program ****
format C: /V:%VOL_NAME% %FMTCOPTS%
REM **** Returned from Formatting ****

set WASFORMATED=YES
set ReturnFromC=AfterFormat
vcursor hide
vgotoxy eop sor
vecho /n /fLightGreen "Press a key... " /e
vpause /fLightCyan /t %PAUSING% CTRL-C

if errorlevel 200 goto ControlCPress

:AfterFormat
vinfo /dC

REM **** May want to say, we still cannot read C and offer to reboot. ****
if errorlevel 2 goto StartBatch

goto PrepForInstall

:PrepForInstall
if "%TEMP%" == "" set TEMP=%FDTEMP%
if "%TMP%" == "" set TEMP=%TEMP%
if not exist %TEMP%\NUL mkdir "%TEMP%

if "%WASFORMATED%" == "YES" goto SkipBackup
if exist C:\FDAUTO.BAT goto QueryBackup
if exist C:\AUTOEXEC.BAT goto QueryBackup
if exist C:\CONFIG.SYS goto QueryBackup
if exist C:\FDCONFIG.SYS goto QueryBackup
if exist C:\KERNEL.SYS goto QueryBackup
if exist C:\COMMAND.COM goto QueryBackup
if exist C:\DRDOS.386 goto QueryBackup
if exist C:\WINA20.386 goto QueryBackup
if exist C:\IBMBIO.COM goto QueryBackup
if exist C:\IBMDOS.COM goto QueryBackup
if exist C:\IO.SYS copy goto QueryBackup
if exist C:\MSDOS.SYS goto QueryBackup
if exist C:\FDOS\NUL goto QueryBackup
goto SkipBackup

:QueryBackup
set ReturnFromC=QueryBackup
vcls /fGray /bBlue /y2 /h24
vframe /bGray /fBlack /w60 /h10 /c /y7 hidden shadow
vframe /bGray /fBlack /w58 /h10 /c /y7 single
vframe /bGray /fBlack /w56 /h8 /c /y8 hidden
vecho "A previous operating system was detected on drive " /fRed C /fBlack "."
vecho
vecho "Do you wish to backup the old files?"
vframe /w44 /h4 /c /y12 hidden
vecho /fGreen "  Yes " /fBlack "- Please backup first."
vecho /fRed "  No  " /fBlack "- Install without backing up." /n
vchoice /fYellow /bBlue /d 1 Ctrl-C

if errorlevel 200 goto ControlCPress
if errorlevel 2 goto SkipBackup

vcls /fGray /bBlue /y2 /h24
vframe /bGray /fBlack /w60 /h8 /c /y7 hidden shadow
vframe /bGray /fBlack /w58 /h8 /c /y7 single
vframe /bGray /fBlack /w56 /h6 /c /y8 hidden
vecho /n "Creating backup"
vgotoxy /l eop sor
vprogres /fBlack 0
if not exist C:\FDBACKUP\NUL mkdir C:\FDBACKUP

set BFILE=0
:SetBFile
if not exist C:\FDBACKUP\FDBAK%BFILE%.ZIP goto GoodBFile
:IncBFile
vmath %BFILE% + 1 | set /p BFILE=
if not "%BFILE%" == "1000" goto SetBFile
ERRORMSG="Too many backup files in '" /fWhite "C:\FDBACKUP\" /fGray "'".
goto AbortBatch

:GoodBFile
set BLIST=C:\FDBACKUP\FDBAK%BFILE%.LST
if exist %BLIST% goto IncBFile
set BFILE=C:\FDBACKUP\FDBAK%BFILE%.ZIP
echo %BLIST% >%BLIST%
vgotoxy /l sop eol right right
vecho /n "'" /fBlue "%BFILE%" /fBlack "'"
vgotoxy /l eop sor
vprogres /fBlack 5

if exist C:\FDAUTO.BAT echo C:\FDAUTO.BAT >>%BLIST%
if exist C:\AUTOEXEC.BAT echo C:\AUTOEXEC.BAT >>%BLIST%
if exist C:\CONFIG.SYS echo C:\CONFIG.SYS >>%BLIST%
if exist C:\FDCONFIG.SYS echo C:\FDCONFIG.SYS >>%BLIST%
if exist C:\KERNEL.SYS echo C:\KERNEL.SYS >>%BLIST%
if exist C:\COMMAND.COM echo C:\COMMAND.COM >>%BLIST%

REM EXTRAS
if exist C:\DRDOS.386 echo C:\DRDOS.386 >>%BLIST%
if exist C:\WINA20.386 echo C:\WINA20.386 >>%BLIST%
if exist C:\IBMBIO.COM echo C:\IBMBIO.COM >>%BLIST%
if exist C:\IBMDOS.COM echo C:\IBMDOS.COM >>%BLIST%
if exist C:\IO.SYS echo C:\IO.SYS >>%BLIST%
if exist C:\MSDOS.SYS echo C:\MSDOS.SYS >>%BLIST%

vprogres /fBlack 10
rem zip -q -9 -S -u -b %FDITEMP% %BFILE% C:\FDAUTO.BAT

if not exist C:\FDOS\NUL goto BackupRun
:BackupRun

:BackupComplete
vprogres /fBlack 100
vdelay 1000
set BLIST=
set BFILE=

vcls /fGray /bBlue /y2 /h24

:SkipBackup

:FindSourceMedia
vcls /fGray /bBlue /y2 /h24

:MakeBackup

:BeginInstall
vcls /fWhite /bBlue /y2 /h24
vgotoxy down down
vecho /fGray "Transferring " /fLightGreen %OS_NAME% /fGray " boot files..."
vecho

REM **** Launch transfer system files ****
sys C:
REM **** Returned from transfering system files ****

set ReturnFromC=AfterSysXfer
vgotoxy eop sor
vecho /n /fLightGreen "Press a key... " /e
vpause /fLightCyan /t %PAUSING% CTRL-C
if errorlevel 200 goto ControlCPress

:AfterSysXfer
vgotoxy eop sor
vcls /fGray /bBlue eol

vcls /fGray /bBlue /y2 /h24

goto DoneBatch

:DoNotInstall

goto AbortBatch

:ControlCPress
vcls /fGray /bBlue /y2 /h24
vframe /bRed /fWhite /w60 /h10 /c /y7 hidden shadow
vframe /bRed /fWhite /w58 /h10 /c /y7 single
vframe /bRed /fWhite /w56 /h8 /c /y8 hidden
vecho "You have pressed " /fYellow "CTRL-C" /fWhite "."
vecho
vecho "Are you sure you wish to abort the installation?"
vframe /w44 /h4 /c /y12 hidden
vecho /fLightMagenta "  Yes " /fGray "- Please return to DOS."
vecho /fLightGreen "  No  " /fGray "- I want to continue." /n
vchoice /fYellow /bBlue /d 2 Ctrl-C

if errorlevel 200 goto AbortBatch
if errorlevel 2 goto %ReturnFromC%

:AbortBatch
vcls /fGray /bBlack
vecho /fWhite /bRed " Installation of %OS_NAME% %OS_VERSION% was aborted." /e /fGray
vecho
if not "%ERRORMSG%" == "" vecho %ERRORMSG%
if not "%ERRORMSG%" == "" vecho
goto CleanUpBatch

:DoneBatch

vecho /n "Press a key... "
vpause /t 10
vcls /fGray /bBlack
REM Batch file has completed.

:CleanUpBatch
REM Restore the original cursor size and shape.
vcursor %EXIT_CURSOR%
set EXIT_CURSOR=

:DontDoAnything
set FDTEMP=
set FDINSSTATUS=
set VOL_NAME=
set PIPES_OK=
set FMTCOPTS=
set PAUSING=
set WASFORMATED=
set BLIST=
set BFILE=
set ERRORMSG=
set ReturnFromC=
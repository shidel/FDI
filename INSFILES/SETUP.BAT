@echo off

REM Set operating system TITLE and VERSION for installer, not cleared at exit.
set OS_NAME=FreeDOS
set OS_VERSION=1.2

REM Set other installer options. Cleared at exit.
REM Drive C Formatting options.
set FMTCOPTS=/Q /U

REM When booting /CheckStatus switch is provided. This way the installer knows
REM it wasn't the user requesting the installer and the disk is being used
REM for recovery or booting.
REM NOTE: This test may be moved to somewhere after the V8Present label.
if not "%1" == "/CheckStatus" goto SkipChecking

REM **** Check if it is already installed ****
REM **** End of checking ****

:SkipChecking

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

REM Test if SET /P is available. It does not function under DOSBox, PC-DOS,
REM MS-DOS and under the FreeDOS 4DOS shell. The standard FreeDOS shell and
REM later versions of Windows DOS support it.
set SETP_TEST=failed
echo. | set /p SETP_TEST=
if "%SETP_TEST%" == "failed" goto NoSetPSupport
echo YES| set /p SETP_TEST=
if not "%SETP_TEST%" == "YES" goto NoSetPSupport
vcursor | set /p EXIT_CURSOR=
goto StartBatch

:NoSetPSupport
set EXIT_CURSOR=small

REM **** Start of the installer ****
:StartBatch
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
vchoice /fYellow /bBlue

if errorlevel 2 goto DoNotInstall

vinfo /dC

REM verrlvl 5

if errorlevel 100 goto AbortBatch
if errorlevel 15 goto NoSuchDrive
if errorlevel 5 goto NotFormatted
if errorlevel 2 goto WrongTypeDrive

REM We are OK.

goto BeginInstall

:NoSuchDrive
:WrongTypeDrive
vframe /bGray /fBlack /w56 /h8 /c /y8 hidden
vecho "Drive " /fRed C /fBlack " does not appear to be partitioned."
vecho
vecho "Do you wish to partition your drive?"
vframe /w40 /h4 /c /y12 hidden
vecho /fGreen "  Yes " /fBlack "- Launch Partitioner."
vecho /fRed "  No  " /fBlack "- Return to DOS" /n
vchoice /fYellow /bBlue /d 2

if errorlevel 2 goto AbortBatch

vcls /a0x07
vcursor %EXIT_CURSOR%

REM **** Launch Partitioning Program ****
fdisk 1
REM **** Returned from Partitioning ****

vcursor hide
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
vchoice /fYellow /bBlue

if errorlevel 2 goto AbortBatch
vcls /a0x07
vecho "The computer will now reboot."
vecho
reboot
goto AbortBatch

:NotFormatted
vframe /bGray /fBlack /w56 /h8 /c /y8 hidden
vecho "Drive " /fRed C /fBlack " does not appear to be formatted."
vecho
vecho "Do you wish to format your drive?"
vframe /w44 /h4 /c /y12 hidden
vecho /fGreen "  Yes " /fBlack "- Please erase and format drive C."
vecho /fRed "  No  " /fBlack "- Return to DOS" /n
vchoice /fYellow /bBlue /d 2

if errorlevel 2 goto AbortBatch

vcls /fWhite /bBlue /y2 /h24
vgotoxy down
vecho /fYellow "Formatting Drive " /fLightRed C /fYellow "..."

REM **** Launch Formatting Program
vstr /c89/c69/c83/c13 | format C: /V:%OS_NAME% %FMTCOPTS%
REM **** Returned from Formatting

vecho
vgotoxy eop sor
vecho /n /fLightGreen "Press a key... "
vpause /fLightCyan /t 10
vgotoxy eop sor
vcls /fGray /bBlue eol

vcls /fGray /bBlue /y2 /h24

goto StartBatch

:BeginInstall
vcls /fWhite /bBlue /y2 /h24
vgotoxy down down
vecho /fYellow "Transferring " /fLightGreen %OS_NAME% /fYellow " boot files..."
vecho

REM sys C:

vgotoxy eop sor
vecho /n /fLightGreen "Press a key... "
vpause /fLightCyan /t 10
vgotoxy eop sor
vcls /fGray /bBlue eol

vcls /fGray /bBlue /y2 /h24

goto DoneBatch

:DoNotInstall

:AbortBatch
vcls /fGray /bBlack
vecho /fWhite /bRed " Installation of %OS_NAME% %OS_VERSION% was aborted." /e /fGray
vecho
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
set SETP_TEST=
set FMTCOPTS=

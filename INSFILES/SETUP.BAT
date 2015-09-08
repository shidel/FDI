@echo off

set TITLE=FreeDOS
set VERSION=1.2

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

REM Test if running under DOSBox
set SETP_TEST=failed
echo. | set /p SETP_TEST=
if "%SETP_TEST%" == "failed" goto NoSetPSupport
echo YES| set /p SETP_TEST=
if not "%SETP_TEST%" == "YES" goto NoSetPSupport
vcursor | set /p EXIT_CURSOR=
goto StartBatch

:NoSetPSupport
set EXIT_CURSOR=small

:StartBatch
vcursor hide

REM Clear entire screen and fill with character 0xb0.
REM ASCII values can easily be found using the "vinfo ascii" to display
REM the ascii/hex table.
vcls /fGray /bBlue

REM Draw the Title Bar
vgotoxy /x1 /y1
vcls /bGray /fBlack EOL
vgotoxy /x30 /y1
vecho /fBlack "%TITLE% " /fRed "%VERSION%" /fBlack " Installer"

REM Move cursor to end of the page, then column 1. You should use this
REM method to prevent issues if the screen is not using 25 rows of text.
rem vgotoxy eop /x1

REM Clear from cursor to end of line using a NULL Character in preparation
REM for buttons and hot-key sequences.
rem vcls /bGray /fBlack /c0 EOL

vframe /bGray /fBlack /w60 /h10 /c /y7 hidden shadow
vframe /bGray /fBlack /w58 /h10 /c /y7 single
vframe /bGray /fBlack /w56 /h8 /c /y8 hidden
vecho "Welcome to the installation program for " /fRed "%TITLE% %VERSION%" /fBlack "."
vecho
vecho "Do you wish to proceed?"
vframe /w40 /h4 /c /y12 hidden
vecho /fGreen '  Yes ' /fBlack '- Continue with Installation'
vecho /fRed '  No  ' /fBlack '- Return to DOS' /n
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
vecho /fGreen '  Yes ' /fBlack '- Launch Partitioner.'
vecho /fRed '  No  ' /fBlack '- Return to DOS' /n
vchoice /fYellow /bBlue /d 2

if errorlevel 2 goto AbortBatch

vcls /a0x07
vcursor %EXIT_CURSOR%

REM **** Launch Partitioning Program
fdisk 1
REM **** Returned from Partitioning

vcursor hide
vcls /fGray /bBlue
vcls /bGray /fBlack EOL
vgotoxy /x30
vecho /fBlack "%TITLE% " /fRed "%VERSION%" /fBlack " Installer"
vframe /bGray /fBlack /w60 /h11 /c /y7 hidden shadow
vframe /bGray /fBlack /w58 /h11 /c /y7 single
vframe /bGray /fBlack /w56 /h9 /c /y8 hidden
vecho /n "You must reboot your computer for the new partitioning"
vecho "scheme to take effect."
vecho
vecho "Do you wish to reboot now?"
vframe /w40 /h4 /c /y13 hidden
vecho /fGreen '  Yes ' /fBlack '- Please reboot now.'
vecho /fRed '  No  ' /fBlack '- Return to DOS' /n
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
vecho /fGreen '  Yes ' /fBlack '- Please erase and format drive C.'
vecho /fRed '  No  ' /fBlack '- Return to DOS' /n
vchoice /fYellow /bBlue /d 2

if errorlevel 2 goto AbortBatch

vcls /a0x07
vcursor %EXIT_CURSOR%

REM **** Launch Formatting Program
format C: /V:%TIITLE% /Q /U
REM **** Returned from Formatting

vcursor hide
goto StartBatch

:BeginInstall
vcls /fWhite /bBlue /y2 /h24
vgotoxy down down down
vecho /fYellow "Transferring system boot files..."
vecho

REM sys C:

vgotoxy eop sor
vecho /n /fLightGreen "Press a key... "
vpause /fLightCyan /t 10

vcls /fGray /bBlue /y2 /h24

goto DoneBatch

:DoNotInstall

:AbortBatch
vcls /fGray /bBlack
vecho /fWhite /bRed " Installation of %TITLE% %VERSION% was aborted." /e /fGray
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

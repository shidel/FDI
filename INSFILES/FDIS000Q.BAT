@echo off

goto DoNotInstall

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
date /d >%BLIST%
echo %BLIST% >>%BLIST%
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

if not exist C:\FDOS\NUL goto BackupRun
dir /A /B /P- C:\FDOS\*.* >> %BLIST%

:BackupRun
type %BLIST% | vstr /L TOTAL | set /p FDBAKMAX=
set FDBAKLINE=1

:BackupLoop
REM vmath processes only from left to right!!!!!
vmath %FDBAKLINE% mul 90 div %FDBAKMAX% + 10 | set /p FDBAKPER=

vgotoxy /l eop sor
vprogres /fBlack %FDBAKPER%

type %BLIST% | vstr /L %FDBAKLINE% | set /p FDBAKFILE=

REM kind of a kludge, but i still need to do string/line prefixing in vstr
if exist C:\FDOS\%FDBAKFILE%\NUL set FDBAKFILE=C:\FDOS\%FDBAKFILE%
if exist C:\FDOS\%FDBAKFILE% set FDBAKFILE=C:\FDOS\%FDBAKFILE%

zip -q -9 -S -u -r -b %TEMP% %BFILE% %FDBAKFILE%

if "%FDBAKLINE%" == "%FDBAKMAX%" goto BackupComplete
vmath %FDBAKLINE% + 1 | set /p FDBAKLINE=
goto BackupLoop

:BackupComplete
if exist %BLIST% del %BLIST%
set FDBAKMAX=
set FDBAKFILE=
set FDBAKPER=
set FDBAKLINE=
vgotoxy /l eop sor
vecho /n /fBlack "Backup complete." /e
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
rem sys C:
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


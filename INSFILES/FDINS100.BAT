@echo off

if "%OBAK%" == "" goto AfterBackup
if not "%OBAK%" == "n" goto MakeBackup
goto AfterBackup

:MakeBackup
call FDIWIND.BAT 7
vecho /n "Creating backup"
vgotoxy /l eop sor
vprogres /fBlack 0
goto AfterBackup

if "%OBAK%" == "z" goto ZipBackup
:SimpleBackup

goto AfterBackup

ZipBackup:
goto AfterBackup

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

:AfterBackup

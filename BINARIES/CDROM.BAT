@ECHO OFF

vecho CD-ROM initialization.

set CDOPTS=/D:FDCD0001

set CDDRVR=UDVD2
goto TryDriver
:Not-UDVD2
set CDDRVR=ELTORITO
goto TryDriver
:Not-ELTORITO
set CDDRVR=GCDROM
goto TryDriver
:Not-GCDROM
set CDDRVR=VIDE-CDD
goto TryDriver
:Not-VIDE-CDD
set CDDRVR=OAKCDROM
goto TryDriver
:Not-OAKCDROM
set CDDRVR=GSCDROM
goto TryDriver
:Not-GSCDROM
set CDDRVR=UIDE
goto TryDriver
:Not-UIDE

:GiveUp
vecho /p /fLightRed "unable to load an appropriate CD/DVD driver" /fGrey
set CDDRVR=
vdelay /d 2000
verrlvl 1
goto End

:Failed
vecho , /fGrey error "#%ERRORLEVEL%" reported - /fLightRed failed /fGrey /n
vdelay /d 1000
vecho /fGrey
goto Not-%CDDRVR%
goto GiveUp

:TryDriver
if not exist %DOSDIR%\BIN\%CDDRVR%.SYS goto AltLocation
vecho attempting to use the /fYellow "%CDDRVR%" /fGrey CD driver /n
DEVLOAD /H %DOSDIR%\BIN\%CDDRVR%.SYS %CDOPTS% >NUL
if errorlevel 1 goto Failed
goto TryExtender
:AltLocation
if not exist %CDDRVR%.SYS goto Not-%CDDRVR%
vecho attempting to use the /fYellow "%CDDRVR%" /fGrey CD driver /n
DEVLOAD /H %CDDRVR%.SYS %CDOPTS% >NUL
if errorlevel 1 goto Failed

:TryExtender
vecho , /fLightGreen success /fGrey
vecho attempting to load /fYellow SHSUSCDX /fGrey CD extenstions /n
SHSUCDX /QQ /~ /D:?SHSU-CDR,D /D:?SHSU-CDH,D /D:?FDCD0001,D /D:?FDCD0002,D /D:?FDCD0003,D
if errorlevel 27 goto Failed
SHSUCDX /QQ /L:1
if errorlevel 27 goto Failed
if not errorlevel 1 goto Failed

if errorlevel 1 set CDROM=A:
if errorlevel 2 set CDROM=B:
if errorlevel 3 set CDROM=C:
if errorlevel 4 set CDROM=D:
if errorlevel 5 set CDROM=E:
if errorlevel 6 set CDROM=F:
if errorlevel 7 set CDROM=G:
if errorlevel 8 set CDROM=H:
if errorlevel 9 set CDROM=I:
if errorlevel 10 set CDROM=J:
if errorlevel 11 set CDROM=K:
if errorlevel 12 set CDROM=L:
if errorlevel 13 set CDROM=M:
if errorlevel 14 set CDROM=N:
if errorlevel 15 set CDROM=O:
if errorlevel 16 set CDROM=P:
if errorlevel 17 set CDROM=Q:
if errorlevel 18 set CDROM=R:
if errorlevel 19 set CDROM=S:
if errorlevel 20 set CDROM=T:
if errorlevel 21 set CDROM=U:
if errorlevel 22 set CDROM=V:
if errorlevel 23 set CDROM=W:
if errorlevel 24 set CDROM=X:
if errorlevel 25 set CDROM=Y:
if errorlevel 26 set CDROM=Z:

vecho , /fLightGreen success /fGrey
vecho successfully started the CD driver and extenstions /n
vecho /c32 for drive /fLightGreen "%CDROM%" /fGrey
vdelay /D 500

:End
set CDOPTS=
set CDDRVR=
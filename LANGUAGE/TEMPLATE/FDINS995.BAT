@echo off

REM FDI installation customizer

REM Some useful environment variables:

REM %FDRIVE%   Drive letter of install target C: or D:
REM %FTARGET%  The DOSDIR path of the install target. (like C:\FDOS)
REM %FMEDIA%   Base directory of the media package tree.
REM %FBOOTD%   Drive letter for the install media. (A:, B:, C:, D:, E: .....)
REM %FINSP%    Path for installer files like this one. (?:\FREEDOS\SETUP)
REM %OALL%     n = Base Only, y = All Packages, ? = Customized by FDIMPLES
REM %OSRC%     n = sources not installed, y = sources installed

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /w50 /h5 /c
vecho /k0 /n /f %TFF% About to /f %TFH% customize /f %TFF% the /f %TFH% %OS_NAME% /f %TFF% install.
vdelay %FDEL%
vdelay %FDEL%
vcls /l
vprogres /k0 /f %TFP% 0


REM Step 1
vprogres /k0 /f %TFP% 1 of 5
rem xcopy %FMEDIA%\DONSTUFF\*.* %FDRIVE%\ >NUL
vdelay 250

REM Step 2
vprogres /k0 /f %TFP% 2 of 5
vdelay 250

REM Step 3
vprogres /k0 /f %TFP% 3 of 5
vdelay 250

REM Step 4
vprogres /k0 /f %TFP% 4 of 5
vdelay 250

REM Step 5
vprogres /k0 /f %TFP% 5 of 5
echo vecho /k0 /n /p /fLightRed Warning: /fGray /s- /c32 >>%FDRIVE%\AUTOEXEC.BAT
echo vecho /k0 This OS has some serious /fLightCyan Coolness /s- /fGray. /p>>%FDRIVE%\AUTOEXEC.BAT
vdelay 250

:Success
vcls /l
vecho /k0 /n /f %TFF% It has been /f %TFH% chilled /f %TFF% /s-.
vdelay %FDEL%
vdelay %FDEL%
verrlvl 0
goto AllDone

:Failure
verrlvl 1
goto AllDone

:AllDone
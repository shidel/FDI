@echo off

REM FreeDOS 1.2+ Language Tester version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2015 Jerome Shidel.

set SELF=%0
if "%1" == "CLS" goto ClearScreen
if "%1" == "STANDBY" goto StandBy
if "%1" == "FAIL" goto FAIL

set OLD_LANG=%LANG%
set FADV="y"

if "%1" == "" goto DoneParams
if not exist LANGUAGE\%1\FDSETUP.DEF goto NoSetLang
set LANG=%1
shift
:NoSetLang
if "%1" == "" goto DoneParams
if not "%1" == "" set PART=%1
shift

:DoneParams

if "%LANG%" == "" goto NoLangSet

if not "%PART%" == "" goto %PART%
if not "%PART%" == "" goto Error

:FDICLS
call %SELF% CLS FDICLS FDSETUP
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:PICKLANG
call %SELF% CLS PICKLANG FDSETUP
vframe /b %TFB% /f %TFF% %TFS% textbox /w45 /h11 /c /y7
vgotoxy /l /y3
vline hidden
vgotoxy /l sop /g up up
vecho /n /e
vgotoxy /l sop
vecho /n /t %FLANG% LANG_ASK
vecho /n /e
vgotoxy /l eop /g down down /l sop
vecho /e /r4 /c 0x20 /t %FLANG% LANG_EN
vecho /e /r4 /c 0x20 /t %FLANG% LANG_ES
vecho /e /r4 /c 0x20 /t %FLANG% LANG_FR
vecho /e /r4 /c 0x20 /n /t %FLANG% LANG_DE
vchoice /a %TFC% Ctrl-C
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:WELCOME
call %SELF% CLS WELCOME FDSETUP
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% HELLO_FRAME
if "%FADV%" == "y" goto AdvancedMesssage
vecho /t %FLANG% HELLO %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
goto Spacer
:AdvancedMesssage
vecho /t %FLANG% HELLO_ADV %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
:Spacer
vecho
vecho /t %FLANG% PROCEED?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% HELLO_OPTS
vecho /t %FLANG% CONTINUE
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:NEEDPART
call %SELF% CLS NEEDPART FDSETUP
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% NOPART_FRAME
vecho /t %FLANG% NOPART %TFH% C: %TFF%
vecho
vecho /t %FLANG% PART?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% NOPART_OPTS
vecho /t %FLANG% PART_YES %FDRIVE%
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 2
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:PARTED
call %SELF% CLS PARTED FDSETUP
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PARTED_FRAME
vecho /t %FLANG% PARTED
vecho
vecho /t %FLANG% REBOOT?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% PARTED_OPTS
vecho /t %FLANG% REBOOT_YES
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:NEEDFORMAT
call %SELF% CLS NEEDFORMAT FDSETUP
if "%FADV%" == "y" goto NEEDFORMATADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% NOFORMAT_FRAME
vecho /t %FLANG% NOFORMAT %TFH% C: %TFF%
vecho
vecho /t %FLANG% FORMAT?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% NOFORMAT_OPTS
vecho /t %FLANG% FORMAT_YES C:
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 2
goto NEEDFORMATCHK
:NEEDFORMATADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% NOFORMATADV_FRAME
vecho /t %FLANG% NOFORMAT %TFH% C: %TFF%
vecho
vecho /t %FLANG% FORMAT?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% NOFORMATADV_OPTS
vecho /t %FLANG% FORMATADV_QUICK C:
vecho /t %FLANG% FORMATADV_SLOW C:
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 3
:NEEDFORMATCHK
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:FORMATTED
call %SELF% CLS FORMATTED FDSETUP
vcls /f %TSF% /b %TSB% /y2 /h24
vgotoxy down
vecho /t %FLANG% FORMATTING C:
vecho
vgotoxy eop sor
vecho /n /t %FLANG% PAUSE
vpause /fLightCyan CTRL-C
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:FORMATFAIL
call %SELF% CLS FORMATFAIL FDSETUP
call %SELF% FAIL ERROR_READC
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:SHELLFAIL
call %SELF% CLS SHELLFAIL FDSETUP
call %SELF% FAIL ERROR_SHELL
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:MEDIASEARCH
call %SELF% CLS MEDIASEARCH FDSETUP
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% GATHERING_FRAME
vecho /n /t %FLANG% GATHERING
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:MEDIAFAIL
call %SELF% CLS MEDIAFAIL FDSETUP
call %SELF% FAIL ERROR_MEDIA
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:READY
call %SELF% CLS READY FDSETUP
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% INSTALL_FRAME
vecho /t %FLANG% INSTALL %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
vecho
vecho /t %FLANG% INSTALL?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% INSTALL_OPTS
vecho /t %FLANG% INSTALL_YES "%OS_NAME% %OS_VERSION%"
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 2
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:PREP
call %SELF% CLS PREP FDSETUP
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PREPARING_FRAME
vecho /n /t %FLANG% PREPARING
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:COMPLETE
call %SELF% CLS COMPLETE FDSETUP
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% COMPLETE_FRAME
vecho /t %FLANG% COMPLETE %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
vecho
vecho /t %FLANG% REBOOT?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% COMPLETE_OPTS
vecho /t %FLANG% REBOOT_YES
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:TARGET
call %SELF% CLS TARGET FDASK ADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% TARGET_FRAME
vecho /t %FLANG% TARGET?
vecho
vask /c /t %FLANG% TARGET_ASK %TQF% %TQB% 15 C:\FDOS
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:BACKUP
call %SELF% CLS BACKUP FDASK
if "%FADV%" == "y" goto BACKUPADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% BACKUP_FRAME
vecho /t %FLANG% BACKUP %TFH% C: %TFF%
vecho
vecho /t %FLANG% BACKUP?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% BACKUP_OPTS
vecho /t %FLANG% BACKUPY
vecho /n /t %FLANG% BACKUPN
vchoice /a %TFC% Ctrl-C /d 1
goto BACKUPCHECK
:BACKUPADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% BACKUPADV_FRAME
vecho /t %FLANG% BACKUP %TFH% C: %TFF%
vecho
vecho /t %FLANG% BACKUP?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% BACKUPADV_OPTS
vecho /t %FLANG% BACKUPY
vecho /t %FLANG% BACKUPZ
vecho /n /t %FLANG% BACKUPN
vchoice /a %TFC% Ctrl-C /d 1

:BACKUPCHECK
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

vcls /a7
vecho Language %LANG% verification complete.

goto Done

:ClearScreen
if "%FADV%" == "" set TADV=y
if "%FADV%" == "y" set TADV=
set FADV=%TADV%
set TADV=
call FDISETUP\SETUP\STAGE000.BAT VersionOnly
set PART=%2
set FLANG=LANGUAGE\%LANG%\FDSETUP.DEF
if "%FADV%" == "" call FDISETUP\SETUP\THEMEDEF.BAT
if "%FADV%" == "y" call FDISETUP\SETUP\THEMEADV.BAT
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vgotoxy /x1 /y1
vcls /b %TTB% /f %TTF% EOL
vgotoxy /x30 /y1
vecho /t %FLANG% TITLE %TTF% "%OS_NAME%" %TTH% "%OS_VERSION%"
set FLANG=LANGUAGE\%LANG%\%3.DEF
if "%FADV%" == "" vecho /n "Theme: Basic" /e
if "%FADV%" == "y" vecho /n "Theme: Advanced" /e
if "%4" == "ADV" vecho /n ", (Advanced Only)"
vecho
vecho "Section: %PART%" /e
vecho "Resource: %FLANG%" /e
goto EndOfBatch

:FAIL
shift
if not "%FADV%" == "y" goto NoContinue
if "%1" == "cc" goto CanContinue
:NoContinue
vframe /b %TCB% /f %TCF% %TCS% textbox /t %FLANG% FAIL_FRAME
if "%1" == "cc" goto SkipFirstA
vecho /t %FLANG% %1 %2 %3 %4 %5 %6 %7 %8
goto AfterSkipA
:SkipFirstA
vecho /t %FLANG% %2 %3 %4 %5 %6 %7 %8
:AfterSkipA
vecho /t %FLANG% FAILH
vecho
vecho /t %FLANG% FAIL?
vframe /b %TCB% /f %TCF% optionbox /t %FLANG% FAIL_OPTS
vecho /t %FLANG% FAILY
vecho /n /t %FLANG% FAILN
vchoice /a %TFC% Ctrl-C
goto EndOfBatch

:CanContinue
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% FAILADV_FRAME
vecho /t %FLANG% %2 %3 %4 %5 %6 %7 %8
vecho /t %FLANG% FAILH
vecho
vecho /t %FLANG% FAIL?
vframe /b %TCB% /f %TCF% optionbox /t %FLANG% FAILADV_OPTS
vecho /t %FLANG% FAILY
vecho /t %FLANG% FAILN
vecho
vecho /n /t %FLANG% FAILI
vchoice /a %TFC% Ctrl-C
goto EndOfBatch

:StandBy
vgotoxy eop sor
vecho /fBlack /bGray "Press a key or" /fRed "CTRL+C" /fBlack /s- ... /e /n
vpause CTRL+C
goto EndOfBatch

:NoSuchPart
vcls /a7
vecho "Invaild section: %PART%"
goto Done

:Abort
vcls /a7
if "%FADV%" == "" vecho "Theme: Basic"
if "%FADV%" == "y" vecho "Theme: Advanced"
vecho "Section: %PART%"
vecho "Resource: %FLANG%"
goto DropOut

:NoLangSet
vecho "No Language specified."
goto Done

:Done
set PART=
:DropOut
if not "%OLD_LANG%" == "" set LANG=%OLD_LANG%
set OLD_LANG=
set SELF=
set FADV=
call FDISETUP\SETUP\STAGE999.BAT VARSONLY
if not "%PART%" == "" verrlvl 200

REM The very last command line of the batch file (for Sub-utilties) ***********
:EndOfBatch

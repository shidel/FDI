@echo off

REM FreeDOS 1.2+ Language Tester version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2015 Jerome Shidel.

set SELF=%0
if "%1" == "CLS" goto ClearScreen
if "%1" == "BLACK" goto ClearScreen
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

:START
:0
:1
:BEGIN
:FIRST
:FDICLS
call %SELF% CLS FDICLS FDSETUP
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

REM ***** STAGES

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

:GATHERING
call %SELF% CLS GATHERING FDSETUP
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

:PREPARING
call %SELF% CLS PREPARING FDSETUP
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

REM ***** FDASK
:TARGET
call %SELF% CLS TARGET FDASK ADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% TARGET_FRAME
vecho /t %FLANG% TARGET?
vecho
vask /c /t %FLANG% TARGET_ASK %TQF% %TQB% 15 C:\FREE_DOS
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

:CONFIGFILES
call %SELF% CLS CONFIGFILES FDASK ADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% REPLACE_FRAME
vecho /t %FLANG% REPLACE?
vecho
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% REPLACE_OPTS
vecho /t %FLANG% REPLACEY
vecho /n /t %FLANG% REPLACEN
vchoice /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:DELETE
call %SELF% CLS DELETE FDASK ADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% DELETE_FRAME
vecho /t %FLANG% DELETE? %TFH% C:\FREE_DOS %TFF%
vecho
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% DELETE_OPTS
vecho /t %FLANG% DELETEY
vecho /n /t %FLANG% DELETEN
vchoice /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:XFER
call %SELF% CLS XFER FDASK ADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% XFER_FRAME
vecho /t %FLANG% XFER? %TFH% C: %TFF%
vecho
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% XFER_OPTS
vecho /t %FLANG% XFERY
vecho /n /t %FLANG% XFERN
vchoice /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:PACKAGES
call %SELF% CLS PACKAGES FDASK
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PAC_FRAME
vecho /t %FLANG% PACS? %TFH% %OS_NAME% %TFF%
vecho
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% PAC_OPTS
vecho /t %FLANG% PACBO
vecho /t %FLANG% PACBS
vecho
vecho /t %FLANG% PACAO
vecho /n /t %FLANG% PACAS
vchoice /a %TFC% Ctrl-C /d 3
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:V8FILES
call %SELF% CLS V8FILES FDASK ADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% V8_FRAME
vecho /t %FLANG% V8I? %TFH% %TFF%
vecho
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% V8_OPTS
vecho /t %FLANG% V8IY
vecho /n /t %FLANG% V8IN
vchoice /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

REM ***** FDINS
:MKBACKUP
call %SELF% CLS MKBACKUP FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% BACKUP_FRAME
vecho /n /t %FLANG% BACKUP
vgotoxy /l sop eol right right
vecho /n /t %FLANG% TARGET %TFH% C:\FREE_DOS_OLD.000 %TFF%
vgotoxy /l eop sor
vprogres /f %TFP% 50
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:MKBACKUPZIP
call %SELF% CLS MKBACKUPZIP FDINS ADV
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% BACKUP_FRAME
vecho /n /t %FLANG% BACKUP
vgotoxy /l sop eol right right
vecho /n /t %FLANG% TARGET %TFH% C:\FDBACKUP\FDOS0000.ZIP %TFF%
vgotoxy /l eop sor
vprogres /f %TFP% 50
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:MKBACKUPDONE
call %SELF% CLS MKBACKUPDONE FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% BACKUP_FRAME
vecho /n /t %FLANG% BACKUP
vgotoxy /l sop eol right right
vecho /n /t %FLANG% TARGET %TFH% C:\FREE_DOS_OLD.000 %TFF%
vgotoxy /l eop sor
vecho /n /e /t %FLANG% BACKUP_DONE %TFF%
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:BACKUPFAIL
call %SELF% CLS BACKUPFAIL FDSETUP
call %SELF% FAIL ERROR_BACKUP
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:BACKUPZIPFAIL
call %SELF% CLS BACKUPZIPFAIL FDSETUP
call %SELF% FAIL ERROR_BACKZIP C:\FDBACKUP\FDOS0000.ZIP
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:RMOLDPKG
call %SELF% CLS RMOLDPKG FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% RMPACK_FRAME
vecho /n /t %FLANG% RMPACKS
vgotoxy /l eop sor
vprogres /f %TFP% 0
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:RMOLDPKGPART
call %SELF% CLS RMOLDPKGPART FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% RMPACK_FRAME
vecho /n /t %FLANG% RMPACKS
vgotoxy /l eop sor
vprogres /f %TFP% 50
vgotoxy /l sop
vecho /e /n /t %FLANG% RMPACKN %TFH% PACKAGES %TFF%
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:RMOLDDOS
call %SELF% CLS RMOLDDOS FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% RMOS_FRAME
vecho /n /t %FLANG% RMOS %TFH% C:\FREE_DOS %TFF%
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:RMOLDDOSDONE
call %SELF% CLS RMOLDDOSDONE FDINS ADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% RMOS_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% RMOS_DONE
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:RMOLDCFG
call %SELF% CLS RMOLDCFG FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% CLEAN_FRAME
vecho /n /t %FLANG% CLEAN
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:RMOLDCFGDONE
call %SELF% CLS RMOLDCFGDONE FDINS ADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% CLEAN_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% CLEAN_DONE
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSPKG
call %SELF% CLS INSPKG FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PAC_FRAME
vecho /n /t %FLANG% PACBM
vgotoxy /l eop sor
vprogres /f %TFP% 0
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSPKGPART
call %SELF% CLS INSPKGPART FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PAC_FRAME
vecho /e /n /t %FLANG% PACBI %TFH% "packages\filename" %TFF%
vgotoxy /l eop sor
vprogres /f %TFP% 50
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSPKGDONE
call %SELF% CLS INSPKGDONE FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PACDONE_FRAME
vecho /n /t %FLANG% PACDONE
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSDIRFAIL
call %SELF% CLS INSDIRFAIL FDSETUP
call %SELF% FAIL ERROR_MKDOS C:\FREE_DOS
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSPKGFAIL
call %SELF% CLS INSPKGFAIL FDSETUP
call %SELF% FAIL cc ERROR_PACKAGE packages\filename
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSSYS
call %SELF% CLS INSSYS FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% XSYS_FRAME
vecho /n /t %FLANG% XSYS %TFH% C: %TFF%
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSSYSDONE
call %SELF% CLS INSSYSDONE FDINS ADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% XSYS_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% XSYS_DONE
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSSYSFAIL
call %SELF% CLS INSSYSFAIL FDSETUP
call %SELF% FAIL cc ERROR_XSYS C:
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSCFG
call %SELF% CLS INSCFG FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% CONFIGS_FRAME
vecho /n /t %FLANG% CONFIGS
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSCFGDONE
call %SELF% CLS INSCFGDONE FDINS ADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% CONFIGS_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% CONFIGS_DONE
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSCFGFAIL
call %SELF% CLS INSCFGFAIL FDSETUP
call %SELF% FAIL cc ERROR_CONFIG
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSV8
call %SELF% CLS INSV8 FDINS
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% V8POWER_FRAME
vecho /n /t %FLANG% V8POWER %TFH% %TFF%
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSV8DONE
call %SELF% CLS INSV8DONE FDINS ADV
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% V8POWER_FRAME
vgotoxy /l sop
vecho /n /e /t %FLANG% V8POWER_DONE
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSV8FAIL
call %SELF% CLS INSV8FAIL FDSETUP
call %SELF% FAIL cc ERROR_V8
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:STAGEFAIL
SET FADV="y"
call %SELF% BLACK STAGEFAIL FDSETUP
vecho /t %FLANG% STAGE_ERROR nnn
call %SELF% STANDBY
if Errorlevel 200 goto Abort

:SKIPPED
SET FADV="y"
call %SELF% BLACK SKIPPED FDSETUP
call FDISETUP\SETUP\FDNOTICE.BAT
call %SELF% STANDBY
if Errorlevel 200 goto Abort

:AUTO
SET FADV="y"
call %SELF% BLACK AUTO FDSETUP
vecho /p /t %FLANG% AUTO_DONE AUTOEXEC.BAT FDCONFIG.SYS
vecho /p /t %FLANG% AUTO_HELP HELP
vecho /p /t %FLANG% AUTO_WELCOME %OS_NAME% %OS_VERSION% http://www.freedos.org
vecho
call %SELF% STANDBY
if Errorlevel 200 goto Abort

vcls /a7
vecho Language %LANG% verification complete.

goto Done

:ClearScreen
if "%FADV%" == "" set TADV=y
if "%FADV%" == "y" set TADV=
if "%4" == "ADV" set TADV=y
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
if not "%1" == "BLACK" goto EndOfBatch
vline
vcls /y6 /h24 /a0x07
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

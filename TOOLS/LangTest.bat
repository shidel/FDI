@echo off

REM FreeDOS 1.2+ Language Tester version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2016 Jerome Shidel.

set SELF=%0
if "%1" == "CLS" goto ClearScreen
if "%1" == "CLEAN" goto ClearScreen
if "%1" == "BLACK" goto ClearScreen
if "%1" == "STANDBY" goto StandBy
if "%1" == "FAIL" goto FAIL

set OLD_LANG=%LANG%
set OLDPATH=%PATH%

if exist V8POWER\VECHO.COM set PATH=%PATH%;V8POWER

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
:RESTART
:0
:1
:BEGIN
:FIRST
:FDICLS
call %SELF% CLS FDICLS FDSETUP
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%


:CTRLC
call %SELF% CLS CTRLC FDSETUP
vframe /p0 /b %TCB% /f %TCF% %TCS% textbox /t %FLANG% CTRLC_FRAME
vecho /k0 /t %FLANG% CTRLC %TCH% %TCF%
vecho
vecho /k0 /t %FLANG% CTRLC?
vframe /p0 /b %TCB% /f %TCF% optionbox /t %FLANG% CTRLC_OPTS
vecho /k0 /t %FLANG% CTRLCY
vecho /k0 /t %FLANG% CTRLCN
vecho
if "%FADV%" == "" vecho /k0 /n /t %FLANG% CTRLCA
if "%FADV%" == "y" vecho /k0 /n /t %FLANG% CTRLCB
vchoice /k0 /a %TFC% Ctrl-C
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

REM ***** STAGES

:PICKLANG
call %SELF% CLS PICKLANG FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /w45 /h15 /c
vgotoxy /k0 /y3
vline /p0 /k0 hidden
vgotoxy /k0 /l sop /g up up
vecho /k0 /n /e
vgotoxy /k0 sop
vecho /k0 /n /t %FLANG% LANG_ASK
vecho /k0 /n /e
vgotoxy /k0 /l eop /g down down /l sop
vecho /k0 /e /r4 /c 0x20 /t %FLANG% LANG_EN
vecho /k0 /e /r4 /c 0x20 /t %FLANG% LANG_ES
vecho /k0 /e /r4 /c 0x20 /t %FLANG% LANG_FR
vecho /k0 /e /r4 /c 0x20 /t %FLANG% LANG_DE
vecho /k0 /e /r4 /c 0x20 /t %FLANG% LANG_EO
vecho /k0 /e /r4 /c 0x20 /t %FLANG% LANG_NL
vecho /k0 /e /r4 /c 0x20 /t %FLANG% LANG_TR
vecho /k0 /e /r4 /c 0x20 /n /t %FLANG% LANG_RU
vchoice /k0 /a %TFC% Ctrl-C
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:WELCOME
call %SELF% CLS WELCOME FDSETUP
REM vgotoxy /g eop sor
REM vecho /k0 /b %TSB% /f %TSF% /n /t %FLANG% RELDATE 11/24/2016
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% HELLO_FRAME
if "%FADV%" == "y" goto AdvancedMesssage
vecho /k0 /t %FLANG% HELLO %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
goto Spacer
:AdvancedMesssage
vecho /k0 /t %FLANG% HELLO_ADV %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
:Spacer
vecho /k0 /p /n /t %FLANG% HELLO_WARN.1 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% HELLO_WARN.2 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% HELLO_WARN.3 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% HELLO_WARN.4 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% HELLO_WARN.5 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /t %FLANG% PROCEED?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% HELLO_OPTS
vecho /k0 /t %FLANG% CONTINUE
vecho /k0 /n /t %FLANG% EXIT
vchoice /k0 /a %TFC% Ctrl-C
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:NEEDPART
call %SELF% CLS NEEDPART FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% NOPART_FRAME
vecho /k0 /t %FLANG% NOPART %TFH% C: %TFF%
vecho
vecho /k0 /t %FLANG% PART?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% NOPART_OPTS
vecho /k0 /t %FLANG% PART_YES C:
vecho /k0 /n /t %FLANG% EXIT
vchoice /k0 /a %TFC% Ctrl-C /d 2
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:PARTED
call %SELF% CLS PARTED FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PARTED_FRAME
vecho /k0 /t %FLANG% PARTED
vecho
vecho /k0 /t %FLANG% REBOOT?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% PARTED_OPTS
vecho /k0 /t %FLANG% REBOOT_YES
vecho /k0 /n /t %FLANG% EXIT
vchoice /k0 /a %TFC% Ctrl-C
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:NEEDFORMAT
call %SELF% CLS NEEDFORMAT FDSETUP
if "%FADV%" == "y" goto NEEDFORMATADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% NOFORMAT_FRAME
vecho /k0 /t %FLANG% NOFORMAT %TFH% C: %TFF%
vecho
vecho /k0 /t %FLANG% FORMAT?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% NOFORMAT_OPTS
vecho /k0 /t %FLANG% FORMAT_YES C:
vecho /k0 /n /t %FLANG% EXIT
vchoice /k0 /a %TFC% Ctrl-C /d 2
goto NEEDFORMATCHK
:NEEDFORMATADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% NOFORMATADV_FRAME
vecho /k0 /t %FLANG% NOFORMAT %TFH% C: %TFF%
vecho
vecho /k0 /t %FLANG% FORMAT?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% NOFORMATADV_OPTS
vecho /k0 /t %FLANG% FORMATADV_QUICK C:
vecho /k0 /t %FLANG% FORMATADV_SLOW C:
vecho /k0 /n /t %FLANG% EXIT
vchoice /k0 /a %TFC% Ctrl-C /d 3
:NEEDFORMATCHK
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:FORMATTED
call %SELF% CLEAN FORMATTED FDSETUP
vgotoxy down
vecho /k0 /t %FLANG% FORMATTING C:
vecho
vgotoxy eop sor
vecho /k0 /n /t %FLANG% PAUSE
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

:PARTING
call %SELF% CLS PARTING FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PARTING_FRAME
vecho /k0 /n /t %FLANG% PARTING
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:GATHERING
call %SELF% CLS GATHERING FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% GATHERING_FRAME
vecho /k0 /n /t %FLANG% GATHERING
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
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% INSTALL_FRAME
vecho /k0 /t %FLANG% INSTALL %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
vecho
vecho /k0 /t %FLANG% INSTALL?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% INSTALL_OPTS
vecho /k0 /t %FLANG% INSTALL_YES "%OS_NAME% %OS_VERSION%"
vecho /k0 /n /t %FLANG% EXIT
vchoice /k0 /a %TFC% Ctrl-C /d 2
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:PREPARING
call %SELF% CLS PREPARING FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PREPARING_FRAME
vecho /k0 /n /t %FLANG% PREPARING
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:COMPLETE
call %SELF% CLS COMPLETE FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% COMPLETE_FRAME
vecho /k0 /t %FLANG% COMPLETE %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
vecho
vecho /k0 /t %FLANG% REBOOT?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% COMPLETE_OPTS
vecho /k0 /t %FLANG% REBOOT_YES
vecho /k0 /n /t %FLANG% EXIT
vchoice /k0 /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

REM ***** FDSETUP
:KEYMAP
call %SELF% CLS KEYMAP FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% KBS_FRAME
vecho /k0 /t %FLANG% KBS?
vecho
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% KBS_OPTS
vecho /k0 /n /t %FLANG% KBO.1
vecho /k0 /n /t %FLANG% KBO.2
vecho /k0 /n /t %FLANG% KBM

vchoice /k0 /a %TFC% Ctrl-C /d 1

if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:KEYMAP_ALL
call %SELF% CLS KEYMAP_ALL FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% KBA_FRAME
vecho /k0 /n " Language 1" /p " Language 2" /p " Language 3" /p " Language 4"
vecho /k0 /p " Language 5" /p " Language 6" /p " Language 7" /p " Language 8"
vecho /k0 /n /t %FLANG% KBL

vchoice /k0 /a %TFC% Ctrl-C /d 1

if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%


:TARGET
call %SELF% CLS TARGET FDSETUP ADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% TARGET_FRAME
vecho /k0 /t %FLANG% TARGET?
vecho
vask /c /t %FLANG% TARGET_ASK %TQF% %TQB% 99 C:\FREE_DOS
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:BACKUP
call %SELF% CLS BACKUP FDSETUP
if "%FADV%" == "y" goto BACKUPADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% BACKUP_FRAME
vecho /k0 /t %FLANG% BACKUP %TFH% C: %TFF%
vecho
vecho /k0 /t %FLANG% BACKUP?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% BACKUP_OPTS
vecho /k0 /t %FLANG% BACKUPY
vecho /k0 /n /t %FLANG% BACKUPN
vchoice /k0 /a %TFC% Ctrl-C /d 1
goto BACKUPCHECK
:BACKUPADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% BACKUPADV_FRAME
vecho /k0 /t %FLANG% BACKUP %TFH% C: %TFF%
vecho
vecho /k0 /t %FLANG% BACKUP?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% BACKUPADV_OPTS
vecho /k0 /t %FLANG% BACKUPY
vecho /k0 /t %FLANG% BACKUPZ
vecho /k0 /n /t %FLANG% BACKUPN
vchoice /k0 /a %TFC% Ctrl-C /d 1
:BACKUPCHECK
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:CONFIGFILES
call %SELF% CLS CONFIGFILES FDSETUP ADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% REPLACE_FRAME
vecho /k0 /t %FLANG% REPLACE?
vecho
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% REPLACE_OPTS
vecho /k0 /t %FLANG% REPLACEY
vecho /k0 /n /t %FLANG% REPLACEN
vchoice /k0 /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:DELETE
call %SELF% CLS DELETE FDSETUP ADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% DELETE_FRAME
vecho /k0 /t %FLANG% DELETE? %TFH% C:\FREE_DOS %TFF%
vecho
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% DELETE_OPTS
vecho /k0 /t %FLANG% DELETEY
vecho /k0 /n /t %FLANG% DELETEN
vchoice /k0 /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:XFER
call %SELF% CLS XFER FDSETUP ADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% XFER_FRAME
vecho /k0 /t %FLANG% XFER? %TFH% C: %TFF%
vecho
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% XFER_OPTS
vecho /k0 /t %FLANG% XFERY
vecho /k0 /n /t %FLANG% XFERN
vchoice /k0 /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:OBSS
call %SELF% CLS OBSS FDSETUP ADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% OBSS_FRAME
vecho /k0 /t %FLANG% OBSS? %TFH% C: %TFF% 4 2
vecho
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% OBSS_OPTS
vecho /k0 /t %FLANG% OBSSY
vecho /k0 /n /t %FLANG% OBSSN
vchoice /k0 /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:PACBO
call %SELF% CLS PACBO FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PAC_FRAME_B
vecho /k0 /t %FLANG% PACS? %TFH% %OS_NAME% %TFF%
vecho
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% PAC_OPTS_B
vecho /k0 /t %FLANG% PACBO
vecho /k0 /n /t %FLANG% PACBS
vchoice /k0 /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

set FADV=
:PACBD
call %SELF% CLS PACBD FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PAC_FRAME_BD
vecho /k0 /t %FLANG% PACS? %TFH% %OS_NAME% %TFF%
vecho
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% PAC_OPTS_BD
vecho /k0 /t %FLANG% PACBO
vecho /k0 /t %FLANG% PACBS
vecho
vecho /k0 /t %FLANG% PACDO_ADV
vecho /k0 /n /t %FLANG% PACDS_ADV
vchoice /k0 /a %TFC% Ctrl-C /d 1
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:PACAO
call %SELF% CLS PACAO FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PAC_FRAME
vecho /k0 /t %FLANG% PACS? %TFH% %OS_NAME% %TFF%
vecho
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% PAC_OPTS
vecho /k0 /t %FLANG% PACBO
vecho /k0 /t %FLANG% PACAO
vecho
vecho /k0 /t %FLANG% PACBS
vecho /k0 /n /t %FLANG% PACAS
vchoice /k0 /a %TFC% Ctrl-C /d 2
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

set FADV=
:PACDO
call %SELF% CLS PACDO FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% PAC_FRAME_D
vecho /k0 /t %FLANG% PACS? %TFH% %OS_NAME% %TFF%
vecho
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% PAC_OPTS_D
vecho /k0 /t %FLANG% PACBO
vecho /k0 /t %FLANG% PACAO
vecho
vecho /k0 /t %FLANG% PACBS
vecho /k0 /t %FLANG% PACAS
vecho
vecho /k0 /t %FLANG% PACDO_ADV
vecho /k0 /n /t %FLANG% PACDS_ADV
vchoice /k0 /a %TFC% Ctrl-C /d 2
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

REM ***** FDSETUP
:MKBACKUP
call %SELF% CLS MKBACKUP FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IBACKUP_FRAME
vecho /k0 /n /t %FLANG% IBACKUP
vgotoxy /k0 sop eol right right
vecho /k0 /n /t %FLANG% ITARGET %TFH% C:\FREE_DOS_OLD.000 %TFF%
vgotoxy /k0 eop sor
vprogres /k0 /f %TFP% 50
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:MKBACKUPZIP
call %SELF% CLS MKBACKUPZIP FDSETUP ADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IBACKUP_FRAME
vecho /k0 /n /t %FLANG% IBACKUP
vgotoxy /k0 sop eol right right
vecho /k0 /n /t %FLANG% ITARGET %TFH% C:\FDBACKUP\FDOS0000.ZIP %TFF%
vgotoxy /k0 eop sor
vprogres /k0 /f %TFP% 50
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:MKBACKUPDONE
call %SELF% CLS MKBACKUPDONE FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IBACKUP_FRAME
vecho /k0 /n /t %FLANG% IBACKUP
vgotoxy /k0 sop eol right right
vecho /k0 /n /t %FLANG% ITARGET %TFH% C:\FREE_DOS_OLD.000 %TFF%
vgotoxy /k0 eop sor
vecho /k0 /n /e /t %FLANG% IBACKUP_DONE %TFF%
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
call %SELF% CLS RMOLDPKG FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IRMPACK_FRAME
vecho /k0 /n /t %FLANG% IRMPACKS
vgotoxy /k0 eop sor
vprogres /k0 /f %TFP% 0
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:RMOLDPKGPART
call %SELF% CLS RMOLDPKGPART FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IRMPACK_FRAME
vecho /k0 /n /t %FLANG% IRMPACKS
vgotoxy /k0 eop sor
vprogres /k0 /f %TFP% 50
vgotoxy /k0 sop
vecho /k0 /e /n /t %FLANG% IRMPACKN %TFH% PACKAGES %TFF%
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:RMOLDDOS
call %SELF% CLS RMOLDDOS FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IRMOS_FRAME
vecho /k0 /n /t %FLANG% IRMOS %TFH% C:\FREE_DOS %TFF%
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:RMOLDDOSDONE
call %SELF% CLS RMOLDDOSDONE FDSETUP ADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IRMOS_FRAME
vgotoxy /k0 sop
vecho /k0 /n /e /t %FLANG% IRMOS_DONE
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:RMOLDCFG
call %SELF% CLS RMOLDCFG FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% ICLEAN_FRAME
vecho /k0 /n /t %FLANG% ICLEAN
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:RMOLDCFGDONE
call %SELF% CLS RMOLDCFGDONE FDSETUP ADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% ICLEAN_FRAME
vgotoxy /k0 sop
vecho /k0 /n /e /t %FLANG% ICLEAN_DONE
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSPKG
call %SELF% CLS INSPKG FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IPAC_FRAME
vecho /k0 /n /t %FLANG% IPACBM
vgotoxy /k0 eop sor
vprogres /k0 /f %TFP% 0
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSPKGPART
call %SELF% CLS INSPKGPART FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IPAC_FRAME
vecho /k0 /e /n /t %FLANG% IPACBI %TFH% "packages\filename" %TFF%
vgotoxy /k0 eop sor
vprogres /k0 /f %TFP% 50
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSPKGDONE
call %SELF% CLS INSPKGDONE FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IPACDONE_FRAME
vecho /k0 /n /t %FLANG% IPACDONE
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
call %SELF% CLS INSSYS FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IXSYS_FRAME
vecho /k0 /n /t %FLANG% IXSYS %TFH% C: %TFF%
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSSYSDONE
call %SELF% CLS INSSYSDONE FDSETUP ADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% IXSYS_FRAME
vgotoxy /k0 sop
vecho /k0 /n /e /t %FLANG% IXSYS_DONE
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSSYSFAIL
call %SELF% CLS INSSYSFAIL FDSETUP
call %SELF% FAIL cc ERROR_XSYS C:
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSCFG
call %SELF% CLS INSCFG FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% ICONFIGS_FRAME
vecho /k0 /n /t %FLANG% ICONFIGS
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSCFGDONE
call %SELF% CLS INSCFGDONE FDSETUP ADV
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% ICONFIGS_FRAME
vgotoxy /k0 sop
vecho /k0 /n /e /t %FLANG% ICONFIGS_DONE
call %SELF% STANDBY
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:INSCFGFAIL
call %SELF% CLS INSCFGFAIL FDSETUP
call %SELF% FAIL cc ERROR_CONFIG
if Errorlevel 200 goto Abort
if "%FADV%" == "" goto %PART%

:STAGEFAIL
SET FADV="y"
call %SELF% BLACK STAGEFAIL FDSETUP
vecho /k0 /t %FLANG% STAGE_ERROR ???
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
vecho /k0 /p /t %FLANG% AUTO_DONE AUTOEXEC.BAT FDCONFIG.SYS
vecho /k0 /p /t %FLANG% AUTO_HELP HELP
vecho /k0 /p /t %FLANG% AUTO_WELCOME %OS_NAME% %OS_VERSION% http://www.freedos.org
vecho
call %SELF% STANDBY
if Errorlevel 200 goto Abort

:BOOTPAUSE
SET FADV="y"
call %SELF% BLACK BOOTPAUSE FDSETUP
vgotoxy eop sor up
vecho /k0 /bRed /e /n /t %FLANG% REBOOT_PAUSE White Yellow
vpause /fLightCyan /d 60 CTRL+C
if Errorlevel 200 goto Abort

:NORUN
SET FADV="y"
call %SELF% BLACK NORUN FDSETUP
vgotoxy eop sor up
vecho /k0 /n /t %FLANG% NORUN.1
vecho /k0 /t %FLANG% NORUN.2
call %SELF% STANDBY
if Errorlevel 200 goto Abort

:BOOTWARN
SET FADV="y"
call %SELF% BLACK BOOTWARN FDSETUP
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% REBOOT_FRAME
vecho /k0 /n /t %FLANG% REBOOT_WARN.1 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% REBOOT_WARN.2 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% REBOOT_WARN.3 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% REBOOT_WARN.4 %TFH% "%OS_NAME%" %TFF%
vecho /k0 /n /t %FLANG% REBOOT_WARN.5 %TFH% "%OS_NAME%" %TFF%
vgotoxy /g eop sor up
vecho /k0 /bRed /e /n /t %FLANG% REBOOT_PAUSE White Yellow
vpause /fLightCyan /d 60 CTRL+C
if Errorlevel 200 goto Abort

vcls /a7
vecho /k0 /n Language verification for /fWhite /t %FLANG% LANG_NAME
vecho /k0 /n /s- /fGray " (" /fYellow %LANG% /fGray ) /s+ by /fLightCyan /t %FLANG% LANG_AUTHOR
vecho /k0 /fGray /c32 has completed.

goto Done

:ClearScreen
if "%FADV%" == "" set TADV=y
if "%FADV%" == "y" set TADV=
if "%4" == "ADV" set TADV=y
set FADV=%TADV%
set TADV=
call FDISETUP\SETUP\STAGE000.BAT VersionOnly
rem if "%OS_VERSION%" == "$VERSION$" set OS_VERSION=UNDEFINED
set PART=%2
set FLANG=LANGUAGE\%LANG%\FDSETUP.DEF
if "%FADV%" == "" call FDISETUP\SETUP\THEMEDEF.BAT
if "%FADV%" == "y" call FDISETUP\SETUP\THEMEADV.BAT
if "%1" == "CLS" vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
if not "%1" == "CLS" vcls /f %TSF% /b %TSB% /y2 /h24
vgotoxy /x1 /y1
vcls /b %TTB% /f %TTF% EOL
vgotoxy /x30 /y1
vecho /k0 /t %FLANG% TITLE %TTF% "%OS_NAME%" %TTH% "%OS_VERSION%"
set FLANG=LANGUAGE\%LANG%\%3.DEF
if "%FADV%" == "" vecho /k0 /n "Theme: Basic" /e
if "%FADV%" == "y" vecho /k0 /n "Theme: Advanced" /e
if "%4" == "ADV" vecho /k0 /n ", (Advanced Only)"
vecho
vecho /k0 "Section: %PART%" /e
vecho /k0 "Resource: %FLANG%" /e
if "%1" == "CLS" goto EndOfBatch
vline
if "%1" == "BLACK" vcls /y6 /h24 /a0x07
goto EndOfBatch

:FAIL
shift
if not "%FADV%" == "y" goto NoContinue
if "%1" == "cc" goto CanContinue
:NoContinue
vframe /p0 /b %TCB% /f %TCF% %TCS% textbox /t %FLANG% FAIL_FRAME
if "%1" == "cc" goto SkipFirstA
vecho /k0 /t %FLANG% %1 %2 %3 %4 %5 %6 %7 %8
goto AfterSkipA
:SkipFirstA
vecho /k0 /t %FLANG% %2 %3 %4 %5 %6 %7 %8
:AfterSkipA
vecho /k0 /t %FLANG% FAILH
vecho
vecho /k0 /t %FLANG% FAIL?
vframe /p0 /b %TCB% /f %TCF% optionbox /t %FLANG% FAIL_OPTS
vecho /k0 /t %FLANG% FAILY
vecho /k0 /n /t %FLANG% FAILN
vchoice /k0 /a %TFC% Ctrl-C
goto EndOfBatch

:CanContinue
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% FAILADV_FRAME
vecho /k0 /t %FLANG% %2 %3 %4 %5 %6 %7 %8
vecho /k0 /t %FLANG% FAILH
vecho
vecho /k0 /t %FLANG% FAIL?
vframe /p0 /b %TCB% /f %TCF% optionbox /t %FLANG% FAILADV_OPTS
vecho /k0 /t %FLANG% FAILY
vecho /k0 /t %FLANG% FAILN
vecho
vecho /k0 /n /t %FLANG% FAILI
vchoice /k0 /a %TFC% Ctrl-C
goto EndOfBatch

:StandBy
vgotoxy eop sor
vecho /k0 /fBlack /bGray "Press a key or" /fRed "CTRL+C" /fBlack /s- ... /e /n
vpause CTRL+C
goto EndOfBatch

:NoSuchPart
vcls /a7
vecho /k0 "Invaild section: %PART%"
goto Done

:Abort
vcls /a7
if "%FADV%" == "" vecho /k0 "Theme: Basic"
if "%FADV%" == "y" vecho /k0 "Theme: Advanced"
vecho /k0 "Section: %PART%"
vecho /k0 "Resource: %FLANG%"
goto DropOut

:NoLangSet
vecho /k0 "No Language specified."
goto Done

:Done
set PART=
:DropOut
if not "%OLD_LANG%" == "" set LANG=%OLD_LANG%
if not "%OLDPATH%" == "" set PATH=%OLDPATH%
set OLD_LANG=
set OLDPATH=
set SELF=
set FADV=
call FDISETUP\SETUP\FDICLEAN.BAT VARSONLY
if not "%PART%" == "" verrlvl 200

REM The very last command line of the batch file (for Sub-utilties) ***********
:EndOfBatch

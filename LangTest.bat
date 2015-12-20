@echo off

REM FreeDOS 1.2+ Language Tester version 1.00.
REM Released Under GPL v2.0 License.
REM Copyright 2015 Jerome Shidel.

set SELF=%0
if "%1" == "CLS" goto ClearScreen
if "%1" == "STANDBY" goto StandBy

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
call %SELF% CLS PICKLANG FDSETUP DEF
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
call %SELF% CLS WELCOME FDSETUP DEF
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
call %SELF% CLS NEEDPART FDSETUP DEF
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
if "%FADV%" == "" vecho "Theme: Basic" /e
if "%FADV%" == "y" vecho "Theme: Advanced" /e
vecho "Section: %PART%" /e
vecho "Resource: %FLANG%" /e
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

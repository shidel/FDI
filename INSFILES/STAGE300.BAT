@echo off

REM Welcome to the installer, continue or exit.

if "%1" == "Welcome" goto NoTitleClear

vcursor hide

call FDICLS.BAT
goto Welcome

:NoTitleClear
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24

:Welcome
if "%_WCI%" == "" set _WCI=1
REM If Need to set language then do it now
if not "%FCLANG%" == "y" goto LanguageSet
vframe /b %TFB% /f %TFF% %TFS% textbox /w45 /h11 /c /y7
vgotoxy /l /y3
vline hidden
:LanguagePrompt
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
vchoice /a %TFC% Ctrl-C /p %_WCI%
if errorlevel 200 FDICTRLC.BAT %0 Welcome
if errorlevel 100 goto LanguageChange
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
goto LanguageSet

:LanguageChange
set _WCI=4
set LANG=DE
if errorlevel 104 goto DoChange
set _WCI=3
set LANG=FR
if errorlevel 103 goto DoChange
set _WCI=2
set LANG=ES
if errorlevel 102 goto DoChange
set _WCI=1
set LANG=EN

:DoChange
call FDILANG.BAT FDSETUP
vgotoxy /x30 /y1
vecho /n /t %FLANG% TITLE %TTF% "%OS_NAME%" %TTH% "%OS_VERSION%"
vecho /e
vgotoxy /g /x40 /y12
goto LanguagePrompt

:LanguageSet
if "%FCLANG%" == "y" set FCLANG=n
set _WCI=
REM Draw the welcome screen.
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% HELLO_FRAME
if "%FADV%" == "y" goto AdvancedMesssage
vecho /t %FLANG% HELLO %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
goto Spacer
:AdvancedMesssage
vecho /t %FLANG% HELLO_ADV %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
:Spacer
vecho
vecho /t %FLANG% PROCEED?
vframe /b %TFB% /f %TFF% hidden /t %FLANG% HELLO_OPTS
vecho /t %FLANG% CONTINUE
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C

if errorlevel 200 FDICTRLC.BAT %0 Welcome
if errorlevel 2 goto Done

verrlvl 0
goto Done

:Done
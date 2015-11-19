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
:LanguagePrompt
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% LANG_FRAME
vecho /t %FLANG% LANG_ASK
vline hidden
vecho /t %FLANG% LANG_EN
vecho /t %FLANG% LANG_ES
vecho /t %FLANG% LANG_FR
vecho /n /t %FLANG% LANG_GB
vchoice /a %TFC% Ctrl-C /p %_WCI%
if errorlevel 200 FDICTRLC.BAT %0 Welcome
if errorlevel 100 goto LanguageChange
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
goto LanguageSet

:LanguageChange
set _WCI=4
set LANG=GB
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
vgotoxy /x1 /y1
vcls /b %TTB% /f %TTF% EOL
vgotoxy /x30 /y1
vecho /t %FLANG% TITLE %TTF% "%OS_NAME%" %TTH% "%OS_VERSION%"
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
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
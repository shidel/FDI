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

REM the Language frame height is set automatically as 6 + language count by
REM mkFDI.bat when the build creates the boot image. The languages order and
REM count are determined by the order, number and name of the LANG_ variables
REM stored the LANGUAGE\TEMPLATE\FDSETUP.DEF translation template file.

vframe /b %TFB% /f %TFF% %TFS% textbox /w45 $HEIGHT$ /c
vgotoxy /l /y2
vline hidden
:LanguagePrompt
set _XLNG=%LANG%
vgotoxy /l sop /g up up /l sop
vecho /n /t %FLANG% LANG_ASK
vecho /n /e
vgotoxy /l eop /g down down /l sop
vecho /n /t %FLANG% LANG_LIST
vchoice /a %TFC% Ctrl-C /p %_WCI%
if errorlevel 200 FDICTRLC.BAT %0 Welcome
if errorlevel 100 goto LanguageChange
vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
goto LanguageSet

REM Everything between the LanguageChange and DoChange Labels is replaced
REM dynamically by the mkFDI.bat build utility.
:LanguageChange

REM This static version will be replaced automatically by the mkFDI utility.

set _WCI=6
set LANG=NL
if errorlevel 106 goto DoChange
set _WCI=5
set LANG=EO
if errorlevel 105 goto DoChange
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
if  "%_XLNG%" == "" goto NoPrevLang
if exist %_XLNG%\SETFONT.BAT call %_XLNG%\SETFONT.BAT UNLOAD >NUL
:NoPrevLang
if exist %LANG%\SETFONT.BAT goto UseSetFont
rem if exist EN\SETFONT.BAT call EN\SETFONT.BAT LOAD >NUL
goto ApplyLang
:UseSetFont
call %LANG%\SETFONT.BAT LOAD >NUL
:ApplyLang
call FDILANG.BAT FDSETUP
vgotoxy /x30 /y1
vecho /n /t %FLANG% TITLE %TTF% "%OS_NAME%" %TTH% "%OS_VERSION%"
vecho /e
vgotoxy /g /x40 /y12
goto LanguagePrompt

:LanguageSet
if "%FCLANG%" == "y" set FCLANG=n
set _WCI=
set _XLNG=
if not exist %LANG%\SETLANG.BAT goto DefaultEnglish
call %LANG%\SETLANG.BAT >NUL
call FDICLS.BAT
goto LanguageDone

:DefaultEnglish
if exist EN\SETLANG.BAT call EN\SETLANG.BAT >NUL

:LanguageDone

REM Draw the welcome screen.
vframe /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% HELLO_FRAME
if "%FADV%" == "y" goto AdvancedMesssage
vecho /t %FLANG% HELLO %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
goto Spacer
:AdvancedMesssage
vecho /t %FLANG% HELLO_ADV %TFH% "%OS_NAME% %OS_VERSION%" %TFF%
:Spacer
vecho /p /n /t %FLANG% HELLO_WARN.1 %TFH% "%OS_NAME%" %TFF%
vecho /n /t %FLANG% HELLO_WARN.2 %TFH% "%OS_NAME%" %TFF%
vecho /n /t %FLANG% HELLO_WARN.3 %TFH% "%OS_NAME%" %TFF%
vecho /n /t %FLANG% HELLO_WARN.4 %TFH% "%OS_NAME%" %TFF%
vecho /n /t %FLANG% HELLO_WARN.5 %TFH% "%OS_NAME%" %TFF%
vecho /t %FLANG% PROCEED?
vframe /b %TFB% /f %TFF% optionbox /t %FLANG% HELLO_OPTS
vecho /t %FLANG% CONTINUE
vecho /n /t %FLANG% EXIT
vchoice /a %TFC% Ctrl-C

if errorlevel 200 FDICTRLC.BAT %0 Welcome
if errorlevel 2 goto Done

verrlvl 0
goto Done

:Done
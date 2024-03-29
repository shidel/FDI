@echo off

REM Welcome to the installer, continue or exit.

if "%1" == "Welcome" goto NoTitleClear

vcursor hide

call FDICLS.BAT
goto Welcome

:NoTitleClear
vcls /k0 /f %TSF% /b %TSB% /c %TSC% /y2 /h24

:Welcome
if "%_WCI%" == "" set _WCI=1
REM If Need to set language then do it now
if not "%FCLANG%" == "y" goto LanguageSet

REM the Language frame height is set automatically as 6 + language count by
REM mkFDI.bat when the build creates the boot image. The languages order and
REM count are determined by the order, number and name of the LANG_ variables
REM stored the LANGUAGE\TEMPLATE\FDSETUP.DEF translation template file.

vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /w45 /h$LANG_SETHEIGHT$ /c
vgotoxy /k0 /l /y2
vline /p0 /k0 hidden
:LanguagePrompt
set _XLNG=%LANG%
vgotoxy /k0 sop /g up up /l sop
vecho /k0 /n /t %FLANG% LANG_ASK
vecho /k0 /n /e
vgotoxy /k0 eop /g down down /l sop
vecho /k0 /n /t %FLANG% LANG_LIST
vchoice /k0 /a %TFC% Ctrl-C /p %_WCI%
if errorlevel 200 FDICTRLC.BAT %0 Welcome
if errorlevel 100 goto LanguageChange
vcls /k0 /f %TSF% /b %TSB% /c %TSC% /y2 /h24
goto LanguageSet

REM Everything between the LanguageChange and DoChange Labels is replaced
REM dynamically by the mkFDI.bat build utility.
:LanguageChange

$LANG_DOCHANGE$

:DoChange
if  "%_XLNG%" == "" goto NoPrevLang
if exist SETFONT.BAT goto UseSetFont
goto ApplyLang
:UseSetFont
call SETFONT.BAT %LANG% >NUL
:ApplyLang
call FDILANG.BAT FDSETUP
vgotoxy /g /x30 /y1
vecho /k0 /n /t %FLANG% TITLE %TTF% "%OS_NAME%" %TTH% "%OS_VERSION%"
vecho /k0 /e
vgotoxy /g /x40 /y12
goto LanguagePrompt

:LanguageSet
if "%FCLANG%" == "y" set FCLANG=n
set _WCI=
set _XLNG=
if exist SETLANG.BAT CALL SETFONT.BAT %LANG% >NUL
call %LANG%\SETLANG.BAT >NUL
call FDICLS.BAT

REM Draw the welcome screen.
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% HELLO_FRAME
if "%FADV%" == "y" goto AdvancedMesssage
vecho /k0 /t %FLANG% HELLO %TFH% "%OS_NAME% %OS_VERSION%" %TFF% %TFX%
goto Spacer
:AdvancedMesssage
vecho /k0 /t %FLANG% HELLO_ADV %TFH% "%OS_NAME% %OS_VERSION%" %TFF% %TFX%
:Spacer
vecho /k0 /p /n /t %FLANG% HELLO_WARN.1 %TFH% "%OS_NAME%" %TFF% %TFX%
vecho /k0 /n /t %FLANG% HELLO_WARN.2 %TFH% "%OS_NAME%" %TFF% %TFX%
vecho /k0 /n /t %FLANG% HELLO_WARN.3 %TFH% "%OS_NAME%" %TFF% %TFX%
vecho /k0 /n /t %FLANG% HELLO_WARN.4 %TFH% "%OS_NAME%" %TFF% %TFX%
vecho /k0 /n /t %FLANG% HELLO_WARN.5 %TFH% "%OS_NAME%" %TFF% %TFX%
vecho /k0 /t %FLANG% PROCEED?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% HELLO_OPTS
vecho /k0 /t %FLANG% CONTINUE
vecho /k0 /n /t %FLANG% EXIT
vchoice /k0 /a %TFC% Ctrl-C

if errorlevel 200 FDICTRLC.BAT %0 Welcome
if errorlevel 2 goto Done

verrlvl 0
goto Done

:Done
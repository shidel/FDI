@echo off

REM Keyboard Keymap selection

if "%KLST%" == "y" goto KBAdv

REM Remove the REM statements to only show keyboard layout selection for
REM non-English or advanced mode users.

REM if "%FADV%" == "y" goto KBSimple
REM if "%LANG%" == "EN" goto Done

:KBSimple
set KLST=
set KTT=1
if "%LANG%" == "ES" set KTT=3
if "%LANG%" == "FR" set KTT=4
if "%LANG%" == "DE" set KTT=5
if "%LANG%" == "NL" set KTT=6
if "%LANG%" == "TR" set KTT=7
if "%LANG%" == "RU" set KTT=8

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% KBS_FRAME
vecho /k0 /t %FLANG% KBS?
vframe /p0 /b %TFB% /f %TFF% optionbox /t %FLANG% KBS_OPTS
vecho /k0 /n /t %FLANG% KBO.1
vecho /k0 /n /t %FLANG% KBO.2
vecho /k0 /n /t %FLANG% KBM
vchoice /k0 /a %TFC% Ctrl-C /d %KTT%

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 1 set FKB=1
if errorlevel 2 set FKB=2
if errorlevel 3 set FKB=3
if errorlevel 4 set FKB=4
if errorlevel 5 set FKB=5
if errorlevel 6 set FKB=6
if errorlevel 7 set FKB=7
if errorlevel 8 set FKB=8
if errorlevel 9 goto KBAdv
goto Done

:KBPolling
if errorlevel 109 goto ScrollDown
if errorlevel 102 goto ListChange
if errorlevel 101 goto ScrollUp
:ListChange
if errorlevel 102 set KBI=2
if errorlevel 103 set KBI=3
if errorlevel 104 set KBI=4
if errorlevel 105 set KBI=5
if errorlevel 106 set KBI=6
if errorlevel 107 set KBI=7
if errorlevel 108 set KBI=8
goto KBPoll

:ScrollUp
if "%KBP%" == "99" goto AtTop
:UpCheck
vmath %KBP% - 1 | set /p KTT=
if "%KTT%" == "" goto UpCheck
set KBP=%KTT%
:TopCheck
vmath %KBP% + 1 | set /p KTT=
if "%KTT%" == "" goto TopCheck
vgotoxy /k0 sop
vinsert /k0
vecho /k0  /n /e /c32 /t %LANG%\KEYBOARD.LST TITLE.%KTT%
goto KBPoll
:AtTop
set KBI=1
goto KBPoll

:ScrollDown
vmath %KBP% + 9 | set /p KTT=
if "%KTT%" == "" goto ScrollDown
if "%KTT%" == "%KBM%" goto AtBottom
:DownCheck
vmath %KBP% + 1 | set /p KTT=
if "%KTT%" == "" goto DownCheck
set KBP=%KTT%
:BottomCheck
vmath %KBP% + 9 | set /p KTT=
if "%KTT%" == "" goto BottomCheck
vgotoxy /k0 sop
vdelete /k0
vgotoxy /k0 eop sor
if "%KTT%" == "%KBM%" goto ReturnOption
vecho /k0 /n /e /c32 /t %LANG%\KEYBOARD.LST TITLE.%KTT%
goto KBPoll
:ReturnOption
vecho /k0 /n /t %FLANG% KBL
goto KBPoll
:AtBottom
set KBI=9
goto KBPoll

:KBAdv
if not exist %LANG%\KEYBOARD.LST goto KBSimple
:CountCheck
type %LANG%\KEYBOARD.LST | grep -i "^TITLE." | vstr /B/L TOTAL | set /p KBM=
if "%KBM%" == "" goto CountCheck
:GetMaxLine
vmath %KBM% - 1 | set /p KTT=
if "%KTT%" == "" goto GetMaxLine
set KBM=%KTT%
:GetMaxValue
type %LANG%\KEYBOARD.LST|grep -i "^TITLE."|vstr /B/L%KBM%|vstr /f. 2|vstr /f= 1|set /p KTT=
if "%KTT%" == "" goto GetMaxValue
set KBM=%KTT%
:AddReturnCheck
vmath %KBM% + 1 | set /p KTT=
if "%KTT%" == "" goto AddReturnCheck
set KBM=%KTT%
set KTT=

set KLST=y
set KBI=1
set KBP=99

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /p0 /b %TFB% /f %TFF% %TFS% textbox /t %FLANG% KBA_FRAME

vecho /k0 /c32 /t %LANG%\KEYBOARD.LST TITLE.100
vecho /k0 /c32 /t %LANG%\KEYBOARD.LST TITLE.101
vecho /k0 /c32 /t %LANG%\KEYBOARD.LST TITLE.102
vecho /k0 /c32 /t %LANG%\KEYBOARD.LST TITLE.103
vecho /k0 /c32 /t %LANG%\KEYBOARD.LST TITLE.104
vecho /k0 /c32 /t %LANG%\KEYBOARD.LST TITLE.105
vecho /k0 /c32 /t %LANG%\KEYBOARD.LST TITLE.106
vecho /k0 /c32 /t %LANG%\KEYBOARD.LST TITLE.107
vecho /k0 /n /c32 /t %LANG%\KEYBOARD.LST TITLE.108

:KBPoll
set KBT=
set KTT=
vchoice /k0 /a %TFC% Ctrl-C /p %KBI%

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 101 goto KBPolling
if errorlevel 1 set FKB=1
if errorlevel 2 set FKB=2
if errorlevel 3 set FKB=3
if errorlevel 4 set FKB=4
if errorlevel 5 set FKB=5
if errorlevel 6 set FKB=6
if errorlevel 7 set FKB=7
if errorlevel 8 set FKB=8
if errorlevel 9 set FKB=9

:FigureItOut
vmath %KBP% + %FKB% | set /p KTT=
if "%KTT%" == "" goto FigureItOut
set FKB=%KTT%
if "%FKB%" == "%KBM%" goto KBSimple

:Done
set KLST=
set KBI=
set KBP=
set KBM=
set KTT=
verrlvl 0
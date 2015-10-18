@echo off

set _WB=60
set _WC=58
set _WD=56
if "%2" == "" goto NoWidth

set _WB=%2
vmath %_WB% - 2 | set /p _WC=
vmath %_WC% - 2 | set /p _WD=

:NoWidth
vmath %1 - 2 | set /p _WA=

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% /w %_WB% /h %1 /c hidden shadow
vframe /b %TFB% /f %TFF% /w %_WC% /h %1 /c %TFS%
vframe /b %TFB% /f %TFF% /w %_WD% /h %_WA% /c hidden

set _WA=
set _WB=
set _WC=
set _WD=

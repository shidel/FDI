@echo off

vmath %1 - 2 | set /p _TA=

vcls /f %TSF% /b %TSB% /c %TSC% /y2 /h24
vframe /b %TFB% /f %TFF% /w60 /h %1 /c hidden shadow
vframe /b %TFB% /f %TFF% /w58 /h %1 /c %TFS%
vframe /b %TFB% /f %TFF% /w56 /h %_TA% /c hidden

set _TA=

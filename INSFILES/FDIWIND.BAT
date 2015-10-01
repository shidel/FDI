@echo off

vmath %1 - 2 | set /p _TFMA=

vcls /f %_SFG% /b %_SBG% /c %_SFC% /y2 /h24
vframe /b %_FBG% /f %_FFG% /w60 /h %1 /c hidden shadow
vframe /b %_FBG% /f %_FFG% /w58 /h %1 /c %_FBS%
vframe /b %_FBG% /f %_FFG% /w56 /h %_TFMA% /c hidden

set _TFMA=

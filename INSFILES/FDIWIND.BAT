@echo off

vmath %1 - 2 | set /p FDI_TFMA=

vcls /f %FDI_SFG% /b %FDI_SBG% /c %FDI_SFC% /y2 /h24
vframe /b %FDI_FBG% /f %FDI_FFG% /w60 /h %1 /c hidden shadow
vframe /b %FDI_FBG% /f %FDI_FFG% /w58 /h %1 /c %FDI_FBS%
vframe /b %FDI_FBG% /f %FDI_FFG% /w56 /h %FDI_TFMA% /c hidden

set FDI_TFMA=

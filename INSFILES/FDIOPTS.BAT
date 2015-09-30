@echo off

vmath %1 - 2 | set /p FDI_TFMA=

vcls /f %FDI_SFG% /b %FDI_SBG% /c %FDI_SFC% /y2 /h24
vframe /b %FDI_FBG% /f %FDI_FFG% /w60 /h %1/c /y7 hidden shadow
vframe /b %FDI_FBG% /f %FDI_FFG% /w58 /h %1 /c /y7 %FDI_FBS%
vframe /b %FDI_FBG% /f %FDI_FFG% /w56 /h %FDI_WFM% /c /y8 hidden

set FDI_TFMA=

@echo off

vgotoxy /l eop /g /q Y | set /p FDI_TFMA=
vmath %FDI_TFMA% - %1 | set /p FDI_TFMA=
vmath %1 + 2 | set /p FDI_TFMB=

vframe /w44 /h %FDI_TFMB% /c /y %FDI_TFMA% hidden

set FDI_TFMA=
set FDI_TFMA=

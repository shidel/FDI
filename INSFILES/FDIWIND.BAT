@echo off

vgotoxy /l eop /q Y | set /p FDI_TFMA=
vmath %FDI_TFMA% - %1 - 2 | set /p FDI_TFMA=
vmath %1 + 2 | set /p FDI_TFMB=

vframe /w44 /h %FDMI_TFMB% /c /y %FDMI_TFMA% hidden

set FDI_TFMA=
set FDI_TFMB=

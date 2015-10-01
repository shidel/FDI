@echo off

vgotoxy /l eop /g /q Y | set /p _TFMA=
vmath %_TFMA% - %1 | set /p _TFMA=
vmath %1 + 2 | set /p _TFMB=

vframe /w44 /h %_TFMB% /c /y %_TFMA% hidden

set _TFMA=
set _TFMB=

@ECHO OFF

REM Temporary Load or unload font for specific language.

if "%1" == "LOAD" goto LoadFont

:UnloadFont
vfont /d
goto End

:LoadFont
vfont /f16 ru\ru866.v8f

:End
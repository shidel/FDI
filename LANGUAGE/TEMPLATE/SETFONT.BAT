@ECHO OFF

REM Temporary Load or unload font for specific language.

if "%1" == "LOAD" goto LoadFont

:UnloadFont
goto End

:LoadFont

:End
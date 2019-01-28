@ECHO OFF

REM Temporary Load or unload font for specific language. It is only used
REM during the execution of FDI and is not used to configure the installed
REM system.

REM Note when this batch is called, the working path is the main FDI setup
REM directory. So to reference files stored in this directory (like fonts),
REM you will need to prefix their file names with the language prefix. Like:
REM vfont /f16 EN\EN-FONT.V8F

if "%1" == "LOAD" goto LoadFont

:UnloadFont
REM Do something to unload the font. For font's loaded with V8Power Tools vfont
REM vfont /d
goto End

:LoadFont
REM Load a temporary font using V8Power Tools vfont
REM vfont /f16 %LANG%\FONTFILE.V8F

:End
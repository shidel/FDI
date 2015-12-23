@echo off

REM Set Package list variable to point to appropriate package list file.
REM This is the file FDINS section you would modify what list of packages
REM are installed based on the users selections.
REM
REM For best compatibility and ease of implementing future versions of this
REM installer, I recommend that customizations to the list be preformed
REM in a custom FDINS file. For instance, if a FDINS101.BAT is added, it
REM will be automatically processed after this file.
REM
REM If you wanted to always include non-standard packages, you could do
REM something like the following in the additional FDINS batch file.
REM
REM copy %FINSP%\FDPLALL.LST %TEMP%\MYPACKS.LST
REM type %FINSP%\MYLIST.LST >>%TEMP%\MYPACKS.LST
REM set FKPGS=%TEMP%\MYPACKS.LST

set FPKGS=%FINSP%\FDPLBASE.LST
if "%OALL%" == "y" set FPKGS=%FINSP%\FDPLALL.LST

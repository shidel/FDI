@echo off

REM Set Package list variable to point to appropriate package list file.
REM This is the file FDINS section you would modify to add more files or lists
REM that are not included with the default installer.
REM
REM For example, to append a custom list, you would do something like this.
REM
REM copy %FINSP%\FDPLALL.LST %TEMP%\MYPACKS.LST
REM type %FINSP%\MYLIST.LST >>%TEMP%\MYPACKS.LST
REM set FKPGS=%TEMP%\MYPACKS.LST

set FPKGS=%FINSP%\FDPLBASE.LST
if "%OALL%" == "y" set FPKGS=%FINSP%\FDPLALL.LST

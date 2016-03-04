@echo off

if exist \SETUP.BAT goto MBRZAP
echo.
echo Please use the following command to rewrite the MBR boot code:
echo.
echo sys C: /BOOTONLY
echo.
echo or
echo.
echo sys D: /BOOTONLY
echo.
echo For whichever drive you installed the operating system. A backup copy of
echo its current MBR should have been saved inside the main OS subdirectory as
echo ORIGINAL.BSS. But, you should check first.
echo.
goto Done

:MBRZAP
\SETUP.BAT MBRZAP
:Done
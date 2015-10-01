@echo off

REM if advanced mode prompt for transfer system files.

if "%FDI_ADVANCED%" == "yes" goto AdvancedMode

set FDI_SYS=yes
verrlvl 0
goto Done

:AdvancedMode
call FDIWIND.BAT 8
vecho "Transfer system files to drive " /f %_FHC% C /f %_FFG% "?"
vecho
call FDIOPTS.BAT 2
vecho "  Yes - Transfer system files."
vecho "  No  - Do not transfer system files." /n
vchoice /a %_FCS% Ctrl-C /d 1

if errorlevel 200 FDICTRLC.BAT %0
if errorlevel 2 goto SkipSysXfer

set FDI_SYS=yes
verrlvl 0
goto Done

:SkipSysXfer
set FDI_SYS=no
verrlvl 0
goto Done

:Done
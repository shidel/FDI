@echo off

set RESULT=
if "%1" == "PRE" \FDSETUP\BIN\VFDUTIL /x /d %2
if not "%1" == "PRE" \FDSETUP\BIN\VFDUTIL /x /d %1
if errorlevel 1 set RESULT=A:
if errorlevel 2 set RESULT=B:
if errorlevel 3 set RESULT=C:
if errorlevel 4 set RESULT=D:
if errorlevel 5 set RESULT=E:
if errorlevel 6 set RESULT=F:
if errorlevel 7 set RESULT=G:
if errorlevel 8 set RESULT=H:
if errorlevel 9 set RESULT=I:
if errorlevel 10 set RESULT=J:
if errorlevel 11 set RESULT=K:
if errorlevel 12 set RESULT=L:
if errorlevel 13 set RESULT=M:
if errorlevel 14 set RESULT=N:
if errorlevel 15 set RESULT=O:
if errorlevel 16 set RESULT=P:
if errorlevel 17 set RESULT=Q:
if errorlevel 18 set RESULT=R:
if errorlevel 19 set RESULT=S:
if errorlevel 20 set RESULT=T:
if errorlevel 21 set RESULT=U:
if errorlevel 22 set RESULT=V:
if errorlevel 23 set RESULT=W:
if errorlevel 24 set RESULT=X:
if errorlevel 25 set RESULT=Y:
if errorlevel 26 set RESULT=Z:
if errorlevel 27 set RESULT=

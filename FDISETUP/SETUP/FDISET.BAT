@echo off

REM Text file variable setting utility.

if "%1" == "BEGIN" goto Prepare
if "%1" == "END" goto Finished
if "%1" == "SET" goto SetData
goto Error

:SetData
if not exist %TEMP%\FDISET.TMP goto Error
type %TEMP%\FDISET.TMP | vstr /n/s "%2" "%3" >%TEMP%\FDISET.OUT
if not exist %TEMP%\FDISET.OUT goto Error
copy /y %TEMP%\FDISET.OUT %TEMP%\FDISET.TMP >NUL
del %TEMP%\FDISET.OUT >NUL
goto Success

:Prepare
if exist %TEMP%\FDISET.TMP goto Error
copy /y %2 %TEMP%\FDISET.TMP >NUL
if errorlevel 1 goto Error
if not exist %TEMP%\FDISET.TMP goto Error
goto Success

:Finished
if not exist %TEMP%\FDISET.TMP goto Error
copy /y %TEMP%\FDISET.TMP %2>NUL
if not exist %2 goto Error
del %TEMP%\FDISET.TMP >NUL
if exist %TEMP%\FDISET.TMP goto Error
goto Success

:Success
verrlvl 0
goto Done

:Error
verrlvl 1
goto Done

:Done

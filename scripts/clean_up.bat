@echo off
REM ======================================================
REM Generic Python Installer build script
REM ------------------------------------------
REM Licensed under the terms of the BSD 3-Clause
REM (see cdl/LICENSE for details)
REM ======================================================
call %~dp0utils GetScriptPath SCRIPTPATH
call %FUNC% SetEnvVars
set ROOTPATH=%SCRIPTPATH%\..\
cd %ROOTPATH%

if exist *.obj del /s /q *.obj
if exist "tmp" ( rmdir /s /q "tmp" )
if exist "dist" ( rmdir /s /q "dist" )
if exist "packages" ( rmdir /s /q "packages" )
if exist "launchers" ( rmdir /s /q "launchers" )

call %FUNC% EndOfScript
@echo off
REM ======================================================
REM Generic Python Installer build script
REM ------------------------------------------
REM Licensed under the terms of the BSD 3-Clause
REM (see cdl/LICENSE for details)
REM ======================================================
call %~dp0utils GetScriptPath SCRIPTPATH
set ROOTPATH=%SCRIPTPATH%\..\
cd %ROOTPATH%

if exist "%CI_WNM%" ( rmdir /s /q "%CI_WNM%" )
if exist "%CI_DST%" ( rmdir /s /q "%CI_DST%" )

call %FUNC% EndOfScript
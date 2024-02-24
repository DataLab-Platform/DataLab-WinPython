@echo off
REM ======================================================
REM Generic Python Installer build script
REM ------------------------------------------
REM Licensed under the terms of the BSD 3-Clause
REM (see cdl/LICENSE for details)
REM ======================================================
call %~dp0utils GetScriptPath SCRIPTPATH
call %FUNC% GetLibName LIBNAME

set PRIVATE=%SCRIPTPATH%\..\
set PUBLIC=%ROOTPATH%..\%LIBNAME%_%date:~6,8%-%date:~3,2%-%date:~0,2%
cd %PRIVATE%
git clone %PRIVATE% %PUBLIC%
"C:\Program Files\7-Zip\7z.exe" a -mx1 "%PUBLIC%.7z" %PUBLIC%
rmdir /s /q %PUBLIC%
explorer /select,"%PUBLIC%.7z"

call %FUNC% EndOfScript
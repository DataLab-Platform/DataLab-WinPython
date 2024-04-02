@echo off
REM ======================================================
REM Generic Python Installer build script
REM ------------------------------------------
REM Licensed under the terms of the BSD 3-Clause
REM (see cdl/LICENSE for details)
REM ======================================================
setlocal enabledelayedexpansion
call %~dp0utils GetScriptPath SCRIPTPATH
call %FUNC% SetEnvVars
set ROOTPATH=%SCRIPTPATH%\..\
cd %ROOTPATH%

@REM CI_WPI=Winpython64-3.9.10.0dot.exe => PYSUFFIX=Py39
for /f "tokens=2 delims=-" %%a in ("!CI_WPI!") do set VERSION_PART=%%a
for /f "tokens=1-2 delims=." %%b in ("!VERSION_PART!") do (
    set MAJOR=%%b
    set MINOR=%%c
)
set PYSUFFIX=Py!MAJOR!!MINOR!

@REM Build installer
@REM ===========================================================================
set NSIS_DIST_PATH=%ROOTPATH%\DIST\%CI_DST%
set NSIS_PRODUCT_NAME=%CI_DST%
set NSIS_PRODUCT_ID=%CI_DST%
set NSIS_INSTALLDIR=C:\%CI_DST%
set NSIS_PRODUCT_VERSION=%CI_VER%
set NSIS_INSTALLER_VERSION=%CI_VER%.0
set NSIS_COPYRIGHT_INFO=%CI_CYR%
"C:\Program Files (x86)\NSIS\makensis.exe" nsis\installer.nsi

@REM Create release directory
@REM ===========================================================================
if not exist "%ROOTPATH%\releases" ( mkdir "%ROOTPATH%\releases" )
set RLSPTH=%ROOTPATH%\releases\%CI_DST%-%CI_VER%_release\
if exist "%RLSPTH%" ( rmdir /s /q "%RLSPTH%" )
mkdir %RLSPTH%
move /Y %ROOTPATH%\%CI_DST%-%CI_VER%.exe %RLSPTH%\%CI_DST%-%CI_VER%_%PYSUFFIX%.exe

call %FUNC% EndOfScript
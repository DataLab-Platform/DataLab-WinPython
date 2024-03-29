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

ren %CI_WNM% %CI_DST%

@REM Build installer
@REM ===========================================================================
set NSIS_DIST_PATH=%ROOTPATH%%CI_DST%
set NSIS_PRODUCT_NAME=%CI_DST%
set NSIS_PRODUCT_ID=%CI_DST%
set NSIS_INSTALLDIR=C:\%CI_DST%
set NSIS_PRODUCT_VERSION=%CI_VER%
set NSIS_INSTALLER_VERSION=%CI_VER%.0
set NSIS_COPYRIGHT_INFO=%CI_CYR%
"C:\Program Files (x86)\NSIS\makensis.exe" nsis\installer.nsi

@REM Create release directory
@REM ===========================================================================
if exist "%RLSPTH%" ( rmdir /s /q "%RLSPTH%" )
mkdir %RLSPTH%
move /Y %ROOTPATH%%CI_DST%-%CI_VER%.exe %RLSPTH%\%CI_DST%-%CI_VER%_%CI_SUF%.exe

call %FUNC% EndOfScript
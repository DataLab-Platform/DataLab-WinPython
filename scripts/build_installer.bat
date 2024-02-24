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

ren %CI_WNM% %CI_DST%

@REM Build installer
@REM ===========================================================================
copy "executables\*.ico" "%CI_DST%\scripts"
copy "executables\*.bat" "%CI_DST%"
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
set RLSPTH=%ROOTPATH%%CI_DST%-%CI_VER%_release\
set SRCPTH=%RLSPTH%\source\
rmdir /S /Q %RLSPTH%
mkdir %RLSPTH%
move %ROOTPATH%%CI_DST%-%CI_VER%.exe %RLSPTH%
set AddToSource="C:\Program Files\7-Zip\7z.exe" a -mx1 "%RLSPTH%%CI_DST%-%CI_VER%_source.zip"
%AddToSource% executables nsis packages prerequisites scripts
%AddToSource% create_installer.bat README.md requirements.txt %CI_WPI%

call %FUNC% EndOfScript
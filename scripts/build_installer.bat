@echo off
REM ======================================================
REM Generic Python Installer build script
REM ------------------------------------------
REM Licensed under the terms of the BSD 3-Clause
REM (see datalab/LICENSE for details)
REM ======================================================
setlocal enabledelayedexpansion
call %~dp0utils GetScriptPath SCRIPTPATH
call %FUNC% SetEnvVars
set ROOTPATH=%SCRIPTPATH%\..
cd %ROOTPATH%

@REM CI_WPI=Winpython64-3.9.10.0dot.exe => PYSUFFIX=Py39
for /f "tokens=2 delims=-" %%a in ("!CI_WPI!") do set VERSION_PART=%%a
for /f "tokens=1-2 delims=." %%b in ("!VERSION_PART!") do (
    set MAJOR=%%b
    set MINOR=%%c
)
set PYSUFFIX=Py!MAJOR!!MINOR!

@REM Export installer images
@REM ===========================================================================
echo Generating images for WiX installer...
pushd %ROOTPATH%\resources
call deploy.bat
popd

@REM Build installer
@REM ===========================================================================
call %FUNC% DeployPython
echo Generating .wxs file for WiX installer...
%PYTHON% "wix\makewxs.py" %CI_DST% %CI_VER%
echo Building WiX Installer...
wix build "wix\%CI_DST%-%CI_VER%.wxs" -ext WixToolset.UI.wixext -ext WixToolset.Util.wixext

@REM Create release directory
@REM ===========================================================================
if not exist "%ROOTPATH%\releases" ( mkdir "%ROOTPATH%\releases" )
set RLSPTH=%ROOTPATH%\releases\%CI_DST%-%CI_VER%_release
if exist "%RLSPTH%" ( rmdir /s /q "%RLSPTH%" )
mkdir %RLSPTH%
move /Y %ROOTPATH%\wix\%CI_DST%-%CI_VER%.msi %RLSPTH%\%CI_DST%-%CI_VER%_%PYSUFFIX%.msi
explorer %RLSPTH%

@REM Clean up
rmdir /S /Q ".\tmp"

call %FUNC% EndOfScript
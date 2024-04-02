@echo off
call %~dp0utils GetScriptPath SCRIPTPATH
call %FUNC% SetEnvVars
set ROOTPATH=%SCRIPTPATH%\..\
cd %ROOTPATH%

if exist "packages" ( rmdir /s /q "packages" )
mkdir packages

call %FUNC% DeployPython
%PYTHON% -m pip install --upgrade pip
pip download cdl==%CI_VER% -d packages
pip download -r requirements.txt -d packages

rmdir /S /Q ".\tmp"
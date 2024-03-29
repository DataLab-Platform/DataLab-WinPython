@echo off
call %~dp0utils GetScriptPath SCRIPTPATH
call %FUNC% SetEnvVars
set ROOTPATH=%SCRIPTPATH%\..\
cd %ROOTPATH%

if exist "packages" ( rmdir /s /q "packages" )
mkdir packages

if not exist "%CI_WNM%" ( "C:\Program Files\7-Zip\7z.exe" x -y -o"." "%CI_WPI%" )

call "%CI_WNM%\scripts\env_for_icons.bat" %*

%PYTHON% -m pip install --upgrade pip
pip download cdl==%CI_VER% -d packages
pip download -r requirements.txt -d packages
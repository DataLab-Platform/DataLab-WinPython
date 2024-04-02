@echo off
call %~dp0utils GetScriptPath SCRIPTPATH
call %FUNC% SetEnvVars
set ROOTPATH=%SCRIPTPATH%\..\
cd %ROOTPATH%

if exist "packages" ( rmdir /s /q "packages" )
mkdir packages

if not exist ".\tmp" ( mkdir ".\tmp" )
"C:\Program Files\7-Zip\7z.exe" x -y -o".\tmp" "%CI_WPI%"
for /D %%I in (.\tmp\*) do set WP_FOLDER=%%~nxI
call ".\tmp\%WP_FOLDER%\scripts\env_for_icons.bat" %*

%PYTHON% -m pip install --upgrade pip
pip download cdl==%CI_VER% -d packages
pip download -r requirements.txt -d packages

rmdir /S /Q ".\tmp"
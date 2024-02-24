@echo off
cd %~dp0..
call "WPy64-31180\scripts\env_for_icons.bat" %*
rmdir /s /q packages
mkdir packages
pip download -r requirements.txt -d packages
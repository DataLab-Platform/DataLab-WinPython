@echo off
call "%~dp0scripts\env_for_icons.bat" %*
cd/D "%WINPYWORKDIR1%"
"%WINPYDIR%\python.exe" -m cdl.app %*

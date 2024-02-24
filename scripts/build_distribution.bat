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

@REM Build WinPython distribution
@REM ===========================================================================
"C:\Program Files\7-Zip\7z.exe" x -y -o"." "%CI_WPI%"
call "%CI_WNM%\scripts\env_for_icons.bat" %*
cd %CI_WNM%
del IPython*.exe
del Jupyter*.exe
del Pyzo.exe
del Qt*.exe
del Spyder*.exe
del VS*.exe
del "WinPython Powershell Prompt.exe"
rmdir /S /Q notebooks
rmdir /S /Q t
cd %ROOTPATH%
pip install --no-cache-dir --no-index --find-links=packages -r requirements.txt

call %FUNC% EndOfScript
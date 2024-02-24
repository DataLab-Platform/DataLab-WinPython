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
del IDLE*.exe
del "WinPython Powershell Prompt.exe"
rmdir /S /Q notebooks
rmdir /S /Q t
cd %ROOTPATH%
@REM Install packages
pip install --no-cache-dir --no-index --find-links=packages -r requirements.txt

@REM Create additional launchers
@REM ===========================================================================
@REM Iterate over all .bat files in "executables" folder:
set NSIS_WORKDIR=$EXEDIR\scripts
set NSIS_COMMAND=wscript.exe
for %%f in (executables\*.bat) do (
  @REM Copy each .bat file to the "scripts" folder:
  copy "executables\%%~nxf" "%ROOTPATH%\%CI_WNM%\scripts"
  @REM Set NSIS_ICON, NSIS_OUTFILE and NSIS_PARAMS for each .bat file:
  set NSIS_ICON=%ROOTPATH%\executables\%%~nf.ico
  set NSIS_OUTFILE=%ROOTPATH%\%CI_WNM%\%%~nf.exe
  set NSIS_PARAMS=Noshell.vbs %%~nxf
  "C:\Program Files (x86)\NSIS\makensis.exe" nsis\launcher.nsi
)

call %FUNC% EndOfScript
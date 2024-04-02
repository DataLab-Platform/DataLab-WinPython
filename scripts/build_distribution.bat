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

@REM Build WinPython distribution
@REM ===========================================================================

@REM Extract WinPython distribution
if not exist "%ROOTPATH%\dist" ( mkdir "%ROOTPATH%\dist" )
if exist "%ROOTPATH%\dist\%CI_DST%" ( rmdir /s /q "%ROOTPATH%\dist\%CI_DST%" )

@REM Rename extracted folder to %CI_DST%
if exist ".\tmp" ( rmdir /s /q ".\tmp" )
"C:\Program Files\7-Zip\7z.exe" x -y -o".\tmp" "%CI_WPI%"
for /D %%I in (.\tmp\*) do set WP_FOLDER=%%~nxI
pushd ".\tmp"
ren %WP_FOLDER% %CI_DST%
popd
move ".\tmp\%CI_DST%" "%ROOTPATH%\dist\"
rmdir /S /Q ".\tmp"

@REM Customize WinPython distribution
call "%ROOTPATH%\dist\%CI_DST%\scripts\env_for_icons.bat" %*
cd %ROOTPATH%\dist\%CI_DST%
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
pip install --no-cache-dir --no-index --find-links=packages cdl==%CI_VER%
pip install --no-cache-dir --no-index --find-links=packages -r requirements.txt

@REM Remove all '__pycache__' folders
@REM for /d /r "%ROOTPATH%\dist\%CI_DST%" %%d in (__pycache__) do (
@REM     rd /s /q "%%d"
@REM )

@REM Create additional launchers
@REM ===========================================================================
@REM Iterate over all .bat files in "executables" folder:
set NSIS_WORKDIR=$EXEDIR\scripts
set NSIS_COMMAND=wscript.exe
for %%f in (executables\*.bat) do (
  @REM Copy each .bat file to the "scripts" folder:
  copy "executables\%%~nxf" "%ROOTPATH%\dist\%CI_DST%\scripts"
  @REM Set NSIS_ICON, NSIS_OUTFILE and NSIS_PARAMS for each .bat file:
  set NSIS_ICON=%ROOTPATH%\executables\%%~nf.ico
  set NSIS_OUTFILE=%ROOTPATH%\dist\%CI_DST%\%%~nf.exe
  set NSIS_PARAMS=Noshell.vbs %%~nxf
  "C:\Program Files (x86)\NSIS\makensis.exe" nsis\launcher.nsi
)

call %FUNC% EndOfScript
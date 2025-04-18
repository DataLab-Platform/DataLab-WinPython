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

@REM Apply patches
@REM ===========================================================================
@REM Patches are folders in the "patches" folder: for each folder in "patches",
@REM check if that folder exists in the WinPython distribution and, if so, copy
@REM the content of that folder to the corresponding folder in the WinPython,
@REM recursively.
for /d %%d in (patches\*) do (
    if exist "dist\%CI_DST%\%%~nxd" (
        xcopy /s /y "patches\%%~nxd" "dist\%CI_DST%\%%~nxd"
    )
)

@REM Remove all '__pycache__' folders
@REM for /d /r "%ROOTPATH%\dist\%CI_DST%" %%d in (__pycache__) do (
@REM     rd /s /q "%%d"
@REM )

@REM Copy launchers (generated by build_launchers.bat) to the distribution
@REM ===========================================================================
xcopy /s /y executables\*.bat "dist\%CI_DST%\scripts"
xcopy /s /y launchers\*.exe "dist\%CI_DST%"

call %FUNC% EndOfScript
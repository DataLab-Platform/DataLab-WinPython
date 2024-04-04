@echo off
set FUNC=%0
call:%*
goto Exit

REM ======================================================
REM Utilities for deployment, test and build scripts
REM ======================================================
REM Licensed under the terms of the MIT License
REM Copyright (c) 2020 Pierre Raybaut
REM (see LICENSE file for more details)
REM ======================================================

:GetScriptPath
    set _tmp_=%~dp0
    if %_tmp_:~-1%==\ set %1=%_tmp_:~0,-1%
    EXIT /B 0

:GetLibName
    pushd %~dp0..
    for %%I in (.) do set %1=%%~nxI
    popd
    goto:eof

:SetPythonPath
    set PYTHONPATH=%~dp0..
    goto:eof

:SetEnvVars
    cd %~dp0..
    @REM Get parent directory name (that is the project name) 
    @REM and set it to "CI_DST" environment variable:
    for %%I in (.) do set CI_DST=%%~nxI
    echo Project name: "%CI_DST%"
    for /F "tokens=*" %%A in (.env) do (
        set %%A
        echo   %%A
    )
    goto:eof

:DeployPython
    echo Deploying temporary Python environment...
    cd %~dp0..
    if not exist ".\tmp" ( mkdir ".\tmp" )
    "C:\Program Files\7-Zip\7z.exe" x -y -o".\tmp" "%CI_WPI%" >nul
    for /D %%I in (.\tmp\*) do set WP_FOLDER=%%~nxI
    call ".\tmp\%WP_FOLDER%\scripts\env_for_icons.bat" %*
    goto:eof

:ShowTitle
    @echo:
    @echo ========= %~1 =========
    @echo:
    goto:eof

:EndOfScript
    @echo:
    @echo **********************************************************************************
    @echo:
    if not defined UNATTENDED (
        @echo End of script
        pause
        )
    goto:eof

:Exit
    exit /b
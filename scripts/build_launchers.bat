@echo off
setlocal EnableDelayedExpansion

call %~dp0utils GetScriptPath SCRIPTPATH
call %FUNC% SetEnvVars
set ROOTPATH=%SCRIPTPATH%\..\
cd %ROOTPATH%

:: Check if MSVC environment is already initialized
if not defined VSINSTALLDIR (
    echo Initializing MSVC environment...
    call %VCVARS_PATH%
    if errorlevel 1 (
        echo [ERROR] Failed to initialize MSVC environment.
        exit /b 1
    )
)

:: Paths
set SOURCE_FILE=src\launcher_template.cpp
set OUTPUT_DIR=launchers

:: Ensure output directory exists
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:: Walk through .bat files in the current directory
for %%B in (executables\*.bat) do (
    echo Processing %%B...

    :: Derive the base name and paths
    set "BASE_NAME=%%~nB"
    set "BAT_FILE=%%~dpB%%~nxB"
    set "ICON_FILE=%%~dpB%%~nB.ico"
    set "RESOURCE_FILE=%OUTPUT_DIR%\%%~nB.rc"
    set "RESOURCE_OBJ=%OUTPUT_DIR%\%%~nB.res"
    set "LAUNCHER_EXE=%OUTPUT_DIR%\%%~nB.exe"

    :: Check if the icon exists
    if exist "%%~dpB%%~nB.ico" (
        echo Icon found: %%~dpB%%~nB.ico
    ) else (
        echo No icon found for %%B. Using default icon.
        set "ICON_FILE=default.ico"
    )

    :: Create resource file
    echo Creating resource file...
    > "!RESOURCE_FILE!" echo IDI_ICON1 ICON "!ICON_FILE!"
    :: Compile resource
    echo Compiling resource...
    rc /fo "%OUTPUT_DIR%\%%~nB.res" "!RESOURCE_FILE!"

    :: Compile the launcher executable
    echo Compiling launcher executable...
    cl /EHsc /O2 /DUNICODE /W4 "%SOURCE_FILE%" "!RESOURCE_OBJ!" ^
        /Fe"!LAUNCHER_EXE!" ^
        /DLAUNCH_TARGET=\"%%~nxB\" ^
        User32.lib ^
        /link /SUBSYSTEM:WINDOWS

    :: Remove intermediate .obj file
    del /q "launcher_template.obj"

    if errorlevel 1 (
        echo [ERROR] Failed to build launcher for %%B.
        exit /b 1
    )

    if exist "!LAUNCHER_EXE!" (
        echo [SUCCESS] Launcher created: !LAUNCHER_EXE!
    ) else (
        echo [ERROR] Failed to build launcher for %%B.
        exit /b 1
    )
)

echo All launchers processed.
exit /b 0

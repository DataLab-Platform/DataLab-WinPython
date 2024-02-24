@echo off
REM ======================================================
REM Generic Python Installer creation script
REM ------------------------------------------
REM Licensed under the terms of the BSD 3-Clause
REM (see cdl/LICENSE for details)
REM ======================================================

@REM === Build parameters ======================================================
set CI_DST=DataLab-WinPython
set CI_VER=0.12.0
set CI_CYR=Copyright (C) 2023 DataLab Platform Developers
set CI_WNM=WPy64-31180
set CI_WPI=Winpython64-3.11.8.0dot.exe
@REM ===========================================================================

set UNATTENDED=1
call %~dp0scripts\clean_up.bat
call %~dp0scripts\build_distribution.bat
set UNATTENDED=
call %~dp0scripts\build_installer.bat
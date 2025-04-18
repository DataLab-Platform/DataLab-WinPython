DataLab-WinPython
=================

![DataLab-WinPython](https://raw.githubusercontent.com/DataLab-Platform/DataLab-WinPython/main/resources/DataLab-WinPython.png)

Description
-----------

DataLab-WinPython is a Python distribution for Windows, based on WinPython, 
including [DataLab](https://datalab-platform.com/) (the open-source platform for scientific data analysis) and
its dependencies.

Motivation
----------

The goal of this project is to provide a simple and efficient way to deploy
a DataLab-based application on Windows, without requiring the end user to
install Python, Qt, or any other scientific/technical package.

As opposed to DataLab standalone installer for Windows which is based on 
[PyInstaller](https://www.pyinstaller.org/), DataLab-WinPython is based on 
[WinPython](https://winpython.github.io/). This allows to customize the
Python environment and to install additional packages.

This is a solution to DataLab's [Issue #58](https://github.com/DataLab-Platform/DataLab/issues/58).

Technologies
------------

DataLab-WinPython is based on the following technologies:

* Windows batch scripts (to minimize prerequisites)
* C++ for the launcher executable (to minimize dependencies), using MSVC (tested with Visual Studio 2022 Community Edition but should work with pretty much any version)
* WiX Toolset for the installer
* WinPython Python distribution
* Python package manager `pip`
* 7-zip compression software

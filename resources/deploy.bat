@echo off

set INKSCAPE_PATH="C:\Program Files\Inkscape\bin\inkscape.exe"

@REM Generating images for NSIS installer
%INKSCAPE_PATH% "WixUIBanner.svg" -o "temp.png" -w 493 -h 58
magick convert "temp.png" bmp3:"banner.bmp"
%INKSCAPE_PATH% "WixUIDialog.svg" -o "temp.png" -w 493 -h 312
magick convert "temp.png" bmp3:"dialog.bmp"
del "temp.png"
move /y *.bmp ..\wix

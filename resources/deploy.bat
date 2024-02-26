@echo off

set INKSCAPE_PATH="C:\Program Files\Inkscape\bin\inkscape.exe"

@REM Generating images for NSIS installer
%INKSCAPE_PATH% "win.svg" -o "temp.png" -w 164 -h 314
magick convert "temp.png" bmp3:"win.bmp"
%INKSCAPE_PATH% "banner.svg" -o "temp.png" -w 150 -h 57
magick convert "temp.png" bmp3:"banner.bmp"
del "temp.png"
move /y *.bmp %~dp0..\nsis\images

@REM Generating icons for NSIS installer
for %%s in (16 24 32 48 128 256) do (
  %INKSCAPE_PATH% "install.svg" -o "install-%%s.png" -w %%s -h %%s
  %INKSCAPE_PATH% "uninstall.svg" -o "uninstall-%%s.png" -w %%s -h %%s
)
magick convert "install-*.png" "install.ico"
magick convert "uninstall-*.png" "uninstall.ico"
del "install-*.png"
del "uninstall-*.png"
move /y *install.ico %~dp0..\nsis\icons

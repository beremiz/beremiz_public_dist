@echo off
setlocal

rem %~dp0 includes a trailing backslash automatically
set "script_dir=%~dp0"

rem Use USERPROFILE instead of HOMEDRIVE/HOMEPATH for better space handling
set "user_home=%USERPROFILE%"

rem Clean path joining (avoiding double backslashes)
set "python_exe=%script_dir%$MSYS_DIR\$MSYS_ENV_DIR\bin\pythonw.exe"
set "beremiz_py=%script_dir%beremiz\Beremiz.py"
set "winpaths_py=%script_dir%winpaths.py"

set "MSYSTEM=$MSYSTEM"

rem Launching via start:
rem First argument = Window title ("Beremiz IDE")
rem /d = Working directory (quoted)
rem Target executable and all path arguments safely quoted
start "Beremiz IDE" /d "%user_home%" "%python_exe%" "%beremiz_py%" -e "%winpaths_py%" --plcsdkselector %*

endlocal
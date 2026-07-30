@echo off
setlocal

rem %~dp0 includes a trailing backslash automatically
set "script_dir=%~dp0"

rem Use USERPROFILE instead of HOMEDRIVE/HOMEPATH for clean space handling
set "user_home=%USERPROFILE%"

rem Clean path joining (avoiding double backslashes like %script_dir%\...)
set "python_exe=%script_dir%$MSYS_DIR\$MSYS_ENV_DIR\bin\pythonw.exe"
set "plcopeneditor_py=%script_dir%beremiz\PLCOpenEditor.py"

set "MSYSTEM=$MSYSTEM"

rem Launch PLCOpen editor:
rem 1. "PLCOpen Editor" = Explicit window title so quotes aren't eaten
rem 2. /d "%user_home%" = Quoted working directory
rem 3. "%python_exe%" "%plcopeneditor_py%" = Quoted executable and script path
start "PLCOpen Editor" /d "%user_home%" "%python_exe%" "%plcopeneditor_py%" %*

endlocal
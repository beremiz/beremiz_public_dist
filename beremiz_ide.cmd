@echo off
setlocal

rem %~dp0 includes a trailing backslash automatically
set "script_dir=%~dp0"

rem Use USERPROFILE for robust space and path handling
set "user_home=%USERPROFILE%"

rem Clean path joining (avoiding double backslashes like %script_dir%\...)
set "python_exe=%script_dir%$MSYS_DIR\$MSYS_ENV_DIR\bin\pythonw.exe"
set "beremiz_py=%script_dir%beremiz\Beremiz.py"
set "winpaths_py=%script_dir%winpaths.py"

set "MSYSTEM=$MSYSTEM"

rem Launch Beremiz IDE safely with double-quoted paths throughout
start "Beremiz IDE" /d "%user_home%" "%python_exe%" "%beremiz_py%" -e "%winpaths_py%" %*

endlocal
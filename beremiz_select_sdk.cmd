@echo off
setlocal

rem Get the directory of the current script
set "script_dir=%~dp0"

rem Set the path to the executable relative to the script directory
set "python_exe=%script_dir%\$MSYS_DIR\$MSYS_ENV_DIR\bin\pythonw.exe"
set "beremiz_py=%script_dir%\beremiz\Beremiz.py"

set MSYSTEM=$MSYSTEM

rem Launch the executable with winpaths extension added to the command line arguments
start "Beremiz IDE" /d %HOMEDRIVE%%HOMEPATH% "%python_exe%" "%beremiz_py%" -e "%script_dir%\winpaths.py" --plcsdkselector %*

endlocal
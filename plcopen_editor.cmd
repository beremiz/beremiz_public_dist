@echo off
setlocal

rem Get the directory of the current script
set "script_dir=%~dp0"

rem Set the path to the executable relative to the script directory
set "python_exe=%script_dir%\$MSYS_DIR\$MSYS_ENV_DIR\bin\pythonw.exe"
set "plcopeneditor_py=%script_dir%\beremiz\PLCOpenEditor.py"

set MSYSTEM=$MSYSTEM

rem Launch PLCOpen editor with all command line arguments
start "Beremiz IDE" /d %HOMEDRIVE%%HOMEPATH% "%python_exe%" "%plcopeneditor_py%" %*

endlocal
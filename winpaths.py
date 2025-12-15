import os

# In order to avoid spurious terminal windows, MSYS2's pythonw.exe is launched directly.
# Since it is launched outside of any MSYS2 login shell (bash -l),
# it doesn't have the MSYS2 paths in the PATH. This script adds them.

# Beremiz installation directory, relative to this script
instdir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))

# Promote MSYS2 paths to the front of PATH
paths = os.environ["PATH"].split(os.pathsep)
new_PATH_1st = []
new_PATH_2nd = []
for path in paths:
    (new_PATH_1st if path.startswith(instdir) else new_PATH_2nd).append(path)

# re-compose PATH
os.environ["PATH"] = os.pathsep.join(new_PATH_1st + [
    os.path.join(instdir, "$MSYS_DIR", "$MSYS_ENV_DIR", "bin"),
    os.path.join(instdir, "$MSYS_DIR", "usr", "bin"),
] + new_PATH_2nd)
# Note: $MSYSTEM/bin is already added to PATH when calling pythonw.exe
# -> no need of os.path.join(instdir, "$MSYS_DIR", "$MSYS_ENV_DIR", "bin"),

os.environ["HOME"] = os.path.join(os.environ["HOMEDRIVE"], os.environ["HOMEPATH"], "BeremizHome")

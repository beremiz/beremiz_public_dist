import os

PATH = os.environ["PATH"]
instdir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
os.environ["PATH"] = ';'.join([
    os.path.join(instdir, "msys2", "bin"),
    os.path.join(instdir, "msys2", "usr", "bin"),
    os.path.join(instdir, "msys2", "mingw32", "bin"),
    PATH
])


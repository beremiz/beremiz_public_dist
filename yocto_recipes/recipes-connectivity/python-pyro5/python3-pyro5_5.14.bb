SUMMARY = "Python Remote Objects"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=c1c9ccd5f4ca5d0f5057c0e690a0153d"

SRC_URI[md5sum] = "477f4d5befa49ff39b225c894ad8bb4b"
SRC_URI[sha256sum] = "64fdce137b0fe532e88614d246b7c98bbe0a4f426786c524539acdc5e694086a"

PYPI_PACKAGE = "Pyro5"

inherit pypi setuptools3

RDEPENDS:${PN} += " \
    ${PYTHON_PN}-serpent \
    ${PYTHON_PN}-wheel \
"

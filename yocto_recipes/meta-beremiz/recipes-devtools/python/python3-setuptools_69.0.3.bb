
SUMMARY = "Easily download, build, install, upgrade, and uninstall Python packages"
HOMEPAGE = "https://github.com/pypa/setuptools"
AUTHOR = "Python Packaging Authority <distutils-sig@python.org>"
LICENSE = ""
LIC_FILES_CHKSUM = "file://LICENSE;md5=141643e11c48898150daa83802dbc65f"

SRC_URI = "https://files.pythonhosted.org/packages/fc/c9/b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7/setuptools-69.0.3.tar.gz"
SRC_URI[md5sum] = "b82de45aaa6b9bb911226660212ebb83"
SRC_URI[sha256sum] = "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"

S = "${WORKDIR}/setuptools-69.0.3"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

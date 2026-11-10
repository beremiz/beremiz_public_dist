
SUMMARY = "Foreign Function Interface for Python calling C code."
HOMEPAGE = "http://cffi.readthedocs.org"
AUTHOR = "Armin Rigo, Maciej Fijalkowski <python-cffi@googlegroups.com>"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5677e2fdbf7cdda61d6dd2b57df547bf"

SRC_URI = "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
SRC_URI[md5sum] = "0bcaed453da3004d0bea103038345c1e"
SRC_URI[sha256sum] = "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"

S = "${WORKDIR}/cffi-1.16.0"

RDEPENDS_${PN} = " \
"

inherit pypi setuptools3

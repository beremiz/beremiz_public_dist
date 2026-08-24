SUMMARY = "Pure Python Multicast DNS Service Discovery Library (Bonjour/Avahi compatible)"
HOMEPAGE = "https://github.com/jstasiak/python-zeroconf"
LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=9fe712b1bc27c5c4e9ecd7f31d208900"

SRC_URI[md5sum] = "d7d0838f62c971a8c88669cc430257ae"
SRC_URI[sha256sum] = "c51340a8a7f13d7265dcc582c4a97907c11e4f3d23d5234d3c2c0e44fb446717"

inherit pypi setuptools3

RDEPENDS:${PN} += " \
    ${PYTHON_PN}-ifaddr \
    ${PYTHON_PN}-asyncio \
"

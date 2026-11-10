SUMMARY = "Interface definitions for Zope products"
HOMEPAGE = "https://github.com/beremiz/nevow-py3"
LICENSE = ""

LIC_FILES_CHKSUM = "file://LICENSE;md5=c433166efeddc545cf06b0677ffa79ee"

SRC_URI = "https://github.com/beremiz/nevow-py3.git;branch=master"
SRC_URI[sha256sum] = "8452c8986b5090ffb4c204f0bddc7e8700ed6fd5"

SRCREV = "8452c8986b5090ffb4c204f0bddc7e8700ed6fd5"

S = "${WORKDIR}/git"

RDEPENDS_${PN} = ""

inherit setuptools3




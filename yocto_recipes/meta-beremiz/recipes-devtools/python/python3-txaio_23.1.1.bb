
SUMMARY = "Compatibility API between asyncio/Twisted/Trollius"
HOMEPAGE = "https://github.com/crossbario/txaio"
AUTHOR = "typedef int GmbH <autobahnws@googlegroups.com>"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3e2c2c2cc2915edc5321b0e6b1d3f5f8"

SRC_URI = "https://files.pythonhosted.org/packages/51/91/bc9fd5aa84703f874dea27313b11fde505d343f3ef3ad702bddbe20bfd6e/txaio-23.1.1.tar.gz"
SRC_URI[md5sum] = "297409f2dff8e71bad24467374aa8775"
SRC_URI[sha256sum] = "f9a9216e976e5e3246dfd112ad7ad55ca915606b60b84a757ac769bd404ff704"

S = "${WORKDIR}/txaio-23.1.1"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

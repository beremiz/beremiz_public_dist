
SUMMARY = "Extensions to the standard Python datetime module"
HOMEPAGE = "https://github.com/dateutil/dateutil"
AUTHOR = "Gustavo Niemeyer <gustavo@niemeyer.net>"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3155c7bdc71f66e02678411d2abf996"

SRC_URI = "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
SRC_URI[md5sum] = "5970010bb72452344df3d76a10281b65"
SRC_URI[sha256sum] = "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"

S = "${WORKDIR}/python-dateutil-2.8.2"

RDEPENDS_${PN} = "python3-six"

inherit pypi setuptools3


SUMMARY = "Python 2 and 3 compatibility utilities"
HOMEPAGE = "https://github.com/benjaminp/six"
AUTHOR = "Benjamin Peterson <benjamin@python.org>"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=43cfc9e4ac0e377acfb9b76f56b8415d"

SRC_URI = "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
SRC_URI[md5sum] = "a7c927740e4964dd29b72cebfc1429bb"
SRC_URI[sha256sum] = "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"

S = "${WORKDIR}/six-1.16.0"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

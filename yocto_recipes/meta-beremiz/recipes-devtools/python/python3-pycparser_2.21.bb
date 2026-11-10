
SUMMARY = "C parser in Python"
HOMEPAGE = "https://github.com/eliben/pycparser"
AUTHOR = "Eli Bendersky <eliben@gmail.com>"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2c28cdeabcb88f5843d934381b4b4fea"

SRC_URI = "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
SRC_URI[md5sum] = "48f7d743bf018f7bb2ffc5fb976d1492"
SRC_URI[sha256sum] = "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"

S = "${WORKDIR}/pycparser-2.21"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

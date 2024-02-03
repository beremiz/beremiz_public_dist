
SUMMARY = "The PyPA recommended tool for installing Python packages."
HOMEPAGE = "https://pip.pypa.io/"
AUTHOR = "The pip developers <distutils-sig@python.org>"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=63ec52baf95163b597008bb46db68030"

SRC_URI = "https://files.pythonhosted.org/packages/b7/06/6b1ad0ae8f97d7a0d6f6ad640db10780578999e647a9593512ceb6f06469/pip-23.3.2.tar.gz"
SRC_URI[md5sum] = "38dd5f7ab301167df063405c7fc16c84"
SRC_URI[sha256sum] = "7fd9972f96db22c8077a1ee2691b172c8089b17a5652a44494a9ecb0d78f9149"

S = "${WORKDIR}/pip-23.3.2"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

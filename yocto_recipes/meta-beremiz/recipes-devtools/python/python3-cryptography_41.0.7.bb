
SUMMARY = "cryptography is a package which provides cryptographic recipes and primitives to Python developers."
HOMEPAGE = ""
AUTHOR = " <The Python Cryptographic Authority and individual contributors <cryptography-dev@python.org>>"
LICENSE = ""
LIC_FILES_CHKSUM = "file://LICENSE;md5=8c3617db4fb6fae01f1d253ab91511e4"

SRC_URI = "https://files.pythonhosted.org/packages/ce/b3/13a12ea7edb068de0f62bac88a8ffd92cc2901881b391839851846b84a81/cryptography-41.0.7.tar.gz"
SRC_URI[md5sum] = "c06f01c4bc95327c2e4378589ed5a193"
SRC_URI[sha256sum] = "13f93ce9bea8016c253b34afc6bd6a75993e5c40672ed5405a9c832f0d4a00bc"

S = "${WORKDIR}/cryptography-41.0.7"

RDEPENDS_${PN} = " \
         ${PYTHON_PN}-cffi \
         ${PYTHON_PN}-pycparser \
"

inherit pypi setuptools3

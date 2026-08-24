SUMMARY = "An asynchronous networking framework written in Python"
HOMEPAGE = "https://github.com/twisted/twisted"
AUTHOR = "Twisted Matrix Laboratories"
LICENSE = "MIT"

LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "https://files.pythonhosted.org/packages/6e/d3/077ece8f12cd82419bd68bb34cf4538c4df5bb9202835e7a18358223e537/twisted-23.10.0.tar.gz"

SRC_URI[md5sum] = "9d4dd17f9aa0dec3fec8f734f47e1b71"
SRC_URI[sha256sum] = "987847a0790a2c597197613686e2784fd54167df3a55d0fb17c8412305d76ce5"

PYPI_PACKAGE = "Twisted"

RDEPENDS_${PN} = "python3-attrs python3-automat python3-constantly python3-hyperlink python3-incremental python3-typing-extensions python3-zope-interface"


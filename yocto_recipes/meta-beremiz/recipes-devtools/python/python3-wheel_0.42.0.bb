
SUMMARY = "A built-package format for Python"
HOMEPAGE = ""
AUTHOR = " <Daniel Holth <dholth@fastmail.fm>>"
LICENSE = "MIT"

LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "https://files.pythonhosted.org/packages/b0/b4/bc2baae3970c282fae6c2cb8e0f179923dceb7eaffb0e76170628f9af97b/wheel-0.42.0.tar.gz"
SRC_URI[md5sum] = "802ad6e5f9336fcb1c76b7593f0cd22d"
SRC_URI[sha256sum] = "c45be39f7882c9d34243236f2d63cbd58039e360f85d0913425fbd7ceea617a8"

S = "${WORKDIR}/wheel-0.42.0"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

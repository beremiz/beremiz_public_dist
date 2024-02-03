
SUMMARY = "Symbolic constants in Python"
HOMEPAGE = ""
AUTHOR = " <>"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e393e4ddd223e3a74982efa784f89fd7"

SRC_URI = "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
SRC_URI[md5sum] = "c090579309b2b34be04385b54b0a5a85"
SRC_URI[sha256sum] = "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"

S = "${WORKDIR}/constantly-23.10.4"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

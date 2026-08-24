
SUMMARY = ""A small library that versions your Python projects.""
HOMEPAGE = "https://github.com/twisted/incremental"
AUTHOR = " <>"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=6ca9b07f08e2c72d48c74d363d1e0e15"

SRC_URI = "https://files.pythonhosted.org/packages/86/42/9e87f04fa2cd40e3016f27a4b4572290e95899c6dce317e2cdb580f3ff09/incremental-22.10.0.tar.gz"
SRC_URI[md5sum] = "9fffa2490ca649550c79a78e85ef2eef"
SRC_URI[sha256sum] = "912feeb5e0f7e0188e6f42241d2f450002e11bbc0937c65865045854c24c0bd0"

S = "${WORKDIR}/incremental-22.10.0"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

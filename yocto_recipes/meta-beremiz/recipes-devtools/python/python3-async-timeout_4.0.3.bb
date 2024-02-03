
SUMMARY = "Timeout context manager for asyncio programs"
HOMEPAGE = "https://github.com/aio-libs/async-timeout"
AUTHOR = "Andrew Svetlov <andrew.svetlov@gmail.com> <andrew.svetlov@gmail.com>"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=4fa41f15bb5f23b6d3560c5845eb8d57"

SRC_URI = "https://files.pythonhosted.org/packages/87/d6/21b30a550dafea84b1b8eee21b5e23fa16d010ae006011221f33dcd8d7f8/async-timeout-4.0.3.tar.gz"
SRC_URI[md5sum] = "9bf7b764a7310cb063c1c261c21342e4"
SRC_URI[sha256sum] = "4640d96be84d82d02ed59ea2b7105a0f7b33abe8703703cd0ab0bf87c427522f"

S = "${WORKDIR}/async-timeout-4.0.3"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

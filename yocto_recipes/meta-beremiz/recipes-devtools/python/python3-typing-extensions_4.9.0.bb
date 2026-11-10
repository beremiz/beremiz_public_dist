
SUMMARY = "Backported and Experimental Type Hints for Python 3.8+"
HOMEPAGE = ""
AUTHOR = " <"Guido van Rossum, Jukka Lehtosalo, Łukasz Langa, Michael Lee" <levkivskyi@gmail.com>>"
LICENSE = ""
LIC_FILES_CHKSUM = "file://LICENSE;md5=fcf6b249c2641540219a727f35d8d2c2"

SRC_URI = "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
SRC_URI[md5sum] = "2bcafbd6817cb0d7a29ed7a7f1bb1e5d"
SRC_URI[sha256sum] = "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"

S = "${WORKDIR}/typing_extensions-4.9.0"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

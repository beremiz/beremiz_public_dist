
SUMMARY = "A featureful, immutable, and correct URL for Python."
HOMEPAGE = "https://github.com/python-hyper/hyperlink"
AUTHOR = "Mahmoud Hashemi and Glyph Lefkowitz <mahmoud@hatnote.com>"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=6dc5b4bd3d02faedf08461621aa2aeca"

SRC_URI = "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
SRC_URI[md5sum] = "6285ac13e7d6be4157698ad7960ed490"
SRC_URI[sha256sum] = "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"

S = "${WORKDIR}/hyperlink-21.0.0"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

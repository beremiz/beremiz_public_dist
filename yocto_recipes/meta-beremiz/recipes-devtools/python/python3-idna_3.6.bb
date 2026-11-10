
SUMMARY = "Internationalized Domain Names in Applications (IDNA)"
HOMEPAGE = ""
AUTHOR = " <Kim Davies <kim+pypi@gumleaf.org>>"
LICENSE = ""
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=dbec47b98e1469f6a104c82ff9698cee"

SRC_URI = "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
SRC_URI[md5sum] = "70f4beef4feb196ac64b75a93271f53c"
SRC_URI[sha256sum] = "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"

S = "${WORKDIR}/idna-3.6"

RDEPENDS_${PN} = ""

inherit pypi setuptools3

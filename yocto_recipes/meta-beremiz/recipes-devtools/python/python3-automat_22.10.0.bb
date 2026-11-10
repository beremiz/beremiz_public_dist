
SUMMARY = "Self-service finite-state machines for the programmer on the go."
HOMEPAGE = "https://github.com/glyph/Automat"
AUTHOR = "Glyph <glyph@twistedmatrix.com>"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=4ad213bcca81688e94593e5f60c87477"

SRC_URI = "https://files.pythonhosted.org/packages/7a/7b/9c3d26d8a0416eefbc0428f168241b32657ca260fb7ef507596ff5c2f6c4/Automat-22.10.0.tar.gz"
SRC_URI[md5sum] = "b8064994239aabb172748f984489ce75"
SRC_URI[sha256sum] = "e56beb84edad19dcc11d30e8d9b895f75deeb5ef5e96b84a467066b3b84bb04e"

S = "${WORKDIR}/Automat-22.10.0"

RDEPENDS_${PN} = " \
         ${PYTHON_PN}-attrs \
         ${PYTHON_PN}-six \
"

inherit pypi setuptools3

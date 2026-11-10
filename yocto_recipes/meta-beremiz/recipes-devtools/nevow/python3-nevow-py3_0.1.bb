SUMMARY = "Web Application Construction Kit"
HOMEPAGE = "https://github.com/beremiz/nevow-py3"
LICENSE = "CLOSED"

LIC_FILES_CHKSUM = "file://LICENSE;md5=50ad7cdebd8c5f7f1362c4adb8856265"

SRC_URI = "git://github.com/beremiz/nevow-py3.git;protocol=https"
SRC_URI[sha256sum] = "3b1a0cdada1d47b896cfb3f5ee27aae5fd7a3896c6feb69c8406802cac9f2a86"

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

inherit setuptools3     





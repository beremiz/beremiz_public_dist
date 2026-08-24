DESCRIPTION = "WebSocket client & server library, WAMP real-time framework"
HOMEPAGE = "http://crossbar.io/autobahn"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3e2c2c2cc2915edc5321b0e6b1d3f5f8"

SRC_URI = "https://files.pythonhosted.org/packages/92/ee/c3320c326919394ff597592549ff5d29d2f7bf12be9ddaa9017caff1a170/autobahn-23.1.2.tar.gz"

SRC_URI[md5sum] = "55cd275bc3d9c7e354f4b6a87b87f466"
SRC_URI[sha256sum] = "c5ef8ca7422015a1af774a883b8aef73d4954c9fcd182c9b5244e08e973f7c3a"

inherit pypi setuptools3

RDEPENDS:${PN} += " \
    ${PYTHON_PN}-async-timeout \
    ${PYTHON_PN}-asyncio \
    ${PYTHON_PN}-txaio \
    ${PYTHON_PN}-six \
"

BBCLASSEXTEND = "nativesdk"

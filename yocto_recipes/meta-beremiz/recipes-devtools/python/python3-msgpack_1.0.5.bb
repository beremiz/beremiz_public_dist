SUMMARY = "MessagePack (de)serializer"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=cd9523181d9d4fbf7ffca52eaa2a5751"

PYPI_PACKAGE = "msgpack"

inherit pypi setuptools3

SRC_URI[md5sum] = "da12a9f0a65a803ec005219f6095d0a3"
SRC_URI[sha256sum] = "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"

RDEPENDS:${PN}:class-target += "\
    ${PYTHON_PN}-io \
"

BBCLASSEXTEND = "native nativesdk"

do_install_ptest() {
	install -d ${D}${PTEST_PATH}/test
	cp -rf ${S}/test/* ${D}${PTEST_PATH}/test/
}

DESCRIPTION = "Simple Python setuptools hello world application"
SECTION = "examples"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://setup.py \
           file://python-helloworld.py \
           file://helloworld/__init__.py \
           file://helloworld/main.py"

S = "${WORKDIR}"


inherit setuptools3

do_install:append () {
    install -d ${D}${bindir}/mydir1
    install -m 0755 python-helloworld.py ${D}${bindir}/mydir1
    install -m 0755 setup.py ${D}${bindir}/mydir1
    install -d ${D}${bindir}/mydir1/helloworld
    install -m 0755 helloworld/main.py ${D}${bindir}/mydir1/helloworld
    install -d ${D}${bindir}/mydir2
    install -m 0755 helloworld/main.py ${D}${bindir}/mydir2
    install -d ${D}${prefix}/mydir2
    install -m 0755 helloworld/main.py ${D}${prefix}/mydir2
}

DESCRIPTION = "Beremiz Runtime python based"
SECTION = "Runtime for PLC"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://github.com/Nabeel3007/python-beremiz.git;protocol=https;branch=master"

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

do_install:append () {
    install -d ${D}${bindir}/beremiz_runtime_workdir
    install -d ${D}${bindir}/Beremiz
    install -m 0755 beremiz/Beremiz_service.py ${D}${bindir}/Beremiz
    install -m 0755 beremiz/version.py ${D}${bindir}/Beremiz
    install -d ${D}${bindir}/Beremiz/images
    install -m 0755 beremiz/images/brz.png ${D}${bindir}/Beremiz/images
    install -m 0755 beremiz/images/icoplay24.png ${D}${bindir}/Beremiz/images
    install -m 0755 beremiz/images/icostop24.png ${D}${bindir}/Beremiz/images
    install -d ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/__init__.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/loglevels.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/monotonic_time.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/NevowServer.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/PLCObject.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/PlcStatus.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/PyroServer.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/ServicePublisher.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/spawn_subprocess.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/Stunnel.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/typemapping.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/WampClient.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/webinterface.css ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/webinterface.js ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/Worker.py ${D}${bindir}/Beremiz/runtime
    install -m 0755 beremiz/runtime/xenomai.py ${D}${bindir}/Beremiz/runtime
    install -d ${D}${bindir}/Beremiz/util
    install -m 0755 beremiz/util/__init__.py ${D}${bindir}/Beremiz/util
    install -m 0755 beremiz/util/paths.py ${D}${bindir}/Beremiz/util
}

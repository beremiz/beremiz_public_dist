SUMMARY = "A console-only image for raspberrypi4 with beremiz_runtime."

LICENSE = "MIT"

inherit core-image
require recipes-core/images/core-image-base.bb

IMAGE_FEATURES += "ssh-server-openssh"

RDEPENDS_${PN} = "\
     python3-pip \
     python3-autobahn \
     python3-ifaddr \
     python3-msgpack \
     python3-pyro5 \
     python3-zeroconf \
     python3-zope.interface \
"  

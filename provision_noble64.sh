#!/usr/bin/env bash

set -xe

apt-get update

apt-get install -y --no-install-recommends \
     build-essential            \
     `# building pacman`        \
     wget                       \
     meson                      \
     cmake                      \
     pkg-config                 \
     libarchive-dev             \
     libcurl4-openssl-dev       \
     libssl-dev                 \
     `# running pacman`         \
     fakeroot                   \
     `# egg/whl download`       \
     python3-pip                \
     git                        \
     `# run win python3`        \
     xvfb                       \
     `# matiec cross build`     \
     mingw-w64                  \
     automake                   \
     bison                      \
     flex                       \
     `# installer`              \
     nsis                       \
     zip

# run win python3
dpkg --add-architecture i386
apt-get install -y --install-recommends \
     wine-stable

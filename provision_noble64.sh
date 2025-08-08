#!/usr/bin/env bash

set -xe

apt-get update

apt-get install -y --no-install-recommends \
     build-essential            \
     `# getting wine repo`      \
     gpg                        \
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

# Need at least wine 9.13 to run python3.12 in wine
# on noble64 only 9.0 is available, so we add the official wine repository
# https://forum.winehq.org/viewtopic.php?t=39119
mkdir -pm755 /etc/apt/keyrings
wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources

dpkg --add-architecture i386
apt update
apt install -y --install-recommends \
     winehq-stable
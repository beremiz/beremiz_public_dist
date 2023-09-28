#!/usr/bin/env bash

# This script is to be executed as root to provision necessary stuff
# to run distribution build on a blank Ubuntu Focal 64 image

set -xe
dpkg --add-architecture i386

apt-get update

apt-get install -y locales

locale-gen en_US.UTF-8

TZ="America/Paris" \
DEBIAN_FRONTEND="noninteractive" \
apt-get install -y --no-install-recommends \
     automake                   \
     bc                         \
     bison                      \
     build-essential            \
     ca-certificates            \
     cpio                       \
     cmake                      \
     fakeroot                   \
     flex                       \
     gettext                    \
     gawk                       \
     git                        \
     gperf                      \
     g++-multilib               \
     help2man                   \
     less                       \
     libarchive-dev             \
     libcurl4-openssl-dev       \
     libssl-dev                 \
     libtool-bin                \
     lzma                       \
     mercurial                  \
     meson                      \
     mingw-w64                  \
     ncurses-dev                \
     nsis                       \
     rsync                      \
     pkg-config                 \
     python3-pip                \
     subversion                 \
     swig                       \
     texinfo                    \
     unrar                      \
     unzip                      \
     wget                       \
     xvfb                       \
     zip

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
echo ttf-mscorefonts-installer msttcorefonts/present-mscorefonts-eula note | debconf-set-selections

apt-get install -y --install-recommends \
     wine-stable winbind

apt-get clean -y

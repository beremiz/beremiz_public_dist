#!/bin/bash

set -e

# absolute path to directory containing parent directory of that script
# (i.e. source directory containing beremiz, matiec, etc..)
SRCDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
echo "SOURCE direcory : $SRCDIR"

# absolute path to build directory. ~/build if not given as only argument
BUILDDIR=${1:-~/build}
mkdir -p $BUILDDIR
echo "BUILD direcory : $BUILDDIR"

UNAME=runner
UHOME=/home/$UNAME

echo "Creating docker container"
docker create \
       --name beremiz_public_builder_current \
       -v $SRCDIR:$UHOME/src \
       -v $BUILDDIR:$UHOME/build \
       -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 \
       -w $UHOME/build \
       -i -t beremiz_public_builder /bin/bash

#!/bin/bash

set -e

OWNDIRBASENAME=$(basename $(cd $(dirname "${BASH_SOURCE[0]}") && pwd))

echo "Building docker image"
docker build \
    --build-arg UID=$(id -u) \
    --build-arg GID=$(id -g) \
    --build-arg OWNDIRBASENAME="$OWNDIRBASENAME" \
    -t beremiz_public_builder .


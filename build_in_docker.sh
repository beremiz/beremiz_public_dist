#!/bin/bash

CONTAINER=beremiz_public_builder_current

docker start $CONTAINER 
echo exec docker with $*
docker exec $CONTAINER bash -c "build $*"
docker stop $CONTAINER


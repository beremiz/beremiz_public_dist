#!/bin/bash

CONTAINER=beremiz_public_builder_current

docker start $CONTAINER 
docker exec $CONTAINER bash -c build $*
docker stop $CONTAINER


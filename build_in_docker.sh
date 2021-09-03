#!/bin/bash

CONTAINER=beremiz_public_builder_current

docker start $CONTAINER 
docker exec -i -t $CONTAINER bash -i -c build $1
docker stop $CONTAINER


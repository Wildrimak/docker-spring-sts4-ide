#!/bin/bash

#docker container exec -it spring-sts4-ide-jdk14 bash

docker container rm sts-docker
docker container create -it --name sts-docker wildrimak/spring-sts4-ide:jdk14 bash
docker container start -i sts-docker
#!/bin/bash

#docker container exec -it spring-sts4-ide-jdk14 bash
export DBVERSION=10

docker container rm sts-docker

docker container create \
-i -t -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $HOME/.Xauthority:/home/$USER/.Xauthority \
-v $ECLIPSE_WORKSPACE_DIR:$DOCKER_ECLIPSE_WORKSPACE_DIR \
-v $MAVEN_DIR:$MAVEN_DIR \
--name sts-docker wildrimak/spring-sts4-ide:jdk14 bash \
-c "sudo pg_ctlcluster "$DBVERSION" main start && /opt/sts-4.7.1.RELEASE/SpringToolSuite4"

docker container start -i sts-docker
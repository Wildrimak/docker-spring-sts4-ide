#!/bin/bash

export DBVERSION=12

docker container rm -f sts-docker

ECLIPSE_DIR=${PWD}/.eclipse # on host machine
ECLIPSE_WORKSPACE_DIR=${PWD}/eclipse-workspace #on host machine
POSTGRES_DATA_DIR=${PWD}/postgres #on host machine
MAVEN_DIR=${HOME}/.m2 #on host machine
DOCKER_ECLIPSE_WORKSPACE_DIR=/home/$USER/Documents/workspace-spring-tool-suite-4-4.7.1.RELEASE

[ ! -d $ECLIPSE_DIR ] && mkdir -p $ECLIPSE_DIR
[ ! -d $ECLIPSE_WORKSPACE_DIR ] && mkdir -p $ECLIPSE_WORKSPACE_DIR
[ ! -d $MAVEN_DIR ] && mkdir -p $MAVEN_DIR

#-v $POSTGRES_DATA_DIR:/var/lib/ \
#-e POSTGRES_PASSWORD=postgres \
#-w $DOCKER_ECLIPSE_WORKSPACE_DIR \

docker container create \
-i -t -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $HOME/.Xauthority:/home/$USER/.Xauthority \
-v $ECLIPSE_WORKSPACE_DIR:$DOCKER_ECLIPSE_WORKSPACE_DIR \
-v $MAVEN_DIR:$MAVEN_DIR \
--name sts-docker wildrimak/spring-sts4-ide:jdk14 bash \
-c "sudo pg_ctlcluster "$DBVERSION" main start && /opt/sts-4.7.1.RELEASE/SpringToolSuite4"

docker container start sts-docker
docker exec -it sts-docker /bin/zsh
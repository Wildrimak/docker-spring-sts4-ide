# Image to execute sts in docker containg java8 + maven + postgresql 10

## Commands to start this script

### Create normal image
#### docker image build -t env-ubu-18-jav-8-pos-10 .

### Create image with my user and password and root password
#### docker image build \
#### --build-arg ROOT_PASS=myrootpass \
#### --build-arg IAM_USER=myuser \
#### --build-arg IAM_PASS=mypass \
#### -t env-ubu-18-jav-8-pos-10 .

### Create container with a name sts-java-8
#### docker container create -it --name sts-java-8 env-ubu-18-jav-8-pos-10

### Start container sts-java-8
#### docker container start -i sts-java-8

FROM ubuntu:18.04
LABEL maintainer 'finalwildrimak@gmail.com'

## Configurate ubuntu

### Pre-requisites programs needed to execute sts as well
RUN apt-get update && \
  apt-get install openjdk-8-jdk -y && \
  apt-get install maven -y && \
  apt-get install git -y

### Define usefull shell
RUN apt-get install zsh -y && \
  chsh -s $(which zsh)

### Define environment root
ARG ROOT_PASS=root 
ENV ROOT_PASS=${ROOT_PASS}
RUN echo 'root':$(echo $ROOT_PASS) | chpasswd && \
  unset ROOT_PASS

### Define my environment
ARG IAM_USER=wildrimak
ENV IAM_USER=${IAM_USER}
ARG IAM_PASS=wildrimak
ENV IAM_PASS=${IAM_PASS}

#### Configure my home
RUN groupadd -g 1000 $(echo $IAM_USER) && \
  useradd -d /home/$(echo $IAM_USER) -s $(which zsh) -m \
  $(echo $IAM_USER) -u 1000 -g 1000 && \
  echo $(echo $IAM_USER):$(echo $IAM_PASS) | chpasswd && \
  unset IAM_PASS
USER ${IAM_USER}
ENV HOME=/home/${IAM_USER}



FROM mvpjava/ubuntu-x11

MAINTAINER Andy Luis "MVP Java - mvpjava.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get install -y apt-utils && \
apt-get install -y libcanberra-gtk3-module && \
apt-get install -y curl wget git vim && \
apt-get clean all && \
sudo rm -rf /tmp/* && \
sudo rm -rf /var/cache/apk/*

###################################
##Install Java
###################################
ENV INSTALL_DIR=${INSTALL_DIR:-/usr} 
ENV JAVA_HOME=${INSTALL_DIR}/jdk-14.0.2 
ENV PATH=$PATH:${JAVA_HOME}/bin

WORKDIR ${INSTALL_DIR}

ADD jdk-14_linux-x64_bin.tar.gz .

###################################
## Install STS4
###################################

WORKDIR /opt

ADD spring-tool-suite-4-4.7.1.RELEASE-e4.16.0-linux.gtk.x86_64.tar.gz .

###################################
## Install Maven
###################################

ARG MAVEN_VERSION=${MAVEN_VERSION:-3.6.3} 
ENV MAVEN_VERSION=${MAVEN_VERSION} 
ENV MAVEN_HOME=/usr/apache-maven-${MAVEN_VERSION} 
ENV PATH $PATH:${MAVEN_HOME}/bin 
WORKDIR /usr 
ADD apache-maven-3.6.3-bin.tar.gz . 
RUN ln -s ${MAVEN_HOME} /usr/maven

ENV USER=wildrimak 
ENV HOME=/home/wildrimak 
ENV ECLIPSE_WORKSPACE=${HOME}/eclipse-workspace 
ENV USER_ID=1000 
ENV GROUP_ID=1000

RUN useradd ${USER} && \
export uid=${USER_ID} gid=${GROUP_ID} && \
mkdir -m 700 -p ${HOME}/.eclipse ${ECLIPSE_WORKSPACE} && \
chown ${USER}:${USER} ${HOME}/.eclipse ${ECLIPSE_WORKSPACE} && \
chown -R ${USER}:${USER} ${HOME} && \
ls -al ${HOME} && \
mkdir -p /etc/sudoers.d && \
echo "${USER}:x:${USER_ID}:${GROUP_ID}:${USER},,,:${HOME}:/bin/bash" >> /etc/passwd && \
echo "${USER}:x:${USER_ID}:" >> /etc/group && \
echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
chmod 0440 /etc/sudoers.d/${USER}

RUN apt-get install -y docker.io 
RUN usermod -aG docker $USER
RUN apt-get install git -y

ENV DEBIAN_FRONTEND teletype

USER ${USER} 
WORKDIR ${ECLIPSE_WORKSPACE}
CMD ["/opt/sts-4.6.0.RELEASE/SpringToolSuite4"]
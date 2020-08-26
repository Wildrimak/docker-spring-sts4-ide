FROM ubuntu:20.04

LABEL maintainer "Wildrimak - finalwildrimak@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get install -y apt-utils && \
apt-get install -y libcanberra-gtk3-module && \
apt-get install -y curl && \
apt-get install -y git && \
apt-get install -y vim && \
apt-get clean all && \
rm -rf /tmp/* && \
rm -rf /var/cache/apk/* && \
apt-get install gedit -y
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
RUN apt-get install zsh -y

ENV DEBIAN_FRONTEND teletype

RUN apt-get install -y \
  software-properties-common \
  postgresql \
  postgresql-client \
  postgresql-contrib

ENV DBUSER=postgres
ENV DBPASS=postgres
ENV DBNAME=postgres

USER ${USER}
RUN echo $(echo $DBUSER):$(echo $DBPASS) | sudo chpasswd

USER ${DBUSER}
# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
RUN /etc/init.d/postgresql start && \
    psql --command "CREATE USER ${USER} WITH SUPERUSER PASSWORD '${DBPASS}';" && \
    createdb -O ${USER} ${USER} && \
    psql --command "ALTER USER postgres WITH PASSWORD 'postgres';" && \
    /etc/init.d/postgresql restart


# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/$(ls /etc/postgresql)/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/$(ls /etc/postgresql)/main/postgresql.conf``
RUN echo "listen_addresses='*'" >> /etc/postgresql/$(ls /etc/postgresql)/main/postgresql.conf

# Add VOLUMEs to allow backup of config, logs and databases
# Ta descartavel pq eu inicio com parametros
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
#CMD ["/usr/lib/postgresql/${DBVERSION}/bin/postgres", "-D", "/var/lib/postgresql/${DBVERSION}/main", "-c", "config_file=/etc/postgresql/12/main/postgresql.conf"]

USER ${USER} 

RUN git config --global user.email "wildrimak@gmail.com" && \
  git config --global user.name "Wildrimak"


USER root

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
apt-get install -y sudo xauth xorg openbox && \
apt-get install -y libxext-dev libxrender-dev libxtst-dev && \
apt-get install -y apt-transport-https ca-certificates libcurl3-gnutls && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*
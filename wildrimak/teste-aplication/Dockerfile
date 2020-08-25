FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y nemo
RUN groupadd -g 1000 wildrimak
RUN useradd -d /home/wildrimak -s /bin/bash -m wildrimak -u 1000 -g 1000
USER wildrimak
ENV HOME /home/wildrimak
CMD /usr/bin/nemo
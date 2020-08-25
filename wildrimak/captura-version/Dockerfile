FROM postgres:12

USER root
RUN echo "LOG1\n" >> log1 
RUN echo "LOG2\n" >> log2
ENV A="ls -lh /etc/ >> log1"
ENV B="ls -lh /etc/postgresql/ >> log2"
RUN $B && $A
RUN cat /log1
RUN cat /log2
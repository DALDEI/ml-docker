# Adapted and hacked from all over
#######################################################################
#
#  Usage:
#    docker build  --build-arg java=<path to java sdk>  \
#                  --build-arg user=<name of user> \
#                  --build-arg uid=<uid of user> \
#                  -t tag  .
#
#######################################################################

FROM fedora:23
MAINTAINER Norman Walsh <norman.walsh@marklogic.com>
WORKDIR /tmp

# Use /tmp to avoid increasing the filesystem size
ARG java
ADD ${java} /tmp/jdk.rpm
RUN dnf -y install /tmp/jdk.rpm ;  \
   dnf clean all ; \
   rm -rf /tmp/jdk.rpm /tmp/*.log

RUN dnf -y install python-setuptools lsb initscripts sudo

RUN easy_install supervisor
ADD supervisord.conf /etc/supervisord.conf

ARG user=devuser
ARG uid=1000
RUN adduser --gid users --uid ${uid} --groups wheel ${user}
ADD sudoers /etc/sudoers
RUN chown root.root /etc/sudoers

ENV TERM rxvt-unicode
ENV JAVA_HOME /usr/java/latest

CMD [ "/usr/bin/supervisord" ]

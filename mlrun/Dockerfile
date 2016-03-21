# Adapted from https://gist.github.com/nikos/eb27dce271f00cba2bb7
# and https://gist.github.com/rlouapre/39f3cf793f27895ae8d2
# Hat tips to Niko Schmuck <niko.auto@nava.de>
# and Richard Louapre <richard.louapre@marklogic.com>
# and MAINTAINER Norman Walsh <norman.walsh@marklogic.com>
###########################################
#
#  Usage:  
#    docker build  --build-arg java=<path to java sdk>  \
#                  --build-arg marklogic=<path to marklogic rpm> \
#                  -t tag  .
##################################################### 
# 
## TODO: use 
# FROM marklogic-coreos
###################################################
FROM fedora:21
MAINTAINER David Lee <dlee@marklogic.com>

# Setup base system
RUN yum -y update; yum clean all
RUN yum -y install tar sudo applydeltarpm
RUN yum install -y libxml2 wget iputils iproute initscripts

RUN yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm 
  
# ./getjava.sh
ARG jdk
ADD ${jdk} /tmp/jdk.rpm
RUN yum -y install /tmp/jdk.rpm && rm -f /tmp/jdk.rpm 


# Install MarkLogic
ARG marklogic
ADD ${marklogic} /tmp/MarkLogic.rpm
RUN yum -y install /tmp/MarkLogic.rpm
RUN rm /tmp/MarkLogic.rpm
ADD runml.sh /tmp/runml.sh
ENV MARKLOGIC_EC2_HOST 0
ENV TERM rxvt-unicode
ENV JAVA_HOME /usr/java/latest
RUN yum clean all ; rm -rf /tmp/*.rpm /tmp/*.log /var/log/messsages/* 
RUN mkdir /var/opt/MarkLogic ; chown daemon.daemon /var/opt/MarkLogic ; chmod ug+rwx /var/opt/MarkLogic
VOLUME /var/opt/MarkLogic

# Expose MarkLogic Server ports
EXPOSE 7997 7998 7999 8000 8001 8002 8002 8003 8004 8005 8006 8007 8008 8009 8010 
ENTRYPOINT [ "/bin/bash" , "-c" ]
CMD [ "/tmp/runml.sh"]

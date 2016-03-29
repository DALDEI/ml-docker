# Adapted from https://gist.github.com/nikos/eb27dce271f00cba2bb7
# and https://gist.github.com/rlouapre/39f3cf793f27895ae8d2
# Hat tips to Niko Schmuck <niko.auto@nava.de>
# and Richard Louapre <richard.louapre@marklogic.com>
# and MAINTAINER Norman Walsh <norman.walsh@marklogic.com>
###########################################
#
#  Usage:  
#    docker build  --build-arg java=<path to java sdk>  \
#                  -t tag  .
##################################################### 

FROM fedora:21
MAINTAINER David Lee <dlee@marklogic.com>
WORKDIR /dev/shm
ENV TERM rxvt-unicode
ENV JAVA_HOME /usr/java/latest
# Setup base system
RUN yum install -y deltarpm http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm 
# ./getjava.sh
# Use /tmp to avoid increasing the filesystem size
ARG jdk
ADD ${jdk} /tmp/jdk.rpm
RUN yum -y install /tmp/jdk.rpm ;  \
   yum clean all ; \
   rm -rf /tmp/jdk.rpm /tmp/*.log 
#
# Expose MarkLogic Server ports
ENTRYPOINT [ "/bin/bash" , "-c" ]
CMD [ "/bin/bash" , "-l" ]

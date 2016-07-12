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

FROM centos:7
MAINTAINER Norman Walsh <norman.walsh@marklogic.com>
WORKDIR /tmp

# Args we need
ARG java
ARG user
ARG uid

# Add some files
# Use /tmp to avoid increasing the filesystem size
ADD ${java} /tmp/jdk.rpm
ADD supervisord.conf /etc/supervisord.conf
ADD sudoers /etc/sudoers

# Use a single RUN command for multiple commands to limit image sizes
RUN yum -y install /tmp/jdk.rpm ;  \
    yum clean all ; \
    rm -rf /tmp/jdk.rpm /tmp/*.log ; \
    yum -y install \
      http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-7.noarch.rpm ; \
    yum -y install \
      python-setuptools lsb initscripts sudo python34 ; \
   easy_install supervisor ; \
   curl https://bootstrap.pypa.io/get-pip.py | python3.4

RUN adduser --gid users --uid ${uid} --groups wheel ${user} ; \
    chown root.root /etc/sudoers ; \
    # These lines install the MarkLogic Python API. You can delete them
    # if you don't need or want the Python tools
    /usr/bin/pip3 install --upgrade pip ; \
    /usr/bin/pip3 install requests requests-toolbelt ; \
    /usr/bin/pip3 install marklogic_python_api -i https://testpypi.python.org/pypi

# You don't need this either if you don't want the Python tools
ADD marklogic.ini /home/${user}/.marklogic.ini

ENV TERM rxvt-unicode
ENV JAVA_HOME /usr/java/latest

CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]

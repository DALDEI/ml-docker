# Adapted and hacked from all over
#######################################################################
#
#  Usage:
#    docker build  --build-arg marklogic=<path to marklogic rpm> \
#                  --build-arg user=<name of user> \
#                  -t tag  .
#
#######################################################################

FROM ml-docker-coreos
MAINTAINER Norman Walsh <norman.walsh@marklogic.com>
WORKDIR /tmp

ENV MARKLOGIC_EC2_HOST 0

# Install MarkLogic
ARG marklogic
ADD ${marklogic} /tmp/MarkLogic.rpm
RUN dnf -y install /tmp/MarkLogic.rpm ; \
    rm -f /tmp/MarkLogic.rpm ; \
    dnf clean all ; \
    rm -rf /tmp/* /root/.history ; \
    mkdir /var/opt/MarkLogic ; \
    chown daemon.daemon /var/opt/MarkLogic ; \
    chmod ug+rwx /var/opt/MarkLogic

VOLUME [ "/var/opt/MarkLogic" ]

ADD supervisord.conf /etc/supervisord.conf

# These lines install the MarkLogic Python API. You can delete them
# if you don't need or want the Python tools
ARG user=devuser
ADD marklogic.ini /home/${user}/.marklogic.ini
RUN /usr/bin/pip3 install --upgrade pip
RUN /usr/bin/pip3 install requests requests-toolbelt
RUN /usr/bin/pip3 install marklogic_python_api -i https://testpypi.python.org/pypi

# Expose MarkLogic Server ports
EXPOSE 7997 7998 7999 8000 8001 8002 8003 8004 8005 8006 8007 8008 8009 8010

CMD [ "/usr/bin/supervisord" ]

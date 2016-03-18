
# Adapted from https://gist.github.com/nikos/eb27dce271f00cba2bb7
# and https://gist.github.com/rlouapre/39f3cf793f27895ae8d2
# Hat tips to Niko Schmuck <niko.auto@nava.de>
# and Richard Louapre <richard.louapre@marklogic.com>
# and MAINTAINER Norman Walsh <norman.walsh@marklogic.com>

FROM fedora:21
MAINTAINER David Lee <dlee@marklogic.com>

# Setup base system
RUN yum -y update; yum clean all
RUN yum -y install tar sudo applydeltarpm
#RUN yum groupinstall -y 'Development tools'
#sqlite-devel readline-devel tk-devel db4-devel \
#libpcap-devel xz-devel
RUN yum install -y openssh-server

RUN yum install -y libxml2 wget iputils iproute initscripts

WORKDIR /tmp
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm -O epel.rpm && \
  yum -y install epel.rpm && rm -f epel.rpm
  
# ./getjava.sh
ADD getjava.sh /tmp/getjava.sh 
RUN ./getjava.sh -O jdk.rpm  && yum -y install jdk.rpm && rm -f jdk.rpm


RUN adduser --gid users --uid 1000 devuser

ADD marklogic.ini /home/devuser/.marklogic.ini

# Generate ssh key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh

# Install python and MarkLogic Python API
RUN yum install -y python34 python3-pip

RUN /usr/bin/pip3 install --upgrade pip
RUN /usr/bin/pip3 install requests
RUN /usr/bin/pip3 install requests-toolbelt
RUN /usr/bin/pip3 install marklogic_python_api -i https://testpypi.python.org/pypi

# Install rvm
#RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
#RUN curl -L get.rvm.io | bash -s stable
#RUN /bin/bash -l -c "rvm requirements"
#RUN /bin/bash -l -c "rvm install 1.9.3"
#RUN /bin/bash -l -c "rvm use 1.9.3 --default"

# Install MarkLogic
ADD MarkLogic-RHEL7-9.0-20160312.x86_64.rpm /tmp/MarkLogic.rpm
RUN yum -y install /tmp/MarkLogic.rpm
RUN rm /tmp/MarkLogic.rpm
ADD runml.sh /tmp/runml.sh

ENV TERM rxvt-unicode
ENV JAVA_HOME /usr/java/jdk1.8.0_65

# Expose MarkLogic Server ports
EXPOSE 22 25 80 7997 7998 7999 8000 8001 8002 8002

CMD ["/bin/bash", "-c" , "/tmp/runml.sh"]

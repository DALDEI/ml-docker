
# Adapted from https://gist.github.com/nikos/eb27dce271f00cba2bb7
# and https://gist.github.com/rlouapre/39f3cf793f27895ae8d2
# Hat tips to Niko Schmuck <niko.auto@nava.de>
# and Richard Louapre <richard.louapre@marklogic.com>

FROM fedora:21
MAINTAINER Norman Walsh <norman.walsh@marklogic.com>

# Setup base system
RUN yum -y update; yum clean all
RUN yum -y install tar sudo
RUN yum groupremove -y 'Additional Development' 'E-mail server' \
                       'Graphical Administration Tools' 'Perl Support'
RUN yum groupinstall -y 'Development tools'
RUN yum install -y openssh-server glibc.i686 gdb.x86_64 redhat-lsb.x86_64 \
                   zlib-devel bzip2-devel openssl-devel ncurses-devel \
                   sqlite-devel readline-devel tk-devel gdbm-devel db4-devel \
                   libpcap-devel xz-devel

RUN yum install -y emacs postfix bsd-mailx python-setuptools gcc gcc-c++ \
                   libxml2 wget iputils iproute initscripts

WORKDIR /tmp
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN rpm -ivh epel-release-7-5.noarch.rpm


ADD jdk-8u65-linux-x64.rpm /tmp/jdk.rpm
RUN yum install -y /tmp/jdk.rpm
RUN rm /tmp/jdk.rpm

RUN adduser --gid users --uid 1000 devuser

ADD marklogic.ini /home/devuser/.marklogic.ini

# Generate ssh key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd
RUN mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh

# Install python and MarkLogic Python API
ADD Python-3.5.0.tgz /tmp/
RUN cd Python-3.5.0 && ./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && make && make altinstall

RUN cd /usr/bin && ln -s /usr/local/bin/python3.5 python3
RUN cd /usr/bin && ln -s /usr/local/bin/pip3.5 pip3

RUN rm -rf /tmp/Python-3.5.0

RUN /usr/bin/pip3 install --upgrade pip
RUN /usr/bin/pip3 install requests
RUN /usr/bin/pip3 install requests-toolbelt
RUN /usr/bin/pip3 install marklogic_python_api -i https://testpypi.python.org/pypi

# Install rvm
RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
RUN curl -L get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 1.9.3"
RUN /bin/bash -l -c "rvm use 1.9.3 --default"

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

# Adapted and hacked from all over
#######################################################################
#
#  Usage:
#    docker build -t tag  .
#
#######################################################################

FROM ml-docker-coreos
MAINTAINER Norman Walsh <norman.walsh@marklogic.com>

RUN dnf --setopt=deltarpm=false groupinstall -y 'Development tools'
RUN dnf --setopt=deltarpm=false install -y --best auto-buildrequires \
    bison \
    boost \
    boost-devel \
    bzip2 \
    bzip2-devel \
    compat-libstdc++-33.i686 \
    cyrus-sasl-devel \
    db4-devel \
    emacs \
    flex \
    gcc \
    gcc-c++ \
    gdb.x86_64 \
    gdbm-devel \
    git \
    git-svn \
    glibc-devel.i686 \
    glibc.i686 \
    libpcap-devel \
    libstdc++-devel \
    libstdc++-devel.i686 \
    libstdc++-devel.i686 \
    libstdc++-static.i686 \
    libxml2 \
    ncurses-devel \
    openssh-server \
    openssl-devel \
    pcre \
    postfix \
    python-setuptools \
    readline-devel \
    redhat-lsb.x86_64 \
    sqlite-devel \
    tk-devel \
    wget \
    xz-devel \
    zlib-devel

# These lines install the MarkLogic Python API. You can delete them
# if you don't need or want the Python tools
ARG user=devuser
ADD marklogic.ini /home/${user}/.marklogic.ini
RUN /usr/bin/pip3 install --upgrade pip
RUN /usr/bin/pip3 install requests requests-toolbelt
RUN /usr/bin/pip3 install marklogic_python_api -i https://testpypi.python.org/pypi

ADD supervisord.conf /etc/supervisord.conf

# Expose MarkLogic Server ports (yer gonna build it, right?)
EXPOSE 7997 7998 7999 8000 8001 8002 8003 8004 8005 8006 8007 8008 8009 8010

CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]

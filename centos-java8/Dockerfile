FROM centos:centos7
MAINTAINER David Lee <dlee@calldei.com">
WORKDIR /tmp
ENV JDK_URL http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.rpm
ENV JDK_RPM jdk-8u91-linux-x64.rpm'
RUN yum install -y wget tar &&\
      wget -nv --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" $JDK_URL  &&\
      rpm -Uvh $JDK_RPM &&\
      rm -f $JDK_RPM &&\
      yum clean all &&\
      yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm &&\
      java -version
ENV JAVA_HOME /usr/java/latest
ENV JRE_HOME $JAVA_HOME/jre
ENV PATH $JAVA_HOME/bin:$JRE_HOME/bin:$PATH

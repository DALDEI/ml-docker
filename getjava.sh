# Replace with a recent download using a browser
out=${1:?"Usage: $0 jdktarget.rpm"}
wget --no-cookies --no-check-certificate -q --header  \
  "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm" -O $1


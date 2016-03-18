#!/bin/bash
#
# build one of the docker images
# usage: ./build image
# Requires both the Java SDK RPM and a MarkLogic RPM
# if the RPM is found in the local directory it is used, otherwise
#   getjava.sh is run to pull a Java SDK
#   getml.sh is run to pull a ML RPM
# 
#  If either fail the script is aborted

usage(){
  [ $# -gt 0 ] && println "$*"
  printf "Usage: %s [coreos|mlbuild|mlrun] <tab>" $0 
  exit 1;
}

[ $# = 2 ] || usage
image=$1 ; shift
tag="$1" ; shift

getjava() {
  jdk=$(echo jdk*.rpm)
  [ -f "$jdk" ] || ./getjava.sh jdk.rpm || usage "cannot get java sdk"
  ln $jdk $image
}

getml() {
  marklogic=$(echo MarkLogic*.rpm)
  [ -f "$marklogic" ] || ./getml.sh MarkLogic.rpm || usage "cannot get MarkLogic.rpm"
  ln $marklogic $image
}

case $image in 
  mlbuild)
    getjava && getml  
    docker build -t "$tag" --build-arg jdk="$jdk" --build-arg marklogic="$marklogic" $image
    ;;
  coreos)
    getjava 
    docker build -t "$tag" --build-arg jdk="$jdk" $image
    ;;
  mlrun )
    getjava && getml  
    docker build -t "$tag" --build-arg jdk="$jdk" --build-arg marklogic="$marklogic" $image
    ;;
  *)
   usage "Unknown build image $image"
   ;;
esac 

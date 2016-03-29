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

usagestr=("Usage:" "  $0: clean" "  $0 coreos|mlbuild|mlrun <tab>")
images=(coreos mlbuild mlrun)

usage(){
  [ $# -gt 0 ] && printf "%s\n" "$@"
  printf "%s\n" "${usagestr[@]}"
  exit 1;
}

jdk=jdk.rpm
marklogic=MarkLogic.rpm

cleantmp()
{
   local i
   local _f
   for i in ${*:-${images[*]}} ; do
     for _f in "$i"/{$jdk,$marklogic,runml.sh} ; do 
     echo removing $_f
     [ -f $_f ] && rm -f $_f 
     done
   done
}
clean() 
{
  cleantmp ${images[*]} 
}


# copy/link from to-image
copyto() {
  [ $# -eq 2 ] || usage "copyto from to $*"
  local from="$1"
  [ -f "$from" ] || usage "File required: $from"
  local to="$2"
  echo using "$from -> $to"
  [ -f "$to" ] && rm -f "$to" ;
  ln -f "$from" "$to" || usage "Cannot link $from to $to"
  [ -f "$to" ] || usage "Failed to copy to $to"
}


getjava() {
  local j=$(echo jdk*.rpm| tail -1)
  if [ -f "$j" ]   ; then 
      copyto "$j" "$image/$jdk" 
  else 
      ./getjava.sh "$image/$jdk" || usage "cannot get java sdk"
  fi 
  [ -f "$image/$jdk" ] || usage "Failed to copy $image/$jdk" 
}

getml() {
  local m=$(echo [mM]ark[lL]ogic*.rpm|tail -1)
  if [ -f "$m" ]  ; then
      copyto "$m" "$image/$marklogic" 
  else
      ./getml.sh "$image/$marklogic" 
  fi
  [ -f "$image/$marklogic" ] || usage "Failed to copy $image/$marklogic" 
}
debug=
case ${cmd:=${1:-help}} in 
  clean )
     clean ; exit ;;
   help|--help|-h|-?)
      usage "help" ; exit ;;
   coreos|mlbuild|mlrun*) ;; 
  *)
    usage "Unknown command $cmd" ;;
esac

[ $# -lt 2 ] && usage "Missing argument <tag>"
image="$cmd"
tag="$2"
debug=
[ -d "$image" ] || usage "Invalid build directory: $image" 
cleantmp $image
cp runml.sh $image/
getjava || usage "Cannot find a Java RPM"


trap 'cleantmp $image' EXIT
case $cmd in 
  coreos)
    $debug docker build -t "$tag" --build-arg jdk="$jdk" $image
    ;;
  mlbuild|mlrun|mlrun_tools)
    getml  || usage "Cannot find a MarkLogic RPM"
    $debug docker build -t "$tag" --build-arg jdk="$jdk" --build-arg marklogic="$marklogic" $image
   ;;
  *)
    usage "Unknown command $cmd" ;;
esac 

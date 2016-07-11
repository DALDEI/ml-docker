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

# FIXME: do a better job with tags when there's a repository

tag=ml-docker-$cmd
user=$(id -un)
uid=$(id -u)
debug=
usagestr=("Usage:" "  $0 clean" "  $0 coreos|builder|runner {--tag tag} {--user user} {--uid uid}"
"Defaults: "  "  user:$user " "  uid:$uid" "  tag:$tag-[coreos|builder|runner]")
images=(coreos builder runner)

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
     for _f in "$i"/{$jdk,$marklogic} ; do
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
  elif  [ -x ./getjava.sh ] ; then
      ./getjava.sh "$image/$jdk" || usage "cannot get java sdk"
  else
     usage "Place an Oracle Java 8 JDK rpm in $PWD or a script named 'getjava.sh'"
  fi
  [ -f "$image/$jdk" ] || usage "Failed to copy $image/$jdk"
}

getml() {
  local m=$(echo [mM]ark[lL]ogic*.rpm|tail -1)
  if [ -f "$m" ]  ; then
      copyto "$m" "$image/$marklogic"
  elif  [ -x ./getml.sh ] ; then
      ./getml.sh "$image/$marklogic"
  else
     usage "Place a MarkLogic rpm in $PWD or a script named 'getml.sh'"
  fi
  [ -f "$image/$marklogic" ] || usage "Failed to copy $image/$marklogic"
}

debug=
case ${cmd:=${1:-help}} in
  clean )
     clean ; exit ;;
   help|--help|-h|-?)
      usage "help" ; exit ;;
   coreos|builder|runner*) ;;
  *)
    usage "Unknown command $cmd" ;;
esac

image="$cmd"
shift

while [[ $# -gt 0 ]]; do
    key=$1
    case $key in
        -t|--tag)
            shift
            tag=$1
            ;;
        -u|--user)
            shift
            user=$1
            ;;
        -U|--uid)
            shift
            uid=$1
            ;;
        --debug)
            shift
            debug=$1
            ;;
        *)
            usage "Unknown option $key"
            ;;
    esac
    shift
done

[ -d "$image" ] || usage "Invalid build directory: $image"
cleantmp $image

trap 'cleantmp $image' EXIT

case $cmd in
    coreos)
        getjava || usage "Cannot find a Java RPM"
        $debug docker build -t "$tag" --build-arg java="$jdk" --build-arg user="$user" --build-arg uid="$uid" $image
        ;;
    builder)
        $debug docker build -t "$tag" --build-arg user="$user" $image
        ;;
    runner)
        getml  || usage "Cannot find a MarkLogic RPM"
        $debug docker build -t "$tag" --build-arg marklogic="$marklogic" --build-arg user="$user" $image
        ;;
    *)
        usage "Unknown command $cmd" ;;
esac

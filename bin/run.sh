#!/bin/bash

CLEAR=0
DATAROOT="/space/docker/data";

if [ "X$1" = "X-c" ]; then
  CLEAR=1
  shift
fi

if [ "X$1" = "X" ]; then
    echo "Usage: $0 num"
    exit 1
fi

NUM=$1
shift

if [ ! -d "$DATAROOT/nightly-$NUM" ]; then
    echo "No data directory: $DATAROOT/nightly-$NUM"
    exit 2
fi

if [ "$CLEAR" = "1" ]; then
    echo "Clearing data directory: $DATAROOT/nightly-$NUM"
    sudo rm -rf $DATAROOT/nightly-$NUM/*
fi

docker run --dns 172.17.0.1 -h nightly-$NUM \
           -v $DATAROOT/nightly-$NUM:/var/opt/MarkLogic \
           -d nightly

sleep 1
sudo /home/ndw/bin/update-docker-hosts


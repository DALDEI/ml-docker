#!/bin/bash
# Replace this with a script that copies a MarkLogic rpm to $1
#echo "Replace this with a script that copies a MarkLogic rpm to $1" 
#exit 1
set -x
ML=$(ls  /public/MarkLogic-RHEL7-9.0*| tail -1)
[ -f "$ML" ] && cp "$ML" ${1:?"Usage: $0 target-rpm"}

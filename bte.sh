#!/usr/bin/env bash
#
# use the krdwrd's BTE pipe output and filter the TXT pipe output accrodingly

[ -z $1 ] && { echo "Usage: $(basename $0) pipeout.bte (with pipeout.txt in the same directory.)" ; exit 1;}

paste -d ' ' <(cut -d ' ' -f 3 ${1}) $(dirname ${1})/$(basename ${1} .bte).txt | grep -E "^1 " | cut -d ' ' -f 2- | uniq

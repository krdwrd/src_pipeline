#!/bin/bash
#
#crf-features: sentence.count
#crf-features: token.{alpha,num,mixed,other}-{abs,rel}
#crf-features: avg-word-{length,run}
#crf-features: char.{alpha,num,punct,white,other}-rel
#crf-features: twins
#crf-features: regexp.{date,time}
#crf-features: document.{{word,sentence}-count}
#

VICTOR=$(dirname $0)/victor

if [[ -z "$1" || -z "$2" || -n "$3" ]]
then
    echo "Usage:$(basename $0) INFILE.txt OUTFILE.txtf"
    echo " Use Victor on INFILE.txt to generate text features in OUTFILE.txtf"
    exit 1
fi


INFILE=$1
OUTFILE=$2

PERL5LIB=${PERL5LIB}:${VICTOR} \
    ${VICTOR}/krdwrd.pl \
    --config ${VICTOR}/configs/krdwrd.conf \
    --format krdwrd ${INFILE} ${OUTFILE}

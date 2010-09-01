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

. $(dirname $0)/config.pipe

count=0
for i in ${OUT}/*.txt
do
    let count++

    if [[ -f ${OUT}/$(basename ${i} .txt).txtf ]]; then echo -n "."; continue; fi

    echo -n "$(basename ${i} .txt) "
    PERL5LIB=${PERL5LIB}:$(dirname ${0})/victor ./victor/krdwrd.pl --config victor/configs/krdwrd.conf --format krdwrd ${i} ${OUT}/$(basename ${i} .txt).txtf;
done

echo
echo ${count}

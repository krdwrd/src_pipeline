#!/bin/bash

. $(dirname $0)/config.pipe
###

if [[ -z "$1" || -z "$2" || -n "$3" ]]
then
    echo Usage:$(basename $0) DIR_WITH_FILES FILE.clf
    exit 1
fi

OUT=$1
CLF=$2
SCALE=${SVMIN}/xy2-bte-dom-txtf.allvecs.srange
MODEL=${MODELS}/best

function out2train
{
    echo -n "${1// /-}: "
    count=0
    for i in $(cut -d ' ' -f 1 ${CLF})
    do
        # be verbose from time to time
        if ! (( $count % 5000 )); then echo -n "${count}"; fi
        let count++

        trap "rm -v $OUT/$i.${1// /-}.scaled $OUT/$i.pred; exit 1" ERR INT QUIT TERM KILL

        if [[ ! -f  $OUT/$i.${1// /-}.scaled ]]
        then
            eval paste -d \' \' $(for j in $1; do echo '<(cat '"$OUT/$i.$j"') '; done;) | ${BASE}/vectorize2c.py > ${OUT}/$i.${1// /-}.vecs
            svm-scale -r $SCALE ${OUT}/$i.${1// /-}.vecs > ${OUT}/$i.${1// /-}.scaled \
            && echo -n "+"
            rm ${OUT}/$i.${1// /-}.vecs
        else
            echo -n "."
        fi

        if [[ -f ${OUT}/$i.${1// /-}.scaled && ! -f $OUT/$i.pred ]]
        then
            svm-predict ${OUT}/$i.${1// /-}.scaled $MODEL $OUT/$i.pred > /dev/null 2>&1 \
            && echo -n "+"
        else
            echo -n "."
        fi
    done 
    echo "${count}"
}

out2train "xy2 bte dom txtf"

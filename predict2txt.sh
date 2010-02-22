#!/bin/bash

. ./config.pipe

for f in ${PREDICT}/*.pred 
do

    FNAME=$(basename ${f} .viz-dom.vecs.scaled.pred)
    PRETXT=${PREDICT}/${FNAME}.txt
    PRENOTXT=${PREDICT}/${FNAME}.notxt
    if [[ -f $PRETXT ]]
    then
        echo -n "." 
        continue
    fi
    touch $PRETXT
    echo -n "${FNAME} "

    paste -d'\t' ${f} ${OUT}/${FNAME}.txt | awk '/^[-1]+\t/' | cut -f 2- | uniq > ${PRENOTXT}
    paste -d'\t' ${f} ${OUT}/${FNAME}.txt | awk '/^[1]+\t/' | cut -f 2- | uniq > ${PRETXT}
done

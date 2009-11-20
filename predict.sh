#!/bin/bash

. ./config.sh

MOD=$BASE/models/canola/viz-dom.allvecs.scaled.1.learn.10-0.005.mod

for f in ${SVMIN}/*.scaled 
do
    PRED=$PREDICT/$(basename $f).pred

    if [[ -f $PRED ]]
    then
        echo -n "." 
        continue
    fi
    touch $PRED
    echo -n "$PRED "

    svm-predict $f $MOD $PRED
done

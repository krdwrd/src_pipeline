#!/bin/bash

. `dirname $0`/config.pipe
###

function out2train
{
    echo -n "${1// /-}: "
    count=0
    for g in $OUT/*.gold
    do
        let count++
        i=$(basename $g .gold)

        if [[ ! -f  ${SVMIN}2c/$i.${1// /-}.vecs ]]
        then
        
            eval paste -d \' \' $(for j in $1; do echo '<(cat '"$OUT/$i.$j"') '; done;) | ./vectorize2c.py > ${SVMIN}2c/$i.${1// /-}.vecs
        else
            echo -n "."
        fi
    done 
    echo "${count}"
}

out2train "viz dom"
out2train "viz dom txtfeat"

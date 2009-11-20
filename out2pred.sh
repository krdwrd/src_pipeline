#!/bin/bash

. `dirname $0`/config.sh

###

count_1=0
count_2=0
for g in $OUT/*.png
do
    i=`basename $g .png`
    if [[ ! -f  $SVMIN/$i.viz-dom.vecs ]]; then
        if [[ -f ${OUT}/${i}.viz && -f ${OUT}/${i}.dom  ]]; then
            let count_1++
            echo -n "${i} "
            paste -d ' ' $OUT/${i}.{viz,dom} | ./vectorize4pred.py > $SVMIN/$i.viz-dom.vecs
        fi
    else
        echo -n "."
    fi

    if [[ ! -f  $SVMIN/$i.viz-dom-txt.vecs ]]; then
        if [[ -f ${OUT}/${i}.viz && -f ${OUT}/${i}.dom && -f ${OUT}/${i}.txtfeat  ]]; then
            let count_2++
            echo -n "${i} "
            paste -d ' ' $OUT/${i}.{viz,dom,txtfeat} | ./vectorize4pred.py > $SVMIN/$i.viz-dom-txt.vecs
        fi
    else
        echo -n "."
    fi

    #if [[ -f ${SVMIN}/${i}.txtf ]]; then
    #fi
done 
echo; echo ${count_1}; echo ${count_2}

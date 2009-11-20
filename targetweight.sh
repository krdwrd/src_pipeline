#!/bin/bash

. `dirname $0`/config.sh

count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`

    if [[ -f ${SVMIN}/${i}.targetweight ]]; then echo -n "."; continue; fi
    
    echo -n "${i} "
    cut -d ' ' -f 14 ${OUT}/${i}.dom > $SVMIN/$i.targetweight
done
echo; echo ${count}

for g in $OUT/*.gold
do
    i=`basename $g .gold`
    cat $SVMIN/${i}.targetweight
done > $SVMIN/allvecs.targetweight

for g in $OUT/*.gold
do
    i=`basename $g .gold`
    cat $SVMIN/${i}.target
done > $SVMIN/allvecs.target

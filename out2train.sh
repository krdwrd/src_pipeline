#!/bin/bash

. $(dirname $0)/config.pipe

[ -d $SVMIN ] || mkdir -p $SVMIN 

echo -n "target: "
count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`

    ./target.py < $g > $SVMIN/$i.target
    cat $SVMIN/${i}.target
done > $SVMIN/allvecs.target
echo ${count}

echo -n "targetweight: "
count=0
for g in $OUT/*.gold
do
    let count++
    i=`basename $g .gold`

    cut -d ' ' -f 1 ${OUT}/${i}.bte > $SVMIN/$i.targetweight
    cat $SVMIN/${i}.targetweight
done > $SVMIN/allvecs.targetweight
echo ${count}
###

function out2train
{
    echo -n "${1// /-}: "
    count=0
    for g in $OUT/*.gold
    do
        let count++
        i=$(basename $g .gold)
        
        eval paste -d \' \' $(for j in $1; do echo '<(cat '"$OUT/$i.$j"') '; done;) | ./vectorize.py > $SVMIN/$i.${1// /-}.vecs
        eval paste -d \' \' $(for j in target ${1// /-}.vecs; do echo '<(cat '"$SVMIN/$i.$j"') ';done;) 
    done > $SVMIN/${1// /-}.allvecs
    echo "${count}"
}

out2train "xy2"
out2train "bte"
out2train "dom"
out2train "xy2 bte"
out2train "xy2 dom"
out2train "bte dom"
out2train "xy2 bte dom"
out2train "txtf"
out2train "xy2 txtf"
out2train "bte txtf"
out2train "dom txtf"
out2train "bte dom txtf"
out2train "xy2 bte dom txtf"

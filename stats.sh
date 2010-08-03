#!/bin/bash 

for i in $1/*.allvecs.scaled.1.test.*.res; do
    for a in $(echo $i | sed s/1/\*/)
    do 
        tail -n 3 $a | tr '\n' '\t'    
        echo
    done | awk '{a+=$1; b+=$2; c+=$3;}END{printf "%0.5f %.5f %0.5f", a/10, b/10, c/10}'
    echo " ${i##*/}"
done

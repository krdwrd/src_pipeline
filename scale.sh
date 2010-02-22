#!/bin/bash

. `dirname $0`/config.pipe

count=0

for a in ${SVMIN}/*.allvecs
do
  let count++
  # if [[ -f ${a}.scaled ]]; then echo -n "."; continue; fi
  echo -n "$(basename ${a} .allvecs) "

  svm-scale -s $a.srange $a > $a.scaled
done

echo ${count}

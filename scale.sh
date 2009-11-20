#!/bin/bash

. `dirname $0`/config.sh

count=0

for a in ${SVMIN}/*.allvecs
do
  let count++
  if [[ -f ${a}.scaled ]]; then echo -n "."; continue; fi
  echo -n "$(basename ${a} .allvecs) "

  svm-scale -s $a.scale_range $a > $a.scaled
done

echo
echo ${count}
